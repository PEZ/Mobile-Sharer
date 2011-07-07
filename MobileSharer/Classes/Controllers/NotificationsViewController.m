//
//  NotificationsViewController.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-06-30.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "NotificationsViewController.h"
#import "NotificationsDataSource.h"
#import "Notification.h"
#import "StartController.h"

@implementation NotificationsViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    self.title = @"Notifications";
    self.variableHeightRows = YES;
  }
  
  return self;
}

- (void)dealloc {
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
  self.dataSource = [[[NotificationsDataSource alloc] init] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

- (void)didLoadModel:(BOOL)firstTime {
  [super didLoadModel:firstTime];
  
  NSArray* items = ((NotificationsDataSource*)self.dataSource).items;
  NSMutableArray* newIds = [NSMutableArray arrayWithCapacity:[items count]];
  for (Notification* notification in items) {
    @try {
      if (notification.isNew) {
        [newIds addObject:notification.notificationId];
      }
    }
    @catch (NSException *exception) {
      DLog(@"Error checking isNew: %@", exception)
    }
  }
  if ([newIds count] > 0) {
    [[FacebookJanitor sharedInstance].facebook
     requestWithMethodName:@"notifications.markRead"
     andParams:[NSMutableDictionary dictionaryWithObject:[newIds componentsJoinedByString:@","]
                                                  forKey:@"notification_ids"]
     andHttpMethod:@"POST"
     andDelegate:self];
  }
}

#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
  DLog(@"Failed marking notifications as read: %@", error);
}

- (void)request:(FBRequest*)request didLoad:(id)result {
  [(StartController*)[[TTNavigator navigator] viewControllerForURL:kAppStartURLPath] refreshData];
}

@end