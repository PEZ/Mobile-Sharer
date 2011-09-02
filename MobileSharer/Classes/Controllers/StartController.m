//
//  StartController.m
//  MobileSharer
//
//  Created by PEZ on 2010-10-24.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "StartController.h"
#import "FavoritesViewController.h"

static const NSTimeInterval kNotificationsCountFetchInterval = 120;

@implementation NotificationsCountFetcher

@synthesize isLoading = _isLoading;
@synthesize failedLoading = _failedLoading;
@synthesize newCount = _newCount;

- (id)initWithDelegate:(id<NotificationsCountDelegate>)delegate {
  if ((self = [super init])) {
    _delegate = [delegate retain];
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_delegate);
  TT_RELEASE_SAFELY(_newCount);
  [super dealloc];
}

- (void)fetch {
  _isLoading = YES;
  _failedLoading = NO;
  [[FacebookJanitor sharedInstance].facebook
   requestWithParams:[NSMutableDictionary dictionaryWithObject:@"notifications.get"
                                                        forKey:@"method"]
   andDelegate:self];
}

#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
  _isLoading = NO;
  _failedLoading = YES;
  DLog(@"Failed getting notification counts: %@", error);
  [_delegate fetchingNotificationsCountError:error];
}

- (void)request:(FBRequest*)request didLoad:(id)result {
  _isLoading = NO;
  _failedLoading = NO;
  if ([result isKindOfClass:[NSDictionary class]]) {
  NSDictionary* data = result;
    self.newCount = [[data objectForKey:@"notification_counts"] objectForKey:@"unseen"];
    [_delegate fetchingNotificationsCountDone:self]; 
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[_newCount intValue]];
  }
  else {
    [self request:request didFailWithError:[NSError errorWithDomain:@"Facebook API returned garbage instead of notification counts" code:0 userInfo:nil]];
  }
}

@end

@implementation HasLikedChecker

@synthesize hasChecked = _hasChecked;
@synthesize hasLiked = _hasLiked;

- (id)initWithPageId:(NSString*)pageId andDelegate:(id<HasLikedDelegate>)delagate {
  if ((self = [self init])) {
    _hasChecked = NO;
    _hasLiked = NO;
    _pageId = [pageId retain];
    _delegate = [delagate retain];
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_pageId);
  TT_RELEASE_SAFELY(_delegate);
  [super dealloc];
}

+ (HasLikedChecker*)checkerWithPageId:(NSString*)pageId andDelegate:(id<HasLikedDelegate>)delegate {
  HasLikedChecker* checker = [[[HasLikedChecker alloc] initWithPageId:pageId andDelegate:delegate] autorelease];
  return checker;
}

- (void)check {
  [[FacebookJanitor sharedInstance].facebook
   requestWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"pages.isFan", @"method", _pageId, @"page_id", nil]
   andDelegate:self];
}

#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
  DLog(@"Failed checking has liked: %@", error);
  DLog(@"Details: %@", [error description]);
  DLog(@"More details: %@", [error userInfo]);
}

- (void)request:(FBRequest*)request didLoad:(id)result {
  _hasChecked = YES;
  if ([result isKindOfClass:[NSDictionary class]]) {
    _hasLiked = [[result objectForKey:@"result"] boolValue];
  }
  else {
    [self request:request didFailWithError:[NSError errorWithDomain:@"Facebook API returned garbage instead of isFan results" code:0 userInfo:nil]];
  }
  [_delegate hasLikedCheckDone:self];
}

@end

@implementation StartController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if ((self = [super initWithNibName:nibNameOrNil	bundle:nibBundleOrNil])) {
    self.title = @"Menu";
    _notificationsCountFetcher = [[[NotificationsCountFetcher alloc] initWithDelegate:self] retain];
    _hasLikedChecker = [[HasLikedChecker checkerWithPageId:kFeedbackPageId andDelegate:self] retain];
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_loginLogoutButton);
  TT_RELEASE_SAFELY(_refreshButton);
  TT_RELEASE_SAFELY(_notificationsCountFetcher)
  [super dealloc];
}

- (void) showFeed {
  TTOpenURL([Etc toFeedURLPath:@"me" name:@"News feed"]);
}

- (void) createLoginLogoutButton {
  if (_loginLogoutButton != nil) {
    TT_RELEASE_SAFELY(_loginLogoutButton);
  }
  _loginLogoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Login"
                                                        style:UIBarButtonItemStyleBordered
                                                       target:self
                                                       action:nil];
  self.navigationItem.rightBarButtonItem = _loginLogoutButton;
}

