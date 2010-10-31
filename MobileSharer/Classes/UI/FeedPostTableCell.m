//
//  FeedPostCell.m
//  MobileSharer
//
//  Created by PEZ on 2010-10-30.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "FeedPostTableCell.h"
#import "FeedPostItem.h"

// UI
#import "Three20UI/TTImageView.h"
#import "Three20UI/UIViewAdditions.h"
#import "Three20Style/UIFontAdditions.h"

// Style
#import "Three20Style/TTGlobalStyle.h"
#import "Three20Style/TTDefaultStyleSheet.h"

// Core
#import "Three20Core/TTCorePreprocessorMacros.h"
#import "Three20Core/NSDateAdditions.h"

static const CGFloat    kDiscloureWidth   = 20;
static const CGFloat    kDefaultMessageImageWidth   = 34;
static const CGFloat    kDefaultMessageImageHeight  = 34;

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation FeedPostTableCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
  if (self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier]) {
    self.textLabel.font = TTSTYLEVAR(tableFont);
    self.textLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
    self.textLabel.textAlignment = UITextAlignmentLeft;
    self.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.textLabel.adjustsFontSizeToFitWidth = NO;
  }
  
  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  TT_RELEASE_SAFELY(_titleLabel);
  TT_RELEASE_SAFELY(_timestampLabel);
  TT_RELEASE_SAFELY(_iconImageView);
  TT_RELEASE_SAFELY(_linkTextLabel);
  TT_RELEASE_SAFELY(_countsLabel);

  [super dealloc];
}

+ (NSString*)textForCount:(int)count withSingular:(NSString*)singular andPlural:(NSString*)plural {
  return [NSString stringWithFormat:@"%d %@", count, count == 1 ? singular : plural];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell class public

+ (CGFloat)heightForText:(NSString*)_text withFont:(UIFont*)_font andWidth:(CGFloat)_width {
  return [_text sizeWithFont:_font
           constrainedToSize:CGSizeMake(_width, CGFLOAT_MAX)
               lineBreakMode:UILineBreakModeWordWrap].height;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
  FeedPostItem* item = object;
  
  CGFloat left = kTableCellSmallMargin;
  CGFloat imageHeight = 0;
  if (item.imageURL) {
    left += kDefaultMessageImageWidth + kTableCellSmallMargin;
    imageHeight = kDefaultMessageImageHeight;
  }

  CGFloat textWidth = [UIScreen mainScreen].bounds.size.width - left - kTableCellSmallMargin;
  if (item.URL) {
    textWidth -= kDiscloureWidth;
  }
  
  CGFloat textHeight = TTSTYLEVAR(tableTitleFont).ttLineHeight + TTSTYLEVAR(tableFont).ttLineHeight + kTableCellSmallMargin;
  if (item.text.length) {
    textHeight += [self heightForText:item.text withFont:TTSTYLEVAR(tableFont) andWidth:textWidth];
  }
  
  return MAX(imageHeight + 26, textHeight) + kTableCellSmallMargin * 2;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse {
  [super prepareForReuse];
  [_imageView2 unsetImage];
  _titleLabel.text = nil;
  _timestampLabel.text = nil;
  [_iconImageView unsetImage];
  _linkTextLabel.text = nil;
  _countsLabel.text = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
  [super layoutSubviews];

  FeedPostItem* item = self.object;

  CGFloat left = 0;
  if (item.imageURL) {
    CGFloat iconWidth = item.imageURL ? kDefaultMessageImageWidth : 0;
    CGFloat iconHeight = item.imageURL ? kDefaultMessageImageHeight : 0;
    
    _imageView2.frame = CGRectMake(kTableCellSmallMargin, kTableCellSmallMargin,
                                   iconWidth, iconHeight);
    left += kTableCellSmallMargin + iconWidth + kTableCellSmallMargin;
  } else {
    _imageView2.frame = CGRectZero;
    left = kTableCellMargin;
  }
  
  CGFloat width = self.contentView.width - left - kTableCellSmallMargin;
  CGFloat top = kTableCellSmallMargin;
  
  _titleLabel.frame = CGRectMake(left, top, width, _titleLabel.font.ttLineHeight);
  top += _titleLabel.height;
    
  if (self.textLabel.text.length) {
    self.textLabel.frame = CGRectMake(left, top, width, 0);
    self.textLabel.numberOfLines = 0;
    [self.textLabel sizeToFit];
  } else {
    self.textLabel.frame = CGRectZero;
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

  if (_countsLabel.text.length) {
    [_countsLabel sizeToFit];
    _countsLabel.left = left;
    _countsLabel.top = self.textLabel.bottom + kTableCellSmallMargin;
  }

  if (item.icon) {
    _iconImageView.frame = CGRectMake(_countsLabel.left - _iconImageView.width - kTableCellSmallMargin,
                                      _countsLabel.bottom - 16, 15, 16);
    //_iconImageView.bottom = _countsLabel.bottom;
    //_iconImageView.left = _countsLabel.left - _iconImageView.width - kTableCellSmallMargin;
    //    _iconImageView.frame = CGRectMake(_imageView2.bottom + kTableCellSmallMargin, kTableCellSmallMargin, 0, 0);
    //[_iconImageView sizeToFit];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didMoveToSuperview {
  [super didMoveToSuperview];
  
  if (self.superview) {
    _imageView2.backgroundColor = self.backgroundColor;
    _titleLabel.backgroundColor = self.backgroundColor;
    _timestampLabel.backgroundColor = self.backgroundColor;
    _linkTextLabel.backgroundColor = self.backgroundColor;
    _countsLabel.backgroundColor = self.backgroundColor;
    _iconImageView.backgroundColor = self.backgroundColor;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
  if (_item != object) {
    [super setObject:object];
    
    FeedPostItem* item = object;
    if (item.title.length) {
      self.titleLabel.text = item.title;
    }
    if (item.text.length) {
      self.textLabel.text = item.text;
    }
    else {
      self.textLabel.text = @" ";
    }
    if (item.timestamp) {
      self.timestampLabel.text = [item.timestamp formatRelativeTime];
    }
    if (item.imageURL) {
      self.imageView2.urlPath = item.imageURL;
    }
    if (item.imageStyle) {
      self.imageView2.style = item.imageStyle;
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
    if (item.icon) {
      self.iconImageView.urlPath = item.icon;
    }
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public

- (UILabel*)linkTextLabel {
  if (!_linkTextLabel) {
    _linkTextLabel = [[UILabel alloc] init];
    _linkTextLabel.textColor = TTSTYLEVAR(tableTitleTextColor);
    _linkTextLabel.highlightedTextColor = [UIColor whiteColor];
    _linkTextLabel.font = TTSTYLEVAR(tableFont);
    _linkTextLabel.contentMode = UIViewContentModeLeft;
    [self.contentView addSubview:_linkTextLabel];
  }
  return _linkTextLabel;
}

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


///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTImageView*)imageView2 {
  if (!_imageView2) {
    _imageView2 = [[TTImageView alloc] init];
    //    _imageView2.defaultImage = TTSTYLEVAR(personImageSmall);
    //    _imageView2.style = TTSTYLE(threadActorIcon);
    [self.contentView addSubview:_imageView2];
  }
  return _imageView2;
}


@end