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

static NSString* _secret;
static NSString* _userId;

- (id)initWithName:(NSString*)name {
  if ((self = [super initWithNibName:nil bundle:nil])) {
    self.title = name;
    self.variableHeightRows = YES;
  }
  return self;
}

+ (void)setSecret:(NSString*)secret andUserId:(NSString*)userId {
  TT_RELEASE_SAFELY(_secret);
  TT_RELEASE_SAFELY(_userId);
  _secret = [secret retain];
  _userId = [userId retain];
}

- (void)createModel {
  self.dataSource = [[[FavoritesFeedDataSource alloc]
                      initWithSecret:_secret andUserId:_userId] autorelease];
}


@end
