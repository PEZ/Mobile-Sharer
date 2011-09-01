//
//  FavoritesFeedModel.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-08-31.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "FavoritesFeedModel.h"
#import "FacebookJanitor.h"

@implementation FavoritesFeedModel

@synthesize favoriteIds = _favoriteIds;

- (id)initWithFavoriteIds:(NSArray*)ids {
    if ((self = [super init])) {
      self.favoriteIds = ids;
    }    
    return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_favoriteIds);
  [super dealloc];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
  if (!self.isLoading) {
    FBRequest* fbRequest;
    NSString* path = @"";
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:[_favoriteIds componentsJoinedByString:@","] forKey:@"ids"];
    if (more) {
    }
    else {
    }      
    fbRequest = [[FacebookJanitor sharedInstance].facebook createRequestWithGraphPath:path
                                                                            andParams:params
                                                                        andHttpMethod:@"GET"
                                                                          andDelegate:nil];

    [[FacebookModel createRequest:fbRequest cachePolicy:TTURLRequestCachePolicyNetwork delegate:self] send]; //TODO: use cachePolicy arg
  }
}

- (NSArray *)entriesFromResponse:(TTURLJSONResponse*)response  {
  NSMutableArray* entries = [[NSMutableArray arrayWithCapacity:[_favoriteIds count]] retain];
  for (NSString* favId in _favoriteIds) {
    NSObject* obj = [response.rootObject objectForKey:favId];
    if (obj != nil) {
      [entries addObject:obj];
    }
  }
  return [NSArray arrayWithArray:entries];
}

@end
