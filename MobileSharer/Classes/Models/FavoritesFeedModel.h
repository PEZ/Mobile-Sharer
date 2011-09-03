//
//  FavoritesFeedModel.h
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-08-31.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "FeedModelBase.h"

#pragma mark -
#pragma mark SecretFetcher

@protocol SecretFetcherDelegate <NSObject>
- (void)fetchingSecretDone:(NSString*)secret;
- (void)request:(TTURLRequest*)request fetchingSecretError:(NSError*)error;
@end

@interface SecretFetcher : TTURLRequestModel <TTURLRequestDelegate> {
@private
  NSString* _userId;
  NSString* _accessToken;
  id<SecretFetcherDelegate> _delegate;
}

- (id)initWithUserId:(NSString*)userId andAccessToken:(NSString*)accessToken andDelegate:(id<SecretFetcherDelegate>)delegate;

@end

#pragma mark -
#pragma mark FavoriteIdsFetcher

@protocol FavoriteIdsFetcherDelegate <NSObject>
- (void)fetchingFavoriteIdsDone:(NSArray*)ids;
- (void)request:(TTURLRequest*)request fetchingFavoriteIdsError:(NSError*)error;
@end

@interface FavoriteIdsFetcher : TTURLRequestModel <TTURLRequestDelegate> {
@private
  NSString* _secret;
  NSString* _userId;
  id<FavoriteIdsFetcherDelegate> _delegate;
}

@property (readonly, retain) NSDate* lastFavCreatedAt;

- (id)initWithSecret:(NSString*)secret andUserId:(NSString*)userId andDelegate:(id<FavoriteIdsFetcherDelegate>)delegate;

@end

#pragma mark -
#pragma FavoritesFeedModel

@interface FavoritesFeedModel : FeedModelBase <FavoriteIdsFetcherDelegate> {
  @private
  FavoriteIdsFetcher* _favoriteIdsFetcher;
}

@property (readonly, retain) NSArray* favoriteIds;

- (id)initWithSecret:(NSString*)secret andUserId:(NSString*)userId;

@end
