#import "ConnectionsDataSource.h"

#import "ConnectionCell.h"
#import "LoadMoreCell.h"
#import "Connection.h"

@implementation ConnectionsDataSource

- (id)initWithConnectionsPath:(NSString*)connectionsPath {
  if (self = [super init]) {
    _connectionsModel = [[ConnectionsModel alloc] initWithGraphPath:connectionsPath];
  }

  return self;
}


- (void)dealloc {
  TT_RELEASE_SAFELY(_connectionsModel);
  [super dealloc];
}


- (id<TTModel>)model {
  return _connectionsModel;
}


- (void)tableViewDidLoadModel:(UITableView*)tableView {
  NSMutableArray* items = [[NSMutableArray alloc] init];

  for (Connection* connection in _connectionsModel.connections) {
    [items addObject:connection];
  }
  
  //[items addObject:[TTTableMoreButton itemWithText:@"Load more connections..."]];

  self.items = items;
  TT_RELEASE_SAFELY(items);
}


#pragma mark -
#pragma mark TTTableViewDataSource
- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object { 
	if ([object isKindOfClass:[Connection class]]) {
    return [TTTableImageItemCell class];
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
    return NSLocalizedString(@"Updating connections list...", @"Connections list updating text");
  } else {
    return NSLocalizedString(@"Loading connections list...", @"Connections list loading text");
  }
}

- (NSString*)titleForEmpty {
  return NSLocalizedString(@"No connections found.", @"Connections list no results");
}

- (NSString*)subtitleForError:(NSError*)error {
  return NSLocalizedString(@"Sorry, there was an error loading the list.", @"Error loading list");
}


@end
