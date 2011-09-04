//
//  FavoriteUpdaterBase.m
//  
//
//  Created by Peter Stromberg on 2011-09-04.
//  Copyright 2011 NA. All rights reserved.
//

#import "FavoriteUpdaterBase.h"

@implementation FavoriteUpdaterBase

@synthesize isLoading = _isLoading;

- (id)initWithPostId:postId andUserId:(NSString*)userId andSecret:(NSString*)secret andDelegate:(id<FavoriteUpdaterDelegate>)delegate {
  if ((self = [self init])) {
    _postId = [postId retain];
    _secret = [secret retain];
    _userId = [userId retain];
    _delegate = [delegate retain];
  }
  return self;
}


- (void)dealloc {
  TT_RELEASE_SAFELY(_postId);
  TT_RELEASE_SAFELY(_userId);
  TT_RELEASE_SAFELY(_secret);
  TT_RELEASE_SAFELY(_delegate);
  [super dealloc];
}

@end
