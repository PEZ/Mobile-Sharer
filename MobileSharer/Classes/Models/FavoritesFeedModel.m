//
//  FavoritesFeedModel.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-08-31.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "FavoritesFeedModel.h"
#import "FacebookJanitor.h"
#import "FavoritesSettings.h"


@implementation FavoritesFeedModel

@synthesize favoriteIds = _favoriteIds;

- (id)initWithSecret:(NSString*)secret andUserId:(NSString*)userId {
    if ((self = [super init])) {
      _favoriteIdsFetcher = [[FavoriteIdsFetcher alloc] initWithSecret:secret andUserId:userId andDelegate:self];
    }    
    return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_favoriteIds);
  [super dealloc];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
  if (!self.isLoading) {
    [_favoriteIdsFetcher load:cachePolicy more:more];
  }
  [super load:cachePolicy more:more];
}

- (void)fetchingFavoriteIdsDone:(NSArray*)ids {
  TT_RELEASE_SAFELY(_favoriteIds);
  _favoriteIds = [ids retain];
  FBRequest* fbRequest;
  NSString* path = @"";
  NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:[_favoriteIds componentsJoinedByString:@","] forKey:@"ids"];
  fbRequest = [[FacebookJanitor sharedInstance].facebook createRequestWithGraphPath:path
                                                                          andParams:params
                                                                      andHttpMethod:@"GET"
                                                                        andDelegate:nil];
  
  [[FacebookModel createRequest:fbRequest cachePolicy:TTURLRequestCachePolicyNetwork delegate:self] send]; //TODO: use cachePolicy arg
}

- (void)request:(TTURLRequest*)request fetchingFavoriteIdsError:(NSError*)error {
  DLog(@"Error fetching favorites: %@", error);
  [self request:request didFailLoadWithError:error]; 
}

- (NSArray *)entriesFromResponse:(TTURLJSONResponse*)response  {
  NSMutableArray* entries = [[NSMutableArray arrayWithCapacity:[_favoriteIds count]] retain];
  for (NSString* favId in _favoriteIds) {
    NSObject* obj = [response.rootObject objectForKey:favId];
    if (obj != nil) {
      [entries addObject:obj];
    }
  }
  NSArray* result = [NSArray arrayWithArray:entries];
  [entries release];
  return result;
}

@end
