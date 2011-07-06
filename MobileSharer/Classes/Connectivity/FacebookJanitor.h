//
//  FacebookJanitor.h
//  MobileSharer
//
//  Created by PEZ on 2010-10-23.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "UserModel.h"
#import "FBConnect.h"

@protocol FBJSessionDelegate;

@interface FacebookJanitor : NSObject <FBRequestDelegate, FBDialogDelegate, FBSessionDelegate, UserRequestDelegate> {
  id<FBJSessionDelegate> _sessionDelegate;
  id<UserRequestDelegate> _userRequestDelegate;
  Facebook* _facebook;
  NSArray* _permissions;
  BOOL _isLoggedIn;
  NSDateFormatter* _dateFormatter;
  UserModel* _currentUserModel;
}

@property(nonatomic, retain) Facebook* facebook;
@property(nonatomic, getter=_isLoggedIn) BOOL loggedIn;
@property(nonatomic, retain) NSDateFormatter* dateFormatter;
@property(nonatomic, readonly) User* currentUser;
          
+ (FacebookJanitor*) sharedInstance;
+ (NSDateFormatter*) dateFormatter;
+ (NSString*)avatarForId:(NSString*)fbId;
+ (NSString*)getAppId;

- (void) getPermissions:(NSArray*)permissions delegate:(id<FBSessionDelegate>)delegate;
- (void) login:(id<FBJSessionDelegate>)delegate;
- (void) logout:(id<FBJSessionDelegate>)delegate;
- (void) getCurrentUserInfo:(id<UserRequestDelegate>)delegate;
- (BOOL) isLoggedIn;
- (void)likeCommentWithId:(NSString*)commentId delegate:(id<FBRequestDelegate>)delegate;
- (void)unLikeCommentWithId:(NSString*)commentId delegate:(id<FBRequestDelegate>)delegate;
@end

@protocol FBJSessionDelegate <NSObject>

@optional

/**
 * Called when the Janitor successfully logged in the user
 */
- (void)fbjDidLogin;

/**
 * Called when the Janitor successfully logged out the user
 */
- (void)fbjDidLogout;

/**
 * Called when the user dismiss the dialog without login
 */
- (void)fbjDidNotLogin:(BOOL)cancelled;

@end
