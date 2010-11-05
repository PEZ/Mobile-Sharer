//
//  PostViewController.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-05.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "PostViewController.h"
#import "FeedDataSource.h"

@implementation PostViewController

@synthesize postId = _postId;

- (id)initWithPostId:(NSString *)postId andName:(NSString *)name {
  if (self = [super initWithNibName:nil bundle:nil]) {
    self.postId = postId;
    self.title = name;
    self.variableHeightRows = YES;
  }
  return self;
}

- (void)createModel {
  self.dataSource = [[[FeedDataSource alloc]
                      initWithSearchQuery:self.postId] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

@end
