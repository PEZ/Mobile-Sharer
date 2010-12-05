//
//  Comment.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-08.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "StyledTableDataItem.h"

@interface Comment : StyledTableDataItem {
  NSDate*   _created;
  NSString* _commentId;
  NSString* _fromId;
  NSString* _fromName;
  NSString* _fromAvatar;
  NSString* _message;
  NSNumber* _likes;
  BOOL      _isLiked;
}

@property (nonatomic, retain) NSDate*   created;
@property (nonatomic, retain) NSString* commentId;
@property (nonatomic, retain) NSString* fromId;
@property (nonatomic, retain) NSString* fromName;
@property (nonatomic, retain) NSString* fromAvatar;
@property (nonatomic, retain) NSString* message;
@property (nonatomic, retain) NSNumber* likes;
@property (nonatomic)         BOOL      isLiked;

@end