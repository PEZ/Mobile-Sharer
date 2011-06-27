//
//  Connection.m
//  MobileSharer
//
//  Created by PEZ on 2011-06-27.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "Connection.h"


@implementation Connection

@synthesize connectionId     = _connectionId;
@synthesize connectionName   = _connectionName;

- (void)dealloc {
  TT_RELEASE_SAFELY(_connectionId);
  TT_RELEASE_SAFELY(_connectionName);
  
  [super dealloc];
}

@end
