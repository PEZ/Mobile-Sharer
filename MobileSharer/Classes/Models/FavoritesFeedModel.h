//
//  FavoritesFeedModel.h
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-08-31.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "FeedModelBase.h"

static const NSInteger kIdsPerPage = 20;

@interface FavoritesFeedModel : FeedModelBase

@property (nonatomic, retain) NSArray* favoriteIds;

- (id)initWithFavoriteIds:(NSArray*)ids;

@end
