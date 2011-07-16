//
//  Comment.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-08.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "StyledTableDataItem.h"
#import "FacebookJanitor.h"

@class Comment;

@protocol UpdatingLikesObserver <NSObject>

- (void)likesUpdatedForComment:(Comment*)comment;
- (void)failedUpdatingLikesForComment:(Comment*)comment withError:(NSError*)error;

@end

@interface Comment : StyledTableDataItem <FBRequestDelegate> {
  NSString* _commentId;
  NSString* _fromName;
  NSNumber* _likes;
  BOOL      _isLiked;
  BOOL      _isUpdatingLikes;
  id<UpdatingLikesObserver> _updatingLikesObserver;
}

@property (nonatomic, retain) NSString* commentId;
@property (nonatomic, retain) NSString* fromName;
@property (nonatomic, retain) NSNumber* likes;
@property (nonatomic)         BOOL      isLiked;
@property (nonatomic)         BOOL      isUpdatingLikes;
@property (nonatomic, retain) id<UpdatingLikesObserver> updatingLikesObserver;

- (void)likeIt:(id<UpdatingLikesObserver>)delegate;
- (void)unLikeIt:(id<UpdatingLikesObserver>)delegate;

@end