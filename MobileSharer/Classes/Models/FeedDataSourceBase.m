//
//  FeedDataSourceBase.m
//  
//
//  Created by Peter Stromberg on 2011-09-01.
//  Copyright 2011 NA. All rights reserved.
//

#import "FeedDataSourceBase.h"
#import "FeedPostCell.h"
#import "LoadMoreCell.h"

@implementation FeedDataSourceBase

@synthesize feedModel = _feedModel;

- (void)dealloc {
  TT_RELEASE_SAFELY(_feedModel);
  [super dealloc];
}


- (id<TTModel>)model {
  return _feedModel;
}

#pragma mark -
#pragma mark TTTableViewDataSource


- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object { 
	if ([object isKindOfClass:[Post class]]) {
    return [FeedPostCell class];
	}
  else if ([object isKindOfClass:[TTTableMoreButton class]]) {
    return [LoadMoreCell class];
  }  
  else {
		return [super tableView:tableView cellClassForObject:object];
	}
}

- (void)tableView:(UITableView*)tableView prepareCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
	cell.accessoryType = UITableViewCellAccessoryNone;
}

- (NSString*)titleForLoading:(BOOL)reloading {
  if (reloading) {
    return NSLocalizedString(@"Updating feed...", @"Feed updating text");
  } else {
    return NSLocalizedString(@"Loading feed...", @"Feed loading text");
  }
}

- (NSString*)titleForEmpty {
  return NSLocalizedString(@"No posts found.", @"Feed no results");
}

- (NSString*)subtitleForError:(NSError*)error {
  return NSLocalizedString(@"Sorry, there was an error loading the Facebook stream.", @"");
}

@end
