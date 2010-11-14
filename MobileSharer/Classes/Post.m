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
@synthesize fromId            = _fromId;
@synthesize toId              = _toId;
@synthesize message           = _message;
@synthesize fromName          = _fromName;
@synthesize picture           = _picture;
@synthesize fromAvatar        = _fromAvatar;
@synthesize linkCaption       = _link;
@synthesize linkURL           = _linkURL;
@synthesize linkTitle         = _linkTitle;
@synthesize linkText          = _linkText;
@synthesize source            = _source;
@synthesize icon              = _icon;
@synthesize likes             = _likes;
@synthesize commentCount      = _commentCount;

- (void)dealloc {
  TT_RELEASE_SAFELY(_updated);
  TT_RELEASE_SAFELY(_created);
  TT_RELEASE_SAFELY(_postId);
  TT_RELEASE_SAFELY(_type);
  TT_RELEASE_SAFELY(_fromId);
  TT_RELEASE_SAFELY(_toId);
  TT_RELEASE_SAFELY(_message);
  TT_RELEASE_SAFELY(_fromName);
  TT_RELEASE_SAFELY(_picture);
  TT_RELEASE_SAFELY(_fromAvatar);
  TT_RELEASE_SAFELY(_link);
  TT_RELEASE_SAFELY(_linkURL);
  TT_RELEASE_SAFELY(_linkTitle)
  TT_RELEASE_SAFELY(_linkText)
  TT_RELEASE_SAFELY(_source);
  TT_RELEASE_SAFELY(_icon);
  TT_RELEASE_SAFELY(_likes);
  TT_RELEASE_SAFELY(_commentCount);

  [super dealloc];
}

- (id)userInfo {
  return self;
}

- (id)copyWithZone:(NSZone *)zone {
  Post *another = [[Post alloc] init];
  another.created = [_created copyWithZone: zone];
  another.updated = [_updated copyWithZone: zone];
  another.postId = [_postId copyWithZone: zone];
  another.type = [_type copyWithZone: zone];
  another.fromId = [_fromId copyWithZone: zone];
  another.toId = [_toId copyWithZone: zone];
  another.message = [_message copyWithZone: zone];
  another.fromName = [_fromName copyWithZone: zone];
  another.picture = [_picture copyWithZone: zone];
  another.fromAvatar = [_fromAvatar copyWithZone: zone];
  another.linkCaption = [_link copyWithZone: zone];
  another.linkURL = [_linkURL copyWithZone: zone];
  another.linkTitle = [_linkTitle copyWithZone: zone];
  another.linkText = [_linkText copyWithZone: zone];
  another.source = [_source copyWithZone: zone];
  another.icon = [_icon copyWithZone: zone];
  another.likes = [_likes copyWithZone: zone];
  another.commentCount = [_commentCount copyWithZone: zone];
  
  return another;
}

@end
