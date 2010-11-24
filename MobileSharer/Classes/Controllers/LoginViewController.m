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
  TTOpenURL([Etc toFeedURLPath:@"me" name:@"My Feed"]);
}

- (void)loadView {
  [super loadView];
  _contentView = [[LoginView alloc] initWithFrame:self.view.frame];
  self.navigationItem.leftBarButtonItem = _contentView.loginLogoutButton;
  _contentView.loginLogoutButton.target = self;
  [self.view addSubview:_contentView];
}

- (void)updateView {
  if ([[FacebookJanitor sharedInstance] isLoggedIn]) {
    NSString* html = @"";
    html = [NSString stringWithFormat:@"%@At <a href=\"http://blog.betterthantomorrow.com\">Better Than Tomorrow</a> we are happy \
that you are using <a href=\"ms://feed/%@/Mobile%%20Sharer\">Mobile Sharer</a>.\n\n\
Please consider posting about the app on Facebook. (We also get all warm and fuzzzy when someone Likes the app.)",
     html, [FacebookJanitor getAppId]];
    if (_currentUserLoaded) {
      FacebookJanitor* janitor = [FacebookJanitor sharedInstance];
      html = [NSString stringWithFormat:@"%@\n\nYou are logged in as:\
              <div class=\"userInfo\"><img class=\"avatar\" src=\"%@\" /> <span class=\"tableTitleText\">%@</span></div>",
              html, [FacebookJanitor avatarForId:janitor.currentUser.userId], janitor.currentUser.userName];
    }
    html = [NSString stringWithFormat:@"<div class=\"appInfo\">%@</div>", html];
    _contentView.infoLabel.text = [TTStyledText textFromXHTML:html lineBreaks:YES URLs:YES];
    _contentView.loginLogoutButton.title = @"Logout";
    _contentView.loginLogoutButton.action = @selector(logout);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_contentView.showFeedButton];
    [_contentView.showFeedButton addTarget:self action:@selector(showFeed) forControlEvents:UIControlEventTouchUpInside];
  }
  else {
    _contentView.infoLabel.text = [TTStyledText textFromXHTML:@"<div class=\"appInfo\">Login and allow everything!</div>" lineBreaks:YES URLs:YES];
    _contentView.loginLogoutButton.title = @"Login";
    _contentView.loginLogoutButton.action = @selector(login);
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
    [[FacebookJanitor sharedInstance] getCurrentUserInfo:self];
    [self showFeed];
  }
}

#pragma mark -
#pragma mark FBJSessionDelegate

-(void) fbjDidLogin {
  NSLog(@"Did login");
  [self updateView];
  [[FacebookJanitor sharedInstance] getCurrentUserInfo:self];
  [self showFeed];
}


-(void) fbjDidLogout {
  NSLog(@"Did logout");
  _currentUserLoaded = NO;
  [self updateView];
}

- (void)fbjDidNotLogin:(BOOL)cancelled {
  _currentUserLoaded = NO;
  [self updateView];
}

#pragma mark -
#pragma mark UserRequestDelegate
/**
 * Called when the current logged in users info has been fetched
 */
- (void) userRequestDidFinishLoad:(UserModel*)userModel {
  _currentUserLoaded = YES;
  [self updateView];
}

@end
