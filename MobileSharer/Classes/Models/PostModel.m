//
//  PostModel.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-06.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "PostModel.h"
#import "Comment.h"
#import "FacebookJanitor.h"
#import <extThree20JSON/extThree20JSON.h>

BOOL commentsEmpty(NSArray* comments) {
  return comments == nil || [comments count] == 0;
}

@implementation PostModel

@synthesize post          = _post;
@synthesize comments      = _comments;

- (id)initWithPost:(Post*)post {
  if (self = [super init]) {
    self.post = post;
  }
  
  return self;
}

- (void) dealloc {
  TT_RELEASE_SAFELY(_post);
  TT_RELEASE_SAFELY(_comments);
  [super dealloc];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
  if (!self.isLoading) {
    NSString* path = [NSString stringWithFormat:@"%@/comments", self.post.postId];
    FBRequest* fbRequest;
    if (more && !commentsEmpty(_comments)) {
      NSString* offset = [NSString stringWithFormat:@"%@",
                         [NSNumber numberWithDouble:[_comments count]]];
      NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:offset forKey:@"offset"];
      [params setObject:@"25" forKey:@"limit"];
      fbRequest = [[FacebookJanitor sharedInstance].facebook getRequestWithGraphPath:path
                                                                           andParams:params
                                                                       andHttpMethod:@"GET"
                                                                         andDelegate:nil];
    }
    else {
      fbRequest = [[FacebookJanitor sharedInstance].facebook getRequestWithGraphPath:path andDelegate:nil];
    }    
    TTURLRequest* request = [TTURLRequest
                             requestWithURL: [fbRequest getConnectURL]
                             delegate: self];
    
    request.cachePolicy = TTURLRequestCachePolicyNetwork;//cachePolicy; // | TTURLRequestCachePolicyEtag;
    request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
    
    TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);
    
    [request send];
  }
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
  TTURLJSONResponse* response = request.response;
  TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
  
  NSDictionary* feed = response.rootObject;
  TTDASSERT([[feed objectForKey:@"data"] isKindOfClass:[NSArray class]]);
  
  NSArray* entries = [feed objectForKey:@"data"];
  
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
  [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];

  BOOL more = ([[request urlPath] rangeOfString:@"offset="].location != NSNotFound);
  NSMutableArray* oldComments;
  if (more && !commentsEmpty(_comments)) {
    oldComments = [[NSMutableArray arrayWithArray:_comments] retain];
  }
  else {
    oldComments = [[NSMutableArray alloc] initWithCapacity:0];
  }


  NSMutableArray* comments = [[NSMutableArray alloc] initWithCapacity:[entries count]];

  TT_RELEASE_SAFELY(_comments);
  
  for (NSDictionary* entry in entries) {
    Comment* comment = [[Comment alloc] init];
    
    NSDate* date = [dateFormatter dateFromString:[entry objectForKey:@"created_time"]];
    comment.created = date;
    comment.commentId = [entry objectForKey:@"id"];
    comment.message = [entry objectForKey:@"message"];
    if ([entry objectForKey:@"from"] != [NSNull null]) {
      comment.fromName = [[entry objectForKey:@"from"] objectForKey:@"name"];
      comment.fromId = [[entry objectForKey:@"from"] objectForKey:@"id"];
      comment.fromAvatar = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=square", comment.fromId];
    }
    else {
      comment.fromName = @"Facebook User";
      comment.fromAvatar = @"https://graph.facebook.com/1/picture?type=square";
    }    
    
    [comments addObject:comment];
    TT_RELEASE_SAFELY(comment);
  }
  
  if (more) {
    [comments addObjectsFromArray:oldComments];
  }
  _comments = comments;
  
  TT_RELEASE_SAFELY(dateFormatter);
  
  [super requestDidFinishLoad:request];
}

@end

