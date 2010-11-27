//
//  PostTableCell.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-01.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PostCellBase.h"

@implementation PostCellBase

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
  if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
  }
  return self;
}

+ (NSString*)textForCount:(int)count withSingular:(NSString*)singular andPlural:(NSString*)plural {
  return [NSString stringWithFormat:@"%d %@", count, count == 1 ? singular : plural];
}

#pragma mark -
#pragma mark TTTableViewCell class public

+ (NSString*) getLinkHTMLForText:(NSString*)text andURL:(NSString*)url {
  return nil; //Not inplemented in base class
}

+ (NSString*) getAttachmentTitleHTML:(Post*)item {
  return nil; //Not inplemented in base class
}

+ (NSString*) getAttachmentPictureHTML:(Post*)item {
  return nil; //Not implemented in base class
}

+ (NSString*) getNameHTML:(NSString*)name feedId:(NSString*)feedId {
  return [NSString stringWithFormat:@"<span class=\"tableTitleText\">%@</span>",
          [self getLinkHTMLForText:name andURL:[Etc toFeedURLPath:feedId name:name]]];
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
    attachmentText = [NSString stringWithFormat:@"%@<span class=\"tableSubText\">%@</span>", attachmentText, [Etc xmlEscape:item.linkText]];
  }
  return attachmentText;
}

+ (NSString*) getMetaHTML:(Post*)item {
  NSString* metaText = @"";
  if (item.icon) {
    metaText = [NSString stringWithFormat:@"%@<img width=\"16\" height=\"16\" src=\"%@\" /> ",
                   metaText, [Etc xmlEscape:item.icon]];
  }
  metaText = [NSString stringWithFormat:@"%@%@", metaText, [item.created formatRelativeTime]];
  if (item.commentCount) {
    metaText = [NSString stringWithFormat:@"%@, %@", metaText,
                   [[self class] textForCount:[item.commentCount intValue] withSingular:@"comment" andPlural:@"comments"]];
  }
  if (item.likes) {
    metaText = [NSString stringWithFormat:@"%@, %@", metaText,
                               [[self class] textForCount:[item.likes intValue] withSingular:@"like" andPlural:@"likes"]];
  }
  return [NSString stringWithFormat:@"<div class=\"tableMetaText\">%@</div>", metaText];
}

+ (void) setMessageHTML:(Post*)item {
  if (item.html == nil) {
    NSString* messageText = @"";
    messageText = [NSString stringWithFormat:@"%@<img class=\"feedAvatar\" width=\"%f\" height=\"%f\" src=\"%@\" />",
                   messageText, kAvatarImageWidth, kAvatarImageHeight, [Etc xmlEscape:item.fromAvatar]];
    messageText = [NSString stringWithFormat:@"%@<div class=\"tableMessageContent\">%@", messageText, [self getNameHTML:item.fromName feedId:item.fromId]];
    if (item.toName && ![item.toId isEqualToString:item.fromId]) {
      messageText = [NSString stringWithFormat:@"%@ &gt; %@", messageText, [self getNameHTML:item.toName feedId:item.toId]];
    }
    if (item.message) {
      messageText = [NSString stringWithFormat:@"%@ <span class=\"tableText\">%@</span>", messageText, [Etc xmlEscape:item.message]];
    }
    messageText = [NSString stringWithFormat:@"%@<div class=\"tableAttachmentText\">%@</div>", messageText, [self getAttachmentHTML:item]];
    messageText = [NSString stringWithFormat:@"%@<br />%@</div>", messageText, [self getMetaHTML:item]];
    
    item.html = messageText;
  }
}

+ (CGFloat) getTextWidth:(CGFloat)left tableView:(UITableView*)tableView item:(Post*)item  {
  CGFloat textWidth = tableView.width - left - kTableCellSmallMargin;
  if (item.URL) {
    textWidth -= kDiscloureWidth;
  }
  return textWidth;
}

+ (TTStyledTextLabel*)createStyledLabel {
  TTStyledTextLabel* label = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
  label.textColor = TTSTYLEVAR(tableTextColor);
  label.highlightedTextColor = [UIColor whiteColor];
  label.font = TTSTYLEVAR(tableFont);
  label.contentMode = UIViewContentModeLeft;
  return label;  
}

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
  Post* item = object;
  [self setMessageHTML:item];
  item.styledText.width = [self getTextWidth:kTableCellSmallMargin tableView:tableView item:item];
  return kTableCellSmallMargin + MAX(kAvatarImageHeight, item.styledText.height) + kTableCellSmallMargin;
}

#pragma mark -
#pragma mark UIView

- (void)prepareForReuse {
  [super prepareForReuse];
  _messageLabel.text = nil;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGFloat width = self.contentView.width - kTableCellSmallMargin - kTableCellSmallMargin;  
  _messageLabel.frame = CGRectMake(kTableCellSmallMargin, kTableCellSmallMargin, width, 0);
  [_messageLabel sizeToFit];
}

- (void)didMoveToSuperview {
  [super didMoveToSuperview];
  
  if (self.superview) {
    _messageLabel.backgroundColor = self.backgroundColor;
  }
}

#pragma mark -
#pragma mark TTTableViewCell

- (void)setObject:(id)object {
  if (_item != object) {
    [super setObject:object];
    [[self class] setMessageHTML:(Post*)_item];
    //_messageLabel.text = ((Post*)_item).styledText;
    self.messageLabel.text = ((Post*)_item).styledText;
  }
}

#pragma mark -
#pragma mark Public

- (TTStyledTextLabel*)messageLabel {
  if (!_messageLabel) {
    _messageLabel = [[self class] createStyledLabel];
    _messageLabel.highlightedTextColor = TTSTYLEVAR(lightColor); //TODO: This doesn't do what I want it to do.
    [self.contentView addSubview:_messageLabel];
    return _messageLabel;
  }
  else {
    return _messageLabel;
  }
}

@end
