//
//  FeedPostCell.h
//  MobileSharer
//
//  Created by PEZ on 2010-10-30.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "PostCell.h"

@interface LinkPostCellBase : PostCell {
  TTStyledTextLabel*      _linkTextLabel;
}

@property (nonatomic, readonly, retain) TTStyledTextLabel*      linkTextLabel;

@end
