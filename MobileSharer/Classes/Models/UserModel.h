//
//  UserModel.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-23.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "FacebookModel.h"
#import "User.h"

@class UserModel;

@protocol UserRequestDelegate
- (void)userRequestDidFinishLoad:(UserModel*)userModel;
- (void)userRequestDidFailWithError:(NSError*)error;
@end

@interface UserModel : TTURLRequestModel {
  NSString*                _graphPath;
  User*                    _user;
  id<UserRequestDelegate>  _delegate;
}

@property (nonatomic, retain)    NSString* graphPath;
@property (nonatomic, retain)  User* user;

- (id)initWithGraphPath:(NSString*)path andDelegate:(id<UserRequestDelegate>)delegate;

@end
