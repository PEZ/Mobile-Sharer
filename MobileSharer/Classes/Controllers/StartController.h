//
//  LoginViewController.h
//  MobileSharer
//
//  Created by PEZ on 2010-10-24.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "TableViewController.h"
#import "FacebookJanitor.h"

@class NotificationsCountFetcher;

@protocol NotificationsCountDelegate <NSObject>
- (void)fetchingNotificationsCountDone:(NotificationsCountFetcher*)fetcher;
- (void)fetchingNotificationsCountError:(NSError*)error;
@end

@interface NotificationsCountFetcher : NSObject <FBRequestDelegate> {
@private
  BOOL _isLoading;
  BOOL _failedLoading;
  NSNumber* _newCount;
  id<NotificationsCountDelegate> _delegate;
}

@property (readonly) BOOL isLoading;
@property (readonly) BOOL failedLoading;
@property (nonatomic, retain) NSNumber* newCount;

- (id)initWithDelegate:(id<NotificationsCountDelegate>)delegate;
- (void)fetch;

@end

@class HasLikedChecker;

@protocol HasLikedDelegate <NSObject>
- (void)hasLikedCheckDone:(HasLikedChecker*)checker;
@end

@interface HasLikedChecker : NSObject <FBRequestDelegate> {
@private
  NSString*            _pageId;
  id<HasLikedDelegate> _delegate;
}

@property (readonly) BOOL hasChecked;
@property (readonly) BOOL hasLiked;

+ (HasLikedChecker*)checkerWithPageId:(NSString*)pageId andDelegate:(id<HasLikedDelegate>)delegate;
- (void)check;

@end


@interface StartController : TableViewController
<FBJSessionDelegate, UserRequestDelegate, NotificationsCountDelegate, HasLikedDelegate> {
  @private
  UIBarButtonItem* _loginLogoutButton;
  UIBarButtonItem* _refreshButton;
  NSString*  _newNotificationsCountString;
  BOOL       _currentUserLoaded;
  BOOL       _currentUserLoadFailed;
  NotificationsCountFetcher* _notificationsCountFetcher;
  HasLikedChecker* _hasLikedChecker;
}

- (void)refreshData;

@end
