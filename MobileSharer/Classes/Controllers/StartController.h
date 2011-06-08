//
//  LoginViewController.h
//  MobileSharer
//
//  Created by PEZ on 2010-10-24.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import <Three20UI/TTTableViewController.h>
#import "FacebookJanitor.h"

@interface StartController : TTTableViewController <FBJSessionDelegate, UserRequestDelegate> {
  @private
  UIBarButtonItem* _loginLogoutButton;
  BOOL       _currentUserLoaded;
}

@end
