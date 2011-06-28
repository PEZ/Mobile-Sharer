//
//  ConnectionsViewController.h
//  MobileSharer
//
//  Created by PEZ on 2011-06-27.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "TableViewController.h"

@protocol SearchControllerDelegate;

@interface ConnectionsViewController : TableViewController <TTSearchTextFieldDelegate> {
  id<SearchControllerDelegate> _delegate;
  NSString* _connectionsPath;
}

@property(nonatomic,assign) id<SearchControllerDelegate> delegate;
@property (nonatomic, retain)   NSString* connectionsPath;

- (id)initWithFBConnectionsPath:(NSString *)connectionsPath andName:(NSString *)name;

@end

@protocol SearchControllerDelegate <NSObject>

- (void)searchController:(ConnectionsViewController*)controller didSelectObject:(id)object;

@end
