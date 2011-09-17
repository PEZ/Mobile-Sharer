//
//  FavoritesFeedDataSource.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-09-01.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "FavoritesFeedDataSource.h"
#import "FavoritesFeedModel.h"
#import "FavoritesSecretFetcher.h"
#import "Post.h"
#import "FacebookJanitor.h"

@implementation FavoritesFeedDataSource


- (id)initWithSecret:(NSString*)secret andUserId:(NSString*)userId {
  if ((self = [super init])) {
    self.feedModel = [[[FavoritesFeedModel alloc] initWithSecret:secret andUserId:userId] autorelease];
  }
  
  return self;
}

- (void) dealloc {
  TT_RELEASE_SAFELY(_favoriteRemover);
  [super dealloc];
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {
  [super tableViewDidLoadModel:tableView];
  NSMutableArray* items = [[NSMutableArray alloc] init];
  
  for (Post* post in self.feedModel.posts) {
    [items addObject:post];
  }
  
  //[items addObject:[TTTableMoreButton itemWithText:@"Load more posts..."]];
  
  self.items = items;
  TT_RELEASE_SAFELY(items);
}


- (void)removeFavorite:(NSString*)postId {
  if (_favoriteRemover != nil) {
    TT_RELEASE_SAFELY(_favoriteRemover);
  }
  _favoriteRemover = [[FavoriteRemover alloc] initWithPostId:postId
                                                   andUserId:[FacebookJanitor sharedInstance].currentUser.userId
                                                   andSecret:[FavoritesSecretFetcher getSecret]
                                                 andDelegate:self];
  [_favoriteRemover remove];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView beginUpdates];
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    if([self.feedModel.posts count] >= indexPath.row){
      [self removeFavorite:((Post*)[self.feedModel.posts objectAtIndex:indexPath.row]).postId];
      [self.feedModel.posts removeObjectAtIndex:indexPath.row];
      [_items removeObjectAtIndex:indexPath.row];
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
    }
  }
  [tableView endUpdates];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.feedModel.posts count];
}


#pragma mark -
#pragma mark FavoriteRemoverDelegate

- (void)removingFavoriteDone {
}

- (void)request:(TTURLRequest*)request removingFavoriteError:(NSError*)error {
  DLog(@"Failed removing favorite.\n\n(%@)", error)
}

@end
