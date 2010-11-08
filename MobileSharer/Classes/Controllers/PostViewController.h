//
//  PostViewController.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-05.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "Post.h"

@interface PostViewController : TTTableViewController {
  Post* _post;
}

@property (nonatomic, copy)   Post* post;

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query;

@end