- (void) createRefreshButton {
  if (_refreshButton != nil) {
    TT_RELEASE_SAFELY(_refreshButton);
  }
  _refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                 target:self
                                                                 action:@selector(refreshData)];
  self.navigationItem.leftBarButtonItem = _refreshButton;
}

- (void)loadView {
  [super loadView];
  [self createLoginLogoutButton];
  [self createRefreshButton];
  _refreshButton.enabled = NO;
  [self refreshData];
}

- (void)refreshData {
  _currentUserLoadFailed = NO;
  if (_refreshButton == nil) {
    [self createRefreshButton];
  }
  _refreshButton.enabled = NO;
  if ([[FacebookJanitor sharedInstance] isLoggedIn]) {
    if (_currentUserLoaded) {
      [_notificationsCountFetcher fetch];
      [_hasLikedChecker check];
    }
    else {
      [[FacebookJanitor sharedInstance] getCurrentUserInfo:self];
    }
  }
  [self invalidateModel];
}

- (void)createModel {
  TTListDataSource* dataSource = [[TTListDataSource alloc] init];
  NSString* html = @"";
  if ([[FacebookJanitor sharedInstance] isLoggedIn]) {
    self.variableHeightRows = NO;
    self.tableView.rowHeight = 64;
    _loginLogoutButton.title = @"Logout";
    _loginLogoutButton.action = @selector(logout);

    //NSString* facebookPageUrl = [Etc urlEncode:@"http://www.facebook.com/apps/application.php?id=139083852806042&v=app_6261817190"];

    if (_notificationsCountFetcher.isLoading) {
      [dataSource.items addObject:[TTTableActivityItem itemWithText:@"Fetching..."]];
    }
    else {
      NSString* newCountString = @"";
      if (_notificationsCountFetcher.failedLoading) {
        newCountString = @"(Fetch failed)";
      }
      else if ([_notificationsCountFetcher.newCount intValue] > 0) {
        newCountString = [NSString stringWithFormat:@"(%@)", _notificationsCountFetcher.newCount];
      }
      [dataSource.items addObject:[TTTableImageItem itemWithText:[NSString stringWithFormat:@"Notifications %@", newCountString]
                                                        imageURL:@"bundle://notifications-50x50.png"
                                                             URL:kNotificationsURLPath]];
    }
    
    NSString* feedUrl = [Etc toFeedURLPath:@"me" name:@"News feed"];
    [dataSource.items addObject:[TTTableImageItem itemWithText:@"News feed"
                                                      imageURL:@"bundle://newsfeed-50x50.png"
                                                           URL:feedUrl]];
    if (_currentUserLoaded) {
      FacebookJanitor* janitor = [FacebookJanitor sharedInstance];
      [dataSource.items addObject:[TTTableImageItem itemWithText:[NSString stringWithFormat:@"%@", janitor.currentUser.userName]
                                                        imageURL:[FacebookJanitor avatarForId:janitor.currentUser.userId]
                                                             URL:[Etc toFeedURLPath:janitor.currentUser.userId name:janitor.currentUser.userName]]];
    }
    else if (_currentUserLoadFailed) {
      [dataSource.items addObject:[TTTableTextItem itemWithText:@"Error loading user info"]];
    }
    else {
      [dataSource.items addObject:[TTTableActivityItem itemWithText:@"Loading current user..."]];
    }

#if APP==FAVORITES_APP
    [FavoritesViewController setSecret:@"6ae8a11b0d34a5028296ef11e3bb45cd2b9279d2"];
    NSString* favoritesUrl = [Etc toFavoritesFeedURLPath:@"Bookmarks"];
    [dataSource.items addObject:[TTTableImageItem itemWithText:@"Bookmarked posts"
                                                      imageURL:@"bundle://favorites-50x50.png"
                                                           URL:favoritesUrl]];    
#endif
    
    NSString* friendsUrl = [Etc toConnectionsURLPath:@"friends" andName:@"Friends"];
    [dataSource.items addObject:[TTTableImageItem itemWithText:@"Friends"
                                                      imageURL:@"bundle://friends-50x50.png"
                                                           URL:friendsUrl]];

    NSString* pagesUrl = [Etc toConnectionsURLPath:@"likes" andName:@"Likes"];
    [dataSource.items addObject:[TTTableImageItem itemWithText:@"Likes (pages etc.)"
                                                      imageURL:@"bundle://likes-50x50.png"
                                                           URL:pagesUrl]];

    NSString* groupsUrl = [Etc toConnectionsURLPath:@"groups" andName:@"Groups"];
    [dataSource.items addObject:[TTTableImageItem itemWithText:@"Groups"
                                                      imageURL:@"bundle://groups-50x50.png"
                                                           URL:groupsUrl]];
    
    NSString* shareAppUrl = [Etc toFeedURLPath:kFeedbackPageId name:kAppTitle];
    [dataSource.items addObject:[TTTableImageItem itemWithText:@"Feedback"
                                                      imageURL:[FacebookJanitor avatarForId:kFeedbackPageId]
                                                           URL:shareAppUrl]];
    
    NSString* shareItUrl = [Etc toPostIdPath:@"139083852806042_145649555484134" andTitle:@"Please share!"];
    [dataSource.items addObject:[TTTableImageItem itemWithText:@"Please share this"
                                                      imageURL:@"bundle://love-50x50.png"
                                                           URL:shareItUrl]];
    
    NSString* appStoreUrl = [NSString stringWithFormat:
                             @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@&mt=8",
                             kAppStoreId];
    [dataSource.items addObject:[TTTableImageItem itemWithText:@"Please rate Share! on the App Store"
                                                      imageURL:@"bundle://love-50x50.png"
                                                           URL:appStoreUrl]];

    if (_hasLikedChecker.hasChecked && !_hasLikedChecker.hasLiked) {
      NSString* fbShareURL = [NSString stringWithFormat:@"https://www.facebook.com/%@", kFeedbackPageUsername];
      [dataSource.items addObject:[TTTableImageItem itemWithText:@"Please like the Share! page"
                                                        imageURL:@"bundle://love-50x50.png"
                                                             URL:fbShareURL]];
    }
  }
  else {
    self.variableHeightRows = YES;
    html = [NSString stringWithFormat:@"<div class=\"appInfo\"><img class=\"articleImage\" src=\"bundle://Icon75.png\"/>\
Welcome to Share!\n\n\
To be able to help you follow your Facebook feed and share links <b>Share!</b> needs your permission. Please \
click the login button and grant it.\n\n\
Share! will never post in your name without you telling it to. Hopefull you will use Share! to tell your \
friends you are a happy user of the app anyway. Please do!\n\n\
Read reviews, ask questions, suggest features, whatever on the \
<a href=\"%@\">Share! Facebook page.</a> \
(Please Like that page too.)</div>", kFeedbackPageURL];
    _loginLogoutButton.title = @"Login";
    _loginLogoutButton.action = @selector(login);
    self.navigationItem.leftBarButtonItem = nil;
    if (_refreshButton != nil) {
      TT_RELEASE_SAFELY(_refreshButton);
    }
    [dataSource.items addObject:[TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:html lineBreaks:YES URLs:YES] URL:nil]];
  }

 _loginLogoutButton.enabled = YES;
  self.dataSource = dataSource;
  TT_RELEASE_SAFELY(dataSource);
}

