
#import "FeedModel.h"
#import "FacebookJanitor.h"

@implementation FeedModel

@synthesize feedId     = _feedId;

- (id)initWithFeedId:(NSString*)feedId {
  if ((self = [super init])) {
    self.feedId = feedId;
  }

  return self;
}

- (void) dealloc {
  TT_RELEASE_SAFELY(_feedId);
  [super dealloc];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
  if (!self.isLoading && TTIsStringWithAnyText(_feedId)) {
    FBRequest* fbRequest;
    NSString* path = [NSString stringWithFormat:@"%@/%@", _feedId, [_feedId isEqual:@"me"] ? @"home" : @"feed"];
    if (more) {
      NSString* until = [NSString stringWithFormat:@"%@",
                         [NSNumber numberWithDouble:[[[self.posts lastObject] created] timeIntervalSince1970]]];
      NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:until forKey:@"until"];
      fbRequest = [[FacebookJanitor sharedInstance].facebook createRequestWithGraphPath:path
                                                                           andParams:params
                                                                       andHttpMethod:@"GET"
                                                                         andDelegate:nil];
    }
    else {
      fbRequest = [[FacebookJanitor sharedInstance].facebook createRequestWithGraphPath:path andDelegate:nil];
    }
    
    [[FacebookModel createRequest:fbRequest cachePolicy:TTURLRequestCachePolicyNetwork delegate:self] send]; //TODO: use cachePolicy arg
  }
}

- (NSArray *)entriesFromResponse:(TTURLJSONResponse*)response  {
  NSDictionary* feed = response.rootObject;
  TTDASSERT([[feed objectForKey:@"data"] isKindOfClass:[NSArray class]]);
  return [feed objectForKey:@"data"];
}

@end

