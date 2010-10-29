
@class FeedModel;

@interface FeedDataSource : TTListDataSource {
  FeedModel* _searchFeedModel;
}

- (id)initWithSearchQuery:(NSString*)searchQuery;

@end