- (void)logout {
  _loginLogoutButton.enabled = NO;
  [[FacebookJanitor sharedInstance] logout:self];
}

- (void)login {
  _loginLogoutButton.enabled = NO;
  [[FacebookJanitor sharedInstance] login:self];
}

/*
- (void) viewDidLoad {
  [super viewDidLoad];
  [self refreshData];
}
*/

- (void)fetchNotificationsCountTimerFired:(NSTimer*)timer {
  [timer invalidate];
  [self refreshData];
}

- (void) scheduleNotificationsCountTimer {
  NSTimer* timer = [NSTimer timerWithTimeInterval:kNotificationsCountFetchInterval
                                           target:self
                                         selector:@selector(fetchNotificationsCountTimerFired:)
                                         userInfo:nil
                                          repeats:YES];
  [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
  
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
  _currentUserLoadFailed = NO;
  [self refreshData];
}

- (void)userRequestDidFailWithError:(NSError*)error {
  _currentUserLoadFailed = YES;
  _refreshButton.enabled = YES;
  TTAlert([NSString stringWithFormat:@"Error getting user info: %@", [error localizedDescription]]);
  [self invalidateModel];
}

#pragma mark -
#pragma mark NotificationsCountDelegate

- (void)fetchingNotificationsCountDone:(NotificationsCountFetcher*)fetcher {
  _refreshButton.enabled = YES;
  [self invalidateModel];
  [self scheduleNotificationsCountTimer];
}

- (void)fetchingNotificationsCountError:(NSError*)error {
  _refreshButton.enabled = YES;
  [self invalidateModel];
  [self scheduleNotificationsCountTimer];
}

#pragma mark -
#pragma mark HasLikedDelegate

- (void)hasLikedCheckDone:(HasLikedChecker *)checker {
  [self invalidateModel];
}

@end
