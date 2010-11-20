//
//  PostTableCell.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-01.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PostCellBase.h"

static TTStyledTextLabel* _measureLabel;

@implementation PostCellBase

@synthesize imageView2 = _imageView2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
  if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
    _imageView2 = [[TTImageView alloc] init];
    [self.contentView addSubview:_imageView2];
  }
  return self;
}

+ (NSString*)textForCount:(int)count withSingular:(NSString*)singular andPlural:(NSString*)plural {
  return [NSString stringWithFormat:@"%d %@", count, count == 1 ? singular : plural];
}

#pragma mark -
#pragma mark TTTableViewCell class public

+ (NSString*) getNameHTML:(NSString*)name feedId:(NSString*)feedId {
  return [NSString stringWithFormat:@"<span class=\"tableTitleText\"><a href=\"%@\">%@</a></span>",
          [Etcetera toFeedURLPath:feedId name:name], name];
}

+ (NSString*) getLinkTitleHTML:(Post*)item {
  //return [NSString stringWithFormat:@"%@<div class=\"tableTitleText\">%@</div>", linkText, item.linkTitle];
  //linkText = [NSString stringWithFormat:@"%@<div class=\"tableTitleText\"><a href=\"%@\">%@</a></div>", linkText, item.linkURL, item.linkTitle];
  return nil;
}

+ (NSString*) getLinkHTML:(Post*)item  {
  NSString* linkText = @"";
  if (item.linkTitle) {
    linkText = [NSString stringWithFormat:@"%@%@", linkText, [self getLinkTitleHTML:item]];
  }
  if (item.linkCaption) {
    linkText = [NSString stringWithFormat:@"%@<div class=\"tableSubText\">%@</div>", linkText, item.linkCaption];
  }
  if (item.picture) {
    linkText = [NSString stringWithFormat:@"%@<img class=\"tablePostImage\" width=\"%f\" height=\"%f\" src=\"%@\" />", linkText, kPictureImageWidth,
                kPictureImageHeight, item.picture];
  }
  if (item.linkText) {
    linkText = [NSString stringWithFormat:@"%@<div class=\"tableSubText\">%@</div>", linkText, item.linkText];
  }
  return [linkText stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
}

+ (NSString*) getMessageHTML:(Post*)item  {
  NSString* messageText = @"";
  messageText = [NSString stringWithFormat:@"%@%@", messageText, [self getNameHTML:item.fromName feedId:item.fromId]];
  if (item.toName && ![item.toId isEqualToString:item.fromId]) {
    messageText = [NSString stringWithFormat:@"%@ &gt; %@", messageText, [self getNameHTML:item.toName feedId:item.toId]];
  }
  if (item.message) {
    messageText = [NSString stringWithFormat:@"%@ <span class=\"tableText\">%@</span>", messageText, item.message];
  }
  messageText = [NSString stringWithFormat:@"%@%@", messageText, [self getLinkHTML:item]];
  return messageText;
}

+ (CGFloat) getTextWidth:(CGFloat)left tableView:(UITableView*)tableView item:(Post*)item  {
  CGFloat textWidth = tableView.width - left - kTableCellSmallMargin;
  if (item.URL) {
    textWidth -= kDiscloureWidth;
  }
  return textWidth;
}

+ (CGFloat) getLeft:(CGFloat*)imageHeight_p item:(Post*)item {
  CGFloat left = kTableCellSmallMargin;
  *imageHeight_p = 0;
  if (item.fromAvatar) {
    left += kDefaultMessageImageWidth + kTableCellSmallMargin;
    *imageHeight_p = kDefaultMessageImageHeight;
  }
  return left;
}

+ (TTStyledTextLabel*)createStyledLabel {
  TTStyledTextLabel* label = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
  label.textColor = TTSTYLEVAR(tableTextColor);
  label.highlightedTextColor = [UIColor whiteColor];
  label.font = TTSTYLEVAR(tableFont);
  label.contentMode = UIViewContentModeLeft;
  return label;  
}

+ (CGFloat)tableView:(UITableView*)tableView styledHeight:(Post*)item {
  if (!_measureLabel) {
    _measureLabel = [[self class] createStyledLabel];
  }  
  CGFloat junk;
  CGFloat left = [self getLeft:&junk item:item];
  _measureLabel.text = [TTStyledText textFromXHTML:[self getMessageHTML:item] lineBreaks:YES URLs:NO];
  _measureLabel.frame = CGRectMake(left, 0, [self getTextWidth:left tableView:tableView item:item], 0);
  [_measureLabel sizeToFit];

  return _measureLabel.height;
}

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
  Post* item = object;
  
  CGFloat imageHeight;

  CGFloat messageHeight = [self tableView:tableView styledHeight:item] + kTableCellSmallMargin;
  
  CGFloat countsHeight = TTSTYLEVAR(tableTimestampFont).ttLineHeight + kTableCellSmallMargin;
  
  return kTableCellSmallMargin + MAX(imageHeight + 25, messageHeight) + countsHeight;
}

