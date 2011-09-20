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

- (void)addEntry:(NSDictionary*)entry toPosts:(NSMutableArray*)posts  {
  [posts addObject:[FacebookModel createPostFromEntry:entry]];
}

- (BOOL)isLoadMoreQuery:(TTURLRequest *)request  {
  return [[request urlPath] rangeOfString:@"until="].location != NSNotFound;
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
  TTURLJSONResponse* response = request.response;
  TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
  
  NSArray *entries = [self entriesFromResponse:response];
  
  NSMutableArray* posts;
  
  if ([self isLoadMoreQuery: request]) {
    posts = [[NSMutableArray arrayWithArray:_posts] retain];
  }
  else {
    posts = [[NSMutableArray alloc] initWithCapacity:[entries count]];
  }
  TT_RELEASE_SAFELY(_posts);
  
  for (NSDictionary* entry in entries) {
    //DLog(@"Type: %@ - Message: %@", [entry objectForKey:@"type"], [entry objectForKey:@"message"]);
    if (!([[entry objectForKey:@"type"] isEqualToString:@"status"] && [entry objectForKey:@"message"] == nil)) {
      [self addEntry:entry toPosts:posts];
    }
  }
  self.posts = posts;
  TT_RELEASE_SAFELY(posts)
  
  [super requestDidFinishLoad:request];
}


@end
