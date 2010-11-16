//
//  PostTableCell.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-01.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

@synthesize imageView2 = _imageView2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
  if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
    _imageView2 = [[TTImageView alloc] init];
    [self.contentView addSubview:_imageView2];
    
    self.textLabel.font = TTSTYLEVAR(tableFont);
    self.textLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
    self.textLabel.textAlignment = UITextAlignmentLeft;
    self.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.textLabel.adjustsFontSizeToFitWidth = NO;    
  }
  
  return self;
}

+ (NSString*)textForCount:(int)count withSingular:(NSString*)singular andPlural:(NSString*)plural {
  return [NSString stringWithFormat:@"%d %@", count, count == 1 ? singular : plural];
}

#pragma mark -
#pragma mark TTTableViewCell class public

+ (CGFloat)heightForText:(NSString*)_text withFont:(UIFont*)_font andWidth:(CGFloat)_width {
  return [_text sizeWithFont:_font
           constrainedToSize:CGSizeMake(_width, CGFLOAT_MAX)
               lineBreakMode:UILineBreakModeWordWrap].height;
}

+ (CGFloat)tableView:(UITableView *)tableView heightForMoreBody:(Post *)item {
  return 0;
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

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
  Post* item = object;
  
  CGFloat imageHeight;
  CGFloat left = [self getLeft:&imageHeight item:item];
  
  CGFloat textWidth = [self getTextWidth:left tableView:tableView item:item];
  
  CGFloat textHeight = TTSTYLEVAR(tableTitleFont).ttLineHeight + TTSTYLEVAR(tableFont).ttLineHeight + kTableCellSmallMargin;
  if (item.message) {
    textHeight += [self heightForText:item.message withFont:TTSTYLEVAR(tableFont) andWidth:textWidth];
  }
  
  return MAX(imageHeight + 25, textHeight + [self tableView:tableView heightForMoreBody:item]) + kTableCellSmallMargin * 2;
}

#pragma mark -
#pragma mark UIView

- (void)prepareForReuse {
  [super prepareForReuse];
  [_imageView2 unsetImage];
  self.textLabel.text = nil;
  _titleLabel.text = nil;
  _timestampLabel.text = nil;
  [_iconImageView unsetImage];
  _countsLabel.text = nil;
}

- (CGFloat)layoutMoreBodyForItem:(Post *)item andX:(CGFloat)x andY:(CGFloat)y withWidth:(CGFloat)w {
  return y;
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
  
  _titleLabel.frame = CGRectMake(left, top, width, _titleLabel.font.ttLineHeight);
  top += _titleLabel.height;
  
  self.textLabel.frame = CGRectMake(left, top, width, 0);
  if (self.textLabel.text) {
    self.textLabel.numberOfLines = 0;
    [self.textLabel sizeToFit];
  }
  
  if (_timestampLabel.text.length) {
    _timestampLabel.alpha = !self.showingDeleteConfirmation;
    [_timestampLabel sizeToFit];
    _timestampLabel.left = [UIScreen mainScreen].bounds.size.width - (_timestampLabel.width + kTableCellSmallMargin);
    _timestampLabel.top = _titleLabel.top;
    _titleLabel.width -= _timestampLabel.width + kTableCellSmallMargin*2;
  } else {
    _timestampLabel.frame = CGRectZero;
  }
  
  CGFloat y = [self layoutMoreBodyForItem:item andX:left andY:self.textLabel.bottom withWidth:width];
  
  if (_countsLabel.text.length) {
    [_countsLabel sizeToFit];
    _countsLabel.left = left;
    _countsLabel.top = y + kTableCellSmallMargin;
  }
  
  if (item.icon) {
    _iconImageView.frame = CGRectMake(_countsLabel.left - _iconImageView.width - kTableCellSmallMargin,
                                      _countsLabel.bottom - 16, 15, 16);
  }
}

- (void)didMoveToSuperview {
  [super didMoveToSuperview];
  
  if (self.superview) {
    self.textLabel.backgroundColor = self.backgroundColor;
    _imageView2.backgroundColor = self.backgroundColor;
    _titleLabel.backgroundColor = self.backgroundColor;
    _timestampLabel.backgroundColor = self.backgroundColor;
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
    if (item.fromName) {
      self.titleLabel.text = item.fromName;
    }
    if (item.message) {
      self.textLabel.text = item.message;
    }
    if (item.created) {
      self.timestampLabel.text = [item.created formatRelativeTime];
    }
    self.imageView2.defaultImage = TTIMAGE(@"bundle://Three20.bundle/images/photoDefault.png");
    if (item.fromAvatar) {
      self.imageView2.urlPath = item.fromAvatar;
    }
    //self.imageView2.style = TTSTYLE(avatar);
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
    _countsLabel.textColor = TTSTYLEVAR(tableSubTextColor);
    _countsLabel.highlightedTextColor = [UIColor whiteColor];
    _countsLabel.font = TTSTYLEVAR(tableFont);
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


///////////////////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////////////////
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
