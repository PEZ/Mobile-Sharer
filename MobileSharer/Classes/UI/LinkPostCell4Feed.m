//
//  LinkPostCell.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-14.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "LinkPostCell4Feed.h"


@implementation LinkPostCell4Feed

+ (NSString*) getLinkTitleHTML:(Post*)item {
  return [NSString stringWithFormat:@"<div class=\"tableTitleText\">%@</div>", item.linkTitle];
  //linkText = [NSString stringWithFormat:@"%@<div class=\"tableTitleText\"><a href=\"%@\">%@</a></div>", linkText, item.linkURL, item.linkTitle];
}

@end
