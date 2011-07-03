
#import "AppDelegate.h"
#import "DefaultStyleSheet.h"
#import "FeedViewController.h"
#import "ConnectionsViewController.h"
#import "PostViewController.h"
#import "NotificationsViewController.h"
#import "StartController.h"
#import "SplitStartController.h"
#import "WebController.h"


@implementation AppDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIApplicationDelegate

- (void)applicationWillTerminate:(UIApplication *)application {
  //TT_RELEASE_SAFELY(_rootViewController);
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
  [TTStyleSheet setGlobalStyleSheet:[[[DefaultStyleSheet 
                                       alloc] init] autorelease]];
  TTNavigator* navigator = [TTNavigator navigator];
  navigator.persistenceMode = TTNavigatorPersistenceModeAll;
  
  TTURLMap* map = navigator.URLMap;
  [map from:@"*" toViewController:[WebController class]];
  
  if (NO && TTIsPad()) {
    [map                    from:kAppStartURLPath
          toSharedViewController:[SplitStartController class]];
    
    SplitStartController* controller =
    (SplitStartController*)[[TTNavigator navigator] viewControllerForURL:kAppStartURLPath];
    TTDASSERT([controller isKindOfClass:[SplitStartController class]]);
    //map = controller.primaryNavigator.URLMap;
    map = controller.rightNavigator.URLMap;
    
  } else {
    [map                    from:kAppStartURLPath
          toSharedViewController:[StartController class]];
  }

  [map from:kFeedURLPath toViewController:[FeedViewController class]];
  [map from:kConnectionsURLPath toViewController:[ConnectionsViewController class]];
  [map from:kPostIdPath toViewController:[PostViewController class]];
  [map from:kNotificationsURLPath toViewController:[NotificationsViewController class]];

  //_rootViewController = [[TTRootViewController alloc] init];
  //[[TTNavigator navigator].window addSubview:_rootViewController.view];
  //[TTNavigator navigator].rootContainer = _rootViewController;
  
  if (![navigator restoreViewControllers]) {
    [navigator openURLAction:[TTURLAction actionWithURLPath:kAppStartURLPath]];
  }
  
  //[_rootViewController showController: navigator.rootViewController
  //                         transition: UIViewAnimationTransitionNone
  //                           animated: NO];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  UIViewController* controller = [TTNavigator navigator].visibleViewController;
  if ([controller isKindOfClass:[TTTableViewController class]]) {
    [((TTTableViewController*)controller).tableView reloadData];
  }
}

#pragma mark -
#pragma mark URL opening

- (BOOL)isFBAuthenticationURL:(NSURL*)URL {
  return [[URL absoluteString] hasPrefix:kFacebookLoginPath];
}

//- (BOOL)navigator:(TTNavigator*)navigator shouldOpenURL:(NSURL*)URL {
//  return YES;
//}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
  if (![self isFBAuthenticationURL:URL]) {
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
  }
  else {
    [[FacebookJanitor sharedInstance].facebook handleOpenURL:URL];
  }
  return YES;
}


@end
