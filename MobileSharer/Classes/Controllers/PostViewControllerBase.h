//
//  PostViewController.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-05.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "FacebookJanitor.h"
#import "PostDataSource.h"
#import "CommentsPostController.h"
#import "Post.h"

@interface PostViewControllerBase : TTTableViewController <TTPostControllerDelegate, FBRequestDelegate> {
  Post* _post;
  BOOL _wasShared;
}

@property (nonatomic, retain)   Post* post;

- (CommentsPostController *) createCommentsPostController;


@end
