
#import "AppDelegate.h"
#import "DefaultStyleSheet.h"
#import "FeedViewController.h"
#import "LoginViewController.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
  [TTStyleSheet setGlobalStyleSheet:[[[DefaultStyleSheet 
                                       alloc] init] autorelease]];
  TTNavigator* navigator = [TTNavigator navigator];
  navigator.persistenceMode = TTNavigatorPersistenceModeNone;
  
  TTURLMap* map = navigator.URLMap;
  
  [map from:@"*" toViewController:[TTWebController class]];
  [map from:kFeedURLPath toViewController:[FeedViewController class]];
  [map from:kAppLoginURLPath toViewController:[LoginViewController class]];
  if (![navigator restoreViewControllers]) {
    [navigator openURLAction:[TTURLAction actionWithURLPath:kAppLoginURLPath]];
  }
}

#pragma mark -
#pragma mark URL opening

- (BOOL)navigator:(TTNavigator*)navigator shouldOpenURL:(NSURL*)URL {
  return YES;
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
  [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
  return YES;
}


@end
