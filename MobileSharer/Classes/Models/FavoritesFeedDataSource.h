//
//  FavoritesFeedDataSource.h
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-09-01.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "FeedDataSourceBase.h"

@interface FavoritesFeedDataSource : FeedDataSourceBase

- (id)initWithSecret:(NSString*)secret andUserId:(NSString*)userId;

@end
