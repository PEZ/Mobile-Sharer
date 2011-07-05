//
//  NotificationCell.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-07-03.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "Notification.h"
#import "NotificationCell.h"


@implementation NotificationCell

+ (NSString*) getMetaHTML:(StyledTableDataItem*)item {
  NSString* metaText = [super getMetaHTML:item];
  return [NSString stringWithFormat:@"<div class=\"tableMetaText\">%@</div>", metaText];
}

+ (void) setMessageHTML:(StyledTableDataItem*)item {
  Notification* notificationItem = (Notification*)item;
  if (notificationItem.html == nil) {
    NSString* messageText = [self getAvatarHTML:notificationItem.fromAvatar feedId:notificationItem.fromId];
    messageText = [NSString stringWithFormat:@"%@<div class=\"%@\">", messageText, @"tableMessageContent"];
    if (notificationItem.message) {
      messageText = [NSString stringWithFormat:@"%@<span class=\"tableText\">%@</span>", messageText,
                     [Etc xmlEscape:notificationItem.message]];
    }
    messageText = [NSString stringWithFormat:@"%@%@</div>", messageText, [self getMetaHTML:notificationItem]];
    if (notificationItem.isNew) {
      messageText = [NSString stringWithFormat:@"<div class=\"tableNewNotificationContent\">%@</div>", messageText];
    }
    notificationItem.html = messageText;
  }
}

@end
