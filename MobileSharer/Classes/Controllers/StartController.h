//
//  LoginViewController.h
//  MobileSharer
//
//  Created by PEZ on 2010-10-24.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "TableViewController.h"
#import "FacebookJanitor.h"

@interface StartController : TableViewController <FBJSessionDelegate, UserRequestDelegate> {
  @private
  UIBarButtonItem* _loginLogoutButton;
  BOOL       _currentUserLoaded;
}

@end
