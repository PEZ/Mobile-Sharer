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

@implementation CommentLikeButton

- (id)initWithCommentCell:(CommentCell*)cell {
  if (self = [super initWithFrame:CGRectMake(0, 0, 40, 20)]) {
    _cell = cell;
    [self setTitle:@"Like" forState:UIControlStateNormal];
    [self setStyle:TTSTYLE(commentLikeButton) forState:UIControlStateNormal];
    [self addTarget:self action:@selector(likeIt) forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
}

- (void)likeIt {
  self.enabled = NO;
  _cell.comment.isLiked = YES;
  [self setTitle:@"..." forState:UIControlStateNormal];
  [[FacebookJanitor sharedInstance] likeCommentWithId:_cell.comment.commentId delegate:self];
}

- (void)unLikeIt {
  self.enabled = NO;
  _cell.comment.isLiked = NO;
  [self setTitle:@"..." forState:UIControlStateNormal];
  [[FacebookJanitor sharedInstance] unLikeCommentWithId:_cell.comment.commentId delegate:self];
}

#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
  self.enabled = YES;
  _cell.comment.isLiked = !_cell.comment.isLiked;
  [self setTitle:_cell.comment.isLiked ? @"Unlike" : @"Like" forState:UIControlStateNormal];
  DLog(@"Failed posting like: %@", error);
  TTAlert([NSString stringWithFormat:@"Updating likes failed: %@", [error localizedDescription]]);
}

- (void)request:(FBRequest*)request didLoad:(id)result {
  self.enabled = YES;
  [self setTitle:_cell.comment.isLiked ? @"Unlike" : @"Like" forState:UIControlStateNormal];
  if (_cell.comment.isLiked) {
    _cell.comment.likes = [NSNumber numberWithInt:[_cell.comment.likes intValue] + 1];
  }
  else {
    _cell.comment.likes = [NSNumber numberWithInt:[_cell.comment.likes intValue] - 1];
  }
  [self removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
  [self addTarget:self action:_cell.comment.isLiked ? @selector(unLikeIt) : @selector(likeIt) forControlEvents:UIControlEventTouchUpInside];
  if (_cell != nil) {
    [_cell updateMessageLabel];
  }
}

@end


@implementation CommentCell

- (void)dealloc {
  TT_RELEASE_SAFELY(_likeButton);
  [super dealloc];
}

+ (NSString*) getMetaHTML:(Comment*)item {
  NSString* metaText = @"";
  metaText = [NSString stringWithFormat:@"<div class=\"tableMetaText\">%@%@", metaText, [item.created formatRelativeTime]];
  if (item.likes && [item.likes intValue] > 0) {
    metaText = [NSString stringWithFormat:@"%@, %@", metaText,
                [[self class] textForCount:[item.likes intValue] withSingular:@"like" andPlural:@"likes"]];
  }
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
  if (item.html == nil) {
    [self setMessageHTMLRegardless:item];
 }
}

- (void) updateMessageLabel {
  Comment* comment = (Comment*)_item;
  [[self class] setMessageHTMLRegardless:comment];
  self.messageLabel.text = comment.styledText;
}

- (TTButton*)likeButton {
  if (!_likeButton) {
    _likeButton = [[CommentLikeButton alloc] initWithCommentCell:self];
    [self.contentView addSubview:_likeButton];
    return _likeButton;
  }
  else {
    return _likeButton;
  }
}

- (Comment*)comment {
  return (Comment*)_item;
}

#pragma mark -
#pragma mark UIView

- (void)prepareForReuse {
  [super prepareForReuse];
  [_likeButton setTitle:@"Like" forState:UIControlStateNormal];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _likeButton.right = _messageLabel.right;
  _likeButton.bottom = _messageLabel.bottom;
}

#pragma mark -
#pragma mark TTTableViewCell

- (void)setObject:(id)object {
  if (_item != object) {
    [super setObject:object];
  }
  Comment* item = (Comment*)_item;
  [self.likeButton setTitle:item.isLiked ? @"Unlike" : @"Like" forState:UIControlStateNormal];
}

@end