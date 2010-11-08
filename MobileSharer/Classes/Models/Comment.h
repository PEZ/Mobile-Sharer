//
//  Comment.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-08.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Comment : NSObject {
  NSDate*   _created;
  NSString* _commentId;
  NSString* _fromId;
  NSString* _fromName;
  NSString* _fromAvatar;
  NSString* _message;
}

@property (nonatomic, retain) NSDate*   created;
@property (nonatomic, retain) NSString* commentId;
@property (nonatomic, copy)   NSString* fromId;
@property (nonatomic, copy)   NSString* fromName;
@property (nonatomic, copy)   NSString* fromAvatar;
@property (nonatomic, copy)   NSString* message;

@end