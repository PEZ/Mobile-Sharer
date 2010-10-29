#import "FeedDataSource.h"

#import "FeedModel.h"
#import "FeedPost.h"

//#import <Three20Core/NSDateAdditions.h>


@implementation FeedDataSource


- (id)initWithSearchQuery:(NSString*)searchQuery {
  if (self = [super init]) {
    _searchFeedModel = [[FeedModel alloc] initWithSearchQuery:searchQuery];
  }

  return self;
}


- (void)dealloc {
  TT_RELEASE_SAFELY(_searchFeedModel);

  [super dealloc];
}


- (id<TTModel>)model {
  return _searchFeedModel;
}


- (void)tableViewDidLoadModel:(UITableView*)tableView {
  NSMutableArray* items = [[NSMutableArray alloc] init];

  for (FeedPost* post in _searchFeedModel.posts) {
    [items addObject:[TTTableMessageItem itemWithTitle: post.fromName
                                               caption: nil
                                                  text: post.message
                                             timestamp: post.created
                                              imageURL: post.fromAvatar
                                                   URL: post.fromId != nil ? [Atlas toFeedURLPath:post.fromId name:post.fromName] : nil]];
  }

  self.items = items;
  TT_RELEASE_SAFELY(items);
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
