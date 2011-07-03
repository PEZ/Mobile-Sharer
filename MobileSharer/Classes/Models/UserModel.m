//
//  UserModel.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-23.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "UserModel.h"
#import "FacebookJanitor.h"


@implementation UserModel

@synthesize graphPath = _graphPath;
@synthesize user      = _user;

- (id)initWithGraphPath:(NSString*)path andDelegate:(id<UserRequestDelegate>)delegate {
  if (self = [super init]) {
    _graphPath = path;
    _delegate = delegate;
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_graphPath);
  TT_RELEASE_SAFELY(_user);
  [super dealloc];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
  if (!self.isLoading && TTIsStringWithAnyText(_graphPath)) {
    FBRequest* fbRequest;
    fbRequest = [[FacebookJanitor sharedInstance].facebook createRequestWithGraphPath:_graphPath andDelegate:nil];
    [[FacebookModel createRequest:fbRequest cachePolicy:TTURLRequestCachePolicyNetwork delegate:self] send]; //TODO: use cachePolicy arg
  }
}


- (void)requestDidFinishLoad:(TTURLRequest*)request {
  TTURLJSONResponse* response = request.response;
  TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
  
  NSDictionary* info = response.rootObject;
  
  TT_RELEASE_SAFELY(_user);
  _user = [[User alloc] init];
  _user.userId   = [info objectForKey:@"id"];
  _user.userName = [info objectForKey:@"name"];
  _user.about    = [info objectForKey:@"about"];
  
  [_delegate userRequestDidFinishLoad:self];
  [super requestDidFinishLoad:request];
}

@end
