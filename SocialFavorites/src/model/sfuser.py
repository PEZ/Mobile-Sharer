'''
Created on Jul 23, 2011

@author: pez
'''

from google.appengine.ext import db
from google.appengine.api import memcache

import logging #@UnusedImport

class SFUser(db.Model):
    created_at = db.DateTimeProperty(auto_now_add=True)
    user_id    = db.StringProperty(required=True)
    secret     = db.StringProperty(required=True)
    
    @classmethod
    def create(cls, user_id, secret):
        user = cls(user_id=user_id, secret=secret)
        user.put()
        return user

    @classmethod
    def validate_user(cls, user_id, secret):
        key = "%s:%s" % (user_id, secret)
        user_count = memcache.get(key)
        if user_count is not None:
            #logging.warning("Memcache hit")
            return user_count
        else:
            #logging.warning("Memcache miss")
            user_count = cls.all().filter('user_id =', user_id).filter('secret =', secret).count(1)
            memcache.set(key, user_count)
            if user_count > 0:
                return True
        return False
