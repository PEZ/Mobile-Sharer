//
//  Comment.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-08.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "Comment.h"


@implementation Comment
@synthesize commentId         = _commentId;
@synthesize fromName          = _fromName;
@synthesize likes             = _likes;
@synthesize isLiked           = _isLiked;

- (void)dealloc {
  TT_RELEASE_SAFELY(_commentId);
  TT_RELEASE_SAFELY(_fromName);
  TT_RELEASE_SAFELY(_likes);
  
  [super dealloc];
}

@end


