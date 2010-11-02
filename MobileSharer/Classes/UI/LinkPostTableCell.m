//
//  FeedPostCell.m
//  MobileSharer
//
//  Created by PEZ on 2010-10-30.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "LinkPostTableCell.h"

static const CGFloat    kPictureImageHeight  = 50;

@implementation LinkPostTableCell


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

- (void)dealloc {
  TT_RELEASE_SAFELY(_linkTextLabel);

  [super dealloc];
}

+ (TTStyledTextLabel*)createStyledLabel {
  TTStyledTextLabel* label = [[TTStyledTextLabel alloc] init];
  label.textColor = TTSTYLEVAR(tableSubTextColor);
  label.highlightedTextColor = [UIColor whiteColor];
  label.font = TTSTYLEVAR(tableFont);
  return label;
}

+ (NSString *) getLinkHTML:(FeedPostItem*)item  {
  NSString* linkText = @"";
  if (item.picture) {
    linkText = [NSString stringWithFormat:@"%@<img src=\"%@\"/>", linkText, item.picture];
  }
  if (item.linkTitle) {
    linkText = [NSString stringWithFormat:@"%@<span class=\"tableTitleText\">%@</span>", linkText, item.linkTitle];
  }
  if (item.linkText) {
    linkText = [NSString stringWithFormat:@"%@<span class=\"tableSubText\">%@</span>", linkText, item.linkText];
  }
  NSLog(@"+html: %@", linkText);
  return linkText;
}


#pragma mark -
#pragma mark TTTableViewCell class public

+ (CGFloat)tableView:(UITableView *)tableView heightForMoreBody:(FeedPostItem *)item {
  TTStyledTextLabel* label = [self createStyledLabel];
  CGFloat junk;
  CGFloat left = [self getLeft:&junk item:item];
  label.text = [TTStyledText textFromXHTML:[self getLinkHTML:item] lineBreaks:YES URLs:NO];
  NSLog(@"+height: %@", [TTStyledText textFromXHTML:[self getLinkHTML:item] lineBreaks:YES URLs:NO]);

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
  NSLog(@"-layout: %@", _linkTextLabel.text);
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
    
    FeedPostItem* item = object;
    NSString *linkText;
    linkText = [[self class] getLinkHTML: item];

    _linkTextLabel.text = [TTStyledText textFromXHTML:[[self class] getLinkHTML:item] lineBreaks:YES URLs:NO];
  }
}

#pragma mark -
#pragma mark Public

- (TTStyledTextLabel*)linkTextLabel {
  if (!_linkTextLabel) {
    _linkTextLabel = [[self class] createStyledLabel];
  }
  return _linkTextLabel;
}

@end