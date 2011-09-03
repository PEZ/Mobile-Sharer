//
//  FavoritesViewController.h
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-08-30.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "FeedViewControllerBase.h"

@interface FavoritesViewController : FeedViewControllerBase

+ (void)setSecret:(NSString*)secret andUserId:(NSString*)userId;

@end
