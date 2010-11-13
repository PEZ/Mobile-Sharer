//
//  CommentsPostController.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-11.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "PostController.h"
#import "Post.h"

@interface SharePostController : PostController {
  Post* _post;
}

@property (nonatomic, retain) Post* sharePost;

- (id)initWithPost:(Post *)post andDelegate:(id<TTPostControllerDelegate>)delegate;

@end
