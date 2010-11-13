//
//  FeedPostCell.m
//  MobileSharer
//
//  Created by PEZ on 2010-10-30.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "LinkPostCell.h"

static const CGFloat    kPictureImageHeight  = 55;
static const CGFloat    kPictureImageWidth  = 80;

@implementation LinkPostCell
@synthesize linkTextLabel = _linkTextLabel;


+ (TTStyledTextLabel*)createStyledLabel {
  TTStyledTextLabel* label = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
  label.textColor = TTSTYLEVAR(tableSubTextColor);
  label.highlightedTextColor = [UIColor whiteColor];
  label.font = TTSTYLEVAR(tableFont);
  label.contentMode = UIViewContentModeLeft;
  return label;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
  if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
    _linkTextLabel = [[self class] createStyledLabel];
    [self.contentView addSubview:_linkTextLabel];
  }
  
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_linkTextLabel);

  [super dealloc];
}

+ (NSString *) getLinkHTML:(Post*)item  {
  NSString* linkText = @"";
  if (item.linkTitle) {
    linkText = [NSString stringWithFormat:@"%@<div class=\"tableTitleText\">%@</div>", linkText, item.linkTitle];
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


#pragma mark -
#pragma mark TTTableViewCell class public

+ (CGFloat)tableView:(UITableView *)tableView heightForMoreBody:(Post *)item {
  TTStyledTextLabel* label = [self createStyledLabel];
  CGFloat junk;
  CGFloat left = [self getLeft:&junk item:item];
  label.text = [TTStyledText textFromXHTML:[self getLinkHTML:item] lineBreaks:YES URLs:NO];

  label.frame = CGRectMake(left, 0, [self getTextWidth:left tableView:tableView item:item], 0);
  [label sizeToFit];
  CGFloat h = label.height;
  TT_RELEASE_SAFELY(label);
  return h;
}

#pragma mark -
#pragma mark UIView


- (CGFloat)layoutMoreBodyAtX:(CGFloat)x andY:(CGFloat)y withWidth:(CGFloat)w {
  _linkTextLabel.frame = CGRectMake(x, y, w, 0);
  [_linkTextLabel sizeToFit];
  return _linkTextLabel.bottom;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse {
  [super prepareForReuse];
  _linkTextLabel.text = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didMoveToSuperview {
  [super didMoveToSuperview];
  
  if (self.superview) {
    _linkTextLabel.backgroundColor = self.backgroundColor;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell

- (void)setObject:(id)object {
  if (_item != object) {
    [super setObject:object];
    
    Post* item = object;    
    _linkTextLabel.text = [TTStyledText textFromXHTML:[[self class] getLinkHTML:item] lineBreaks:YES URLs:NO];
  }
  [self setNeedsLayout];
}

#pragma mark -
#pragma mark Public

@end