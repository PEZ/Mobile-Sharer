//
//  FavoriteIdsFetcher.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-09-04.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "FavoriteIdsFetcher.h"

@implementation FavoriteIdsFetcher

@synthesize lastFavCreatedAt = _lastFavCreatedAt;

- (id)initWithSecret:(NSString*)secret andUserId:(NSString*)userId andDelegate:(id<FavoriteIdsFetcherDelegate>)delegate {
  if ((self = [self init])) {
    _secret = [secret retain];
    _userId = [userId retain];
    _delegate = [delegate retain];
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_secret);
  TT_RELEASE_CF_SAFELY(_userId)
  TT_RELEASE_SAFELY(_delegate);
  TT_RELEASE_SAFELY(_lastFavCreatedAt);
  [super dealloc];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
  if (!self.isLoading) {
    
    NSString* url = [NSString stringWithFormat:@"%@/favs?user_id=%@&secret=%@&limit=%d",
                     kFavsServerBase,
                     _userId,
                     _secret,
                     kFavIdsPerPage];
    if (more && _lastFavCreatedAt != nil) {
      url = [NSString stringWithFormat:@"%@&older_than=%@", url, _lastFavCreatedAt];
    }
    TTURLRequest* request = [TTURLRequest
                             requestWithURL:url
                             delegate:self];
    
    request.cachePolicy = TTURLRequestCachePolicyNetwork;
    request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
    request.httpMethod = @"GET";
    
    TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
    request.response = response;
    [_delegate performSelector:@selector(requestDidStartLoad:) withObject:request];
    [response release];
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
  
  if (_lastFavCreatedAt == nil || ![_lastFavCreatedAt isEqualToString:[info objectForKey:@"oldest_created_at"]]) {
    self.lastFavCreatedAt = [info objectForKey:@"oldest_created_at"];
  }
  
  [_delegate fetchingFavoriteIdsDone:[NSArray arrayWithArray:[info objectForKey:@"favorites"]] more:[[request urlPath] rangeOfString:@"older_than="].location != NSNotFound hasNoMore:self.lastFavCreatedAt == nil];
  
  [super requestDidFinishLoad:request];
}

@end
