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

static NSString* kShareCommentURLStr = @"ms://share_comment";
static NSString* kCopyCommentURLStr = @"ms://copy_comment";

@implementation CommentSharer

- (void)tearDownNavigation {
  TTURLMap* map = [TTNavigator navigator].URLMap;
  [map removeURL:[NSString stringWithFormat:@"%@/%@", kShareCommentURLStr, _cell.comment.commentId]];
  [map removeURL:[NSString stringWithFormat:@"%@/%@", kCopyCommentURLStr, _cell.comment.commentId]];
}

- (void)setUpNavigation {
  TTURLMap* map = [TTNavigator navigator].URLMap;
  [map from:[NSString stringWithFormat:@"%@/%@", kShareCommentURLStr, _cell.comment.commentId]
   toObject:self selector:@selector(shareComment)];
  [map from:[NSString stringWithFormat:@"%@/%@", kCopyCommentURLStr, _cell.comment.commentId]
   toObject:self selector:@selector(copyComment)];
}

- (id)initWithCommentCell:(CommentCell*)cell {
  if ((self = [super init])) {
    [self setTitle:@"Share" forState:UIControlStateNormal];
    [self setStyle:TTSTYLE(actionLinks) forState:UIControlStateNormal];
    [self sizeToFit];
    [self addTarget:self
             action:@selector(showShareOptions)
   forControlEvents:UIControlEventTouchUpInside];
    _cell = [cell retain];
    _actionSheet = [[[TTActionSheetController alloc] initWithTitle:nil] retain];
    [_actionSheet addButtonWithTitle:@"Quote and share"
                                 URL:[NSString stringWithFormat:@"%@/%@", kShareCommentURLStr, _cell.comment.commentId]];
    [_actionSheet addButtonWithTitle:@"Copy comment text"
                                 URL:[NSString stringWithFormat:@"%@/%@", kCopyCommentURLStr, _cell.comment.commentId]];
    [_actionSheet addCancelButtonWithTitle:@"Cancel" URL:nil];
    [self setUpNavigation];
  }
  return self;
}

- (void)dealloc {
  [self tearDownNavigation];
  TT_RELEASE_SAFELY(_cell);
  [super dealloc];
}

- (void)copyComment {
  [UIPasteboard generalPasteboard].string = _cell.comment.message;
  TTAlertNoTitle([NSString stringWithFormat:@"Message ready to be pasted:\n %@", _cell.comment.message]);
}

- (void)showShareOptions {
  [self setUpNavigation];
  if (TTIsPad()) {
    [_actionSheet showFromRect:CGRectMake(_cell.left, _cell.top, _cell.width, _cell.height)
                        inView:[TTNavigator navigator].visibleViewController.view animated:YES];
  }
  else {
    [_actionSheet showInView:_cell.contentView.superview animated:YES];
  }
  [_cell updateMessageLabel];
}

#pragma mark -
#pragma mark TTPostControllerDelegate

- (void)postController:(TTPostController*)postController
           didPostText:(NSString*)text
            withResult:(id)result {
	NSString* postId = [result objectForKey:@"id"];
	TTOpenURL([Etc toPostIdPath:[Etc fullPostId:postId andFeedId:[FacebookJanitor sharedInstance].currentUser.userId]
										 andTitle:@"New post"]);
}

- (BOOL)postController:(TTPostController *)postController willPostText:(NSString *)text {
  return NO;
}

@end

@implementation CommentLikesUpdater

- (id)initWithCommentCell:(CommentCell*)cell {
  if ((self = [super init])) {
    [self setTitle:@"Unlike" forState:UIControlStateNormal];
    [self setStyle:TTSTYLE(actionLinks) forState:UIControlStateNormal];
    [self sizeToFit];
    [self setTitle:cell.comment.isLiked ? @"Unlike" : @"Like" forState:UIControlStateNormal];
    [self addTarget:self
             action:(cell.comment.isLiked ? @selector(unLikeIt) : @selector(likeIt))
   forControlEvents:UIControlEventTouchUpInside];
    _cell = cell;
  }
  return self;
}

- (void)likeIt {
  [_cell.comment likeIt:self];
  [_cell updateMessageLabel];
}

- (void)unLikeIt {
  [_cell.comment unLikeIt:self];
  [_cell updateMessageLabel];
}

- (void)update {
  NSString* likeButtonTitle = @"...";
  if (!_cell.comment.isUpdatingLikes) {
    self.enabled = YES;
    [self removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    likeButtonTitle = _cell.comment.isLiked ? @"Unlike" : @"Like";
    [self addTarget:self action:(_cell.comment.isLiked ? @selector(unLikeIt) : @selector(likeIt))
   forControlEvents:UIControlEventTouchUpInside];
  }
  else {
    self.enabled = NO;
  }
  [self setTitle:likeButtonTitle forState:UIControlStateNormal];
}

- (void)likesUpdatedForComment:(Comment *)comment {
  [(TTTableView*)_cell.superview reloadData];
}

- (void)failedUpdatingLikesForComment:(Comment *)comment withError:(NSError *)error {
  [(TTTableView*)_cell.superview reloadData];
  TTAlert([NSString stringWithFormat:@"Updating likes failed: %@", [error localizedDescription]]);
}

@end


@implementation CommentCell

- (void)dealloc {
  TT_RELEASE_SAFELY(_likeUpdater);
  TT_RELEASE_SAFELY(_commentSharer);
  TT_RELEASE_SAFELY(_actionButtonsPanel);
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
  if (item != nil && item.html == nil) {
    [self setMessageHTMLRegardless:item];
 }
}

- (void) updateMessageLabel {
  Comment* comment = (Comment*)_item;
  [[self class] setMessageHTMLRegardless:comment];
  self.messageLabel.text = comment.styledText;
  [_likeUpdater update];
}

- (Comment*)comment {
  return (Comment*)_item;
}

- (TTView*)actionButtonsPanel {
  if (!_actionButtonsPanel) {
    _actionButtonsPanel = [[[TTView alloc] init] retain];
    [self.contentView addSubview:_actionButtonsPanel];
    _likeUpdater = [[CommentLikesUpdater alloc] initWithCommentCell:self];
    [_actionButtonsPanel addSubview:_likeUpdater];
    _commentSharer = [[CommentSharer alloc] initWithCommentCell:self];
    [_actionButtonsPanel addSubview:_commentSharer];
    _commentSharer.left = _likeUpdater.right + kTableCellMargin;
    _actionButtonsPanel.size = CGSizeMake(_likeUpdater.width + _commentSharer.width + kTableCellMargin,
                                          _likeUpdater.height);
  }
  return _actionButtonsPanel;
}

#pragma mark -
#pragma mark UIView

- (void)layoutSubviews {
  [super layoutSubviews];
  _actionButtonsPanel.bottom = _messageLabel.bottom - kTableCellSmallMargin;
  _actionButtonsPanel.right = _messageLabel.right - kTableCellSmallMargin;
}

- (void)didMoveToSuperview {
  [super didMoveToSuperview];
  if (self.superview) {
    _actionButtonsPanel.backgroundColor = _messageLabel.backgroundColor;
  }
}

#pragma mark -
#pragma mark TTTableViewCell

- (void)setObject:(id)object {
  if (_item != object) {
    [super setObject:object];
    [self.actionButtonsPanel setStyle:TTSTYLE(actionLinks)];
  }
  [_likeUpdater update];
}

@end