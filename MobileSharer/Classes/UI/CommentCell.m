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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
  if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
    _imageView2 = [[TTImageView alloc] init];
    [self.contentView addSubview:_imageView2];
    
    self.textLabel.font = TTSTYLEVAR(tableFont);
    self.textLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
    self.textLabel.textAlignment = UITextAlignmentLeft;
    self.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.textLabel.adjustsFontSizeToFitWidth = NO;
    
    self.contentView.backgroundColor = TTSTYLEVAR(lightColor);
  }
  
  return self;
}

#pragma mark -
#pragma mark TTTableViewCell class public

+ (CGFloat)heightForText:(NSString*)_text withFont:(UIFont*)_font andWidth:(CGFloat)_width {
  return [_text sizeWithFont:_font
           constrainedToSize:CGSizeMake(_width, CGFLOAT_MAX)
               lineBreakMode:UILineBreakModeWordWrap].height;
}

+ (CGFloat) getTextWidth:(CGFloat)left tableView:(UITableView*)tableView  {
  return tableView.width - left - kTableCellSmallMargin;
}

+ (CGFloat) getLeft {
  return kTableCellSmallMargin + kDefaultMessageImageWidth + kTableCellSmallMargin;
}

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
  Comment* item = object;
  
  CGFloat left = [self getLeft];
  
  CGFloat textWidth = [self getTextWidth:left tableView:tableView];
  
  CGFloat textHeight = TTSTYLEVAR(tableTitleFont).ttLineHeight + kTableCellSmallMargin +
    [self heightForText:item.message withFont:TTSTYLEVAR(tableFont) andWidth:textWidth];
  
  return MAX(kDefaultMessageImageHeight, textHeight) + kTableCellSmallMargin * 2;
}

#pragma mark -
#pragma mark UIView

- (void)prepareForReuse {
  [super prepareForReuse];
  [_imageView2 unsetImage];
  self.textLabel.text = nil;
  _titleLabel.text = nil;
  _timestampLabel.text = nil;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _imageView2.backgroundColor = TTSTYLEVAR(lightColor);
  _titleLabel.backgroundColor = TTSTYLEVAR(lightColor);
  _timestampLabel.backgroundColor = TTSTYLEVAR(lightColor);
  self.textLabel.backgroundColor = TTSTYLEVAR(lightColor);
  
  CGFloat left = 0;
  _imageView2.frame = CGRectMake(kTableCellSmallMargin, kTableCellSmallMargin,
                                 kDefaultMessageImageWidth, kDefaultMessageImageHeight);
  left += kTableCellSmallMargin + kDefaultMessageImageWidth + kTableCellSmallMargin;
  
  CGFloat width = self.contentView.width - left - kTableCellSmallMargin;
  CGFloat top = kTableCellSmallMargin;
  
  _titleLabel.frame = CGRectMake(left, top, width, _titleLabel.font.ttLineHeight);
  top += _titleLabel.height;
  
  self.textLabel.frame = CGRectMake(left, top, width, 0);
  self.textLabel.numberOfLines = 0;
  [self.textLabel sizeToFit];
  
  _timestampLabel.alpha = !self.showingDeleteConfirmation;
  [_timestampLabel sizeToFit];
  _timestampLabel.left = self.contentView.width - (_timestampLabel.width + kTableCellSmallMargin);
  _timestampLabel.top = _titleLabel.top;

  _titleLabel.width -= _timestampLabel.width + kTableCellSmallMargin*2;
}

- (void)didMoveToSuperview {
  [super didMoveToSuperview];
  
  if (self.superview) {
    self.textLabel.backgroundColor = self.backgroundColor;
    _imageView2.backgroundColor = self.backgroundColor;
    _titleLabel.backgroundColor = self.backgroundColor;
    _timestampLabel.backgroundColor = self.backgroundColor;
  }
}

#pragma mark -
#pragma mark TTTableViewCell

- (void)setObject:(id)object {
  if (_item != object) {
    [super setObject:object];
    
    Comment* item = object;
    self.titleLabel.text = item.fromName;
    self.textLabel.text = item.message;
    self.timestampLabel.text = [item.created formatRelativeTime];
    self.imageView2.urlPath = item.fromAvatar;
    self.imageView2.defaultImage = TTIMAGE(@"bundle://Three20.bundle/images/photoDefault.png");
  }
}

#pragma mark -
#pragma mark Public

- (UILabel*)titleLabel {
  if (!_titleLabel) {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = TTSTYLEVAR(tableTitleTextColor);
    _titleLabel.highlightedTextColor = [UIColor whiteColor];
    _titleLabel.font = TTSTYLEVAR(tableTitleFont);
    _titleLabel.contentMode = UIViewContentModeLeft;
    [self.contentView addSubview:_titleLabel];
  }
  return _titleLabel;
}

- (UILabel*)timestampLabel {
  if (!_timestampLabel) {
    _timestampLabel = [[UILabel alloc] init];
    _timestampLabel.font = TTSTYLEVAR(tableTimestampFont);
    _timestampLabel.textColor = TTSTYLEVAR(timestampTextColor);
    _timestampLabel.textAlignment = UITextAlignmentRight;
    _timestampLabel.highlightedTextColor = [UIColor whiteColor];
    _timestampLabel.contentMode = UIViewContentModeRight;
    [self.contentView addSubview:_timestampLabel];
  }
  return _timestampLabel;
}

@end