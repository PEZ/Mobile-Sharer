//
//  PostIdViewController.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-18.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "PostViewControllerBase.h"


@interface PostIdViewController : PostViewControllerBase {
  NSString* _postId;
}

- (id)initWithPostId:(NSString *)postId andTitle:(NSString*)title;

@end
