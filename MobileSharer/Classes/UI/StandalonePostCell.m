//
//  untitled.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-14.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "StandalonePostCell.h"


@implementation StandalonePostCell

+ (NSString*) getLinkHTMLForText:(NSString*)text andURL:(NSString*)url {
  return [NSString stringWithFormat:@"<a href=\"%@\">%@</a>", [Etc xmlEscape:url], [Etc xmlEscape:text]];
}

+ (NSString*) getAttachmentPictureHTML:(Post*)item {
  return [NSString stringWithFormat:@"<a href=\"%@\"><img class=\"tablePostImage\" width=\"%f\" height=\"%f\" src=\"%@\" /></a>",
          [Etc xmlEscape:item.linkURL], kPictureImageWidth, kPictureImageHeight, [Etc xmlEscape:item.picture]];}

+ (NSString*) getAttachmentTitleHTML:(Post*)item {
  return [NSString stringWithFormat:@"<div class=\"tableTitleText\">%@</div>",
          [self getLinkHTMLForText:item.linkTitle andURL:item.linkURL]];
}

@end
