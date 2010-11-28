//
//  PostViewController.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-18.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "PostViewController.h"

@implementation PostViewController

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query { 
  if (self = [self init]) {
    _post = [query objectForKey:@"__userInfo__"];
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_post);
  [super dealloc];
}

#pragma mark -
#pragma mark TTTableViewController

- (void)createModel {
  self.dataSource = [[[PostDataSource alloc]
                      initWithPost:self.post] autorelease];
}

#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
  NSLog(@"Failed posting: %@", error);
  TTAlert([NSString stringWithFormat:@"Failed posting to Facebook: %@", [error localizedDescription]]);
}

@end
