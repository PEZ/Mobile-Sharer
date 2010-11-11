//
//  PostViewController.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-05.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "FacebookJanitor.h"
#import "Post.h"

@interface PostViewController : TTTableViewController <TTPostControllerDelegate, FBRequestDelegate> {
  Post* _post;
}

@property (nonatomic, retain)   Post* post;

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query;

@end
