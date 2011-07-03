//
//  Notification.h
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-07-01.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//
#import "StyledTableIconDataItem.h"

@interface Notification : StyledTableIconDataItem {
  NSString* _notificationId;
  NSString* _type;
  NSString* _objectId;
  BOOL      _isNew;
}

@property (nonatomic, retain) NSString* notificationId;
@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSString* objectId;
@property (nonatomic)         BOOL      isNew;

@end
