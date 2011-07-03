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
@synthesize isNew = _isNew;

- (void)dealloc {
  TT_RELEASE_SAFELY(_notificationId);
  TT_RELEASE_SAFELY(_objectId);
  TT_RELEASE_SAFELY(_type);
  [super dealloc];
}
@end
