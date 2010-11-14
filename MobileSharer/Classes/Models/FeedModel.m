
#import "FeedModel.h"
#import "Post.h"
#import "FacebookJanitor.h"
#import <extThree20JSON/extThree20JSON.h>

@implementation FeedModel

@synthesize feedId     = _feedId;
@synthesize posts      = _posts;

- (id)initWithFeedId:(NSString*)feedId {
  if (self = [super init]) {
    self.feedId = feedId;
  }

  return self;
}

- (void) dealloc {
  TT_RELEASE_SAFELY(_feedId);
  TT_RELEASE_SAFELY(_posts);
  [super dealloc];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
  if (!self.isLoading && TTIsStringWithAnyText(_feedId)) {
    NSString* path = [NSString stringWithFormat:@"%@/%@", self.feedId, [self.feedId isEqual:@"me"] ? @"home" : @"feed"];
    FBRequest* fbRequest;
    if (more) {
      NSString* until = [NSString stringWithFormat:@"%@",
                         [NSNumber numberWithDouble:[[[_posts lastObject] created] timeIntervalSince1970]]];
      NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:until forKey:@"until"];
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
    
    request.cachePolicy = TTURLRequestCachePolicyNone;// cachePolicy | TTURLRequestCachePolicyEtag;
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
    Post* post = [[Post alloc] init];

    NSDate* date = [dateFormatter dateFromString:[entry objectForKey:@"created_time"]];
    post.created = date;
    post.postId = [entry objectForKey:@"id"];
    post.type = [entry objectForKey:@"type"];
    post.message = [entry objectForKey:@"message"];
    if ([entry objectForKey:@"from"] != [NSNull null]) {
      post.fromName = [[entry objectForKey:@"from"] objectForKey:@"name"];
      post.fromId = [[entry objectForKey:@"from"] objectForKey:@"id"];
      post.URL = [Etcetera toPostPath:post];
      post.fromAvatar = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=square", post.fromId];
    }
    else {
      post.fromName = @"Facebook User";
      post.fromAvatar = @"https://graph.facebook.com/1/picture?type=square";
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


    [posts addObject:post];
    TT_RELEASE_SAFELY(post);
  }
  _posts = posts;

  TT_RELEASE_SAFELY(dateFormatter);

  [super requestDidFinishLoad:request];
}

@end

