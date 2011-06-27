//
//  ConnectionsViewController.h
//  MobileSharer
//
//  Created by PEZ on 2011-06-27.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "TableViewController.h"

@interface ConnectionsViewController : TableViewController {
  NSString* _connectionsPath;
}

@property (nonatomic, retain)   NSString* connectionsPath;

- (id)initWithFBConnectionsPath:(NSString *)connectionsPath andName:(NSString *)name;

@end
