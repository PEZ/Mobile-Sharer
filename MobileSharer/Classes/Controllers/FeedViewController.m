//
//  PostViewController.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-05.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedDataSource.h"

@implementation FeedViewController

@synthesize feedId = _feedId;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = @"Facebook feed";
    self.variableHeightRows = YES;
  }

  return self;
}

- (id)initWithFBFeedIdAndName:(NSString *)feedId name:(NSString *)name {
  if (self = [super initWithNibName:nil bundle:nil]) {
    self.feedId = feedId;
    self.title = name;
    self.variableHeightRows = YES;
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
  self.dataSource = [[[FeedDataSource alloc]
                      initWithFeedId:self.feedId] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

@end

