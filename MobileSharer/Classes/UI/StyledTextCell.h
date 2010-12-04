//
//  StyledTextCell.h
//  MobileSharer
//
//  Created by PEZ on 2010-12-04.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "Three20UI/UIViewAdditions.h"
#import "Three20Core/NSDateAdditions.h"
#import "StyledTableDataItem.h"

@interface StyledTextCell : TTTableLinkedItemCell {
  TTStyledTextLabel* _messageLabel;
}

@property (nonatomic, readonly, retain) TTStyledTextLabel*  messageLabel;

+ (void) setMessageHTML:(StyledTableDataItem*)item;
+ (NSString*)textForCount:(int)count withSingular:(NSString*)singular andPlural:(NSString*)plural;
+ (CGFloat) getTextWidth:(CGFloat)left tableView:(UITableView*)tableView item:(StyledTableDataItem*)item;
+ (NSString*) getLinkHTMLForText:(NSString*)text andURL:(NSString*)url;
+ (NSString*) getNameHTML:(NSString*)name feedId:(NSString*)feedId;

@end
