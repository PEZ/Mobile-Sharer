//
//  FeedPostCell.h
//  MobileSharer
//
//  Created by PEZ on 2010-10-30.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "Three20UI/TTTableLinkedItemCell.h"

@class TTImageView;

@interface FeedPostTableCell : TTTableImageItemCell {
  UILabel*      _titleLabel;
  UILabel*      _timestampLabel;
  TTImageView*  _iconImageView;
  UILabel*      _linkTextLabel;
  UILabel*      _countsLabel;
}

@property (nonatomic, readonly, retain) UILabel*      titleLabel;
@property (nonatomic, readonly, retain) UILabel*      timestampLabel;
@property (nonatomic, readonly, retain) TTImageView*  iconImageView;
@property (nonatomic, readonly, retain) UILabel*      linkTextLabel;
@property (nonatomic, readonly, retain) UILabel*      countsLabel;

@end


