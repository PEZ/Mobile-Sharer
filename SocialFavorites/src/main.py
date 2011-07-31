import os
os.environ['DJANGO_SETTINGS_MODULE'] = 'settings'
from google.appengine.dist import use_library
use_library('django', '1.2')

import logging
import traceback

from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app

from google.appengine.ext.webapp import template

from django.utils.simplejson.encoder import JSONEncoder
from django.utils.simplejson.decoder import JSONDecoder

import datetime

from model.fav import Fav
from model.sfuser import SFUser

from utils import sfdatetime

class WebHandler(webapp.RequestHandler):

    def Render(self, template_file, template_values, layout='main.html'):
        if layout == None:
            _template = template_file
        else:
            _template = layout
            template_values = dict(template_values, **{'template': template_file})
        path = os.path.join(os.path.dirname(__file__), 'templates', _template)
        self.response.out.write(template.render(path, template_values))

    def error(self, code):
        super(WebHandler, self).error(code)
        if code == 404:
            self.Render("404.html", {})

def valid_api_user_required(handler_method):
    """Validate the user_id + secret"""
    def validate_user_credentials(self, *args, **kw):
        user_id = self.request.get('user_id')
        secret = self.request.get('secret')
        if SFUser.validate_user(user_id, secret):
            handler_method(self, *args, **kw)
        else:
            self.bail_with_message(None, {'status': False, 'message': 'Authentication failed'}, 403)
            return

    return validate_user_credentials

class APIHandler(webapp.RequestHandler):
    def respond(self, message_dict):
        self.response.headers['Content-Type'] = 'text/plain'
        self.response.out.write(JSONEncoder().encode(message_dict))

    def bail_with_message(self, err, message_dict, code=500):
        self.error(code)
        if err is not None:
            logging.warning("%s\n%s" % (err.message, traceback.format_exc()))
        self.respond(message_dict)

class FBUserTokenError(Exception):
    pass

class FBUserTokenAPIHandler(APIHandler):
    def get(self, user_id):
        from google.appengine.api.urlfetch import fetch
        token = self.request.get('fb_token')
        try:
            response = fetch('https://graph.facebook.com/me?access_token=%s' % token)
            me_data = JSONDecoder().decode(response.content)
            if me_data.get('id', None) is not None:
                if me_data.get('id') == user_id:
                    user = SFUser.user_by_id(user_id)
                    if user is None:
                        user = SFUser.create(user_id, SFUser.create_secret())
                else:
                    raise FBUserTokenError, "User id mismatch"
                self.respond({'secret': user.secret, 'status': True})
            else:
                self.bail_with_message(None,
                                       {'status': False, 'message': 'Facebook API said: %s' % response.content},
                                       response.status_code)
        except Exception, err:
            self.bail_with_message(err, {'status': False, 'message': 'Error while validating Facebook token'})
            
class CreateFavAPIHandler(APIHandler):
    @valid_api_user_required
    def post(self, fav_id):
        user_id = self.request.get('user_id')
        author_id = self.request.get('author_id')
        try:
            fav = Fav.create(fav_id, user_id, author_id)
            self.respond({'fav_id': fav.fav_id, 'created_at': fav.created_at.isoformat(), 'status': True})
        except Exception, err:
            self.bail_with_message(err, {'status': False})

class DeleteFavAPIHandler(APIHandler):
    @valid_api_user_required
    def post(self, fav_id):
        user_id = self.request.get('user_id')
        try:
            fav = Fav.disable_fav(fav_id, user_id)
            self.respond({'fav_id': fav.fav_id, 'created_at': fav.created_at.isoformat(), 'status': True})
        except Exception, err:
            self.bail_with_message(err, {'status': False})

DEFAULT_FAVS_LIMIT=20

class GetFavsAPIHandler(APIHandler):
    @valid_api_user_required
    def get(self):
        try:
            user_id = self.request.get('user_id')
            limit = int(self.request.get('limit', DEFAULT_FAVS_LIMIT))
            start_time = self.request.get('older_than', default_value=datetime.datetime.now().isoformat())
            start_time = sfdatetime.fromisoformat(start_time)
            fav_ids, oldest = Fav.fav_ids_for_user(user_id, limit, start_time)
            result = {'favorites': fav_ids, 'status': True}
            if oldest is not None:
                result[''] = oldest.isoformat()
            self.respond(result)
        except Exception, err:
            self.bail_with_message(err, {'favorites': [], 'status': False})

application = webapp.WSGIApplication([
                                      ('/api/favs', GetFavsAPIHandler),
                                      ('/api/fav/create/(.+)', CreateFavAPIHandler),
                                      ('/api/fav/delete/(.+)', DeleteFavAPIHandler),
                                      ('/api/fbuser/(.+)/token', FBUserTokenAPIHandler),
                                      ], debug=True)

def main():
    run_wsgi_app(application)

if __name__ == "__main__":
    main()
