
@interface FeedModel : TTURLRequestModel {
  NSString* _feedId;
  NSArray*  _posts;
}

@property (nonatomic, copy)     NSString* feedId;
@property (nonatomic, readonly) NSArray*  posts;

- (id)initWithFeedId:(NSString*)feedId;

@end
