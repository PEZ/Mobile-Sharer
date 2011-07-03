//
//  StyledTableIconDataItem.h
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-07-03.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "StyledTableDataItem.h"


@interface StyledTableIconDataItem : StyledTableDataItem {
  NSString* _icon;
}

@property (nonatomic, retain) NSString* icon;

@end
