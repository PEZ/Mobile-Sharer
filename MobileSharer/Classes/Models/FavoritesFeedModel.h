//
//  FavoritesFeedModel.h
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-08-31.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "FeedModelBase.h"

static const NSInteger kIdsPerPage = 20;

static NSArray* _favoriteIds;

@interface FavoritesFeedModel : FeedModelBase

+ (void)setFavoriteIds:(NSArray*)ids;
@end
