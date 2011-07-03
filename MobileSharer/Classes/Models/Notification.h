//
//  Notification.h
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-07-01.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//


@interface Notification : StyledTableDataItem {
  NSDate*   _created;
  NSString* _notificationId;
  NSString* _postId;
  NSString* _fromId;
  NSString* _fromAvatar;
  NSString* _message;
  NSString* _icon;
  BOOL      _isNew;
}

@property (nonatomic, retain) NSDate*   created;
@property (nonatomic, retain) NSString* notificationId;
@property (nonatomic, retain) NSString* fromId;
@property (nonatomic, retain) NSString* postId;
@property (nonatomic, retain) NSString* fromAvatar;
@property (nonatomic, retain) NSString* message;
@property (nonatomic, retain) NSString* icon;
@property (nonatomic)         BOOL      isNew;

@end
