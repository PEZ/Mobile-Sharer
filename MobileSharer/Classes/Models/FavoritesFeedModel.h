//
//  FavoritesFeedModel.h
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-08-31.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "FeedModelBase.h"
#import "FavoriteIdsFetcher.h"

@interface FavoritesFeedModel : FeedModelBase <FavoriteIdsFetcherDelegate> {
  @private
  FavoriteIdsFetcher* _favoriteIdsFetcher;
}

@property (readonly, retain) NSArray* favoriteIds;

- (id)initWithSecret:(NSString*)secret andUserId:(NSString*)userId;

@end
