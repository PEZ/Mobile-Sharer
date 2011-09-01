//
//  FavoritesViewController.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-08-30.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "FavoritesViewController.h"
#import "FavoritesFeedDataSource.h"

@implementation FavoritesViewController

static NSArray* _favoriteIds;

- (id)initWithName:(NSString *)name {
  if ((self = [super initWithNibName:nil bundle:nil])) {
    self.title = name;
    self.variableHeightRows = YES;
  }
  return self;
}

+ (void)setFavoriteIds:(NSArray *)ids {
  _favoriteIds = [ids retain];
}

- (void)createModel {
  self.dataSource = [[[FavoritesFeedDataSource alloc]
                      initWithFavoriteIds:_favoriteIds] autorelease];
}


@end
