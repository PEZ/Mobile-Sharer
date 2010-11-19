//
//  PostViewControllerBase.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-05.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "PostViewControllerBase.h"
#import "FacebookJanitor.h"
#import "CommentsPostController.h"


@implementation PostViewControllerBase

@synthesize post = _post;

- (id)init {
  if (self = [super initWithNibName:nil bundle:nil]) {
    self.title = @"Comments";
    self.variableHeightRows = YES;
  }
  return self;
}

- (void)dealloc {
  [super dealloc];
}

- (CommentsPostController *) createCommentsPostController {
  return nil;
}

- (void)comment {
  _wasShared = NO;
  CommentsPostController *controller = [self createCommentsPostController];
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
  [self setToolbarItems:[NSArray arrayWithObjects:commentButton, nil] animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setToolbarHidden:NO animated:animated];
}
  
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.navigationController setToolbarHidden:YES animated:animated];
}

- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}


#pragma mark -
#pragma mark TTPostControllerDelegate

- (void)postController: (TTPostController*)postController
           didPostText: (NSString*)text
            withResult: (id)result {
  if (_wasShared) {
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:[Etcetera toPostIdPath:[result objectForKey:@"id"]]]];
  }
  else {
    [self reload];
  }

}

- (BOOL)postController:(TTPostController *)postController willPostText:(NSString *)text {
  return NO;
}

#pragma mark -
#pragma mark FBRequestDelegate

- (void)requestLoading:(FBRequest*)request {
  //NSLog(@"request loading");
}

- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response {
  //NSLog(@"response recieved: %@", response);
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
  NSLog(@"Failed posting comment: %@", error);
  TTAlert([NSString stringWithFormat:@"Posting comment failed: %@", [error localizedDescription]]);
}

- (void)request:(FBRequest*)request didLoad:(id)result {
}
   
@end
