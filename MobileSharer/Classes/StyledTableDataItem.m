//
//  StyledTableDataItem.m
//  MobileSharer
//
//  Created by PEZ on 2010-12-04.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StyledTableDataItem.h"


@implementation StyledTableDataItem

@synthesize html = _html;
@synthesize created = _created;
@synthesize fromId            = _fromId;
@synthesize fromAvatar        = _fromAvatar;
@synthesize message           = _message;

- (void)dealloc {
  TT_RELEASE_SAFELY(_html);
  TT_RELEASE_SAFELY(_created);
  TT_RELEASE_SAFELY(_fromId);
  TT_RELEASE_SAFELY(_fromAvatar);
  TT_RELEASE_SAFELY(_message);
  TT_RELEASE_SAFELY(_styledText);
  [super dealloc];
}

- (TTStyledText*)styledText {
  if (!_styledText) {
    _styledText = [[TTStyledText textFromXHTML:_html lineBreaks:YES URLs:(self.URL == nil)] retain];
  }
  return _styledText;
}

- (void)setHtml:(NSString *)htmlText {
  if (_html) {
    TT_RELEASE_SAFELY(_html);
  }
  _html = [htmlText retain];
  if (_styledText) {
    TT_RELEASE_SAFELY(_styledText);
  }
  _styledText = [[TTStyledText textFromXHTML:_html lineBreaks:YES URLs:(self.URL == nil)] retain];
}  
  
@end
