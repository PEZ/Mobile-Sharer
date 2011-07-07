//
//  MessageCellBase.h
//  
//
//  Created by Peter Stromberg on 2011-07-03.
//  Copyright 2011 NA. All rights reserved.
//

static const CGFloat    kPictureImageHeight  = 66;
static const CGFloat    kPictureImageWidth  = 96;

@interface MessageCellBase : TTTableLinkedItemCell {
  TTStyledTextLabel* _messageLabel;
}

@property (nonatomic, readonly, retain) TTStyledTextLabel*  messageLabel;


+ (NSString*)textForCount:(int)count withSingular:(NSString*)singular andPlural:(NSString*)plural;
+ (CGFloat) getTextWidth:(UITableView*)tableView item:(StyledTableDataItem*)item;
+ (NSString*) getMetaHTML:(StyledTableDataItem*)item;
+ (NSString*) getLinkHTMLForText:(NSString*)text andURL:(NSString*)url;
+ (NSString*) getNameHTML:(NSString*)name feedId:(NSString*)feedId;
+ (void) setMessageHTML:(StyledTableDataItem*)item;
+ (NSString*) wrapMessageHTML:(NSString*)messageHTML item:(StyledTableDataItem*)item;
+ (NSString*) getAvatarHTML:(NSString*)avatar feedId:(NSString*)feedId;

@end
