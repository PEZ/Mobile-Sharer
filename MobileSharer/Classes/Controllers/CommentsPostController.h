//
//  CommentsPostController.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-11.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "FacebookJanitor.h"

@interface CommentsPostController : TTPostController <TTPostControllerDelegate, FBRequestDelegate> {
  NSString* _postId;
}

@property (nonatomic, copy) NSString* postId;

- (id)initWithPostId:(NSString *)postId andDelegate:(id<TTPostControllerDelegate>)delegate;

@end
