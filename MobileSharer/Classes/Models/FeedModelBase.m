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
#import "RegexKitLite.h"
@implementation FeedModelBase

@synthesize posts      = _posts;
@synthesize lastPostCreated = _lastPostCreated;

- (void)dealloc {
  TT_RELEASE_SAFELY(_posts);
  TT_RELEASE_SAFELY(_lastPostCreated);
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
  
  if ([entries count] > 0) {
    self.lastPostCreated = [[FacebookJanitor dateFormatter] dateFromString:[[entries lastObject] objectForKey:@"created_time"]];
  }
  
  NSMutableArray* posts;
  
  if ([self isLoadMoreQuery: request]) {
    posts = [[NSMutableArray arrayWithArray:_posts] retain];
  }
  else {
    posts = [[NSMutableArray alloc] initWithCapacity:[entries count]];
  }
  TT_RELEASE_SAFELY(_posts);
  
  for (NSDictionary* entry in entries) {
    //DLog(@"Type: [%@], Message: [%@], Story: [%@]", [entry objectForKey:@"type"], [entry objectForKey:@"message"], [entry objectForKey:@"story"]);
    if (([(NSString*)[entry objectForKey:@"type"] isEqualToString:@"status"] && [entry objectForKey:@"message"] == nil)) {
      continue;
    }
    if (([(NSString*)[entry objectForKey:@"type"] isEqualToString:@"link"] && [entry objectForKey:@"story"] != nil &&
            ![(NSString*)[entry objectForKey:@"story"] isMatchedByRegex:@"shared a link.$"])) {
      continue;
    }
    [self addEntry:entry toPosts:posts];
  }
  self.posts = posts;
  TT_RELEASE_SAFELY(posts)
  
  [super requestDidFinishLoad:request];
}


@end
