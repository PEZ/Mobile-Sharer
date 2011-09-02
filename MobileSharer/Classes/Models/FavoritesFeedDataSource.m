//
//  FavoritesFeedDataSource.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-09-01.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "FavoritesFeedDataSource.h"
#import "FavoritesFeedModel.h"
#import "Post.h"

@implementation FavoritesFeedDataSource


- (id)initWithSecret:(NSString*)secret {
  if ((self = [super init])) {
    self.feedModel = [[[FavoritesFeedModel alloc] initWithSecret:secret] autorelease];
  }
  
  return self;
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {
  NSMutableArray* items = [[NSMutableArray alloc] init];
  
  for (Post* post in self.feedModel.posts) {
    [items addObject:post];
  }
  
  [items addObject:[TTTableMoreButton itemWithText:@"Load more posts..."]];
  
  self.items = items;
  TT_RELEASE_SAFELY(items);
}

@end
