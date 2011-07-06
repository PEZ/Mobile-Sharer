//
//  PostDataSource.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-06.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "PostModel.h"
#import "Post.h"


@interface PostDataSource : TTListDataSource {
  PostModel* _postModel;
}

- (id)initWithPost:(Post*)post;
- (id)initWithPostId:(NSString*)postId;

@end
