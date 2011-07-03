//
//  FacebookModel.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-16.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "FacebookModel.h"
#import "FacebookJanitor.h"
#import "RegexKitLite.h"

@implementation FacebookModel

+ (NSString*)urlFromURL:(NSString*)url {
  if (url) {
    NSString* pagesRegex = @"^http://www.facebook.com/pages/([^/]+)/([0-9]+)";
    if ([url stringByMatching:pagesRegex]) {
      NSArray* nameAndId = [[url arrayOfCaptureComponentsMatchedByRegex:pagesRegex] objectAtIndex:0];
      return [Etc toFeedURLPath:[nameAndId objectAtIndex:2] name:[nameAndId objectAtIndex:1]];
    }
    NSString* namedFeedRegex = @"^http://www.facebook.com/([^?/#]+)/?$";
    if ([url stringByMatching:namedFeedRegex]) {
      NSArray* name = [[url arrayOfCaptureComponentsMatchedByRegex:namedFeedRegex] objectAtIndex:0];
      return [Etc toFeedURLPath:[name objectAtIndex:1] name:[name objectAtIndex:1]];
    }
    NSString* photoRegex = @"http://www.facebook.com/photo.php[?].*?fbid=([0-9]+)";
    if ([url stringByMatching:photoRegex]) {
      NSString* photoId = [[[url arrayOfCaptureComponentsMatchedByRegex:photoRegex] objectAtIndex:0] objectAtIndex:1];
      return [Etc toPhotoURLPath:photoId];
    }
  }    
  return url;
}

+ (Post*)createPostFromEntry:(NSDictionary *)entry {
  Post* post = [[Post alloc] init];
  
  NSDate* date = [[FacebookJanitor dateFormatter] dateFromString:[entry objectForKey:@"created_time"]];
  post.created = date;
  post.postId = [entry objectForKey:@"id"];
  post.type = [entry objectForKey:@"type"];
  post.message = [entry objectForKey:@"message"];
  if ([entry objectForKey:@"from"] != [NSNull null]) {
    post.fromName = [[entry objectForKey:@"from"] objectForKey:@"name"];
    post.fromId = [[entry objectForKey:@"from"] objectForKey:@"id"];
    post.URL = [Etc toPostIdPath:post.postId andTitle:[post.type capitalizedString]];
    post.fromAvatar = [FacebookJanitor avatarForId:post.fromId];
  }
  else {
    post.fromName = @"Facebook User";
    post.fromAvatar = @"https://graph.facebook.com/1/picture?type=square";
  }
  if ([entry objectForKey:@"actions"]) {
    for (NSMutableDictionary* action in [entry objectForKey:@"actions"]) {
      if ([action objectForKey:@"name"] && [[action objectForKey:@"name"] isEqual:@"Comment"]) {
        post.canComment = YES;
      }
      if ([action objectForKey:@"name"] && [[action objectForKey:@"name"] isEqual:@"Like"]) {
        post.canLike = YES;
      }
    }
  }
  if ([entry objectForKey:@"to"] != [NSNull null] &&
      [[[entry objectForKey:@"to"] objectForKey:@"data"] objectAtIndex:0] != [NSNull null]) {
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
  post.shareURL = [entry objectForKey:@"link"];
  post.linkURL = [self urlFromURL:post.shareURL];
  post.linkCaption = [entry objectForKey:@"caption"];
  post.linkTitle = [entry objectForKey:@"name"];
  post.linkText = [entry objectForKey:@"description"];

  return post;
}

+ (TTURLRequest*)createRequest:(FBRequest*)fbRequest cachePolicy:(TTURLRequestCachePolicy)cachePolicy delegate:(id<TTURLRequestDelegate>)delegate {
  TTURLRequest* request = [TTURLRequest
                           requestWithURL:fbRequest.serializedURL
                           delegate:delegate];
  
  request.cachePolicy = cachePolicy;
  request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
  
  TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
  request.response = response;
  TT_RELEASE_SAFELY(response);
  return request;
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
  DLog(@"request failed: %@", [error localizedDescription]);
}

- (void)requestDidCancelLoad:(TTURLRequest*)request {
  DLog(@"request cancelled");
}

@end
