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
  NSString* _pendingComment;
}

@property (nonatomic, retain)   Post* post;
@property (nonatomic, retain)   NSString* pendingComment;

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query;

@end
