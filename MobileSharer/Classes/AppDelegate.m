
#import "AppDelegate.h"
#import "FeedViewController.h"
#import "LoginViewController.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
  TTDefaultCSSStyleSheet* styleSheet = [[TTDefaultCSSStyleSheet alloc] init];
  [styleSheet addStyleSheetFromDisk:TTPathForBundleResource(@"stylesheet.css")];
  [TTStyleSheet setGlobalStyleSheet:styleSheet];
  TT_RELEASE_SAFELY(styleSheet);
  TTNavigator* navigator = [TTNavigator navigator];
  navigator.persistenceMode = TTNavigatorPersistenceModeNone;
  
  TTURLMap* map = navigator.URLMap;
  
  //[map from:@"*" toViewController:[TTWebController class]];
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