#pragma mark -
#pragma mark UIView

- (void)prepareForReuse {
  [super prepareForReuse];
  [_imageView2 unsetImage];
  self.textLabel.text = nil;
  _messageLabel.text = nil;
  [_iconImageView unsetImage];
  _countsLabel.text = nil;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  Post* item = self.object;
  
  CGFloat left = 0;
  if (item.fromAvatar) {
    CGFloat avatarWidth = item.fromAvatar ? kDefaultMessageImageWidth : 0;
    CGFloat avatarHeight = item.fromAvatar ? kDefaultMessageImageHeight : 0;
    
    _imageView2.frame = CGRectMake(kTableCellSmallMargin, kTableCellSmallMargin,
                                   avatarWidth, avatarHeight);
    left += kTableCellSmallMargin + avatarWidth + kTableCellSmallMargin;
  } else {
    _imageView2.frame = CGRectZero;
    left = kTableCellMargin;
  }
  
  CGFloat width = self.contentView.width - left - kTableCellSmallMargin;
  CGFloat top = kTableCellSmallMargin;
  
  _messageLabel.frame = CGRectMake(left, top, width, 0);
  _messageLabel.text = [TTStyledText textFromXHTML:[[self class] getMessageHTML:item]];
  [_messageLabel sizeToFit];
  
  top = _messageLabel.bottom;
    
  if (_countsLabel.text.length) {
    [_countsLabel sizeToFit];
    _countsLabel.left = left;
    _countsLabel.top = top + kTableCellSmallMargin;
  }
  
  if (item.icon) {
    _iconImageView.frame = CGRectMake(_countsLabel.left - _iconImageView.width - kTableCellSmallMargin,
                                      _countsLabel.bottom - 16, 15, 16);
  }
}

- (void)didMoveToSuperview {
  [super didMoveToSuperview];
  
  if (self.superview) {
    _imageView2.backgroundColor = self.backgroundColor;
    _messageLabel.backgroundColor = self.backgroundColor;
    _countsLabel.backgroundColor = self.backgroundColor;
    _iconImageView.backgroundColor = self.backgroundColor;
  }
}

#pragma mark -
#pragma mark TTTableViewCell

- (void)setObject:(id)object {
  if (_item != object) {
    [super setObject:object];

    Post* item = object;

    self.messageLabel.text = [TTStyledText textFromXHTML:[[self class] getMessageHTML:item] lineBreaks:YES URLs:NO];

    self.imageView2.defaultImage = TTIMAGE(@"bundle://Three20.bundle/images/photoDefault.png");
    if (item.fromAvatar) {
      self.imageView2.urlPath = item.fromAvatar;
    }
    if (item.commentCount) {
      self.countsLabel.text = [[self class] textForCount:[item.commentCount intValue] withSingular:@"comment" andPlural:@"comments"];
    }
    if (item.likes) {
      if (self.countsLabel.text.length) {
        self.countsLabel.text = [NSString stringWithFormat:@"%@, %@", self.countsLabel.text,
                                 [[self class] textForCount:[item.likes intValue] withSingular:@"like" andPlural:@"likes"]];
      }
      else {
        self.countsLabel.text = [[self class] textForCount:[item.likes intValue] withSingular:@"like" andPlural:@"likes"];
      }
    }
    if (!item.commentCount && !item.likes) {
      self.countsLabel.text = @"No comments yet";
    }
    self.countsLabel.text = [NSString stringWithFormat:@"%@, %@", [item.created formatRelativeTime], self.countsLabel.text];
    if (item.icon) {
      self.iconImageView.urlPath = item.icon;
    }
  }
}

#pragma mark -
#pragma mark Public

- (UILabel*)countsLabel {
  if (!_countsLabel) {
    _countsLabel = [[UILabel alloc] init];
    _countsLabel.textColor = TTSTYLEVAR(timestampTextColor);
    _countsLabel.highlightedTextColor = [UIColor whiteColor];
    _countsLabel.font = TTSTYLEVAR(tableTimestampFont);
    _countsLabel.contentMode = UIViewContentModeLeft;
    [self.contentView addSubview:_countsLabel];
  }
  return _countsLabel;
}

- (TTImageView*)iconImageView {
  if (!_iconImageView) {
    _iconImageView = [[TTImageView alloc] init];
    [self.contentView addSubview:_iconImageView];
  }
  return _iconImageView;
}

- (TTStyledTextLabel*)messageLabel {
  if (!_messageLabel) {
    _messageLabel = [[self class] createStyledLabel];
    [self.contentView addSubview:_messageLabel];
    return _messageLabel;
  }
  else {
    return _messageLabel;
  }

}

@end
