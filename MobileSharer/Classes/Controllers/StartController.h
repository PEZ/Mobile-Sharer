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

@end

@interface NotificationsCountFetcher : NSObject <FBRequestDelegate> {
@private
  id<NotificationsCountDelegate> _delegate;
}

- (id)initWithDelegate:(id<NotificationsCountDelegate>)delegate;
- (void)fetch;

@end


@interface StartController : TableViewController <FBJSessionDelegate, UserRequestDelegate, NotificationsCountDelegate> {
  @private
  UIBarButtonItem* _loginLogoutButton;
  NSNumber*  _numNewNotifications;
  BOOL       _currentUserLoaded;
}

@end
