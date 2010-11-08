
#import "FeedModel.h"

@interface FeedDataSource : TTListDataSource {
  FeedModel* _feedModel;
}

- (id)initWithFeedId:(NSString*)feedId;

@end
