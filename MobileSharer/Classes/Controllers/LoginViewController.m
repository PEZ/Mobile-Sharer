//
//  LoginViewController.m
//  MobileSharer
//
//  Created by PEZ on 2010-10-24.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

- (id) init {
  if (self = [super init]) {
  }
  return self;
}

- (void) viewDidLoad {
  [[FacebookJanitor sharedInstance] login:self];
}

#pragma mark -
#pragma mark FBJSessionDelegate

-(void) fbjDidLogin {
  NSLog(@"Did login");
  [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:[Atlas toFeedURLPath:@"me" name:@"My Feed"]]];
}

- (void)fbjDidNotLogin:(BOOL)cancelled {
}

@end

