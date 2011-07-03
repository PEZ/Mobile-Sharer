//
//  NotificationCell.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-07-03.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "NotificationCell.h"


@implementation NotificationCell

+ (NSString*) getMetaHTML:(StyledTableDataItem*)item {
  NSString* metaText = [super getMetaHTML:item];
  return [NSString stringWithFormat:@"<div class=\"tableMetaText\">%@</div>", metaText];
}

@end
