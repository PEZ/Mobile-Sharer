#import "FeedDataSource.h"

#import "LinkPostCell.h"
#import "Post.h"

@implementation FeedDataSource

- (id)initWithFeedId:(NSString*)feedId {
  if (self = [super init]) {
    _feedModel = [[FeedModel alloc] initWithFeedId:feedId];
  }

  return self;
}


- (void)dealloc {
  TT_RELEASE_SAFELY(_feedModel);
  [super dealloc];
}


- (id<TTModel>)model {
  return _feedModel;
}


- (void)tableViewDidLoadModel:(UITableView*)tableView {
  NSMutableArray* items = [[NSMutableArray alloc] init];

  for (Post* post in _feedModel.posts) {
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
      return [LinkPostCell class];
    }
    else {
      return [PostCell class];      
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
