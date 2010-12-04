//
//  StyledTableDataItem.m
//  MobileSharer
//
//  Created by PEZ on 2010-12-04.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StyledTableDataItem.h"


@implementation StyledTableDataItem

@synthesize html              = _html;


- (void)dealloc {
  TT_RELEASE_SAFELY(_html);
  TT_RELEASE_SAFELY(_styledText);
  [super dealloc];
}

- (TTStyledText*)styledText {
  if (!_styledText) {
    _styledText = [[TTStyledText textFromXHTML:_html lineBreaks:YES URLs:(self.URL == nil)] retain];
  }
  return _styledText;
}

@end
