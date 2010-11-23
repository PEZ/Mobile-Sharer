//
//  User.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-23.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "User.h"


@implementation User

@synthesize userId     = _userId;
@synthesize userName   = _userName;
@synthesize about      = _about;

- (void)dealloc {
  TT_RELEASE_SAFELY(_userId);
  TT_RELEASE_SAFELY(_userName);
  TT_RELEASE_SAFELY(_about);
  
  [super dealloc];
}

@end
