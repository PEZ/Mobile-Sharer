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
  NSString* _fromName;
  NSNumber* _likes;
  BOOL      _isLiked;
  BOOL      _isUpdatingLikes;
  NSString* _actionsButtonsHTML;
  TTStyledText* _actionButtonsStyledText;
}

@property (nonatomic, retain) NSString* commentId;
@property (nonatomic, retain) NSString* fromName;
@property (nonatomic, retain) NSNumber* likes;
@property (nonatomic)         BOOL      isLiked;
@property (nonatomic)         BOOL      isUpdatingLikes;
@property (nonatomic, retain) NSString* actionsButtonsHTML;
@property (nonatomic, readonly, retain) TTStyledText* actionButtonsStyledText;

@end