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
    self.title = @"Start";
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_contentView);
  [super dealloc];
}

- (void) showFeed {
  TTOpenURL([Etc toFeedURLPath:@"me" name:@"Updates"]);
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
    NSString* shareItUrl = [Etc toPostIdPath:@"139083852806042_145649555484134" andTitle:@"Please share!"];
    //NSString* shareItUrl2 = [Etc toPostIdPath:@"152352554796431" andTitle:@"Where ideas come from (TED talk)"];
    //NSString* appStoreUrl = [NSString stringWithFormat:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8", kAppStoreId];
    //appStoreUrl = [Etc urlEncode:appStoreUrl];
    //NSString* facebookPageUrl = [Etc urlEncode:@"http://www.facebook.com/apps/application.php?id=139083852806042&v=app_6261817190"];
    NSString* html = @"<img class=\"articleImage\" src=\"bundle://Icon75.png\"/>";
    html = [NSString stringWithFormat:@"%@Thanks for using Mobile Share! Re-sharing links and movies on Facebook is now as easy as:\n\n\
1. tap the post containing the link\n\
2. tap <b>Share</b>\n\
3. write a message to go with the link\n\
4. tap <b>Done</b>\n\n\
If the post you are sharing already has a message you also want to share then use the <b>“Share”</b> button instead. \
This will quote the message and attribute it to it's original author.\n\n\
Please test it by sharing this post:\n\n\
<a href=\"%@\">Mobile Share rocks!</a>\n\n\
Happy mobile sharing!",
     html, shareItUrl];
    if (_currentUserLoaded) {
      FacebookJanitor* janitor = [FacebookJanitor sharedInstance];
      html = [NSString stringWithFormat:@"<div class=\"userInfo\">You are logged in as: \
<span class=\"tableTitleText\">%@</span></div>\n%@", janitor.currentUser.userName, html];
    }
    html = [NSString stringWithFormat:@"<div class=\"appInfo\">%@</div>", html];
    _contentView.infoLabel.text = [TTStyledText textFromXHTML:html lineBreaks:YES URLs:YES];
    _contentView.loginLogoutButton.title = @"Logout";
    _contentView.loginLogoutButton.action = @selector(logout);
    if (self.navigationItem.rightBarButtonItem == nil) {
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_contentView.showFeedButton];
      [_contentView.showFeedButton addTarget:self action:@selector(showFeed) forControlEvents:UIControlEventTouchUpInside];
    }
  }
  else {
    NSString* welcome = @"<div class=\"appInfo\"><img class=\"articleImage\" src=\"bundle://Icon75.png\"/>\
Welcome to Mobile Share!\n\n\
To be able to help you follow your Facebook feed and share links Mobile Share needs your permission. Please \
click the login button and grant it.\n\n\
Mobile Share will never post in your name without you telling it to. Hopefull you will use Mobile Share to tell your \
friends you are a happy user of the app anyway. Please do!\n\n\
Read reviews, ask questions, suggest features, whatever on the \
<a href=\"http://www.facebook.com/apps/application.php?id=139083852806042\">Mobile Share Facebook page.</a> \
(Please Like that page too.)</div>";
    _contentView.infoLabel.text = [TTStyledText textFromXHTML:welcome lineBreaks:YES URLs:YES];
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
  [self updateView];
  [[FacebookJanitor sharedInstance] getCurrentUserInfo:self];
  [self showFeed];
}


-(void) fbjDidLogout {
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
