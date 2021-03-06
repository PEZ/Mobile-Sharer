//
//  PostViewController.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-05.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedDataSource.h"
#import "RegexKitLite.h"

@implementation FeedViewController

@synthesize feedId = _feedId;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    self.title = @"Facebook feed";
    self.variableHeightRows = YES;
  }

  return self;
}

- (id)initWithFBFeedId:(NSString *)feedId andName:(NSString *)name {
  if ((self = [super initWithNibName:nil bundle:nil])) {
    self.feedId = feedId;
    self.title = name;
  }
  return self;
}

- (void)compose {
  ComposePostController* controller = [[ComposePostController alloc]
                                       initWithFeedId:_feedId
                                       andLink:@""
                                       andTitle:[_feedId isEqual:@"me"] ? @"New post" : [NSString stringWithFormat:@"Post to: %@", self.title]
                                       andDelegate:self];
	UIViewController *topController = [TTNavigator navigator].topViewController;
	topController.popupViewController = controller;
	controller.superController = topController;
  [controller showInView:controller.view animated:YES];
  [controller release];
}

- (void)loadView {
  if (self.navigationItem.rightBarButtonItem == nil) {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                              target:self
                                              action:@selector(compose)] autorelease];
  }
  [super loadView];
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_feedId);
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
  self.dataSource = [[[FeedDataSource alloc]
                      initWithFeedId:self.feedId] autorelease];
}

#pragma mark -
#pragma mark TTPostControllerDelegate

- (void)postController: (TTPostController*)postController
           didPostText: (NSString*)text
            withResult: (id)result {
	NSString* postId = [result objectForKey:@"id"];
	TTOpenURL([Etc toPostIdPath:[Post fullPostId:postId andFeedId:[FacebookJanitor sharedInstance].currentUser.userId]
										 andTitle:@"New post"]);
}

- (BOOL)postController:(TTPostController *)postController willPostText:(NSString *)text {
  return NO;
}

@end
