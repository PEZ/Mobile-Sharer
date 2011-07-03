//
//  StartController.m
//  MobileSharer
//
//  Created by PEZ on 2010-10-24.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "StartController.h"

@implementation StartController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if ((self = [super initWithNibName:nibNameOrNil	bundle:nibBundleOrNil])) {
    self.title = @"Menu";
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_loginLogoutButton);
  [super dealloc];
}

- (void) showFeed {
  TTOpenURL([Etc toFeedURLPath:@"me" name:@"News feed"]);
}

- (void)loadView {
  [super loadView];
  _loginLogoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:nil];
  self.navigationItem.leftBarButtonItem = _loginLogoutButton;
}

- (void)createModel {
  TTListDataSource* dataSource = [[[TTListDataSource alloc] init] autorelease];
  NSString* html = @"";
  if ([[FacebookJanitor sharedInstance] isLoggedIn]) {
    self.variableHeightRows = NO;
    self.tableView.rowHeight = 64;
    _loginLogoutButton.title = @"Logout";
    _loginLogoutButton.action = @selector(logout);

    //NSString* facebookPageUrl = [Etc urlEncode:@"http://www.facebook.com/apps/application.php?id=139083852806042&v=app_6261817190"];
    
    [dataSource.items addObject:[TTTableImageItem itemWithText:@"My notifications"
                                                      imageURL:@"bundle://notifications-50x50.png"
                                                           URL:kNotificationsURLPath]];

    NSString* feedUrl = [Etc toFeedURLPath:@"me" name:@"News feed"];
    [dataSource.items addObject:[TTTableImageItem itemWithText:@"My news feed"
                                                      imageURL:@"bundle://newsfeed-50x50.png"
                                                           URL:feedUrl]];

    if (_currentUserLoaded) {
      FacebookJanitor* janitor = [FacebookJanitor sharedInstance];
      [dataSource.items addObject:[TTTableImageItem itemWithText:[NSString stringWithFormat:@"My wall (%@)", janitor.currentUser.userName]
                                                        imageURL:[FacebookJanitor avatarForId:janitor.currentUser.userId]
                                                             URL:[Etc toFeedURLPath:janitor.currentUser.userId name:janitor.currentUser.userName]]];
    }
    else {
      [dataSource.items addObject:[TTTableActivityItem itemWithText:@"Loading current user..."]];
    }
    
    NSString* friendsUrl = [Etc toConnectionsURLPath:@"friends" andName:@"Friends"];
    [dataSource.items addObject:[TTTableImageItem itemWithText:@"My friends"
                                                      imageURL:@"bundle://friends-50x50.png"
                                                           URL:friendsUrl]];
/*
    NSString* pagesUrl = [Etc toConnectionsURLPath:@"likes" andName:@"Likes"];
    [dataSource.items addObject:[TTTableImageItem itemWithText:@"My likes (pages etc.)"
                                                      imageURL:@"bundle://likes-50x50.png"
                                                           URL:pagesUrl]];

    NSString* groupsUrl = [Etc toConnectionsURLPath:@"groups" andName:@"Groups"];
    [dataSource.items addObject:[TTTableImageItem itemWithText:@"My groups"
                                                      imageURL:@"bundle://groups-50x50.png"
                                                           URL:groupsUrl]];
*/
    NSString* shareItUrl = [Etc toPostIdPath:@"139083852806042_145649555484134" andTitle:@"Please share!"];
    [dataSource.items addObject:[TTTableImageItem itemWithText:@"Share Share!"
                                                      imageURL:@"bundle://share-50x50.png"
                                                           URL:shareItUrl]];

    NSString* appStoreUrl = [NSString stringWithFormat:
                             @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@&mt=8",
                             kAppStoreId];
    //appStoreUrl = [Etc urlEncode:appStoreUrl];
    [dataSource.items addObject:[TTTableImageItem itemWithText:@"Rate Share!"
                                                      imageURL:@"bundle://love-50x50.png"
                                                           URL:appStoreUrl]];
  }
  else {
    self.variableHeightRows = YES;
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
    [dataSource.items addObject:[TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:html lineBreaks:YES URLs:YES] URL:nil]];
  }

 _loginLogoutButton.enabled = YES;
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
    //[self showFeed];
  }
}

#pragma mark -
#pragma mark FBJSessionDelegate

-(void) fbjDidLogin {
  [[FacebookJanitor sharedInstance] getCurrentUserInfo:self];
  [self invalidateModel];
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
