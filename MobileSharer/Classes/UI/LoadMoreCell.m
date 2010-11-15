//
//  LoadMoreCell.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-15.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "Cells.h"

#import "LoadMoreCell.h"

#import "Three20UI/TTTableMoreButtonCell.h"

// UI
#import "Three20UI/TTTableMoreButton.h"
#import "Three20UI/UIViewAdditions.h"

// UICommon
#import "Three20UICommon/TTGlobalUICommon.h"

@implementation LoadMoreCell

#pragma mark -
#pragma mark TTTableViewCell class public

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
  CGFloat height = [super tableView:tableView rowHeightForObject:object];
  CGFloat minHeight = TT_ROW_HEIGHT;
  return 30;
  if (height < minHeight) {
    return minHeight;
    
  } else {
    return height;
  }
}


#pragma mark -
#pragma mark UIView

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGFloat margin = kDefaultMessageImageWidth + kTableCellSmallMargin + kTableCellSmallMargin;
  _activityIndicatorView.left = margin - (_activityIndicatorView.width + kTableCellSmallMargin);
  _activityIndicatorView.top = floor(self.contentView.height/2 - _activityIndicatorView.height/2);
  
  self.textLabel.frame = CGRectMake(margin, self.textLabel.top,
                                    self.contentView.width - (margin + kTableCellSmallMargin),
                                    self.textLabel.height);
  self.detailTextLabel.frame = CGRectMake(margin, self.detailTextLabel.top,
                                          self.contentView.width - (margin + kTableCellSmallMargin),
                                          self.detailTextLabel.height);
  
}

@end
