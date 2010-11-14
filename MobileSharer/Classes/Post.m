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
  Post *newPost = [[Post alloc] init];
  newPost.created = [_created copyWithZone: zone];
  newPost.updated = [_updated copyWithZone: zone];
  newPost.postId = [_postId copyWithZone: zone];
  newPost.type = [_type copyWithZone: zone];
  newPost.fromId = [_fromId copyWithZone: zone];
  newPost.toId = [_toId copyWithZone: zone];
  newPost.message = [_message copyWithZone: zone];
  newPost.fromName = [_fromName copyWithZone: zone];
  newPost.picture = [_picture copyWithZone: zone];
  newPost.fromAvatar = [_fromAvatar copyWithZone: zone];
  newPost.linkCaption = [_link copyWithZone: zone];
  newPost.linkURL = [_linkURL copyWithZone: zone];
  newPost.linkTitle = [_linkTitle copyWithZone: zone];
  newPost.linkText = [_linkText copyWithZone: zone];
  newPost.source = [_source copyWithZone: zone];
  newPost.icon = [_icon copyWithZone: zone];
  newPost.likes = [_likes copyWithZone: zone];
  newPost.commentCount = [_commentCount copyWithZone: zone];
  
  return newPost;
}

@end
