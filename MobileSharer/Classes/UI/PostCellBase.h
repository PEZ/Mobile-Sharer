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
#import "Three20UI/TTTableImageItemCell.h"

static const CGFloat    kDiscloureWidth   = 20;
static const CGFloat    kPictureImageHeight  = 66;
static const CGFloat    kPictureImageWidth  = 96;

@interface PostCellBase : TTTableLinkedItemCell {
  TTStyledTextLabel* _messageLabel;
}

@property (nonatomic, readonly, retain) TTStyledTextLabel*  messageLabel;

+ (NSString*)textForCount:(int)count withSingular:(NSString*)singular andPlural:(NSString*)plural;
+ (CGFloat) getTextWidth:(CGFloat)left tableView:(UITableView*)tableView item:(Post*)item;

@end

