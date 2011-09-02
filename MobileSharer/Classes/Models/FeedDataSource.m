#import "FeedDataSource.h"

#import "Post.h"

@implementation FeedDataSource

- (id)initWithFeedId:(NSString*)feedId {
  if (self = [super init]) {
    self.feedModel = [[[FeedModel alloc] initWithFeedId:feedId] autorelease];
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


@end
