//
//  MyClass.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-06-26.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "TableViewController.h"


@implementation TableViewController

 - (void)viewWillAppear:(BOOL)animated { 
  [super viewWillAppear:animated]; 
  if (_lastInterfaceOrientation != self.interfaceOrientation) { 
    _lastInterfaceOrientation = self.interfaceOrientation; 
    NSIndexPath *selectedRow = [[_tableView indexPathForSelectedRow] retain]; 
    [_tableView reloadData]; 
    [_tableView selectRowAtIndexPath:selectedRow animated:NO 
                      scrollPosition:UITableViewScrollPositionNone]; 
    [selectedRow release]; 
  } else if ([_tableView isKindOfClass:[TTTableView class]]) { 
    
    TTTableView* tableView = (TTTableView*)_tableView; 
    tableView.highlightedLabel = nil; 
    tableView.showShadows = _showTableShadows; 
  } 
  
  [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] 
                            animated:NO]; 
} 

- (BOOL)shouldAutorotateToInterfaceOrientation: 
(UIInterfaceOrientation)interfaceOrientation {
  return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  [self.tableView reloadData]; 
}

@end
