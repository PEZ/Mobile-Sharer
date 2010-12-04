//
//  CommentCell.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-09.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "CommentCell.h"
#import "DefaultStyleSheet.h"


@implementation CommentCell

+ (NSString*) getMetaHTML:(Post*)item {
  NSString* metaText = @"";
  metaText = [NSString stringWithFormat:@"<div class=\"tableMetaText\">%@%@", metaText, [item.created formatRelativeTime]];
  if (item.likes) {
    metaText = [NSString stringWithFormat:@"%@, %@", metaText,
                [[self class] textForCount:[item.likes intValue] withSingular:@"like" andPlural:@"likes"]];
  }
  return [NSString stringWithFormat:@"%@</div>", metaText];
}

+ (void) setMessageHTML:(Post*)item {
  if (item.html == nil) {
    NSString* messageText = @"";
    messageText = [NSString stringWithFormat:@"%@<img class=\"feedAvatar\" width=\"%f\" height=\"%f\" src=\"%@\" />",
                   messageText, kAvatarImageWidth, kAvatarImageHeight, [Etc xmlEscape:item.fromAvatar]];
    messageText = [NSString stringWithFormat:@"%@<div class=\"tableMessageContent\">%@", messageText, [self getNameHTML:item.fromName feedId:item.fromId]];
    if (item.message) {
      messageText = [NSString stringWithFormat:@"%@ <span class=\"tableText\">%@</span>", messageText, [Etc xmlEscape:item.message]];
    }
    messageText = [NSString stringWithFormat:@"%@%@</div>", messageText, [self getMetaHTML:item]];
    
    item.html = messageText;
  }
}

@end