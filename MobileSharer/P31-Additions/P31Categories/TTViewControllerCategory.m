//
//  TTViewControllerCategory.m
//  P31-Additions
//
//  Created by Mike on 5/8/10.
//  Copyright 2010 Prime31 Studios. All rights reserved.
//

#import "TTViewControllerCategory.h"


@implementation TTViewController(Category)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		_navigationBarStyle = UIBarStyleDefault;
		_statusBarStyle = TTSTYLEVAR(statusBarStyle); // P31 Addition
		
		self.navigationBarTintColor = TTSTYLEVAR(navigationBarTintColor);
	}
	
	return self;
}


- (id)init {
	if (self = [self initWithNibName:nil bundle:nil]) {

	}
	
	return self;
}


- (void)setSearchViewController:(TTTableViewController*)searchViewController {
	if (searchViewController) {
		if (nil == _searchController) {
			UISearchBar* searchBar = [[[UISearchBar alloc] init] autorelease];
			[searchBar sizeToFit];

			searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth; // P31 Addition
			searchBar.tintColor = TTSTYLEVAR(searchBarTintColor); // P31 Addition
			
			_searchController = [[TTSearchDisplayController alloc] initWithSearchBar:searchBar
																  contentsController:self];
		}
		
		searchViewController.superController = self;
		_searchController.searchResultsViewController = searchViewController;
		
	} else {
		_searchController.searchResultsViewController = nil;
		TT_RELEASE_SAFELY(_searchController);
	}
}

@end
