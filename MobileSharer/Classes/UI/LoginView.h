//
//  LoginView.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-22.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

@interface LoginView : TTView {
  TTButton* _loginLogoutButton;
  TTButton* _showFeedButton;
  TTStyledTextLabel* _infoLabel;
}

@property (nonatomic, retain) TTButton* loginLogoutButton;
@property (nonatomic, retain) TTButton* showFeedButton;
@property (nonatomic, retain) TTStyledTextLabel* infoLabel;

@end
