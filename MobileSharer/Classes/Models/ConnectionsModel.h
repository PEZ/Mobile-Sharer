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
  NSArray*                 _connections;
}

@property (nonatomic, retain)  NSString* graphPath;
@property (nonatomic, retain)  NSArray* connections;

- (id)initWithGraphPath:(NSString*)path;

@end
