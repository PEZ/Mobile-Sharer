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
#import <Three20UICommon/UIViewControllerAdditions.h>

@implementation FeedViewController

@synthesize feedId = _feedId;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = @"Facebook feed";
    self.variableHeightRows = YES;
  }

  return self;
}

- (id)initWithFBFeedId:(NSString *)feedId andName:(NSString *)name {
  if (self = [super initWithNibName:nil bundle:nil]) {
    self.feedId = feedId;
    self.title = name;
    self.variableHeightRows = YES;
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                              target:self
                                              action:@selector(compose)];
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


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

#pragma mark -
#pragma mark TTPostControllerDelegate

- (void)postController: (TTPostController*)postController
           didPostText: (NSString*)text
            withResult: (id)result {
  NSString* postId = [result objectForKey:@"id"];
  if ([postId isMatchedByRegex:@"_"]) {
    TTOpenURL([Etc toPostIdPath:postId andTitle:@"New post"]);
  }
  else {
    TTOpenURL([Etc toPostIdPath:[NSString stringWithFormat:@"%@_%@", [FacebookJanitor sharedInstance].currentUser.userId, postId]
                       andTitle:@"New post"]);
  }
}

- (BOOL)postController:(TTPostController *)postController willPostText:(NSString *)text {
  return NO;
}

@end
