//
//  FacebookJanitor.m
//  MobileSharer
//
//  Created by PEZ on 2010-10-23.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "FacebookJanitor.h"

static void * volatile sharedInstance = nil;                                                

@interface FacebookJanitor(Private)

//KeychainItemWrapper* _keychain;

- (void)restoreSession;
- (void)createDateFormatter;

@end

@implementation FacebookJanitor

@synthesize loggedIn = _isLoggedIn;
@synthesize facebook = _facebook;
@synthesize dateFormatter = _dateFormatter;

- (id) init {
  if (self = [super init]) {
    _permissions =  [[NSArray arrayWithObjects: 
                      @"read_stream", @"publish_stream", @"offline_access", @"manage_notifications",
                      @"friends_photos", @"user_photos", @"user_likes", @"user_groups", @"share_item", nil] retain];
    _facebook = [[Facebook alloc] initWithAppId:kFacebookAppId];
    [self createDateFormatter];
    //_keychain = [[[KeychainItemWrapper alloc] initWithIdentifier:@"fbAccess" serviceName:nil accessGroup:nil] retain];
    [self restoreSession];
  }
  return self;
}

+ (FacebookJanitor *)sharedInstance {
  static BOOL initialized = NO;
  if(!initialized) {
    initialized = YES;
    sharedInstance = [[FacebookJanitor alloc] init];
  }
  return sharedInstance;
}

+ (NSDateFormatter*) dateFormatter {
  return [[self sharedInstance] dateFormatter];
}

- (void) createDateFormatter {
  _dateFormatter = [[NSDateFormatter alloc] init];
  [_dateFormatter setTimeStyle:NSDateFormatterFullStyle];
  [_dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
}

#pragma mark -
#pragma mark Save/restore session

/*
- (void)saveSession {
  [_keychain setObject:_facebook.accessToken forKey:kAccessTokenKey];
  [_keychain setObject:_facebook.expirationDate forKey:kExpirationDateKey];
}

- (void)restoreSession {
  _facebook.accessToken = [_keychain objectForKey:kAccessTokenKey];
  _facebook.expirationDate = [_keychain objectForKey:kExpirationDateKey];
}
*/
- (void)saveSession {
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  [prefs setObject:_facebook.accessToken forKey:kFacebookAccessTokenKey];
  [prefs setObject:_facebook.expirationDate forKey:kFacebookExpirationDateKey];
  [prefs synchronize];
}

- (void)restoreSession {
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  [prefs synchronize];
  _facebook.accessToken = [prefs stringForKey:kFacebookAccessTokenKey];
  _facebook.expirationDate = [prefs objectForKey:kFacebookExpirationDateKey];
}


#pragma mark -
#pragma mark Janitor tasks


+ (NSString*)avatarForId:(NSString*)fbId {
  return [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=square", fbId];
}

+ (NSString*)getAppId {
  return kFacebookAppId;
}

- (BOOL)isLoggedIn {
  return [_facebook isSessionValid];
}

- (void)authenticated:(NSURL*)url {
  [_facebook handleOpenURL:url];
}

- (void) getPermissions:(NSArray*)permissions delegate:(id<FBSessionDelegate>)delegate {
  [_facebook authorize:permissions delegate:delegate];
}

- (void) login:(id<FBJSessionDelegate>)delegate {
  _sessionDelegate = delegate;
  if (![self isLoggedIn]) {
    [self getPermissions:_permissions delegate:self];
  }
  else {
    [_sessionDelegate fbjDidLogin];
  }
}

- (void) logout:(id<FBJSessionDelegate>)delegate {
  _sessionDelegate = delegate;
  [_facebook logout:self];
}

- (void) getCurrentUserInfo:(id<UserRequestDelegate>)delegate {
  _userRequestDelegate = delegate;
  TT_RELEASE_SAFELY(_currentUserModel);
  _currentUserModel = [[[UserModel alloc] initWithGraphPath:@"me" andDelegate:self] retain];
  [_currentUserModel load:TTURLRequestCachePolicyNetwork more:NO];
}

- (User*) currentUser {
  return _currentUserModel.user;
}

- (NSString*)graphPathForCommentLikes:(NSString*)commentId {
  return [NSString stringWithFormat:@"%@/likes", commentId];
}

- (void)likeCommentWithId:(NSString*)commentId delegate:(id<FBRequestDelegate>)delegate {
  [_facebook requestWithGraphPath:[self graphPathForCommentLikes:commentId]
                        andParams:[NSMutableDictionary dictionaryWithCapacity:0]
                    andHttpMethod:@"POST"
                      andDelegate:delegate];
}

- (void)unLikeCommentWithId:(NSString*)commentId delegate:(id<FBRequestDelegate>)delegate {
  [_facebook requestWithGraphPath:[self graphPathForCommentLikes:commentId]
                        andParams:[NSMutableDictionary dictionaryWithCapacity:0]
                    andHttpMethod:@"DELETE"
                      andDelegate:delegate];
}

#pragma mark -
#pragma mark UserRequestDelegate
/**
 * Called when the current logged in users info has been fetched
 */
- (void) userRequestDidFinishLoad:(UserModel*)userModel {
  _currentUserModel = userModel;
  [_userRequestDelegate userRequestDidFinishLoad:userModel];
}

- (void)userRequestDidFailWithError:(NSError*)error {
  [_userRequestDelegate userRequestDidFailWithError:error];
}

#pragma mark -
#pragma mark NSObject

- (void) dealloc {
  TT_RELEASE_SAFELY(_facebook);
  TT_RELEASE_SAFELY(_permissions);
  TT_RELEASE_SAFELY(_sessionDelegate);
  TT_RELEASE_SAFELY(_dateFormatter);
  //  TT_RELEASE_SAFELY(_keychain);
  [super dealloc];
}

#pragma mark -
#pragma mark FBSessionDelegate

/**
 * Callback for facebook login
 */ 
-(void) fbDidLogin {
  _isLoggedIn = YES;
  [self saveSession];
  [_sessionDelegate fbjDidLogin];
}

/**
 * Callback for facebook did not login
 */
- (void)fbDidNotLogin:(BOOL)cancelled {
  _isLoggedIn = NO;
  [_sessionDelegate fbjDidNotLogin:cancelled];
}

/**
 * Callback for facebook logout
 */ 
-(void) fbDidLogout {
  _isLoggedIn = NO;
  [self saveSession];
  [_sessionDelegate fbjDidLogout];
}


#pragma mark -
#pragma mark FBRequestDelegate

/**
 * Callback when a request receives Response
 */ 
- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response{
  DLog(@"received response");
};

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest*)request didFailWithError:(NSError*)error{
  DLog(@"%@", [error localizedDescription]);
};

/**
 * Called when a request returns and its response has been parsed into an object.
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on thee format of the API response.
 */
- (void)request:(FBRequest*)request didLoad:(id)result {
  if ([result isKindOfClass:[NSArray class]]) {
    result = [result objectAtIndex:0]; 
  }
  if ([result objectForKey:@"owner"]) {
    //[self.label setText:@"Photo upload Success"];
  } else {
    //[self.label setText:[result objectForKey:@"name"]];
  }
};

#pragma mark -
#pragma mark FBDialogDelegate

/** 
 * Called when a UIServer Dialog successfully return
 */
- (void)dialogDidComplete:(FBDialog*)dialog{
  DLog(@"publish successfully");
}

@end
