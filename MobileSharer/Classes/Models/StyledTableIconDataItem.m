//
//  StyledTableIconDataItem.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-07-03.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "StyledTableIconDataItem.h"


@implementation StyledTableIconDataItem

@synthesize icon = _icon;

- (void)dealloc {
  TT_RELEASE_SAFELY(_icon);
  [super dealloc];
}

@end
