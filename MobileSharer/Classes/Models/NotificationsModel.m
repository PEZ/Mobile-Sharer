//
//  NotificationsModel.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-07-01.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "NotificationsModel.h"
#import "FacebookJanitor.h"

@implementation NotificationsModel

@synthesize notifications = _notifications;

- (void) dealloc {
  TT_RELEASE_SAFELY(_notifications);
  [super dealloc];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
  if (!self.isLoading) {
    FBRequest* fbRequest;
    NSString* path = @"";
    if (more) {
      /*
      NSString* until = [NSString stringWithFormat:@"%@",
                         [NSNumber numberWithDouble:[[[_posts lastObject] created] timeIntervalSince1970]]];
      NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:until forKey:@"until"];
      fbRequest = [[FacebookJanitor sharedInstance].facebook getRequestWithGraphPath:path
                                                                           andParams:params
                                                                       andHttpMethod:@"GET"
                                                                         andDelegate:nil];
       */
    }
    else {
      NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:1 forKey:@"includeRead"];
      fbRequest = [[FacebookJanitor sharedInstance].facebook createRequestWithMethodAndParams:@"notifications.getList" andParams:params];
    }
    
    [[FacebookModel createRequest:fbRequest cachePolicy:TTURLRequestCachePolicyNetwork delegate:self] send]; //TODO: use cachePolicy arg
  }
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
  /*
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
    [posts addObject:[[FacebookModel createPostFromEntry: entry] autorelease]];
  }
  _posts = posts;
  
  [super requestDidFinishLoad:request];
  */
}

@end
