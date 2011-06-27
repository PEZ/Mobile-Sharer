//
//  Connection.h
//  MobileSharer
//
//  Created by PEZ on 2011-06-27.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

@interface Connection : TTTableImageItem {
  NSString* _connectionId;
  NSString* _connectionName;
}

@property (nonatomic, retain) NSString* connectionId;
@property (nonatomic, retain) NSString* connectionName;

@end
