//
//  CommentCell.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-09.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

//
//  PostTableCell.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-01.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MessageCellBase.h"
#import "Comment.h"

@class CommentCell;

@interface CommentLikesUpdater : TTButton <UpdatingLikesObserver> {
  CommentCell* _cell;
}

- (void)likeIt;
- (void)unLikeIt;

@end

@interface CommentSharer : TTButton <UIActionSheetDelegate, TTPostControllerDelegate> {
  CommentCell* _cell;
  BOOL _wasShared;
  TTActionSheetController* _actionSheet;
}

- (void)setUpNavigation;
- (void)showShareOptions;

@end

@interface CommentCell : MessageCellBase {
  CommentLikesUpdater* _likeUpdater;
  CommentSharer* _commentSharer;
  TTView* _actionButtonsPanel;
}

@property (nonatomic, readonly, retain) Comment* comment;
@property (nonatomic, readonly, retain) TTView* actionButtonsPanel;

+ (void) setMessageHTMLRegardless:(Comment*)item;
- (void) updateMessageLabel;

@end
