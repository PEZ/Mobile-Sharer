//
//  ConnectionsModel.m
//  MobileSharer
//
//  Created by PEZ on 2011-06-27.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "ConnectionsModel.h"
#import "Connection.h"
#import "FacebookJanitor.h"
#import "Etc.h"


@implementation ConnectionsModel

@synthesize graphPath = _graphPath;
@synthesize connections = _connections;
@synthesize allConnections = _allConnections;

- (id)initWithGraphPath:(NSString*)path {
  if (self = [super init]) {
    self.graphPath = path;
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_graphPath);
  TT_RELEASE_SAFELY(_connections);
  TT_RELEASE_SAFELY(_allConnections);
  [super dealloc];
}

- (void)search:(NSString*)text {
  [self cancel];
  
  TT_RELEASE_SAFELY(_connections);
  
  if (text != nil && text.length) {
    self.connections = [NSMutableArray array];
    text = [NSString stringWithFormat:@"*%@*", text];
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"connectionName like[cd] %@", text];
    for (Connection* c in [_allConnections filteredArrayUsingPredicate:filter]) {
      [_connections addObject:c];
    }
  }
  else {
    self.connections = [NSMutableArray arrayWithArray:_allConnections];
  }
  
  [_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
  if (!self.isLoading && TTIsStringWithAnyText(_graphPath)) {
    FBRequest* fbRequest;
    NSString* path = [NSString stringWithFormat:@"%@", _graphPath];
    if (more) {
//      NSString* until = [NSString stringWithFormat:@"%@",
//                         [NSNumber numberWithDouble:[[[_connections lastObject] created] timeIntervalSince1970]]];
//      NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:until forKey:@"until"];
//      fbRequest = [[FacebookJanitor sharedInstance].facebook getRequestWithGraphPath:path
//                                                                           andParams:params
//                                                                       andHttpMethod:@"GET"
//                                                                         andDelegate:nil];
    }
    else {
      fbRequest = [[FacebookJanitor sharedInstance].facebook createRequestWithGraphPath:path andDelegate:nil];
    }
    
    [[FacebookModel createRequest:fbRequest cachePolicy:TTURLRequestCachePolicyNetwork delegate:self] send]; //TODO: use cachePolicy arg
  }
}

- (Connection*)createConnectionFromEntry:(NSDictionary *)entry {
  Connection* connection = [[Connection alloc] init];
  
  connection.connectionId = [entry objectForKey:@"id"];
  connection.connectionName = [entry objectForKey:@"name"];
  connection.imageURL = [FacebookJanitor avatarForId:connection.connectionId];
  //connection.defaultImage = TTIMAGE(@"bundle://imageDefault50x50.png");
  connection.text = connection.connectionName;
  connection.URL = [Etc toFeedURLPath:connection.connectionId name:connection.connectionName];
  return connection;
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
  TTURLJSONResponse* response = request.response;
  TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
  
  NSDictionary* feed = response.rootObject;
  TTDASSERT([[feed objectForKey:@"data"] isKindOfClass:[NSArray class]]);
  
  NSArray* entries = [feed objectForKey:@"data"];
  
  BOOL more = ([[request urlPath] rangeOfString:@"until="].location != NSNotFound);
  NSMutableArray* connections;
  
  if (more) {
    connections = [[NSMutableArray arrayWithArray:_connections] retain];
  }
  else {
    connections = [[NSMutableArray alloc] initWithCapacity:[entries count]];
  }
  TT_RELEASE_SAFELY(_connections);
  TT_RELEASE_SAFELY(_allConnections);
  
  for (NSDictionary* entry in entries) {
    [connections addObject:[[self createConnectionFromEntry: entry] autorelease]];
  }
  _connections = connections;
  self.allConnections = [NSArray arrayWithArray:_connections];
  
  [super requestDidFinishLoad:request];
}

@end