//
//  CommentCell.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-09.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "CommentCell.h"
//#import "DefaultStyleSheet.h"
#import "FacebookJanitor.h"

static NSString* kLikeCommentURLStr = @"ms://like_comment";
static NSString* kUnLikeCommentURLStr = @"ms://unlike_comment";

@implementation CommentLikesUpdater


- (void)tearDownNavigation {
  TTURLMap* map = [TTNavigator navigator].URLMap;
  [map removeURL:[NSString stringWithFormat:@"%@/%@", kLikeCommentURLStr, _cell.comment.commentId]];
  [map removeURL:[NSString stringWithFormat:@"%@/%@", kUnLikeCommentURLStr, _cell.comment.commentId]];
}

- (void)setUpNavigation {
  [self tearDownNavigation];
  TTURLMap* map = [TTNavigator navigator].URLMap;
  [map from:[NSString stringWithFormat:@"%@/%@", kLikeCommentURLStr, _cell.comment.commentId]
   toObject:self selector:@selector(likeIt)];
  [map from:[NSString stringWithFormat:@"%@/%@", kUnLikeCommentURLStr, _cell.comment.commentId]
   toObject:self selector:@selector(unLikeIt)];
}

- (id)initWithCommentCell:(CommentCell*)cell {
  if ((self = [super init])) {
    _cell = [cell retain];
    [self setUpNavigation];
  }
  return self;
}

- (void)dealloc {
  [self tearDownNavigation];
  TT_RELEASE_SAFELY(_cell);
  [super dealloc];
}

- (void)likeIt {
  _cell.comment.isUpdatingLikes = YES;
  _cell.comment.isLiked = YES;
  [[FacebookJanitor sharedInstance] likeCommentWithId:_cell.comment.commentId delegate:self];
  [_cell updateMessageLabel];
}

- (void)unLikeIt {
  _cell.comment.isUpdatingLikes = YES;
  _cell.comment.isLiked = NO;
  [[FacebookJanitor sharedInstance] unLikeCommentWithId:_cell.comment.commentId delegate:self];
  [_cell updateMessageLabel];
}

#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
  _cell.comment.isUpdatingLikes = NO;
  _cell.comment.isLiked = !_cell.comment.isLiked;
  DLog(@"Failed posting like: %@", error);
  TTAlert([NSString stringWithFormat:@"Updating likes failed: %@", [error localizedDescription]]);
}

- (void)request:(FBRequest*)request didLoad:(id)result {
  _cell.comment.isUpdatingLikes = NO;
  if (_cell.comment.isLiked) {
    _cell.comment.likes = [NSNumber numberWithInt:[_cell.comment.likes intValue] + 1];
  }
  else {
    _cell.comment.likes = [NSNumber numberWithInt:[_cell.comment.likes intValue] - 1];
  }
  [_cell updateMessageLabel];
}

@end


@implementation CommentCell

- (void)dealloc {
  TT_RELEASE_SAFELY(_likeUpdater);
  [super dealloc];
}

+ (NSString*) getButtonsHTML:(Comment*)item {
  NSString* html = @"<div class=\"actionLinks\">";
  if (!item.isUpdatingLikes) {
    html = [NSString stringWithFormat:@"%@<a href=\"%@/%@\">%@</a>", html,
            item.isLiked ? kUnLikeCommentURLStr : kLikeCommentURLStr,
            item.commentId,
            item.isLiked ? @"Unlike" : @"Like"];
  }
  else {
    html = [NSString stringWithFormat:@"%@...", html];
  }
  html = [NSString stringWithFormat:@"%@</div>", html];
  return html;
}

+ (NSString*) getMetaHTML:(Comment*)item {
  NSString* metaText = @"";
  metaText = [NSString stringWithFormat:@"<div class=\"tableMetaText\">%@%@", metaText, [item.created formatRelativeTime]];
  if (item.likes && [item.likes intValue] > 0) {
    metaText = [NSString stringWithFormat:@"%@, %@", metaText,
                [[self class] textForCount:[item.likes intValue] withSingular:@"like" andPlural:@"likes"]];
  }
  metaText = [NSString stringWithFormat:@"%@%@", metaText, [self getButtonsHTML:item]];
  return [NSString stringWithFormat:@"%@</div>", metaText];
}

+ (void) setMessageHTMLRegardless:(Comment*)item {
  NSString* messageText = [self getAvatarHTML:item.fromAvatar feedId:item.fromId];
  messageText = [NSString stringWithFormat:@"%@<div class=\"tableMessageContent\">%@", messageText, [self getNameHTML:item.fromName feedId:item.fromId]];
  if (item.message) {
    messageText = [NSString stringWithFormat:@"%@ <span class=\"tableText\">%@</span>", messageText, [Etc xmlEscape:item.message]];
  }
  messageText = [NSString stringWithFormat:@"%@%@</div>", messageText, [self getMetaHTML:item]];
  
  item.html = messageText;
}

+ (void) setMessageHTML:(Comment*)item {
  if (item != nil && item.html == nil) {
    [self setMessageHTMLRegardless:item];
 }
}

- (void) updateMessageLabel {
  Comment* comment = (Comment*)_item;
  [[self class] setMessageHTMLRegardless:comment];
  self.messageLabel.text = comment.styledText;
}

- (CommentLikesUpdater*)likeUpdater {
  if (!_likeUpdater) {
    _likeUpdater = [[CommentLikesUpdater alloc] initWithCommentCell:self];
    return _likeUpdater;
  }
  else {
    return _likeUpdater;
  }
}

- (Comment*)comment {
  return (Comment*)_item;
}

#pragma mark -
#pragma mark TTTableViewCell

- (void)setObject:(id)object {
  if (_item != object) {
    [super setObject:object];
  }
  [self.likeUpdater setUpNavigation];
}

@end