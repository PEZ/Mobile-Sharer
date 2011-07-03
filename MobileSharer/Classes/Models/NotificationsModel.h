//
//  NotificationsModel.h
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-07-01.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

@interface NotificationsModel : TTURLRequestModel {
  NSArray*          _notifications;
}

@property (nonatomic, retain)  NSArray* notifications;

@end
