//
//  PostViewController.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-05.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "PostViewController.h"
#import "PostDataSource.h"

@implementation PostViewController

@synthesize post = _post;

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query { 
  if (self = [super initWithNibName:nil bundle:nil]) {
    Post* passedPost = [query objectForKey:@"__userInfo__"];
    self.post = passedPost;
    self.title = @"Comments";
    self.variableHeightRows = YES;
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_post);
  [super dealloc];
}

- (void)createModel {
  self.dataSource = [[[PostDataSource alloc]
                      initWithPost:self.post] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

@end
