//
//  CommentCell.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-09.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

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
#import "Three20UI/TTTableImageItemCell.h"
#import "Comment.h"

@interface CommentCell : TTTableImageItemCell {
  UILabel*      _titleLabel;
  UILabel*      _timestampLabel;
}

@property (nonatomic, readonly, retain) UILabel*      titleLabel;
@property (nonatomic, readonly, retain) UILabel*      timestampLabel;

+ (CGFloat)heightForText:(NSString*)_text withFont:(UIFont*)_font andWidth:(CGFloat)_width;
+ (CGFloat) getTextWidth:(CGFloat)left tableView:(UITableView*)tableView;

@end
