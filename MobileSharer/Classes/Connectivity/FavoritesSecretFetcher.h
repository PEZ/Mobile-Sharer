//
//  FavoritesSecretFetcher.h
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-09-04.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

@protocol FavoritesSecretFetcherDelegate <NSObject>
- (void)fetchingSecretDone:(NSString*)secret;
- (void)request:(TTURLRequest*)request fetchingSecretError:(NSError*)error;
@end

@interface FavoritesSecretFetcher : TTURLRequestModel <TTURLRequestDelegate> {
@private
  NSString* _userId;
  NSString* _accessToken;
  id<FavoritesSecretFetcherDelegate> _delegate;
}

+ (NSString*)getSecret;
- (id)initWithUserId:(NSString*)userId andAccessToken:(NSString*)accessToken andDelegate:(id<FavoritesSecretFetcherDelegate>)delegate;

@end