//
//  PostIdViewController.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-18.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "PostIdViewController.h"
#import "CommentsPostController.h"

@implementation PostIdViewController

- (id)initWithPostId:(NSString *)postId andTitle:(NSString*)title {

  if (self = [self init]) {
    self.title = title;
    _postId = [postId copy];
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_postId);
  [super dealloc];
}

- (void)modelDidFinishLoad:(PostModel*)postModel {
  _post = postModel.post;
  [self setupView];
  [super modelDidFinishLoad:postModel];
}

#pragma mark -
#pragma mark TTTableViewController

- (void)createModel {
  self.dataSource = [[[PostDataSource alloc] initWithPostId:_postId] autorelease];
}


@end
