//
//  PostViewController.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-05.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "TableViewController.h"
#import "FacebookJanitor.h"
#import "ComposePostController.h"

@interface FeedViewController : TableViewController <TTPostControllerDelegate, FBRequestDelegate>{
  NSString* _feedId;
}

@property (nonatomic, retain)   NSString* feedId;

- (id)initWithFBFeedId:(NSString *)feedId andName:(NSString *)name;

@end
