//
//  PostModel.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-06.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "FacebookModel.h"

@interface PostModel : FacebookModel {
  NSString*  _postId;
  Post*      _post;
  NSArray*   _comments;
}

@property (nonatomic, retain)     NSString*  postId;
@property (nonatomic, retain)     Post*      post;
@property (nonatomic, readonly)   NSArray*   comments;

- (id)initWithPost:(Post*)post;

@end

