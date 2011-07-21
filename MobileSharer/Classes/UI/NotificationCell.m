//
//  NotificationCell.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-07-03.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "Notification.h"
#import "NotificationCell.h"
#import "DefaultStyleSheet.h"


@implementation NotificationCell

+ (NSString*) getMetaHTML:(StyledTableDataItem*)item {
  NSString* metaText = [super getMetaHTML:item];
  return [NSString stringWithFormat:@"<div class=\"tableMetaText\">%@</div>", metaText];
}

+ (NSString*) wrapMessageHTML:(NSString*)messageHTML item:(StyledTableDataItem*)item {
  if (((Notification*)item).isNew) {
    messageHTML = [NSString stringWithFormat:@"<div class=\"tableCellNewNotification\">%@</div>", messageHTML];
  }
  return messageHTML;
}

- (void)setObject:(id)object {
  if (_item != object) {
    [super setObject:object];
    self.backgroundColor = TTSTYLEVAR(highlightedColor);
  }
}


@end
