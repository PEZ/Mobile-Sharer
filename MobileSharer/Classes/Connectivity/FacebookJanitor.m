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

@implementation FacebookJanitor

@synthesize loggedIn = _isLoggedIn, facebook = _facebook;

+ (FacebookJanitor *)sharedInstance {
  static BOOL initialized = NO;
  if(!initialized) {
    initialized = YES;
    sharedInstance = [[FacebookJanitor alloc] init];
  }
  return sharedInstance;
}

- (id) init {
  if (self = [super init]) {
    _permissions =  [[NSArray arrayWithObjects: 
                      @"read_stream", @"publish_stream",nil] retain];
    _facebook = [[Facebook alloc] init];
  }
  return self;
}

#pragma mark -
#pragma mark Janitor tasks

- (void) getPermissions:(NSArray*)permissions delegate:(id<FBSessionDelegate>)delegate {
  [_facebook authorize:kAppId permissions:permissions delegate:delegate];
}

- (void) login:(id<FBJSessionDelegate>)delegate {
  _sessionDelegate = delegate;
  [self getPermissions:_permissions delegate:self];
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