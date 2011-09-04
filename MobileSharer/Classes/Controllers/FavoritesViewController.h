//
//  FavoritesViewController.h
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-08-30.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "FeedViewControllerBase.h"

@interface FavoritesViewController : FeedViewControllerBase {
  @private
  NSString* _secret;
  NSString* _userId;
}

@end
