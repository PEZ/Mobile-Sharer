//
//  FavoritesFeedModel.h
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-08-31.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "FeedModelBase.h"

#pragma mark -
#pragma mark Helpers

@protocol FavoriteIdsFetcherDelegate <NSObject>
- (void)fetchingFavoriteIdsDone:(NSArray*)ids;
- (void)request:(TTURLRequest*)request fetchingFavoriteIdsError:(NSError*)error;
@end

@interface FavoriteIdsFetcher : TTURLRequestModel <TTURLRequestDelegate> {
@private
  NSString* _secret;
  id<FavoriteIdsFetcherDelegate> _delegate;
}

@property (readonly, retain) NSDate* lastFavCreatedAt;

- (id)initWithSecret:(NSString*)secret andDelegate:(id<FavoriteIdsFetcherDelegate>)delegate;

@end

#pragma mark -
#pragma FavoritesFeedModel

@interface FavoritesFeedModel : FeedModelBase <FavoriteIdsFetcherDelegate> {
  @private
  FavoriteIdsFetcher* _favoriteIdsFetcher;
}

@property (readonly, retain) NSArray* favoriteIds;

- (id)initWithSecret:(NSString*)secret;

@end
