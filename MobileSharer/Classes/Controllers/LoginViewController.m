//
//  LoginViewController.m
//  MobileSharer
//
//  Created by PEZ on 2010-10-24.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

@synthesize infoLabel = _infoLabel;
@synthesize loginLogoutButton = _loginLogoutButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = @"Menu";
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_infoLabel);
  TT_RELEASE_SAFELY(_loginLogoutButton);
  [super dealloc];
}

- (void) viewDidLoad {
  [[FacebookJanitor sharedInstance] login:self];
}

#pragma mark -
#pragma mark FBJSessionDelegate

-(void) fbjDidLogin {
  NSLog(@"Did login");
  [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:[Etc toFeedURLPath:@"me" name:@"My Feed"]]];
}

- (void)fbjDidNotLogin:(BOOL)cancelled {
}

@end

