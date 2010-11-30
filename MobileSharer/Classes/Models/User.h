//
//  User.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-23.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

@interface User : NSObject {
  NSString* _userId;
  NSString* _userName;
  NSString* _about;
}

@property (nonatomic, retain) NSString* userId;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* about;

@end
