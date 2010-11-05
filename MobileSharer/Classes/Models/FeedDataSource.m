#import "FeedDataSource.h"

#import "LinkPostTableCell.h"
#import "FeedModel.h"
#import "Post.h"

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

  for (Post* post in _searchFeedModel.posts) {
    post.URL = post.fromId != nil ? [Atlas toFeedURLPath:post.fromId name:post.fromName] : nil;
    [items addObject:post];
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
      return [LinkPostTableCell class];
    }
    else {
      return [PostTableCell class];      
    }
	} else {
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
