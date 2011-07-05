//
//  LoginViewController.h
//  MobileSharer
//
//  Created by PEZ on 2010-10-24.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "TableViewController.h"
#import "FacebookJanitor.h"

@protocol NotificationsCountDelegate <NSObject>

- (void)setNewNotificationsCount:(NSNumber*)count;
- (void)fetchingNotificationsCountError:(NSError*)error;

@end

@interface NotificationsCountFetcher : NSObject <FBRequestDelegate> {
@private
  BOOL _isLoading;
  BOOL _failedLoading;
  id<NotificationsCountDelegate> _delegate;
}

@property (readonly) BOOL isLoading;
@property (readonly) BOOL failedLoading;

- (id)initWithDelegate:(id<NotificationsCountDelegate>)delegate;
- (void)fetch;

@end


@interface StartController : TableViewController <FBJSessionDelegate, UserRequestDelegate, NotificationsCountDelegate> {
  @private
  UIBarButtonItem* _loginLogoutButton;
  UIBarButtonItem* _refreshButton;
  NSString*  _newNotificationsCountString;
  BOOL       _currentUserLoaded;
  BOOL       _currentUserLoadFailed;
  NotificationsCountFetcher* _notificationsCountFetcher;
}

- (void)refreshData;

@end
