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

- (id)initWithName:(NSString*)name andSecret:(NSString*)secret andUserId:(NSString*)userId {
  if ((self = [super initWithNibName:nil bundle:nil])) {
    _secret = [secret retain];
    _userId = [userId retain];
    self.title = name;
    self.variableHeightRows = YES;
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_secret);
  TT_RELEASE_SAFELY(_userId);
  [super dealloc];
}

- (void)createModel {
  self.dataSource = [[[FavoritesFeedDataSource alloc]
                      initWithSecret:_secret andUserId:_userId] autorelease];
}


@end
