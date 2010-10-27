//
//  TTTableViewControllerCategory.m
//  P31-Additions
//
//  Created by Mike on 5/8/10.
//  Copyright 2010 Prime31 Studios. All rights reserved.
//

#import "TTTableViewControllerCategory.h"


@implementation TTTableViewController(Category)

- (UITableView*)tableView {
	
	if (!_tableView) {
		
		_tableView = [[TTTableView alloc] initWithFrame:self.view.bounds style:_tableViewStyle];
		_tableView.autoresizingMask =  UIViewAutoresizingFlexibleWidth
		| UIViewAutoresizingFlexibleHeight;
		
		_tableView.separatorColor = TTSTYLEVAR(searchTableSeparatorColor); // P31 Addition
		UIColor* backgroundColor = _tableViewStyle == UITableViewStyleGrouped
		? TTSTYLEVAR(tableGroupedBackgroundColor)
		: TTSTYLEVAR(tablePlainBackgroundColor);
		if (backgroundColor) {
			_tableView.backgroundColor = backgroundColor;
			self.view.backgroundColor = backgroundColor;
		}
		[self.view addSubview:_tableView];
	}
	return _tableView;
}

@end
