from test import ModelTestCase
from model.fav import Fav

class TestFav(ModelTestCase):
    '''Tests for Fav Models'''

    fav_id = "fav_test_1"
    user_id = "fav_test_user_1"
    author_id = "a2"
    fav = None
    
    def setUp(self):
        super(TestFav, self).setUp()
        self.fav = Fav.create(self.fav_id, self.user_id, self.author_id)
        
    def test_create_fav(self):
        '''Created user is good?'''
        self.assertEqual(self.fav.fav_id, self.fav_id)
        self.assertEqual(self.fav.user_id, self.user_id)
        self.assertEqual(self.fav.author_id, self.author_id)

    def test_get_existing_fav(self):
        '''Getting a fav by fav_id and user_id'''
        gotten = Fav.get_fav(self.fav_id, self.user_id)
        self.assertEqual(gotten.key(), self.fav.key())

    def test_get_nonexisting_fav(self):
        '''Attempt getting a nonexisting fav'''
        self.assertNone(Fav.get_fav('a' + self.fav_id, self.user_id))

    def test_recreate_fav(self):
        '''Creating an existing fav returns the existing instance'''
        same = Fav.create(self.fav_id, self.user_id, self.author_id)
        self.assertEqual(self.fav.key(), same.key())

    def test_disable_fav(self):
        '''Disabling a fav'''
        disabled = Fav.disable_fav(self.fav_id, self.user_id)
        self.assertFalse(disabled.is_enabled)
        self.assertEqual(self.fav.key(), disabled.key())
        self.assertNone(Fav.disable_fav(self.fav_id, 'a' + self.user_id))

    def test_enable_fav(self):
        '''Enabling a fav'''
        disabled = Fav.disable_fav(self.fav_id, self.user_id)
        self.assertFalse(disabled.is_enabled)
        enabled = Fav.enable_fav(self.fav_id, self.user_id)
        self.assertTrue(enabled.is_enabled)
        self.assertEqual(enabled.key(), disabled.key())

    def test_create_enables_fav(self):
        '''Creating an existing fav that is disabled, enables it'''
        disabled = Fav.disable_fav(self.fav_id, self.user_id)
        self.assertFalse(disabled.is_enabled)
        created = Fav.create(self.fav_id, self.user_id, self.author_id)
        self.assertEqual(created.key(), self.fav.key())
        self.assertTrue(created.is_enabled)
        
class TestFavIdLists(ModelTestCase):
    '''Listing and paging through created favs'''
    
    user_id = "list_test_user1"
    author_id = "a1"
    favs = None
    num_favs = 7
    page_length = 3

    def setUp(self):
        self.favs = []
        for fav_id in [str(i) for i in xrange(self.num_favs)]:
            self.favs.append(Fav.create(fav_id, self.user_id, self.author_id))

    def test_get_first_page(self):
        '''Get first page of the user's fav ids'''
        ids, oldest = Fav.fav_ids_for_user(self.user_id, self.page_length)
        self.assertEqual(['6', '5', '4'], ids)
        self.assertEqual(oldest, self.favs[-self.page_length].created_at)

    def test_get_page_from_oldest(self):
        '''Paging is done by giving an older_than datetime'''
        ids, oldest = Fav.fav_ids_for_user(self.user_id, self.page_length, self.favs[-self.page_length].created_at)
        self.assertEqual(['3', '2', '1'], ids)
        self.assertEqual(oldest, self.favs[-(self.page_length * 2)].created_at)

    def test_get_last_page(self):
        '''Last page is not necessarily page_length long'''
        ids, oldest = Fav.fav_ids_for_user(self.user_id, self.page_length, self.favs[1].created_at)
        self.assertEqual(['0'], ids)
        self.assertEqual(oldest, self.favs[0].created_at)

    def test_page_past_the_end(self):
        '''Requesting past the end of the list gives an empty result'''
        ids, oldest = Fav.fav_ids_for_user(self.user_id, self.page_length, self.favs[0].created_at)
        self.assertEqual([], ids)
        self.assertNone(oldest)
        
