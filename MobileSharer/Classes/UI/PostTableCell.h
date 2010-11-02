//
//  PostTableCell.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-01.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

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

#import "FeedPostItem.h"
#import "Three20UI/TTTableImageItemCell.h"

static const CGFloat    kDiscloureWidth   = 20;
static const CGFloat    kDefaultMessageImageWidth   = 34;
static const CGFloat    kDefaultMessageImageHeight  = 34;
static const CGFloat    kIconImageWidth   = 15;
static const CGFloat    kIconImageHeight  = 16;

@interface PostTableCell : TTTableImageItemCell {
  UILabel*      _titleLabel;
  UILabel*      _timestampLabel;
  TTImageView*  _iconImageView;
  UILabel*      _countsLabel;
}

@property (nonatomic, readonly, retain) UILabel*      titleLabel;
@property (nonatomic, readonly, retain) UILabel*      timestampLabel;
@property (nonatomic, readonly, retain) TTImageView*  iconImageView;
@property (nonatomic, readonly, retain) UILabel*      countsLabel;

+ (NSString*)textForCount:(int)count withSingular:(NSString*)singular andPlural:(NSString*)plural;
+ (CGFloat)tableView:(UITableView *)tableView heightForMoreBody:(FeedPostItem *)item;
+ (CGFloat)getLeft:(CGFloat*)imageHeight_p item:(FeedPostItem*)item;
+ (CGFloat) getTextWidth:(CGFloat)left tableView:(UITableView*)tableView item:(FeedPostItem*)item;

- (CGFloat)layoutMoreBodyAtX:(CGFloat)x andY:(CGFloat)y withWidth:(CGFloat)w;

@end
