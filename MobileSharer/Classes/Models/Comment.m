//
//  Comment.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-08.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "Comment.h"


@implementation Comment
@synthesize commentId          = _commentId;
@synthesize fromName           = _fromName;
@synthesize likes              = _likes;
@synthesize isLiked            = _isLiked;
@synthesize isUpdatingLikes    = _isUpdatingLikes;
@synthesize updatingLikesObserver = _updatingLikesObserver;

- (void)dealloc {
  TT_RELEASE_SAFELY(_commentId);
  TT_RELEASE_SAFELY(_fromName);
  TT_RELEASE_SAFELY(_likes);
  [super dealloc];
}


- (void)likeIt:(id<UpdatingLikesObserver>)delegate {
  _updatingLikesObserver = [delegate retain];
  self.isUpdatingLikes = YES;
  self.isLiked = YES;
  [[FacebookJanitor sharedInstance] likeCommentWithId:self.commentId delegate:self];
}

- (void)unLikeIt:(id<UpdatingLikesObserver>)delegate {
  _updatingLikesObserver = [delegate retain];
  self.isUpdatingLikes = YES;
  self.isLiked = NO;
  [[FacebookJanitor sharedInstance] unLikeCommentWithId:self.commentId delegate:self];
}


#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
  self.isUpdatingLikes = NO;
  self.isLiked = !self.isLiked;
  DLog(@"Failed posting like: %@", error);
  [_updatingLikesObserver failedUpdatingLikesForComment:self withError:error];
  TT_RELEASE_SAFELY(_updatingLikesObserver)
}

- (void)request:(FBRequest*)request didLoad:(id)result {
  self.isUpdatingLikes = NO;
  if (self.isLiked) {
    self.likes = [NSNumber numberWithInt:[self.likes intValue] + 1];
  }
  else {
    self.likes = [NSNumber numberWithInt:[self.likes intValue] - 1];
  }
  [_updatingLikesObserver likesUpdatedForComment:self];
  TT_RELEASE_SAFELY(_updatingLikesObserver)
}

@end


