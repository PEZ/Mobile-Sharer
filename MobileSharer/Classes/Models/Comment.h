//
//  Comment.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-08.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "StyledTableDataItem.h"

@interface Comment : StyledTableDataItem {
  NSString* _commentId;
  NSString* _fromId;
  NSString* _fromName;
  NSString* _fromAvatar;
  NSNumber* _likes;
  BOOL      _isLiked;
}

@property (nonatomic, retain) NSString* commentId;
@property (nonatomic, retain) NSString* fromId;
@property (nonatomic, retain) NSString* fromName;
@property (nonatomic, retain) NSString* fromAvatar;
@property (nonatomic, retain) NSNumber* likes;
@property (nonatomic)         BOOL      isLiked;

@end