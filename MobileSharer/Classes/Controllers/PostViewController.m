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
#import "FavoritesSecretFetcher.h"

@implementation LikeButton

- (id)initWithController:(PostViewController*)controller {
  if ((self = [super init])) {
    _controller = [controller retain];
    self.title = @"Like";
    self.style = UIBarButtonItemStyleBordered;
    self.target = self;
    self.action = @selector(likeIt);
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_controller);
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
  if (_controller != nil) {
    [_controller reload];
  }
}

@end

static NSString* kShareStr = @"Share";
static NSString* kShareURLStr = @"ms://postviewcontroller/share";
static NSString* kQuoteStr = @"Share quoted";
static NSString* kQuoteURLStr = @"ms://postviewcontroller/quote";
static NSString* kCopyMessageStr = @"Copy";
static NSString* kCopyMessageURLStr = @"ms://postviewcontroller/copy";
static NSString* kCopyMessageQuotingStr = @"Copy quoted";
static NSString* kCopyMessageQuotingURLStr = @"ms://postviewcontroller/copy_quoting";

@implementation PostViewController

@synthesize post = _post;

- (void)setupNavigation {
  TTURLMap* map = [TTNavigator navigator].URLMap;
  [map from:kShareURLStr toObject:self selector:@selector(share)];
  [map from:kQuoteURLStr toObject:self selector:@selector(shareQ)];
  [map from:kCopyMessageURLStr toObject:self selector:@selector(copyMessage)];
  [map from:kCopyMessageQuotingURLStr toObject:self selector:@selector(copyQuotedMessage)];
}

- (void)tearDownNavigation {
  TTURLMap* map = [TTNavigator navigator].URLMap;
  [map removeURL:kShareURLStr];
  [map removeURL:kQuoteURLStr];
  [map removeURL:kCopyMessageURLStr];
  [map removeURL:kCopyMessageQuotingURLStr];
}

- (id)initWithPostId:(NSString *)postId andTitle:(NSString*)title {
  if ((self = [super initWithNibName:nil bundle:nil])) {
    _postId = [postId copy];
    self.title = title;
    self.variableHeightRows = YES;
  }
  return self;
}

- (id)initWithPostId:(NSString *)postId andTitle:(NSString*)title isFavorite:(BOOL)isFavorite {
  if ((self = [self initWithPostId:postId andTitle:title])) {
    _isFavoritePost = isFavorite;
  }
  return self;
}


- (void)dealloc {
  [self tearDownNavigation];
  TT_RELEASE_SAFELY(_postId);
  TT_RELEASE_SAFELY(_actionSheet);
  TT_RELEASE_SAFELY(_favoriteAdder);
  [super dealloc];
}


- (void) openShareView:(SharePostController*)controller  {
  _wasShared = YES;
	UIViewController *topController = [TTNavigator navigator].topViewController;
	topController.popupViewController = controller;
	controller.superController = topController;
  [controller showInView:controller.view animated:YES];
}

- (void)share:(NSString*)text {
  if (![_post.type isEqualToString:@"photo"]) {
    SharePostController* controller = [[[SharePostController alloc] initWithPost:self.post
                                                                         andText:text
                                                                     andDelegate:self] autorelease];
    [self openShareView: controller];
  }
  else {
    TTAlertNoTitle(@"Sorry, photo's can't be shared.");
  }
}

- (void)share {
  [self share:nil];
}

- (void)shareQ {
  [self share:[Etc quotedMessage:self.post.message quoting:self.post.fromName]];
}

- (void)copyText:(NSString*)text {
  if (_post.shareURL) {
    text = [NSString stringWithFormat:@"%@\n%@", _post.shareURL, text];
  }
  [Etc copyText:text];
}

- (void)copyMessage {
  [self copyText:_post.message];
}

- (void)copyQuotedMessage {
  [self copyText:[Etc quotedMessage:_post.message quoting:_post.fromName]];
}

