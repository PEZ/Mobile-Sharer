//
//  Notification.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-07-01.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "Notification.h"


@implementation Notification

@synthesize created = _created;
@synthesize notificationId = _notificationId;
@synthesize postId = _postId;
@synthesize fromId = _fromId;
@synthesize fromAvatar = _fromAvatar;
@synthesize message = _message;
@synthesize icon = _icon;
@synthesize isNew = _isNew;

- (void)dealloc {
  TT_RELEASE_SAFELY(_created);
  TT_RELEASE_SAFELY(_notificationId);
  TT_RELEASE_SAFELY(_postId);
  TT_RELEASE_SAFELY(_fromId);
  TT_RELEASE_SAFELY(_fromAvatar);
  TT_RELEASE_SAFELY(_message);
  TT_RELEASE_SAFELY(_icon);
  [super dealloc];
}
@end
