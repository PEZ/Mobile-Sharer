//
//  NotificationsDataSource.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-07-03.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "NotificationsDataSource.h"
#import "Notification.h"
#import "NotificationCell.h"


@implementation NotificationsDataSource

- (id)init {
  if (self = [super init]) {
    _notificationsModel = [[NotificationsModel alloc] init];
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_notificationsModel);
  [super dealloc];
}


- (id<TTModel>)model {
  return _notificationsModel;
}


- (void)tableViewDidLoadModel:(UITableView*)tableView {
  NSMutableArray* items = [[NSMutableArray alloc] init];
  
  for (Notification* notification in _notificationsModel.notifications) {
    [items addObject:notification];
  }
  
  self.items = items;
  TT_RELEASE_SAFELY(items);
}

#pragma mark -
#pragma mark TTTableViewDataSource
- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object { 
	if ([object isKindOfClass:[Notification class]]) {
    if (((Notification*)object).isNew) {
      return [HighLightedNotificationCell class];
    }
    else {
      return [NotificationCell class];
    }
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
    return NSLocalizedString(@"Updating notificaions...", @"Notifications updating text");
  } else {
    return NSLocalizedString(@"Loading notifications...", @"Notifications loading text");
  }
}

- (NSString*)titleForEmpty {
  return NSLocalizedString(@"No notifications found.", @"Notifications no results");
}

- (NSString*)subtitleForError:(NSError*)error {
  return NSLocalizedString(@"Sorry, there was an error loading the list.", @"Error loading list");
}

@end
