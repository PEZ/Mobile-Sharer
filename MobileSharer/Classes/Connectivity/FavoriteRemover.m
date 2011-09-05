//
//  FavoriteRemover.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-09-05.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "FavoriteRemover.h"

@implementation FavoriteRemover

- (void)remove {
  if (!self.isLoading) {
    self.isLoading = YES;
    //TODO: Factor out request creation
    TTURLRequest* request = [TTURLRequest
                             requestWithURL:[NSString stringWithFormat:@"%@/fav/delete/%@",
                                             kFavsServerBase,
                                             _postId]
                             delegate:self];
    [request.parameters setObject:_userId forKey:@"user_id"];
    [request.parameters setObject:_secret forKey:@"secret"];
    
    request.cachePolicy = TTURLRequestCachePolicyNetwork;
    request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
    request.httpMethod = @"POST";
    
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
  self.isLoading = NO;
  DLog(@"Failed removing favorite: %@", error);
  [(id<FavoriteRemoverDelegate>)_delegate request:request removingFavoriteError:error];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
  self.isLoading = NO;
  //TTURLJSONResponse* response = request.response;
  //TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);  
  //NSDictionary* info = response.rootObject;
  
  [(id<FavoriteRemoverDelegate>)_delegate removingFavoriteDone];
}

@end
