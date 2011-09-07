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


- (id)initWithSecret:(NSString*)secret andUserId:(NSString*)userId {
  if ((self = [super init])) {
    self.feedModel = [[[FavoritesFeedModel alloc] initWithSecret:secret andUserId:userId] autorelease];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView beginUpdates];
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    if([self.feedModel.posts count] >= indexPath.row){
      Post* post = [[self.feedModel.posts objectAtIndex:indexPath.row] retain];
      //[self removeObjectById: myobject.id];
      
      [self.feedModel.posts removeObjectAtIndex:indexPath.row];
      
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
      TT_RELEASE_SAFELY(post);
    }
  }
  [tableView endUpdates];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.feedModel.posts count];
}

@end
