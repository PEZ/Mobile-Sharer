//
//  Post.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-08.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

@interface Post : TTTableImageItem {
  NSDate*   _created;
  NSDate*   _updated;
  NSString* _postId;
  NSString* _type;
  NSString* _fromName;
  NSString* _fromId;
  NSString* _toName;
  NSString* _toId;
  NSString* _message;
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
  NSString* _html;
  TTStyledText* _styledText;
}

@property (nonatomic, retain) NSDate*   created;
@property (nonatomic, retain) NSDate*   updated;
@property (nonatomic, retain) NSString* postId;
@property (nonatomic, copy)   NSString* type;
@property (nonatomic, copy)   NSString* fromName;
@property (nonatomic, copy)   NSString* fromId;
@property (nonatomic, copy)   NSString* toId;
@property (nonatomic, copy)   NSString* toName;
@property (nonatomic, copy)   NSString* message;
@property (nonatomic, copy)   NSString* picture;
@property (nonatomic, copy)   NSString* fromAvatar;
@property (nonatomic, copy)   NSString* linkCaption;
@property (nonatomic, copy)   NSString* linkURL;
@property (nonatomic, copy)   NSString* linkTitle;
@property (nonatomic, copy)   NSString* linkText;
@property (nonatomic, copy)   NSString* source;
@property (nonatomic, copy)   NSString* icon;
@property (nonatomic, retain) NSNumber* likes;
@property (nonatomic, retain) NSNumber* commentCount;
@property (nonatomic, readonly, retain) Post*     userInfo;
@property (nonatomic, retain) NSString* html;
@property (nonatomic, readonly, retain) TTStyledText* styledText;

@end
