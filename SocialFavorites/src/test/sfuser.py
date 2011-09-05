from test import ModelTestCase
from model.sfuser import SFUser, SECRET_KEY, TOKEN_KEY, USER_KEY
from google.appengine.api import memcache

class TestSFUser(ModelTestCase):
    '''Tests for SFUser Models'''

    user_id = "1"
    secret = "2"
    fb_token = "token123"
    user = None
    
    def setUp(self):
        super(TestSFUser, self).setUp()
        self.user = SFUser.create(self.user_id, self.fb_token, self.secret)
        
    def test_create_user(self):
        '''Created user is good?'''
        self.assertEqual(self.user.user_id, self.user_id)
        self.assertEqual(self.user.secret, self.secret)

    def test_validate_user(self):
        '''User validation'''
        self.assertTrue(SFUser.validate_user(self.user_id, self.secret))
        self.assertTrue(SFUser.validate_user(self.user_id, self.secret))
        self.assertFalse(SFUser.validate_user(self.user_id, "a" + self.secret))

    def test_validate_user_memcache(self):
        '''Validation of a user should store answer in memcache'''
        user_id = "memcache_validate_user "
        secret = "memcahce_validate_secret"
        SFUser.create(user_id, "fb_token", secret)
        self.assertNone(memcache.get(SECRET_KEY % (user_id, secret)))
        self.assertTrue(SFUser.validate_user(user_id, secret))
        self.assertEqual(memcache.get(SECRET_KEY % (user_id, secret)), 1)
        

    def test_create_secret(self):
        '''Creating a secret'''
        secret1 = SFUser.create_secret()
        self.assertNotNone(secret1)
        secret2 = SFUser.create_secret()
        self.assertNotEqual(secret1, secret2)
        
    def test_user_by_id(self):
        '''Get user by id'''
        self.assertEqual(self.user.key(), SFUser.user_by_id(self.user_id).key())
        self.assertNone(SFUser.user_by_id("a" + self.user_id))

    def test_user_by_id_memcache(self):
        '''Get user by id should memcache the answer'''
        user_id = "memcache_ubi_user_id"
        user = SFUser.create(user_id, "fb_token", "secret")
        self.assertNone(memcache.get(USER_KEY % user_id))
        self.assertEqual(user.key(), SFUser.user_by_id(user_id).key())
        self.assertEqual(user.key(), memcache.get(USER_KEY % user_id).key())

    def test_user_by_user_id_and_fb_token(self):
        '''Get user by id and fb_token'''
        self.assertEqual(self.user.key(), SFUser.user_by_user_id_and_fb_token(self.user_id, self.fb_token).key())
        self.assertEqual(self.user.key(), SFUser.user_by_user_id_and_fb_token(self.user_id, self.fb_token).key())
        self.assertNone(SFUser.user_by_user_id_and_fb_token(self.user_id, 'a' + self.fb_token))

    def test_user_by_user_id_and_fb_token_memcache(self):
        '''Get user by id and fb_token should memcache the answer'''
        user_id = "memcache_ubyift_user_id"
        fb_token = "memcache_ubyift_fb_token"
        user = SFUser.create(user_id, fb_token, "secret")
        self.assertNone(memcache.get(TOKEN_KEY % (user_id, fb_token)))
        self.assertEqual(user.key(), SFUser.user_by_user_id_and_fb_token(user_id, fb_token).key())
        self.assertEqual(user.key(), memcache.get(TOKEN_KEY % (user_id, fb_token)).key())
