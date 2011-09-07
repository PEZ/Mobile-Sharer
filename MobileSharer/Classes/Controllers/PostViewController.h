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
#import "FavoriteRemover.h"

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
  TTActionSheetController* _actionSheet;
  UIBarButtonItem*  _shareButton;
#if APP==FAVORITES_APP
  BOOL _isFavoritePost;
  BOOL _hideFavoriteUpdateUI;
  FavoriteAdder* _favoriteAdder;
  FavoriteRemover* _favoriteRemover;
#endif
}

@property (nonatomic, retain)   Post* post;

- (id)initWithPostId:(NSString *)postId andTitle:(NSString*)title;
- (void)setupView;
- (void)comment:(NSString*)text;

#if APP==FAVORITES_APP
- (id)initWithPostId:(NSString *)postId andTitle:(NSString*)title hideFavoriteUpdateUI:(BOOL)hideFavoriteUpdateUI;
#endif

@end
