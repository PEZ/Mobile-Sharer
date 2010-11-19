//
//  PostDataSource.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-06.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "PostModel.h"
#import "Post.h"
#import "Comment.h"


@interface PostDataSource : TTListDataSource {
  PostModel* _postModel;
  Post*      _postItem;
}

- (id)initWithPost:(Post*)post;

@end
