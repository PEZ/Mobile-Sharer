from test import ModelTestCase
from model.sfuser import SFUser

class TestSFUser(ModelTestCase):
    '''Tests for SFUser Models'''

    user_id = "1"
    secret = "2"
    user = None
    
    def setUp(self):
        super(TestSFUser, self).setUp()
        self.user = SFUser.create(self.user_id, self.secret)
        
    def test_create_user(self):
        '''Created user is good?'''
        self.assertEqual(self.user.user_id, self.user_id)
        self.assertEqual(self.user.secret, self.secret)

    def test_validate_user(self):
        '''User validation'''
        self.assertTrue(SFUser.validate_user(self.user_id, self.secret))
        self.assertTrue(SFUser.validate_user(self.user_id, self.secret))
        self.assertFalse(SFUser.validate_user(self.user_id, "a" + self.secret))

    def test_create_secret(self):
        '''Creating a secret'''
        secret1 = SFUser.create_secret()
        self.assertNotNone(secret1)
        secret2 = SFUser.create_secret()
        self.assertNotEqual(secret1, secret2)
        
    def test_user_by_id(self):
        '''Get use by id'''
        self.assertEqual(self.user.key(), SFUser.user_by_id(self.user_id).key())
        self.assertNone(SFUser.user_by_id("a" + self.user_id))