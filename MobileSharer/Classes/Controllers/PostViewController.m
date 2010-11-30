//
//  PostViewControllerBase.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-05.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "PostViewController.h"
#import "FacebookJanitor.h"
#import "CommentsPostController.h"
#import "SharePostController.h"
#import "RegexKitLite.h"

@implementation LikeButton

- (id)initWithController:(PostViewController*)controller {
  if (self = [super init]) {
    _controller = controller;
    self.title = @"Like";
    self.style = UIBarButtonItemStyleBordered;
    self.target = self;
    self.action = @selector(likeIt);
  }
  return self;
}

- (void)dealloc {
  //TT_RELEASE_SAFELY(_controller);
  [super dealloc];
}

- (void) updateLikes:(NSString*)method  {
  NSString* path = [NSString stringWithFormat:@"%@/likes", _controller.post.postId];
  Facebook* fb = [FacebookJanitor sharedInstance].facebook;
  [fb requestWithGraphPath:path andParams:[NSMutableDictionary dictionaryWithCapacity:0] andHttpMethod:method andDelegate:self];
}

- (void)likeIt {
  _liked = YES;
  self.enabled = NO;
  [self updateLikes:@"POST"];
}

- (void)unLikeIt {
  _liked = NO;
  self.enabled = NO;
  [self updateLikes:@"DELETE"];
}

#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
  self.enabled = YES;
  DLog(@"Failed posting like: %@", error);
  TTAlert([NSString stringWithFormat:@"Updating likes failed: %@", [error localizedDescription]]);
}

- (void)request:(FBRequest*)request didLoad:(id)result {
  self.enabled = YES;
  self.title = _liked ? @"Unlike" : @"Like";
  self.action = _liked ? @selector(unLikeIt) : @selector(likeIt);
  if (_controller != nil && _controller.post != nil) {
    _controller.post.likes = [NSNumber numberWithInt:[_controller.post.likes intValue] + (_liked ? 1 : -1)];
    [_controller reload];
  }
}

@end


@implementation PostViewController

@synthesize post = _post;

- (id)initWithPostId:(NSString *)postId andTitle:(NSString*)title {
  
  if (self = [super initWithNibName:nil bundle:nil]) {
    _postId = [postId copy];
    self.title = title;
    self.variableHeightRows = YES;
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_postId);
  [super dealloc];
}


- (void) openShareView: (SharePostController *) controller  {
  _wasShared = YES;
  controller.originView = self.view;
  [controller showInView:self.view animated:YES];
  [controller release];
  
}

- (void)share {
  SharePostController* controller = [[SharePostController alloc] initWithPost:self.post
                                                                        quote:NO
                                                                  andDelegate:self];
  [self openShareView: controller];
}

- (void)shareQ {
  SharePostController* controller = [[SharePostController alloc] initWithPost:self.post
                                                                        quote:YES
                                                                  andDelegate:self];
  [self openShareView: controller];
}

- (CommentsPostController *) createCommentsPostController {
  CommentsPostController* controller = [[CommentsPostController alloc] initWithPostId:_post.postId
                                                                          andDelegate:self];
  return controller;
}

- (void)comment {
  _wasShared = NO;
  CommentsPostController *controller = [self createCommentsPostController];
  controller.originView = self.view;
  [controller showInView:self.view animated:YES];
  [controller release];
}

- (void)setupView {
  if ([self.toolbarItems count] < 1) {
    NSMutableArray* buttons = [NSMutableArray arrayWithCapacity:4];
    if (_post.canComment) {
      UIBarButtonItem* commentButton = [[[UIBarButtonItem alloc] initWithTitle:@"Comment"
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:self
                                                                        action:@selector(comment)]autorelease];
      [buttons addObject:commentButton];
    }
    if (_post.canLike) {
      LikeButton* likeButton = [[[LikeButton alloc] initWithController:self] autorelease];
      [buttons addObject:likeButton];
    }
    UIBarButtonItem* shareButtonQ = [[[UIBarButtonItem alloc] initWithTitle:@"“Share”"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(shareQ)]autorelease];
    [buttons addObject:shareButtonQ];
    UIBarButtonItem* shareButton = [[[UIBarButtonItem alloc] initWithTitle:@"Share"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(share)]autorelease];
    [buttons addObject:shareButton];
    [self setToolbarItems:[NSArray arrayWithArray:buttons] animated:NO];
  }
}

- (void)modelDidFinishLoad:(PostModel*)postModel {
  _post = postModel.post;
  [super modelDidFinishLoad:postModel];
  [self setupView];
}


- (void)viewDidLoad {
  [super viewDidLoad];
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

- (void)createModel {
  self.dataSource = [[[PostDataSource alloc] initWithPostId:_postId] autorelease];
}


#pragma mark -
#pragma mark TTPostControllerDelegate

- (void)postController: (TTPostController*)postController
           didPostText: (NSString*)text
            withResult: (id)result {
  if (_wasShared) {
    NSString* postId = [result objectForKey:@"id"];
    if ([postId isMatchedByRegex:@"_"]) {
      TTOpenURL([Etc toPostIdPath:postId andTitle:@"Shared"]);
    }
    else {
      TTOpenURL([Etc toPostIdPath:[NSString stringWithFormat:@"%@_%@", [FacebookJanitor sharedInstance].currentUser.userId, postId]
                         andTitle:@"Shared"]);
    }
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
  DLog(@"Failed posting comment: %@", error);
  TTAlert([NSString stringWithFormat:@"Posting comment failed: %@", [error localizedDescription]]);
}

- (void)request:(FBRequest*)request didLoad:(id)result {
}
   
@end
