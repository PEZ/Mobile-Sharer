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
#import "FBConnect.h"

@class CommentCell;

@interface CommentLikesUpdater : NSObject <FBRequestDelegate> {
  CommentCell* _cell;
}

- (void)setUpNavigation;
- (void)likeIt;
- (void)unLikeIt;

@end

@interface CommentCell : MessageCellBase {
  CommentLikesUpdater* _likeUpdater;
}

@property (nonatomic, readonly, retain) CommentLikesUpdater* likeUpdater;
@property (nonatomic, readonly, retain) Comment* comment;

+ (void) setMessageHTMLRegardless:(Comment*)item;
- (void) updateMessageLabel;

@end
