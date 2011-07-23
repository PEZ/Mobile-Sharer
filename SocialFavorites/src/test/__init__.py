#!/usr/bin/env python
# -*- coding: utf-8 -*-

import unittest
import re

class SFTestCase(unittest.TestCase):
    @staticmethod
    def main():
        unittest.main()

    def assertMatches(self, text, *patterns):
        '''
        Assert that all regex patterns matches the text.
        @param text: the text to search
        @param *patterns: one or more regular expression pattern
        '''
        for pattern in patterns:
            if not re.search(pattern, text, re.I):
                raise self.failureException, "'" + pattern + "' not found in " + "'" + text + "'"

    def assertNotMatches(self, text, *patterns):
        '''
        Assert that none of the patterns mathces the text.
        @param text: the text to search
        @param *patterns: one or more regular expression pattern
        '''
        for pattern in patterns:
            if re.search(pattern, text, re.I):
                raise self.failureException, "'" + pattern + "' found in " + "'" + text + "'"

    def assertNone(self, var):
        '''
        Assert that var is None
        '''
        if var is not None:
            raise self.failureException, "'%s' is not None" % var

    def assertNotNone(self, var):
        '''
        Assert that var is not None
        '''
        if var is None:
            raise self.failureException, "'%s' is None" % var
  
    def assertNotRaises(self, excClass, callableObj, *args, **kwargs):
        '''
           Fail if an exception of class excClass is thrown
           by callableObj when invoked with arguments args and keyword
           arguments kwargs. If a different type of exception is
           thrown, it will be caught, and the test case succeeds. 
        '''
        try:
            callableObj(*args, **kwargs)
        except excClass:
            if hasattr(excClass,'__name__'): excName = excClass.__name__
            else: excName = str(excClass)
            raise self.failureException, "%s was raised" % excName
        else:
            return
    
    def assertInInterval(self, value, min, max):
        """ Asserts that value is larger or equal to min and smaller or equal to max """
        if value < min:
            raise self.failureException, "%s < %s" % (value, min)
        elif value > max:
            raise self.failureException, "%s > %s" % (value, max)

    def assertNotInInterval(self, value, min, max):
        """ Asserts that value is larger or equal to min and smaller or equal to max """
        if max >= value >= min:
            raise self.failureException, "%s >= %s >= %s" % (max, value, min)
    
    def assertContains(self, container, value):
        if value not in container:
            raise self.failureException('%r not in %r' % (value, container))
    
    def assertNotContains(self, container, value):
        if value in container:
            raise self.failureException('%r in %r' % (value, container))


def clear_datastore():
    from google.appengine.api import apiproxy_stub_map, datastore_file_stub
    
    if 'datastore' in apiproxy_stub_map.apiproxy._APIProxyStubMap__stub_map:
        del apiproxy_stub_map.apiproxy._APIProxyStubMap__stub_map['datastore']
    if 'datastore_v3' in apiproxy_stub_map.apiproxy._APIProxyStubMap__stub_map:
        del apiproxy_stub_map.apiproxy._APIProxyStubMap__stub_map['datastore_v3']
    
    stub = datastore_file_stub.DatastoreFileStub('dev~social-favorites', '/dev/null',
'/dev/null')
    apiproxy_stub_map.apiproxy.RegisterStub('datastore', stub)
 
class ModelTestCase(SFTestCase):    
    def setUp(self):
        super(ModelTestCase, self).setUp()
        clear_datastore()