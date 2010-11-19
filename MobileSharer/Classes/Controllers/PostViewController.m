//
//  PostViewController.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-18.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "PostViewController.h"
#import "CommentsPostController.h"
#import "SharePostController.h"

@implementation PostViewController

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query { 
  if (self = [self init]) {
    _post = [query objectForKey:@"__userInfo__"];
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_post);
  [super dealloc];
}

- (CommentsPostController *) createCommentsPostController {
  CommentsPostController* controller = [[CommentsPostController alloc] initWithPostId:_post.postId
                                                                          andDelegate:self];
  return controller;
}

- (void)share {
  SharePostController* controller = [[SharePostController alloc] initWithPost:self.post
                                                                  andDelegate:self];
  _wasShared = YES;
  controller.originView = self.view;
  [controller showInView:self.view animated:YES];
  [controller release];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  UIBarButtonItem* shareButton = [[[UIBarButtonItem alloc] initWithTitle:@"Share"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(share)]autorelease];
  [self setToolbarItems:[[self toolbarItems] arrayByAddingObjectsFromArray:[NSArray arrayWithObjects:shareButton, nil]] animated:NO];
  //[self setToolbarItems:[NSArray arrayWithObjects:commentButton, shareButton, nil] animated:NO];
}

#pragma mark -
#pragma mark TTTableViewController

- (void)createModel {
  self.dataSource = [[[PostDataSource alloc]
                      initWithPost:self.post] autorelease];
}

#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
  NSLog(@"Failed posting: %@", error);
  TTAlert([NSString stringWithFormat:@"Failed posting to Facebook: %@", [error localizedDescription]]);
}

@end
