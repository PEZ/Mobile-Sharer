//
//  PostTableCell.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-01.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PostCellBase.h"

@implementation PostCellBase

+ (NSString*) getAttachmentTitleHTML:(Post*)item {
  return nil; //Not inplemented in base class
}

+ (NSString*) getAttachmentPictureHTML:(Post*)item {
  return nil; //Not implemented in base class
}

+ (NSString*) getAttachmentHTML:(Post*)item  {
  NSString* attachmentText = @"";
  if (item.linkTitle) {
    attachmentText = [NSString stringWithFormat:@"%@%@", attachmentText, [self getAttachmentTitleHTML:item]];
  }
  if (item.linkCaption) {
    attachmentText = [NSString stringWithFormat:@"%@<div class=\"tableSubText\">%@</div>", attachmentText, [Etc xmlEscape:item.linkCaption]];
  }
  if (item.picture) {
    attachmentText = [NSString stringWithFormat:@"%@%@", attachmentText, [self getAttachmentPictureHTML:item]];
  }
  if (item.linkText) {
    attachmentText = [NSString stringWithFormat:@"%@<div class=\"tableSubText\">%@</div>", attachmentText, [Etc xmlEscape:item.linkText]];
  }
  return attachmentText;
}

+ (NSString*) getMetaHTML:(Post*)item {
  NSString* metaText = [super getMetaHTML:item];
  metaText = [NSString stringWithFormat:@"<div class=\"tableMetaText\">%@", metaText];
  if (item.commentCount) {
    metaText = [NSString stringWithFormat:@"%@, %@", metaText,
                   [[self class] textForCount:[item.commentCount intValue] withSingular:@"comment" andPlural:@"comments"]];
  }
  if (item.likes) {
    metaText = [NSString stringWithFormat:@"%@, %@", metaText,
                               [[self class] textForCount:[item.likes intValue] withSingular:@"like" andPlural:@"likes"]];
  }
  return [NSString stringWithFormat:@"%@</div>", metaText];
}

+ (void) setMessageHTML:(Post*)item {
  if (item.html == nil) {
    NSString* messageText = [self getAvatarHTML:item.fromAvatar feedId:item.fromId];
    messageText = [NSString stringWithFormat:@"%@<div class=\"tableMessageContent\">%@", messageText, [self getNameHTML:item.fromName feedId:item.fromId]];
    if (item.toName && ![item.toId isEqualToString:item.fromId]) {
      messageText = [NSString stringWithFormat:@"%@ &gt; %@", messageText, [self getNameHTML:item.toName feedId:item.toId]];
    }
    if (item.message) {
      messageText = [NSString stringWithFormat:@"%@ <span class=\"tableText\">%@</span>", messageText, [Etc xmlEscape:item.message]];
    }
    messageText = [NSString stringWithFormat:@"%@<div class=\"tableAttachmentText\">%@</div>", messageText, [self getAttachmentHTML:item]];
    messageText = [NSString stringWithFormat:@"%@%@</div>", messageText, [self getMetaHTML:item]];

    item.html = messageText;
  }
}

@end
