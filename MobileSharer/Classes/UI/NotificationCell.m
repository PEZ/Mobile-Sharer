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

@end

@implementation HighLightedNotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
  if ((self = [super initWithStyle:style reuseIdentifier:identifier])) {
    self.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    self.backgroundView.backgroundColor = TTSTYLEVAR(highlightedColor);
  }
  return self;
}

@end
