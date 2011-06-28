//
//  ConnectionsViewController.m
//  MobileSharer
//
//  Created by PEZ on 2011-06-27.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "ConnectionsViewController.h"
#import "ConnectionsDataSource.h"

@implementation ConnectionsViewController

@synthesize delegate = _delegate;
@synthesize connectionsPath = _connectionsPath;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = @"Connection";
    self.variableHeightRows = YES;
  }

  return self;
}

- (id)initWithFBConnectionsPath:(NSString *)connectionsPath andName:(NSString *)name {
  if (self = [super initWithNibName:nil bundle:nil]) {
    self.connectionsPath = [NSString stringWithFormat:@"me/%@", connectionsPath];
    self.title = name;
    self.variableHeightRows = YES;
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_connectionsPath);
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)loadView {
  [super loadView];
  
  ConnectionsViewController* searchController = [[[ConnectionsViewController alloc] init] autorelease];
  searchController.dataSource = [[[ConnectionsDataSource alloc] initWithConnectionsPath:self.connectionsPath] autorelease];
  self.searchViewController = searchController;
  self.tableView.tableHeaderView = _searchController.searchBar;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewController

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
  [_delegate searchController:self didSelectObject:object];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTSearchTextFieldDelegate

- (void)textField:(TTSearchTextField*)textField didSelectObject:(id)object {
  [_delegate searchController:self didSelectObject:object];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
  self.dataSource = [[[ConnectionsDataSource alloc]
                      initWithConnectionsPath:self.connectionsPath] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewVarHeightDelegate alloc] initWithController:self] autorelease];
}

@end
