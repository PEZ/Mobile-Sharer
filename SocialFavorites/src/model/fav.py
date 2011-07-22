'''
Created on July 21, 2011

@author: cobpez
'''
from google.appengine.ext import db
import datetime
import logging #@UnusedImport

class Fav(db.Model):
    created_at        = db.DateTimeProperty(auto_now_add=True)
    fav_id            = db.StringProperty(required=True)
    user_id           = db.StringProperty(required=True)
    user_secret       = db.StringProperty(required=True)
    author_id         = db.StringProperty(required=True)
    is_enabled        = db.BooleanProperty(default=True)

    @classmethod
    def get_fav(cls, fav_id, user_id, user_secret):
        q = cls.all()
        q.filter('fav_id =', fav_id)
        q.filter('user_id =', user_id)
        q.filter('user_secret', user_secret)
        favs_list = q.fetch(1)
        if favs_list != []:
            return favs_list[0]
        else:
            return None

    @classmethod
    def create(cls, fav_id, user_id, user_secret, author_id):
        fav = cls.get_fav(fav_id, user_id, user_secret)
        if fav == None:
            fav = cls(fav_id=fav_id, user_id=user_id, user_secret=user_secret, author_id=author_id)
            fav.put()
        elif not fav.is_enabled:
            fav.is_enabled = True
            fav.put()
        return fav
    
    @classmethod
    def fav_ids_for_user(cls, user_id, user_secret, limit, start_time=None):
        favs_q = cls.all()
        favs_q.filter('user_id =', str(user_id))
        favs_q.filter('user_secret =', str(user_secret))
        favs_q.filter('is_enabled =', True)
        if start_time == None:
            start_time = datetime.datetime.now()
        favs_q.filter('created_at <', start_time)
        favs_q.order('-created_at')
        favs = favs_q.fetch(limit)
        if favs != []:
            return ([fav.fav_id for fav in favs], favs[-1].created_at)
        else:
            return ([], start_time)
    
    @classmethod
    def _fav_set_enabled(cls, fav_id, user_id, user_secret, enabled):
        fav = cls.get_fav(fav_id, user_id, user_secret)
        if fav != None:
            fav.is_enabled = enabled
            fav.put()
        return fav

    @classmethod
    def enable_fav(cls, fav_id, user_id, user_secret):
        return cls._fav_set_enabled(fav_id, user_id, user_secret, True)

    @classmethod
    def disable_fav(cls, fav_id, user_id, user_secret):
        return cls._fav_set_enabled(fav_id, user_id, user_secret, False)