- (CommentsPostController*)createCommentsPostController:(NSString*)text {
  CommentsPostController* controller = [[[CommentsPostController alloc] initWithPostId:_post.postId
                                                                            andMessage:text
                                                                          andDelegate:self] autorelease];
  return controller;
}

- (void)comment:(NSString*)text {
  _wasShared = NO;
  CommentsPostController *controller = [self createCommentsPostController:text];
	UIViewController *topController = [TTNavigator navigator].topViewController;
	topController.popupViewController = controller;
	controller.superController = topController;
  [controller showInView:controller.view animated:YES];
}

- (void)comment {
  [self comment:@""];
}

- (void)shareAction {
  [self tearDownNavigation];
  [self setupNavigation];
  if (_actionSheet == nil) {
    _actionSheet = [[[TTActionSheetController alloc] initWithTitle:nil] retain];
    if (_post.shareURL) {
      [_actionSheet addButtonWithTitle:kShareStr URL:kShareURLStr];
    }
    if (_post.message) {
      [_actionSheet addButtonWithTitle:kQuoteStr URL:kQuoteURLStr];
    }
    if (_post.message) {
      [_actionSheet addButtonWithTitle:kCopyMessageStr URL:kCopyMessageURLStr];
      [_actionSheet addButtonWithTitle:kCopyMessageQuotingStr URL:kCopyMessageQuotingURLStr];
    }
    [_actionSheet addCancelButtonWithTitle:@"Cancel" URL:nil];
  }

  if (TTIsPad()) {
    [_actionSheet showFromBarButtonItem:_shareButton animated:YES];
  }  else {
    [_actionSheet showInView:self.view animated:YES];
  }
}

- (void)addFavorite {
  self.navigationItem.rightBarButtonItem.enabled = NO;
  TT_RELEASE_SAFELY(_favoriteAdder);
  _favoriteAdder = [[FavoriteAdder alloc] initWithPostId:_postId
                                               andUserId:[FacebookJanitor sharedInstance].currentUser.userId
                                             andAuthorId:_post.fromId
                                               andSecret:[FavoritesSecretFetcher getSecret]
                                             andDelegate:self];
  [_favoriteAdder add];
}

- (void)removeFavorite {
  TTAlert([NSString stringWithFormat:@"Remove %@", _postId]);
}

- (void)setupView {
  if ([self.toolbarItems count] < 1) {
#if APP==FAVORITES_APP
    if (self.navigationItem.rightBarButtonItem == nil) {
      self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                                 initWithImage:[UIImage imageNamed:@"add-favorite.png"]
                                                 style:UIBarButtonItemStylePlain
                                                 target:self
                                                 action:_isFavoritePost ? @selector(removeFavorite) : @selector(addFavorite)] autorelease];
    }
#endif
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
    _shareButton = [[[UIBarButtonItem alloc] initWithTitle:@"Share"
                                                     style:UIBarButtonItemStyleBordered
                                                    target:self
                                                    action:@selector(shareAction)] retain];
    [buttons addObject:_shareButton];
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
		TTOpenURL([Etc toPostIdPath:[Post fullPostId:postId andFeedId:[FacebookJanitor sharedInstance].currentUser.userId]
											 andTitle:@"Shared"]);
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

#pragma mark -
#pragma mark FavoriteAdderDelegate

- (void)addingFavoriteDone {
  _isFavoritePost = NO;
  self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"bundle://remove-favorite.png"];
  self.navigationItem.rightBarButtonItem.action = @selector(removeFavorite);
  self.navigationItem.rightBarButtonItem.enabled = TRUE;
}

- (void)request:(TTURLRequest*)request addingFavoriteError:(NSError*)error {
  self.navigationItem.rightBarButtonItem.enabled = TRUE;
  TTAlert([NSString stringWithFormat:@"Failed adding favorite.\n\n(%@)", error]);
}

@end
