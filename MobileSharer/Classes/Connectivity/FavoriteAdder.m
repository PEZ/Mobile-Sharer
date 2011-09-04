//
//  FavoriteAdder.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-09-04.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "FavoriteAdder.h"

@implementation FavoriteAdder

- (id)initWithPostId:(NSString*)postId andUserId:(NSString*)userId andAuthorId:authorId
           andSecret:(NSString*)secret andDelegate:(id<FavoriteUpdaterDelegate>)delegate {
  if ((self = [super initWithPostId:postId andUserId:userId andSecret:secret andDelegate:delegate])) {
    _authorId = authorId;
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_authorId);
  [super dealloc];
}

- (void)add {
  if (!self.isLoading) {
    self.isLoading = YES;
    TTURLRequest* request = [TTURLRequest
                             requestWithURL:[NSString stringWithFormat:@"%@/fav/create/%@",
                                             kFavsServerBase,
                                             _postId]
                             delegate:self];
    [request.parameters setObject:_userId forKey:@"user_id"];
    [request.parameters setObject:_authorId forKey:@"author_id"];
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
  DLog(@"Failed adding favorite: %@", error);
  [(id<FavoriteAdderDelegate>)_delegate request:request addingFavoriteError:error];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
  self.isLoading = NO;
  //TTURLJSONResponse* response = request.response;
  //TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);  
  //NSDictionary* info = response.rootObject;
  
  [(id<FavoriteAdderDelegate>)_delegate addingFavoriteDone];
}

@end
