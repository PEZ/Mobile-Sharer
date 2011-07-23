#!/usr/bin/env python
# -*- coding: utf-8 -*-

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
        self.assertFalse(SFUser.validate_user(self.user_id, "a" + self.secret))
