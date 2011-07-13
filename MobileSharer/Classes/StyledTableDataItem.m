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

- (TTStyledText*)styledText:(TTStyledText**)styledText fromHtml:(NSString*)html {
  if (!*styledText) {
    *styledText = [[TTStyledText textFromXHTML:html lineBreaks:YES URLs:(self.URL == nil)] retain];
  }
  return *styledText;
}

- (TTStyledText*)styledText {
  return [self styledText:&_styledText fromHtml:_html];
}

- (void)setHtml:(NSString*)html forIVar:(NSString**)iVar andStyledText:(TTStyledText**)styledText {
  if (*iVar) {
    TT_RELEASE_SAFELY(*iVar);
  }
  *iVar = [html retain];
  if (*styledText) {
    TT_RELEASE_SAFELY(*styledText);
  }
  *styledText = [[TTStyledText textFromXHTML:html lineBreaks:YES URLs:(self.URL == nil)] retain];
}  

- (void)setHtml:(NSString*)htmlText {
  [self setHtml:htmlText forIVar:&_html andStyledText:&_styledText];
}  

@end
