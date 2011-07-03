//
//  NotificationsViewController.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-06-30.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "NotificationsViewController.h"
#import "NotificationsDataSource.h"


@implementation NotificationsViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
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

@end