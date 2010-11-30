//
//  Post.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-08.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "Post.h"

@implementation Post

@synthesize created           = _created;
@synthesize updated           = _updated;
@synthesize postId            = _postId;
@synthesize type              = _type;
@synthesize fromName          = _fromName;
@synthesize fromId            = _fromId;
@synthesize toName            = _toName;
@synthesize toId              = _toId;
@synthesize message           = _message;
@synthesize picture           = _picture;
@synthesize fromAvatar        = _fromAvatar;
@synthesize linkCaption       = _link;
@synthesize linkURL           = _linkURL;
@synthesize shareURL          = _shareURL;
@synthesize linkTitle         = _linkTitle;
@synthesize linkText          = _linkText;
@synthesize source            = _source;
@synthesize icon              = _icon;
@synthesize likes             = _likes;
@synthesize commentCount      = _commentCount;
@synthesize html              = _html;
@synthesize canComment        = _canComment;
@synthesize canLike           = _canLike;

- (void)dealloc {
  TT_RELEASE_SAFELY(_updated);
  TT_RELEASE_SAFELY(_created);
  TT_RELEASE_SAFELY(_postId);
  TT_RELEASE_SAFELY(_type);
  TT_RELEASE_SAFELY(_fromName);
  TT_RELEASE_SAFELY(_fromId);
  TT_RELEASE_SAFELY(_toName);
  TT_RELEASE_SAFELY(_toId);
  TT_RELEASE_SAFELY(_message);
  TT_RELEASE_SAFELY(_picture);
  TT_RELEASE_SAFELY(_fromAvatar);
  TT_RELEASE_SAFELY(_link);
  TT_RELEASE_SAFELY(_linkURL);
  TT_RELEASE_SAFELY(_shareURL);
  TT_RELEASE_SAFELY(_linkTitle)
  TT_RELEASE_SAFELY(_linkText)
  TT_RELEASE_SAFELY(_source);
  TT_RELEASE_SAFELY(_icon);
  TT_RELEASE_SAFELY(_likes);
  TT_RELEASE_SAFELY(_commentCount);
  TT_RELEASE_SAFELY(_html);
  TT_RELEASE_SAFELY(_styledText);
  [super dealloc];
}

- (id)userInfo {
  return self;
}

/*
- (id)retain {
  NSLog(@"post %@ retained", self);
  return [super retain];
}

- (void)release {
  NSLog(@"post %@ released", self);
  [super release];
}
*/

- (TTStyledText*)styledText {
  if (!_styledText) {
    _styledText = [[TTStyledText textFromXHTML:_html lineBreaks:YES URLs:(self.URL == nil)] retain];
  }
  return _styledText;
}

@end
