//
//  SpecialTableImageItem.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-07-17.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "SpecialTableImageItemCell.h"
#import "DefaultStyleSheet.h"

@implementation SpecialTableImageItemCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
  if ((self = [super initWithStyle:style reuseIdentifier:identifier])) {
    self.contentView.backgroundColor = TTSTYLEVAR(notificationColor);
    self.textLabel.backgroundColor = TTSTYLEVAR(notificationColor);
  }
  return self;
}

@end
