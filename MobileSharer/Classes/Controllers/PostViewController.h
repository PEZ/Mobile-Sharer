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

@class PostViewController;

@interface LikeButton : UIBarButtonItem <FBRequestDelegate> {
  PostViewController* _controller;
  BOOL _liked;
}

- (void)likeIt;
- (void)unLikeIt;

@end

@interface PostViewController : TTTableViewController <TTPostControllerDelegate, FBRequestDelegate> {
  NSString* _postId;
  BOOL _wasShared;
}

@property (nonatomic, retain)   Post* post;

- (id)initWithPostId:(NSString *)postId andTitle:(NSString*)title;
- (CommentsPostController *) createCommentsPostController;
- (void)setupView;


@end
