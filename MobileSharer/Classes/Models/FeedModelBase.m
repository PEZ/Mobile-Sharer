//
//  FeedModelBase.m
//  
//
//  Created by Peter Stromberg on 2011-08-30.
//  Copyright 2011 NA. All rights reserved.
//

#import "FeedModelBase.h"
#import "Post.h"
#import "FacebookJanitor.h"

@implementation FeedModelBase

@synthesize posts      = _posts;

- (void)dealloc {
  TT_RELEASE_SAFELY(_posts);
  [super dealloc];
}

- (NSArray*)entriesFromResponse:(TTURLJSONResponse*)response {
  @throw [NSException exceptionWithName:@"NotImplentedException" reason:@"Method not implemented" userInfo:nil];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
  TTURLJSONResponse* response = request.response;
  TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
  
  NSArray *entries = [self entriesFromResponse:response];
  
  BOOL more = ([[request urlPath] rangeOfString:@"until="].location != NSNotFound);
  NSMutableArray* posts;
  
  if (more) {
    posts = [[NSMutableArray arrayWithArray:self.posts] retain];
  }
  else {
    posts = [[NSMutableArray alloc] initWithCapacity:[entries count]];
  }
  TT_RELEASE_SAFELY(self.posts);
  
  for (NSDictionary* entry in entries) {
    [posts addObject:[FacebookModel createPostFromEntry: entry]];
  }
  self.posts = posts;
  
  [super requestDidFinishLoad:request];
}


@end
