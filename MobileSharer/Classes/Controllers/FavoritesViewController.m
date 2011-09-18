//
//  FavoritesViewController.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-08-30.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "FavoritesViewController.h"
#import "FavoritesFeedDataSource.h"
#import "FavoritesFeedModel.h"

@implementation FavoritesViewController

- (id)initWithName:(NSString*)name andSecret:(NSString*)secret andUserId:(NSString*)userId {
  if ((self = [super initWithNibName:nil bundle:nil])) {
    _secret = [secret retain];
    _userId = [userId retain];
    self.title = name;
    self.variableHeightRows = YES;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_secret);
  TT_RELEASE_SAFELY(_userId);
  [super dealloc];
}

- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewNetworkEnabledDelegate alloc] initWithController:self withDragRefresh:NO withInfiniteScroll:YES] autorelease];
}

- (void)createModel {
  self.dataSource = [[[FavoritesFeedDataSource alloc]
                      initWithSecret:_secret andUserId:_userId] autorelease];
}

- (BOOL)shouldLoadAtScrollRatio:(CGFloat)scrollRatio {
  TTURLRequestModel* model = (TTURLRequestModel*)self.dataSource.model;
  if (model.hasNoMore) {
    return NO;
  }
  else {
    return scrollRatio > 0.5;
  }
}
@end
