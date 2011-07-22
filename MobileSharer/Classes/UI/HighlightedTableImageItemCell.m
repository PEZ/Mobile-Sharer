//
//  SpecialTableImageItem.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-07-17.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "HighlightedTableImageItemCell.h"
#import "DefaultStyleSheet.h"

@implementation HighlightedTableImageItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
  if ((self = [super initWithStyle:style reuseIdentifier:identifier])) {
    self.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    self.backgroundView.backgroundColor = TTSTYLEVAR(highlightedColor);
    self.textLabel.backgroundColor = TTSTYLEVAR(highlightedColor);
  }
  return self;
}

@end
