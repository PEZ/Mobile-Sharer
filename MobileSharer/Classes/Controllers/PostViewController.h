//
//  PostViewController.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-05.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

@interface PostViewController : TTTableViewController {
  NSString* _postId;
}

@property (nonatomic, copy)   NSString* postId;

- (id)initWithPostId:(NSString *)postId andName:(NSString *)name;

@end
