//
//  FacebookJanitor.m
//  MobileSharer
//
//  Created by PEZ on 2010-10-23.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "FacebookJanitor.h"

static void * volatile sharedInstance = nil;                                                
static NSString* kAppId = @"139083852806042";

@interface FacebookJanitor(Private)

- (id)restoreSession;
- (void)createDateFormatter;
- (id)restoreSession;

@end

@implementation FacebookJanitor

@synthesize loggedIn = _isLoggedIn, facebook = _facebook, dateFormatter = _dateFormatter;

- (id) init {
  if (self = [super init]) {
    _permissions =  [[NSArray arrayWithObjects: 
                      @"read_stream", @"publish_stream", @"offline_access", nil] retain];
    _facebook = [[Facebook alloc] init];
    [self createDateFormatter];
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

- (void)saveSession {
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  [prefs setObject:_facebook.accessToken forKey:@"fbAccessToken"];
  [prefs setObject:_facebook.expirationDate forKey:@"fbExpirationDate"];
}

- (id)restoreSession {
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  _facebook.accessToken = [prefs stringForKey:@"fbAccessToken"];
  _facebook.expirationDate = [prefs objectForKey:@"fbExpirationDate"];
  return self;
}

#pragma mark -
#pragma mark Janitor tasks

- (void)authenticated:(NSURL*)url {
  [_facebook handleOpenURL:url];
}

- (void) getPermissions:(NSArray*)permissions delegate:(id<FBSessionDelegate>)delegate {
  [_facebook authorize:kAppId permissions:permissions delegate:delegate];
}

- (void) login:(id<FBJSessionDelegate>)delegate {
  _sessionDelegate = delegate;
  if (![_facebook isSessionValid]) {
    [self getPermissions:_permissions delegate:self];
  }
  else {
    [_sessionDelegate fbjDidLogin];
  }
}

- (void) logout {
  [_facebook logout:self]; 
}

#pragma mark -
#pragma mark NSObject

- (void) dealloc {
  TT_RELEASE_SAFELY(_facebook);
  TT_RELEASE_SAFELY(_permissions);
  TT_RELEASE_SAFELY(_sessionDelegate);
  TT_RELEASE_SAFELY(_dateFormatter);
  [super dealloc];
}

#pragma mark -
#pragma mark FBSessionDelegate

/**
 * Callback for facebook login
 */ 
-(void) fbDidLogin {
  NSLog(@"Logged in");
  _isLoggedIn = YES;
  [self saveSession];
  [_sessionDelegate fbjDidLogin];
}

/**
 * Callback for facebook did not login
 */
- (void)fbDidNotLogin:(BOOL)cancelled {
  NSLog(@"did not login");
  _isLoggedIn = NO;
  [_sessionDelegate fbjDidNotLogin:cancelled];
}

/**
 * Callback for facebook logout
 */ 
-(void) fbDidLogout {
  _isLoggedIn = YES;
  NSLog(@"Logged in");
}


#pragma mark -
#pragma mark FBRequestDelegate

/**
 * Callback when a request receives Response
 */ 
- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response{
  NSLog(@"received response");
};

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest*)request didFailWithError:(NSError*)error{
  NSLog(@"%@", [error localizedDescription]);
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
  NSLog(@"publish successfully");
}

@end
