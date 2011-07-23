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
import datetime

from model.fav import Fav
from model.sfuser import SFUser

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
            self.bail_with_message(None, {'status': False}, 403)
            return

    return valid_api_user_required

class APIHandler(webapp.RequestHandler):
    def respond(self, message_dict):
        self.response.headers['Content-Type'] = 'text/plain'
        self.response.out.write(JSONEncoder().encode(message_dict))

    def bail_with_message(self, err, message_dict, code=500):
        self.error(code)
        logging.warning("%s\n%s" % (err.message, traceback.format_exc()))
        self.respond(message_dict)
    
class CreateFavAPIHandler(APIHandler):
    def post(self, fav_id):
        user_id = self.request.get('user_id')
        author_id = self.request.get('author_id')
        try:
            fav = Fav.create(fav_id, user_id, author_id)
            self.respond({'fav_id': fav.fav_id, 'created_at': fav.created_at.isoformat(), 'status': True})
        except Exception, err:
            self.bail_with_message(err, {'status': False})

class DeleteFavAPIHandler(APIHandler):
    def post(self, fav_id):
        user_id = self.request.get('user_id')
        try:
            fav = Fav.disable_fav(fav_id, user_id)
            self.respond({'fav_id': fav.fav_id, 'created_at': fav.created_at.isoformat(), 'status': True})
        except Exception, err:
            self.bail_with_message(err, {'status': False})


def fromisoformat(val):
    if '.' not in val:
        return datetime.datetime.strptime(val, "%Y-%m-%dT%H:%M:%S")

    nofrag, frag = val.split(".")
    date = datetime.datetime.strptime(nofrag, "%Y-%m-%dT%H:%M:%S")

    frag = frag[:6]  # truncate to microseconds
    frag += (6 - len(frag)) * '0'  # add 0s
    return date.replace(microsecond=int(frag))

DEFAULT_FAVS_LIMIT=20

class GetFavsAPIHandler(APIHandler):
    def get(self):
        try:
            user_id = self.request.get('user_id')
            limit = int(self.request.get('limit', DEFAULT_FAVS_LIMIT))
            start_time = self.request.get('older_than', default_value=datetime.datetime.now().isoformat())
            start_time = fromisoformat(start_time)
            fav_ids, oldest = Fav.fav_ids_for_user(user_id, limit, start_time)
            self.respond({'favorites': fav_ids,
                          'oldest': oldest.isoformat(),
                          'status': True})
        except Exception, err:
            self.bail_with_message(err, {'favorites': [], 'status': False})

application = webapp.WSGIApplication([
                                      ('/api/favs', GetFavsAPIHandler),
                                      ('/api/fav/create/(.+)', CreateFavAPIHandler),
                                      ('/api/fav/delete/(.+)', DeleteFavAPIHandler),
                                      ], debug=True)

def main():
    run_wsgi_app(application)

if __name__ == "__main__":
    main()
