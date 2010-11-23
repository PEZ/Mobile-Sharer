//
//  LoginViewController.m
//  MobileSharer
//
//  Created by PEZ on 2010-10-24.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = @"Home";
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_contentView);
  [super dealloc];
}

- (void) showFeed {
  [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:[Etc toFeedURLPath:@"me" name:@"My Feed"]]];
}

- (void)loadView {
  [super loadView];
  _contentView = [[LoginView alloc] initWithFrame:self.view.frame];
  [self.view addSubview:_contentView];
}

- (void)updateView {
  if ([[FacebookJanitor sharedInstance] isLoggedIn]) {
    _contentView.infoLabel.text = [TTStyledText textFromXHTML:@"Good choice that to log in." lineBreaks:YES URLs:YES];
    [_contentView.loginLogoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    [_contentView.loginLogoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_contentView.showFeedButton];
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(showFeed);
  }
  else {
    _contentView.infoLabel.text = [TTStyledText textFromXHTML:@"Login and allow everything!" lineBreaks:YES URLs:YES];
    [_contentView.loginLogoutButton setTitle:@"Login" forState:UIControlStateNormal];
    [_contentView.loginLogoutButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = nil;
  }
  _contentView.loginLogoutButton.enabled = YES;
  [_contentView layoutSubviews];
}

- (void)logout {
  _contentView.loginLogoutButton.enabled = NO;
  [[FacebookJanitor sharedInstance] logout:self];
}

- (void)login {
  _contentView.loginLogoutButton.enabled = NO;
  [[FacebookJanitor sharedInstance] login:self];
}

- (void) viewDidLoad {
  [self updateView];
  if ([[FacebookJanitor sharedInstance] isLoggedIn]) {
    [self showFeed];
  }
}

#pragma mark -
#pragma mark FBJSessionDelegate

-(void) fbjDidLogin {
  NSLog(@"Did login");
  [self updateView];
  [self showFeed];
}


-(void) fbjDidLogout {
  NSLog(@"Did logout");
  [self updateView];
}

- (void)fbjDidNotLogin:(BOOL)cancelled {
  [self updateView];
}

@end
