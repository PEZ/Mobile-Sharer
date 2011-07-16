//
//  CommentsPostController.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-11.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "PostController.h"

@interface CommentsPostController : PostController {
  NSString* _postId;
}

@property (nonatomic, retain) NSString* postId;

- (id)initWithPostId:(NSString *)postId andDelegate:(id<TTPostControllerDelegate>)delegate;
- (id)initWithPostId:(NSString*)postId andMessage:(NSString*)message
         andDelegate:(id<TTPostControllerDelegate>)delegate;
@end
