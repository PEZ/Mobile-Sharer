//
//  Post.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-08.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "Post.h"
#import "RegexKitLite.h"

@implementation Post

@synthesize updated           = _updated;
@synthesize postId            = _postId;
@synthesize type              = _type;
@synthesize fromName          = _fromName;
@synthesize toName            = _toName;
@synthesize toId              = _toId;
@synthesize picture           = _picture;
@synthesize linkCaption       = _link;
@synthesize linkURL           = _linkURL;
@synthesize shareURL          = _shareURL;
@synthesize linkTitle         = _linkTitle;
@synthesize linkText          = _linkText;
@synthesize source            = _source;
@synthesize likes             = _likes;
@synthesize commentCount      = _commentCount;
@synthesize canComment        = _canComment;
@synthesize canLike           = _canLike;
@synthesize isFavorite        = _isFavorite;

- (void)dealloc {
  TT_RELEASE_SAFELY(_updated);
  TT_RELEASE_SAFELY(_postId);
  TT_RELEASE_SAFELY(_type);
  TT_RELEASE_SAFELY(_fromName);
  TT_RELEASE_SAFELY(_toName);
  TT_RELEASE_SAFELY(_toId);
  TT_RELEASE_SAFELY(_picture);
  TT_RELEASE_SAFELY(_link);
  TT_RELEASE_SAFELY(_linkURL);
  TT_RELEASE_SAFELY(_shareURL);
  TT_RELEASE_SAFELY(_linkTitle)
  TT_RELEASE_SAFELY(_linkText)
  TT_RELEASE_SAFELY(_source);
  TT_RELEASE_SAFELY(_likes);
  TT_RELEASE_SAFELY(_commentCount);
  [super dealloc];
}


+ (NSString*)fullPostId:(NSString*)postId andFeedId:(NSString*)feedId {
	if ([postId isMatchedByRegex:@"_"]) {
		return postId;
	}
	else {
		return [NSString stringWithFormat:@"%@_%@", feedId, postId];
	}
}

@end
