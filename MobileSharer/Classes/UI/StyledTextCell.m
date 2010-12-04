//
//  StyledTextCell.m
//  MobileSharer
//
//  Created by PEZ on 2010-12-04.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "StyledTextCell.h"


@implementation StyledTextCell

- (void)dealloc {
  TT_RELEASE_SAFELY(_messageLabel);
  [super dealloc];
}

+ (NSString*) getLinkHTMLForText:(NSString*)text andURL:(NSString*)url {
  return [NSString stringWithFormat:@"<a href=\"%@\">%@</a>", [Etc xmlEscape:url], [Etc xmlEscape:text]];
}

+ (NSString*) getNameHTML:(NSString*)name feedId:(NSString*)feedId {
  return [NSString stringWithFormat:@"<span class=\"tableTitleText\">%@</span>",
          [self getLinkHTMLForText:name andURL:[Etc toFeedURLPath:feedId name:name]]];
}

+ (NSString*)textForCount:(int)count withSingular:(NSString*)singular andPlural:(NSString*)plural {
  return [NSString stringWithFormat:@"%d %@", count, count == 1 ? singular : plural];
}

+ (TTStyledTextLabel*)createStyledLabel {
  TTStyledTextLabel* label = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
  label.textColor = TTSTYLEVAR(tableTextColor);
  label.highlightedTextColor = [UIColor whiteColor];
  label.font = TTSTYLEVAR(tableFont);
  label.contentMode = UIViewContentModeLeft;
  return label;  
}

+ (CGFloat) getTextWidth:(CGFloat)left tableView:(UITableView*)tableView item:(StyledTableDataItem*)item  {
  CGFloat textWidth = tableView.width - left - kTableCellSmallMargin;
  return textWidth;
}

+ (void) setMessageHTML:(Post*)item {
}

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
  Post* item = object;
  [self setMessageHTML:item];
  item.styledText.width = [self getTextWidth:kTableCellSmallMargin tableView:tableView item:item];
  return kTableCellSmallMargin + MAX(kAvatarImageHeight, item.styledText.height) + kTableCellSmallMargin;
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
