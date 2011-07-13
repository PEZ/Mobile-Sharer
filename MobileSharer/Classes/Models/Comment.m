//
//  Comment.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-08.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "Comment.h"


@implementation Comment
@synthesize commentId          = _commentId;
@synthesize fromName           = _fromName;
@synthesize likes              = _likes;
@synthesize isLiked            = _isLiked;
@synthesize isUpdatingLikes    = _isUpdatingLikes;
@synthesize actionsButtonsHTML = _actionsButtonsHTML;

- (void)dealloc {
  TT_RELEASE_SAFELY(_commentId);
  TT_RELEASE_SAFELY(_fromName);
  TT_RELEASE_SAFELY(_likes);
  TT_RELEASE_SAFELY(_actionsButtonsHTML);
  TT_RELEASE_SAFELY(_actionButtonsStyledText)
  [super dealloc];
}

- (TTStyledText*)actionButtonsStyledText {
  return [self styledText:&_actionButtonsStyledText fromHtml:_actionsButtonsHTML];
}

- (void)setActionsButtonsHTML:(NSString *)actionsButtonsHTML {
  [self setHtml:actionsButtonsHTML forIVar:&_actionsButtonsHTML andStyledText:&_actionButtonsStyledText];
}  
@end


