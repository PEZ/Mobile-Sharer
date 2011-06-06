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
  if ((self = [super initWithNibName:nibNameOrNil	bundle:nibBundleOrNil])) {
    self.title = @"Share!";
    self.variableHeightRows = YES;
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_loginLogoutButton);
  TT_RELEASE_SAFELY(_showFeedButton);
  [super dealloc];
}

- (void) showFeed {
  TTOpenURL([Etc toFeedURLPath:@"me" name:@"Updates"]);
}

- (void)loadView {
  [super loadView];
  _loginLogoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:nil];
  _showFeedButton = [[TTButton buttonWithStyle:@"forwardButton:" title:@"Updates"] retain];
  [_showFeedButton sizeToFit];
  self.navigationItem.leftBarButtonItem = _loginLogoutButton;
}

- (void)createModel {
  TTListDataSource* dataSource = [[[TTListDataSource alloc] init] autorelease];
  NSString* html = @"";
  if ([[FacebookJanitor sharedInstance] isLoggedIn]) {
    NSString* shareItUrl = [Etc toPostIdPath:@"139083852806042_145649555484134" andTitle:@"Please share!"];
    //NSString* shareItUrl2 = [Etc toPostIdPath:@"152352554796431" andTitle:@"Where ideas come from (TED talk)"];
    //NSString* appStoreUrl = [NSString stringWithFormat:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8", kAppStoreId];
    //appStoreUrl = [Etc urlEncode:appStoreUrl];
    //NSString* facebookPageUrl = [Etc urlEncode:@"http://www.facebook.com/apps/application.php?id=139083852806042&v=app_6261817190"];
    html = @"<img class=\"articleImage\" src=\"bundle://Icon75.png\"/>";
    html = [NSString stringWithFormat:@"%@Thanks for using Share! Re-sharing links and movies on Facebook is now as easy as:\n\n\
1. tap the post containing the link\n\
2. tap <b>Share</b>\n\
3. write a message to go with the link\n\
4. tap <b>Done</b>\n\n\
If the post you are sharing already has a message you also want to share then use the <b>“Share”</b> button instead. \
This will quote the message and attribute it to it's original author.\n\n\
Please test it by sharing this post:\n\n\
<a href=\"%@\">Share! rocks</a>\n\n\
Happy sharing!",
     html, shareItUrl];
    if (_currentUserLoaded) {
      FacebookJanitor* janitor = [FacebookJanitor sharedInstance];
      html = [NSString stringWithFormat:@"<div class=\"userInfo\">You are logged in as: \
<span class=\"tableTitleText\">%@</span></div>\n%@", janitor.currentUser.userName, html];
    }
    html = [NSString stringWithFormat:@"<div class=\"appInfo\">%@</div>", html];
    _loginLogoutButton.title = @"Logout";
    _loginLogoutButton.action = @selector(logout);
    if (self.navigationItem.rightBarButtonItem == nil) {
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_showFeedButton];
      [_showFeedButton addTarget:self action:@selector(showFeed) forControlEvents:UIControlEventTouchUpInside];
    }
  }
  else {
    html = @"<div class=\"appInfo\"><img class=\"articleImage\" src=\"bundle://Icon75.png\"/>\
Welcome to Share!\n\n\
To be able to help you follow your Facebook feed and share links Share! needs your permission. Please \
click the login button and grant it.\n\n\
Share! will never post in your name without you telling it to. Hopefull you will use Share! to tell your \
friends you are a happy user of the app anyway. Please do!\n\n\
Read reviews, ask questions, suggest features, whatever on the \
<a href=\"http://www.facebook.com/apps/application.php?id=139083852806042\">Share! Facebook page.</a> \
(Please Like that page too.)</div>";
    _loginLogoutButton.title = @"Login";
    _loginLogoutButton.action = @selector(login);
    self.navigationItem.rightBarButtonItem = nil;
  }
  _loginLogoutButton.enabled = YES;
  [dataSource.items addObject:[TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:html lineBreaks:YES URLs:YES] URL:nil]];
  self.dataSource = dataSource;
}

- (void)logout {
  _loginLogoutButton.enabled = NO;
  [[FacebookJanitor sharedInstance] logout:self];
}

- (void)login {
  _loginLogoutButton.enabled = NO;
  [[FacebookJanitor sharedInstance] login:self];
}

- (void) viewDidLoad {
  [super viewDidLoad];
  [self invalidateModel];
  if ([[FacebookJanitor sharedInstance] isLoggedIn]) {
    [[FacebookJanitor sharedInstance] getCurrentUserInfo:self];
    [self showFeed];
  }
}

#pragma mark -
#pragma mark FBJSessionDelegate

-(void) fbjDidLogin {
  [self invalidateModel];
  [[FacebookJanitor sharedInstance] getCurrentUserInfo:self];
  [self showFeed];
}


-(void) fbjDidLogout {
  _currentUserLoaded = NO;
  [self invalidateModel];
}

- (void)fbjDidNotLogin:(BOOL)cancelled {
  _currentUserLoaded = NO;
  [self invalidateModel];
}

#pragma mark -
#pragma mark UserRequestDelegate
/**
 * Called when the current logged in users info has been fetched
 */
- (void) userRequestDidFinishLoad:(UserModel*)userModel {
  _currentUserLoaded = YES;
  [self invalidateModel];
}

@end
