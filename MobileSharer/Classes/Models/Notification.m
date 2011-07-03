//
//  Notification.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-07-01.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "Notification.h"


@implementation Notification

@synthesize notificationId = _notificationId;
@synthesize objectId = _objectId;
@synthesize type = _type;
@synthesize fromId = _fromId;
@synthesize fromAvatar = _fromAvatar;
@synthesize isNew = _isNew;

- (void)dealloc {
  TT_RELEASE_SAFELY(_notificationId);
  TT_RELEASE_SAFELY(_objectId);
  TT_RELEASE_SAFELY(_type);
  TT_RELEASE_SAFELY(_fromId);
  TT_RELEASE_SAFELY(_fromAvatar);
  [super dealloc];
}
@end
