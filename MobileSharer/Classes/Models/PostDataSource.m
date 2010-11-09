//
//  PostDataSource.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-06.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "PostDataSource.h"

#import "LinkPostCell.h"
#import "PostCell.h"
#import "CommentCell.h"

@implementation PostDataSource

- (id)initWithPost:(Post*)post {
  if (self = [super init]) {
    _postModel = [[PostModel alloc] initWithPost:post];
  }
  
  return self;
}


- (void)dealloc {
  TT_RELEASE_SAFELY(_postModel);
  
  [super dealloc];
}


- (id<TTModel>)model {
  return _postModel;
}


- (void)tableViewDidLoadModel:(UITableView*)tableView {
  NSMutableArray* items = [[NSMutableArray alloc] init];
  [items addObject:_postModel.post];
  for (Comment* comment in _postModel.comments) {
    [items addObject:comment];
  }
  
  self.items = items;
  TT_RELEASE_SAFELY(items);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewDataSource

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object { 
	if ([object isKindOfClass:[Post class]]) {
    Post* item = object;
    if (item.linkURL) {
      return [LinkPostCell class];
    }
    else {
      return [PostCell class];      
    }
	} else 	if ([object isKindOfClass:[Comment class]]) {
    return [CommentCell class];
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
    return NSLocalizedString(@"Updating Facebook feed...", @"Facebook feed updating text");
  } else {
    return NSLocalizedString(@"Loading Facebook feed...", @"Facebook feed loading text");
  }
}

- (NSString*)titleForEmpty {
  return NSLocalizedString(@"No posts found.", @"Facebook feed no results");
}

- (NSString*)subtitleForError:(NSError*)error {
  return NSLocalizedString(@"Sorry, there was an error loading the Facebook stream.", @"");
}


@end
