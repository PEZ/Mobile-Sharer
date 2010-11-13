//
//  PostViewController.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-05.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "PostViewController.h"
#import "CommentsPostController.h"
#import "SharePostController.h"
#import "PostDataSource.h"
#import "FacebookJanitor.h"

@implementation PostViewController

@synthesize post = _post;

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query { 
  if (self = [super initWithNibName:nil bundle:nil]) {
    Post* passedPost = [query objectForKey:@"__userInfo__"];
    self.post = passedPost;
    self.title = @"Comments";
    self.variableHeightRows = YES;
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_post);
  [super dealloc];
}

- (void)comment {
  CommentsPostController* controller = [[CommentsPostController alloc] initWithPostId:self.post.postId
                                                                          andDelegate:self];
  controller.originView = self.view;
  [controller showInView:self.view animated:YES];
  [controller release];
}

- (void)share {
  SharePostController* controller = [[SharePostController alloc] initWithPost:self.post
                                                                  andDelegate:self];
  controller.originView = self.view;
  [controller showInView:self.view animated:YES];
  [controller release];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  UIBarButtonItem* commentButton = [[[UIBarButtonItem alloc] initWithTitle:@"Comment"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(comment)]autorelease];
  UIBarButtonItem* shareButton = [[[UIBarButtonItem alloc] initWithTitle:@"Share"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(share)]autorelease];
  [self setToolbarItems:[NSArray arrayWithObjects:commentButton, shareButton, nil] animated:NO];
  self.navigationController.toolbar.tintColor = TTSTYLEVAR(toolbarTintColor);
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setToolbarHidden:NO animated:animated];
}
  
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)createModel {
  self.dataSource = [[[PostDataSource alloc]
                      initWithPost:self.post] autorelease];
}

- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}


#pragma mark -
#pragma mark TTPostControllerDelegate

- (void)postController: (TTPostController*)postController
           didPostText: (NSString*)text
            withResult: (id)result {
  [self reload];
}

- (BOOL)postController:(TTPostController *)postController willPostText:(NSString *)text {
  return NO;
}

#pragma mark -
#pragma mark FBRequestDelegate

- (void)requestLoading:(FBRequest*)request {
  NSLog(@"request loading");
}

- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response {
  NSLog(@"response recieved: %@", response);
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
  NSLog(@"Failed posting comment: %@", error);
  TTAlert([NSString stringWithFormat:@"Posting comment failed: %@", [error localizedDescription]]);
}

- (void)request:(FBRequest*)request didLoad:(id)result {
}
   
@end
