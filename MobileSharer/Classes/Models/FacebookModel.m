//
//  FacebookModel.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-16.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "FacebookModel.h"
#import "FacebookJanitor.h"


@implementation FacebookModel

- (Post*)postFromEntry:(NSDictionary *)entry {
  Post* post = [[Post alloc] init];
  
  NSDate* date = [[FacebookJanitor dateFormatter] dateFromString:[entry objectForKey:@"created_time"]];
  post.created = date;
  post.postId = [entry objectForKey:@"id"];
  post.type = [entry objectForKey:@"type"];
  post.message = [entry objectForKey:@"message"];
  if ([entry objectForKey:@"from"] != [NSNull null]) {
    post.fromName = [[entry objectForKey:@"from"] objectForKey:@"name"];
    post.fromId = [[entry objectForKey:@"from"] objectForKey:@"id"];
    post.URL = [Etc toPostPath:post];
    post.fromAvatar = [FacebookJanitor avatarForId:post.fromId];
  }
  else {
    post.fromName = @"Facebook User";
    post.fromAvatar = @"https://graph.facebook.com/1/picture?type=square";
  }
  if ([entry objectForKey:@"to"] != [NSNull null]) {
    post.toName = [[[[entry objectForKey:@"to"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"name"];
    post.toId = [[[[entry objectForKey:@"to"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"id"];
  }
  if ([entry objectForKey:@"likes"] != [NSNull null]) {
    post.likes = [[entry objectForKey:@"likes"] objectForKey:@"count"];
  }
  if ([entry objectForKey:@"comments"] != [NSNull null]) {
    post.commentCount = [[entry objectForKey:@"comments"] objectForKey:@"count"];
  }
  post.icon = [entry objectForKey:@"icon"];
  post.picture = [entry objectForKey:@"picture"];
  post.linkURL = [entry objectForKey:@"link"];
  post.linkCaption = [entry objectForKey:@"caption"];
  post.linkTitle = [entry objectForKey:@"name"];
  post.linkText = [entry objectForKey:@"description"];

  return post;
}

- (TTURLRequest*)createRequest:(FBRequest*)fbRequest cachePolicy:(TTURLRequestCachePolicy)cachePolicy {
  TTURLRequest* request = [TTURLRequest
                           requestWithURL: [fbRequest getConnectURL]
                           delegate: self];
  
  request.cachePolicy = cachePolicy;
  request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
  
  TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
  request.response = response;
  TT_RELEASE_SAFELY(response);
  return request;
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
  NSLog(@"request failed: %@", [error localizedDescription]);
}

- (void)requestDidCancelLoad:(TTURLRequest*)request {
  NSLog(@"request cancelled");
}

@end
