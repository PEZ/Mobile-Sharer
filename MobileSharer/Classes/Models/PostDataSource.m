//
//  PostDataSource.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-06.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "PostDataSource.h"

#import "LinkPostCellStandalone.h"
#import "PostCell.h"
#import "CommentCell.h"
#import "LoadMoreCell.h"

@implementation PostDataSource

@synthesize postItem = _postItem;

- (id)initWithPost:(Post*)post {
  if (self = [super init]) {
    _postModel = [[PostModel alloc] initWithPost:post];
    _postItem = [post copy];
    _postItem.URL = nil;
  }
  
  return self;
}


- (void)dealloc {
  TT_RELEASE_SAFELY(_postModel);
  TT_RELEASE_SAFELY(_postItem);
  
  [super dealloc];
}


- (id<TTModel>)model {
  return _postModel;
}


- (void)tableViewDidLoadModel:(UITableView*)tableView {
  NSMutableArray* items = [[NSMutableArray alloc] init];
  [items addObject:_postItem];
  if ([_postItem.commentCount intValue] > [_postModel.comments count]) {
    [items addObject:[TTTableMoreButton itemWithText:@"Load earlier comments..."]];
  }
  for (Comment* comment in _postModel.comments) {
    [items addObject:comment];
  }
  
  self.items = items;
  TT_RELEASE_SAFELY(items);
}

#pragma mark -
#pragma mark TTTableViewDataSource

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object { 
	if ([object isKindOfClass:[Post class]]) {
    Post* item = object;
    if (item.linkURL) {
      return [LinkPostCellStandalone class];
    }
    else {
      return [PostCell class];      
    }
	}
  else 	if ([object isKindOfClass:[Comment class]]) {
    return [CommentCell class];
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
    return NSLocalizedString(@"Updating comments ...", @"Facebook feed updating text");
  } else {
    return NSLocalizedString(@"Loading comments ...", @"Facebook feed loading text");
  }
}

- (NSString*)titleForEmpty {
  return NSLocalizedString(@"No comments found.", @"Facebook feed no results");
}

- (NSString*)subtitleForError:(NSError*)error {
  return NSLocalizedString(@"Sorry, there was an error loading the comments.", @"");
}


@end
