//
//  Comment.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-08.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "Comment.h"


@implementation Comment
@synthesize created           = _created;
@synthesize commentId         = _commentId;
@synthesize fromId            = _fromId;
@synthesize fromName          = _fromName;
@synthesize fromAvatar        = _fromAvatar;
@synthesize message           = _message;

- (void)dealloc {
  TT_RELEASE_SAFELY(_created);
  TT_RELEASE_SAFELY(_commentId);
  TT_RELEASE_SAFELY(_fromId);
  TT_RELEASE_SAFELY(_fromName);
  TT_RELEASE_SAFELY(_fromAvatar);
  TT_RELEASE_SAFELY(_message);
  
  [super dealloc];
}

@end


