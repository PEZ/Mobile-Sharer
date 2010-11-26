//
//  LoginView.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-22.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

@synthesize infoLabel = _infoLabel;
@synthesize loginLogoutButton = _loginLogoutButton;
@synthesize showFeedButton = _showFeedButton;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.layout = [[[TTLayout alloc] init] autorelease];
    self.backgroundColor = RGBCOLOR(216, 221, 231);
    _infoLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)];
    _loginLogoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:nil action:nil];
    _showFeedButton = [[TTButton buttonWithStyle:@"forwardButton:" title:@"My Feed"] retain];
    [_showFeedButton sizeToFit];
    [self addSubview:_infoLabel];
  }
  return self;
}

- (void)layoutSubviews {
  _infoLabel.text.width = self.frame.size.width;
  _infoLabel.frame = CGRectMake(_infoLabel.frame.origin.x, _infoLabel.frame.origin.y, _infoLabel.text.width, _infoLabel.text.height);
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_infoLabel);
  TT_RELEASE_SAFELY(_loginLogoutButton);
  TT_RELEASE_SAFELY(_showFeedButton);
  [super dealloc];
}

@end

