//
//  LoginViewController.h
//  MobileSharer
//
//  Created by PEZ on 2010-10-24.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "FacebookJanitor.h"

@interface LoginViewController : TTViewController <FBJSessionDelegate> {
  TTStyledTextLabel* _infoLabel;
  UIButton* _loginLogoutButton;
}

@property (nonatomic, retain) TTStyledTextLabel* infoLabel;
@property (nonatomic, retain) UIButton* loginLogoutButton;

@end
