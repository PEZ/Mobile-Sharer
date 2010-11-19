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

- (id)initWithPostId:(NSString *)postId {

  if (self = [self init]) {
    self.title = @"New post";
    _postId = [postId copy];
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_postId);
  [super dealloc];
}

- (CommentsPostController *) createCommentsPostController {
  CommentsPostController* controller = [[CommentsPostController alloc] initWithPostId:_postId
                                                                          andDelegate:self];
  return controller;
}

#pragma mark -
#pragma mark TTTableViewController

- (void)createModel {
  self.dataSource = [[[PostDataSource alloc]
                      initWithPostId:_postId] autorelease];
}


@end
