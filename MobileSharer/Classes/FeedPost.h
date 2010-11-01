
@interface FeedPost : NSObject {
  NSDate*   _created;
  NSDate*   _updated;
  NSNumber* _postId;
  NSString* _type;
  NSString* _fromId;
  NSString* _toId;
  NSString* _message;
  NSString* _fromName;
  NSString* _picture;
  NSString* _fromAvatar;
  NSString* _link;
  NSString* _linkURL;
  NSString* _linkTitle;
  NSString* _linkText;
  NSString* _source;
  NSString* _icon;
  NSNumber* _likes;
  NSNumber* _commentCount;
}

@property (nonatomic, retain) NSDate*   created;
@property (nonatomic, retain) NSDate*   updated;
@property (nonatomic, retain) NSNumber* postId;
@property (nonatomic, copy)   NSString* type;
@property (nonatomic, copy)   NSString* fromId;
@property (nonatomic, copy)   NSString* toId;
@property (nonatomic, copy)   NSString* message;
@property (nonatomic, copy)   NSString* fromName;
@property (nonatomic, copy)   NSString* picture;
@property (nonatomic, copy)   NSString* fromAvatar;
@property (nonatomic, copy)   NSString* link;
@property (nonatomic, copy)   NSString* linkURL;
@property (nonatomic, copy)   NSString* linkTitle;
@property (nonatomic, copy)   NSString* linkText;
@property (nonatomic, copy)   NSString* source;
@property (nonatomic, copy)   NSString* icon;
@property (nonatomic, retain) NSNumber* likes;
@property (nonatomic, retain) NSNumber* commentCount;

@end
