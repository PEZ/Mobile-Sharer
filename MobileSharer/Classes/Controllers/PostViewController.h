//
//  PostViewController.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-05.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "TableViewController.h"
#import "FacebookJanitor.h"
#import "PostDataSource.h"
#import "CommentsPostController.h"
#import "Post.h"
#import "FavoriteAdder.h"

@class PostViewController;

@interface LikeButton : UIBarButtonItem <FBRequestDelegate> {
  PostViewController* _controller;
  BOOL _liked;
}

- (void)likeIt;
- (void)unLikeIt;

@end

@interface PostViewController : TableViewController
<TTPostControllerDelegate, FBRequestDelegate, UIActionSheetDelegate, FavoriteAdderDelegate> {
  @protected
  NSString* _postId;
  BOOL _wasShared;
  BOOL _isFavoritePost;
  TTActionSheetController* _actionSheet;
  UIBarButtonItem*  _shareButton;
  FavoriteAdder* _favoriteAdder;
}

@property (nonatomic, retain)   Post* post;

- (id)initWithPostId:(NSString *)postId andTitle:(NSString*)title;
- (id)initWithPostId:(NSString *)postId andTitle:(NSString*)title isFavorite:(BOOL)isFavorite;
- (void)setupView;
- (void)comment:(NSString*)text;

@end
