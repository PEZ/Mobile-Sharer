//
//  LoginViewController.h
//  MobileSharer
//
//  Created by PEZ on 2010-10-24.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "TableViewController.h"
#import "FacebookJanitor.h"
#import "FavoritesFeedModel.h"
#import "FavoritesSecretFetcher.h"

@class NotificationsCountFetcher;

@protocol NotificationsCountDelegate <NSObject>
- (void)fetchingNotificationsCountDone:(NotificationsCountFetcher*)fetcher;
- (void)fetchingNotificationsCountError:(NSError*)error;
@end

@interface NotificationsCountFetcher : NSObject <FBRequestDelegate> {
@private
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
<FBJSessionDelegate, UserRequestDelegate, NotificationsCountDelegate, HasLikedDelegate, FavoritesSecretFetcherDelegate> {
  @private
  UIBarButtonItem* _loginLogoutButton;
  UIBarButtonItem* _refreshButton;
  BOOL       _currentUserLoaded;
  BOOL       _currentUserLoadFailed;
  BOOL       _fetchingSecretFailed;
  NotificationsCountFetcher* _notificationsCountFetcher;
  HasLikedChecker* _hasLikedChecker;
  FavoritesSecretFetcher* _secretFetcher;
  NSString* _favoritesSecret;
}

- (void)refreshData;

@end
