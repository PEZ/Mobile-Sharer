//
//  MessageCellBase.m
//  
//
//  Created by Peter Stromberg on 2011-07-03.
//  Copyright 2011 NA. All rights reserved.
//

#import "MessageCellBase.h"
#import "StyledTableDataItem.h"
#import "StyledTableIconDataItem.h"

#import "DefaultStyleSheet.h"


@implementation MessageCellBase

- (void)dealloc {
  TT_RELEASE_SAFELY(_messageLabel);
  [super dealloc];
}

+ (NSString*) getNameHTML:(NSString*)name feedId:(NSString*)feedId {
  return [NSString stringWithFormat:@"<span class=\"tableTitleText\">%@</span>",
          [self getLinkHTMLForText:name andURL:[Etc toFeedURLPath:feedId name:name]]];
}

+ (NSString*)textForCount:(int)count withSingular:(NSString*)singular andPlural:(NSString*)plural {
  return [NSString stringWithFormat:@"%d %@", count, count == 1 ? singular : plural];
}

+ (NSString*) getLinkHTMLForText:(NSString*)text andURL:(NSString*)url {
  return [NSString stringWithFormat:@"<a href=\"%@\">%@</a>", [Etc xmlEscape:url], [Etc xmlEscape:text]];
}

+ (NSString*) getAvatarHTML:(NSString*)avatar feedId:(NSString*)feedId {
  return [NSString stringWithFormat:@"<img class=\"feedAvatar\" width=\"%f\" height=\"%f\" src=\"%@\" />",
          kAvatarImageWidth, kAvatarImageHeight, avatar];
}

+ (NSString*) getMetaHTML:(StyledTableDataItem*)item {
  NSString* metaText = @"";
  if ([item isKindOfClass:[StyledTableIconDataItem class]]) {
    StyledTableIconDataItem* icon_item = (StyledTableIconDataItem*)item;
    if (icon_item.icon != nil) {
      metaText = [NSString stringWithFormat:@"%@<img class=\"tableMetaIcon\" width=\"16\" height=\"16\" src=\"%@\" />",
                  metaText, [Etc xmlEscape:icon_item.icon]];
    }
  }
  return [NSString stringWithFormat:@"%@%@", metaText, [item.created formatRelativeTime]];
}

+ (void) setMessageHTML:(StyledTableDataItem*)item {
  if (item.html == nil) {
    NSString* messageText = [self getAvatarHTML:item.fromAvatar feedId:item.fromId];
    messageText = [NSString stringWithFormat:@"%@<div class=\"tableMessageContent\">", messageText];
    if (item.message) {
      messageText = [NSString stringWithFormat:@"%@<span class=\"tableText\">%@</span>", messageText, [Etc xmlEscape:item.message]];
    }
    messageText = [NSString stringWithFormat:@"%@%@</div>", messageText, [self getMetaHTML:item]];
    
    item.html = messageText;
  }
}


+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
  StyledTableDataItem* item = object;
  [self setMessageHTML:item];
  item.styledText.width = [self getTextWidth:kTableCellSmallMargin tableView:tableView item:item];
  return kTableCellSmallMargin + MAX(kAvatarImageHeight, item.styledText.height) + kTableCellSmallMargin;
}


+ (TTStyledTextLabel*)createStyledLabel {
  TTStyledTextLabel* label = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
  label.textColor = TTSTYLEVAR(tableTextColor);
  label.highlightedTextColor = [UIColor whiteColor];
  label.font = TTSTYLEVAR(tableFont);
  label.contentMode = UIViewContentModeLeft;
  return label;  
}

+ (CGFloat) getTextWidth:(CGFloat)left tableView:(UITableView *)tableView item:(Post *)item {
  CGFloat textWidth = tableView.width - left - kTableCellSmallMargin;
  if (item.URL) {
    textWidth -= kDiscloureWidth;
  }
  return textWidth;
}

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
    [[self class] setMessageHTML:(StyledTableDataItem*)_item];
    self.messageLabel.text = ((StyledTableDataItem*)_item).styledText;
  }
}

@end
