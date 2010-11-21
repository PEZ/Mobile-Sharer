//
//  untitled.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-14.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "StandalonePostCell.h"


@implementation StandalonePostCell

+ (NSString*) getLinkTitleHTML:(Post*)item {
  return [NSString stringWithFormat:@"<div class=\"tableTitleText\"><a href=\"%@\">%@</a></div>", item.linkURL, [Etc xmlEscape:item.linkTitle]];
}

@end
