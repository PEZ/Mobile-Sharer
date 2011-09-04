//
//  FavoritesSecretFetcher.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-09-04.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "FavoritesSecretFetcher.h"
#import "FavoritesSettings.h"

@implementation FavoritesSecretFetcher

static NSString* _secret;

- (id)initWithUserId:(NSString*)userId andAccessToken:(NSString*)accessToken andDelegate:(id<FavoritesSecretFetcherDelegate>)delegate {
  if ((self = [self init])) {
    _userId = [userId retain];
    _accessToken = [accessToken retain];
    _delegate = [delegate retain];
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_userId);
  TT_RELEASE_SAFELY(_accessToken);
  TT_RELEASE_SAFELY(_delegate);
  [super dealloc];
}

+ (NSString*)getSecret {
  return _secret;
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
  if (!self.isLoading) {
    
    TTURLRequest* request = [TTURLRequest
                             requestWithURL:[NSString stringWithFormat:@"%@/fbuser/%@/token?fb_token=%@",
                                             kFavsServerBase,
                                             _userId,
                                             _accessToken]
                             delegate:self];
    
    request.cachePolicy = TTURLRequestCachePolicyNetwork;
    request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
    request.httpMethod = @"GET";
    
    TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
    request.response = response;
    if ([_delegate respondsToSelector:@selector(requestDidStartLoad:)]) {
      [_delegate performSelector:@selector(requestDidStartLoad:) withObject:request];
    }
    [response release];
    [request send];
  }
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
  DLog(@"Failed fetching secret: %@", error);
  [_delegate request:request fetchingSecretError:error];
  [super request:request didFailLoadWithError:error];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
  TTURLJSONResponse* response = request.response;
  TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);  
  NSDictionary* info = response.rootObject;
  
  _secret = [[info objectForKey:@"secret"] retain];
  [_delegate fetchingSecretDone:_secret];
  
  [super requestDidFinishLoad:request];
}

@end
