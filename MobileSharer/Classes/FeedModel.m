//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "FeedModel.h"
#import "FeedPost.h"
#import "FacebookJanitor.h"
#import <extThree20JSON/extThree20JSON.h>


//static NSString* kFacebookSearchFeedFormat = @"http://graph.facebook.com/search?q=%@&type=post";
//static NSString* kFacebookSearchFeedFormat = @"me/home?type=full";

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation FeedModel

@synthesize searchQuery = _searchQuery;
@synthesize posts      = _posts;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithSearchQuery:(NSString*)searchQuery {
  if (self = [super init]) {
    self.searchQuery = searchQuery;
  }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
  TT_RELEASE_SAFELY(_searchQuery);
  TT_RELEASE_SAFELY(_posts);
  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
  if (!self.isLoading && TTIsStringWithAnyText(_searchQuery)) {
    NSString* path = [NSString stringWithFormat:@"%@/%@", self.searchQuery, [self.searchQuery isEqual:@"me"] ? @"home" : @"feed"];
    FBRequest* fbRequest = [[FacebookJanitor sharedInstance].facebook getRequestWithGraphPath:path andDelegate:nil];
    NSString* url = [fbRequest getGetURL];
    
    TTURLRequest* request = [TTURLRequest
                             requestWithURL: url
                             delegate: self];
    
    request.cachePolicy = cachePolicy | TTURLRequestCachePolicyEtag;
    //request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;

    TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);
    
    [request send];
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
  TTURLJSONResponse* response = request.response;
  TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);

  NSDictionary* feed = response.rootObject;
  TTDASSERT([[feed objectForKey:@"data"] isKindOfClass:[NSArray class]]);

  NSArray* entries = [feed objectForKey:@"data"];

  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
  [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];

  TT_RELEASE_SAFELY(_posts);
  NSMutableArray* posts = [[NSMutableArray alloc] initWithCapacity:[entries count]];

  for (NSDictionary* entry in entries) {
    FeedPost* post = [[FeedPost alloc] init];

    NSDate* date = [dateFormatter dateFromString:[entry objectForKey:@"created_time"]];
    post.created = date;
    post.postId = [NSNumber numberWithLongLong:
                     [[entry objectForKey:@"id"] longLongValue]];
    post.type = [entry objectForKey:@"type"];
    post.message = [entry objectForKey:@"message"];
    post.picture = [entry objectForKey:@"picture"];
    if ([entry objectForKey:@"from"] != [NSNull null]) {
      post.fromName = [[entry objectForKey:@"from"] objectForKey:@"name"];
      post.fromId = [[entry objectForKey:@"from"] objectForKey:@"id"];
      post.fromAvatar = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=square", post.fromId];
    }
    else {
      post.fromName = @"Facebook User";
      post.fromAvatar = @"https://graph.facebook.com/1/picture?type=square";
    }
    post.likes = [entry objectForKey:@"likes"];
    if ([entry objectForKey:@"comments"] != [NSNull null]) {
      post.commentCount = [[entry objectForKey:@"comments"] objectForKey:@"count"];
    }
    post.icon = [entry objectForKey:@"icon"];
    post.picture = [entry objectForKey:@"picture"];
    post.linkURL = [entry objectForKey:@"link"];
    post.linkTitle = [entry objectForKey:@"name"];
    post.linkText = [entry objectForKey:@"description"];


    [posts addObject:post];
    TT_RELEASE_SAFELY(post);
  }
  _posts = posts;

  TT_RELEASE_SAFELY(dateFormatter);

  [super requestDidFinishLoad:request];
}

@end

