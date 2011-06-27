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

- (id)initWithGraphPath:(NSString*)path {
  if (self = [super init]) {
    self.graphPath = path;
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_graphPath);
  TT_RELEASE_SAFELY(_connections);
  [super dealloc];
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
      fbRequest = [[FacebookJanitor sharedInstance].facebook getRequestWithGraphPath:path andDelegate:nil];
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
  
  for (NSDictionary* entry in entries) {
    [connections addObject:[[self createConnectionFromEntry: entry] autorelease]];
  }
  _connections = connections;
  
  [super requestDidFinishLoad:request];
}

@end
