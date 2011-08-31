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

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_favoriteIds);
  [super dealloc];
}

+ (void)setFavoriteIds:(NSArray *)ids {
  _favoriteIds = [ids retain];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
  if (!self.isLoading) {
    FBRequest* fbRequest;
    NSString* path = @"";
    if (more) {
      NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:[_favoriteIds componentsJoinedByString:@","] forKey:@"ids"];
      fbRequest = [[FacebookJanitor sharedInstance].facebook createRequestWithGraphPath:path
                                                                              andParams:params
                                                                          andHttpMethod:@"GET"
                                                                            andDelegate:nil];
    }
    else {
      fbRequest = [[FacebookJanitor sharedInstance].facebook createRequestWithGraphPath:path andDelegate:nil];
    }
    
    [[FacebookModel createRequest:fbRequest cachePolicy:TTURLRequestCachePolicyNetwork delegate:self] send]; //TODO: use cachePolicy arg
  }
}

@end
