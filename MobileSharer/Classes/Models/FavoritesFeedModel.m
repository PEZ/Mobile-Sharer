//
//  FavoritesFeedModel.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-08-31.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "FavoritesFeedModel.h"
#import "FacebookJanitor.h"

#define kFavsServerBase @"http://localhost:8080/api"
//#define kFavsServerBase @"http://social-favorites.appspot.com/api"

#define kIdsPerPage 25


@implementation FavoriteIdsFetcher

@synthesize lastFavCreatedAt = _lastFavCreatedAt;

- (id)initWithSecret:(NSString*)secret andDelegate:(id<FavoriteIdsFetcherDelegate>)delegate {
  if ((self = [self init])) {
    _secret = [secret retain];
    _delegate = [delegate retain];
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_secret);
  TT_RELEASE_SAFELY(_delegate);
  TT_RELEASE_SAFELY(_lastFavCreatedAt);
  [super dealloc];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
  if (!self.isLoading) {
    
    TTURLRequest* request = [TTURLRequest
                             requestWithURL:[NSString stringWithFormat:@"%@/favs?user_id=%@&secret=%@&limit=%d",
                                             kFavsServerBase,
                                             [[FacebookJanitor sharedInstance] currentUser].userId,
                                             _secret,
                                             kIdsPerPage]
                             delegate:self];
    
    request.cachePolicy = TTURLRequestCachePolicyNetwork;
    request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
    request.httpMethod = @"GET";
    
    TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
    request.response = response;
    [request send];
  }
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
  DLog(@"Failed fetching favorit ids: %@", error);
  [_delegate request:request fetchingFavoriteIdsError:error];
  [super request:request didFailLoadWithError:error];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
  TTURLJSONResponse* response = request.response;
  TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);  
  NSDictionary* info = response.rootObject;

  if (_lastFavCreatedAt != nil) {
    TT_RELEASE_SAFELY(_lastFavCreatedAt);
  }
  _lastFavCreatedAt = [info objectForKey:@"oldest_created_at"];
  
  [_delegate fetchingFavoriteIdsDone:[NSArray arrayWithArray:[info objectForKey:@"favorites"]]];
  
  [super requestDidFinishLoad:request];
}

@end

@implementation FavoritesFeedModel

@synthesize favoriteIds = _favoriteIds;

- (id)initWithSecret:(NSString*)secret {
    if ((self = [super init])) {
      _favoriteIdsFetcher = [[FavoriteIdsFetcher alloc] initWithSecret:secret andDelegate:self];
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
