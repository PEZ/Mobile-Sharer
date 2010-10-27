//
//  FacebookJanitor.h
//  MobileSharer
//
//  Created by PEZ on 2010-10-23.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FBJSessionDelegate;

@interface FacebookJanitor : NSObject <FBRequestDelegate, FBDialogDelegate, FBSessionDelegate> {
  id<FBJSessionDelegate> _sessionDelegate;
  Facebook* _facebook;
  NSArray* _permissions;
  BOOL _isLoggedIn;
}

@property(nonatomic, retain) Facebook* facebook;
@property(nonatomic, getter=_isLoggedIn) BOOL loggedIn;

+ (FacebookJanitor*) sharedInstance;

- (void) getPermissions:(NSArray*)permissions delegate:(id<FBSessionDelegate>)delegate;
- (void) login:(id<FBJSessionDelegate>)delegate;
- (void) logout;

@end

@protocol FBJSessionDelegate <NSObject>

@optional

/**
 * Called when the dialog successful log in the user
 */
- (void)fbjDidLogin;

/**
 * Called when the user dismiss the dialog without login
 */
- (void)fbjDidNotLogin:(BOOL)cancelled;

@end
