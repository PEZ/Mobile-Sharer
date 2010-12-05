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

#import "StyledTextCell.h"
#import "Comment.h"

@class CommentCell;

@interface CommentLikeButton : TTButton <FBRequestDelegate> {
  CommentCell* _cell;
}

- (void)likeIt;
- (void)unLikeIt;

@end

@interface CommentCell : StyledTextCell {
  TTButton* _likeButton;
}

@property (nonatomic, readonly, retain) TTButton* likeButton;
@property (nonatomic, readonly, retain) Comment* comment;

+ (void) setMessageHTMLRegardless:(Comment*)item;
- (void) updateMessageLabel;

@end
