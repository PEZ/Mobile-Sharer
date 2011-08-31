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


- (void)requestDidFinishLoad:(TTURLRequest*)request {
  TTURLJSONResponse* response = request.response;
  TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
  
  NSDictionary* feed = response.rootObject;
  TTDASSERT([[feed objectForKey:@"data"] isKindOfClass:[NSArray class]]);
  
  NSArray* entries = [feed objectForKey:@"data"];
  
  BOOL more = ([[request urlPath] rangeOfString:@"until="].location != NSNotFound);
  NSMutableArray* posts;
  
  if (more) {
    posts = [[NSMutableArray arrayWithArray:_posts] retain];
  }
  else {
    posts = [[NSMutableArray alloc] initWithCapacity:[entries count]];
  }
  TT_RELEASE_SAFELY(_posts);
  
  for (NSDictionary* entry in entries) {
    [posts addObject:[FacebookModel createPostFromEntry: entry]];
  }
  _posts = posts;
  
  [super requestDidFinishLoad:request];
}

@end
