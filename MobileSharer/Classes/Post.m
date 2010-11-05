#import "Post.h"


@implementation Post

@synthesize created           = _created;
@synthesize updated           = _updated;
@synthesize postId            = _postId;
@synthesize type              = _type;
@synthesize fromId            = _fromId;
@synthesize toId              = _toId;
@synthesize text              = _message;
@synthesize fromName          = _fromName;
@synthesize picture           = _picture;
@synthesize imageURL          = _fromAvatar;
@synthesize linkCaption              = _link;
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
  TT_RELEASE_SAFELY(_URL);
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

@end
