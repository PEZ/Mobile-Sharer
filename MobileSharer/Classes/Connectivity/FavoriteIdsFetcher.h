//
//  FavoriteIdsFetcher.h
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-09-04.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "FavoritesSettings.h"

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
