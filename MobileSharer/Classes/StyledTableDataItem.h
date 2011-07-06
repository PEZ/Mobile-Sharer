//
//  StyledTableDataItem.h
//  MobileSharer
//
//  Created by PEZ on 2010-12-04.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@interface StyledTableDataItem : TTTableLinkedItem {
  NSString* _html;
  NSDate*   _created;
  NSString* _fromId;
  NSString* _fromAvatar;
  NSString* _message;
  TTStyledText* _styledText;
}

@property (nonatomic, retain) NSString* html;
@property (nonatomic, retain) NSDate* created;
@property (nonatomic, retain)   NSString* fromId;
@property (nonatomic, retain)   NSString* fromAvatar;
@property (nonatomic, retain)   NSString* message;
@property (nonatomic, readonly, retain) TTStyledText* styledText;

@end
