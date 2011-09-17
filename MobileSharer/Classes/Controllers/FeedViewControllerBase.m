//
//  FeedViewControllerBase.m
//  
//
//  Created by Peter Stromberg on 2011-08-30.
//  Copyright 2011 NA. All rights reserved.
//

#import "FeedViewControllerBase.h"

@implementation FeedViewControllerBase


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewNetworkEnabledDelegate alloc] initWithController:self withDragRefresh:YES withInfiniteScroll:YES] autorelease];
}

@end
