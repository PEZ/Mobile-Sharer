
#import "FeedModel.h"
#import "Post.h"
#import "FacebookJanitor.h"

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
    FBRequest* fbRequest;
    NSString* path = [NSString stringWithFormat:@"%@/%@", _feedId, [_feedId isEqual:@"me"] ? @"home" : @"feed"];
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
    
    [[self createRequest:fbRequest cachePolicy:TTURLRequestCachePolicyNetwork] send]; //TODO: use cachePolicy arg
  }
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
    [posts addObject:[self postFromEntry: entry]];
  }
  _posts = posts;

  [super requestDidFinishLoad:request];
}

@end

