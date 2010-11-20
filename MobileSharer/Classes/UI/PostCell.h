//
//  PostTableCell.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-01.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

// UI
#import "Three20UI/UIViewAdditions.h"
#import "Three20Style/UIFontAdditions.h"

// Core
#import "Three20Core/NSDateAdditions.h"

#import "Post.h"
#import "Cells.h"
#import "Three20UI/TTTableImageItemCell.h"

static const CGFloat    kDiscloureWidth   = 20;
static const CGFloat    kIconImageWidth   = 16;
static const CGFloat    kIconImageHeight  = 16;
static const CGFloat    kPictureImageHeight  = 55;
static const CGFloat    kPictureImageWidth  = 80;

@interface PostCell : TTTableLinkedItemCell {
  TTStyledTextLabel* _messageLabel;
  TTImageView*  _iconImageView;
  TTImageView*  _imageView2;
  UILabel*      _countsLabel;
}

@property (nonatomic, readonly, retain) TTStyledTextLabel*  messageLabel;
@property (nonatomic, readonly, retain) TTImageView*        iconImageView;
@property (nonatomic, readonly, retain) TTImageView*        imageView2;
@property (nonatomic, readonly, retain) UILabel*            countsLabel;

+ (NSString*)textForCount:(int)count withSingular:(NSString*)singular andPlural:(NSString*)plural;
+ (CGFloat)getLeft:(CGFloat*)imageHeight_p item:(Post*)item;
+ (CGFloat) getTextWidth:(CGFloat)left tableView:(UITableView*)tableView item:(Post*)item;

@end
