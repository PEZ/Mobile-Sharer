//
//  ConnectionModel.h
//  MobileSharer
//
//  Created by PEZ on 2011-06-27.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

@class ConnectionsModel;

@interface ConnectionsModel : TTURLRequestModel {
  NSString*                _graphPath;
  NSMutableArray*          _connections;
  NSArray*                 _allConnections;
}

@property (nonatomic, retain)  NSString* graphPath;
@property (nonatomic, retain)  NSMutableArray* connections;
@property (nonatomic, retain)  NSArray* allConnections;

- (id)initWithGraphPath:(NSString*)path;
- (void)search:(NSString*)text;

@end
