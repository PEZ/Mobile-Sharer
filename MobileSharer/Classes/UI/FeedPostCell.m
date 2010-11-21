//
//  LinkPostCell.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-14.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "FeedPostCell.h"


@implementation FeedPostCell

+ (NSString*) getLinkHTMLForText:(NSString*)text andURL:(NSString*)url {
  return [NSString stringWithFormat:@"%@", [Etc xmlEscape:text]];
}

+ (NSString*) getAttachmentTitleHTML:(Post*)item {
  return [NSString stringWithFormat:@"<div class=\"tableTitleText\">%@</div>",
          [self getLinkHTMLForText:item.linkTitle andURL:nil]];
}

@end
