//
//  LoginViewController.h
//  MobileSharer
//
//  Created by PEZ on 2010-10-24.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "LoginView.h"
#import "FacebookJanitor.h"

@interface LoginViewController : TTViewController <FBJSessionDelegate, UserRequestDelegate> {
  @private
  LoginView* _contentView;
  BOOL       _currentUserLoaded;
}

@end
