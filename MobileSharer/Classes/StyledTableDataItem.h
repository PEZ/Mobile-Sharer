//
//  StyledTableDataItem.h
//  MobileSharer
//
//  Created by PEZ on 2010-12-04.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Three20UI/TTTableLinkedItem.h"


@interface StyledTableDataItem : TTTableLinkedItem {
  NSString* _html;
  TTStyledText* _styledText;
}

@property (nonatomic, retain) NSString* html;
@property (nonatomic, readonly, retain) TTStyledText* styledText;

@end
