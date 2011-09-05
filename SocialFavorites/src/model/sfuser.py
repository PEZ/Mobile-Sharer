'''
Created on Jul 23, 2011

@author: pez
'''

from google.appengine.ext import db
from google.appengine.api import memcache

import logging #@UnusedImport

USER_KEY = "USER:%s"
SECRET_KEY = "SECRET:%s:%s"
TOKEN_KEY = "TOKEN:%s:%s"

class SFUser(db.Model):
    created_at = db.DateTimeProperty(auto_now_add=True)
    user_id    = db.StringProperty(required=True)
    fb_token   = db.StringProperty(required=True)
    secret     = db.StringProperty(required=True)

    
    @classmethod
    def create(cls, user_id, fb_token, secret):
        user = cls(user_id=user_id, fb_token=fb_token, secret=secret)
        user.put()
        return user

    @classmethod
    def user_by_id(cls, user_id):
        key = USER_KEY % user_id
        user = memcache.get(key)
        if user is None:
            user_q = cls.all().filter('user_id =', user_id)
            user = user_q.get()
            if user is not None:
                memcache.add(key, user)
        return user

    @classmethod
    def validate_user(cls, user_id, secret):
        key = SECRET_KEY % (user_id, secret)
        user_count = memcache.get(key)
        if user_count is not None:
            return user_count
        else:
            user_count = cls.all().filter('user_id =', user_id).filter('secret =', secret).count(1)
            memcache.add(key, user_count)
            if user_count > 0:
                return True
        return False

    @classmethod
    def create_secret(cls):
        import random
        import sha
        
        random.seed()
        return sha.sha("Psst! %f" % random.random()).hexdigest()

    @classmethod
    def user_by_user_id_and_fb_token(cls, user_id, fb_token):
        key = TOKEN_KEY % (user_id, fb_token)
        user = memcache.get(key)
        if user is not None:
            return user
        else:
            user = cls.all().filter('user_id =', user_id).filter('fb_token =', fb_token).get()
            if user is not None:
                memcache.add(key, user)
            return user
                