//
//  Comment.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-08.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

@interface Comment : TTTableImageItem {
  NSDate*   _created;
  NSString* _commentId;
  NSString* _fromId;
  NSString* _fromName;
  NSString* _fromAvatar;
  NSString* _message;
}

@property (nonatomic, retain) NSDate*   created;
@property (nonatomic, retain) NSString* commentId;
@property (nonatomic, retain) NSString* fromId;
@property (nonatomic, retain) NSString* fromName;
@property (nonatomic, retain) NSString* fromAvatar;
@property (nonatomic, retain) NSString* message;

@end