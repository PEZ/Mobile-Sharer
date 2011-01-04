//
//  WebController.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-30.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "WebController.h"
#import "RegexKitLite.h"
#import "ComposePostController.h"
#import <Three20UICommon/UIViewControllerAdditions.h>

static NSString* kUrlEncodedEndQuote = @"%22";

@implementation WebController

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
  if (self = [self initWithNibName:nil bundle:nil]) {
    NSURLRequest* request = [query objectForKey:@"request"];
    if (nil != request) {
      [self openRequest:request];
    } else {
      NSString* q = [URL absoluteString];
      if ([q isMatchedByRegex:kUrlEncodedEndQuote]) {
        NSURL* url = [NSURL URLWithString:[q substringToIndex:[q length] - [kUrlEncodedEndQuote length]]];
        [self openURL:url];
      }
      else {
        [self openURL:URL];
      }
    }
  }
  return self;
}

- (void)shareAction {
  if (nil == _actionSheet) {
    _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                      cancelButtonTitle:TTLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil
                                      otherButtonTitles:
										TTLocalizedString(@"Share", @""),
										TTLocalizedString(@"Copy link", @""),
										TTLocalizedString(@"Open in Safari", @""),
										nil
										];
    if (TTIsPad()) {
      [_actionSheet showFromBarButtonItem:_actionButton animated:YES];
    }  else {
      [_actionSheet showInView:self.view];
    }
  } else {
    [_actionSheet dismissWithClickedButtonIndex:-1 animated:YES];
    TT_RELEASE_SAFELY(_actionSheet);
  }

}

- (void)compose:(NSString*)url {
  ComposePostController* controller = [[ComposePostController alloc]
                                       initWithFeedId:@"me"
                                       andLink:url
                                       andTitle:@"Share link"
                                       andDelegate:self];
	UIViewController *topController = [TTNavigator navigator].topViewController;
	topController.popupViewController = controller;
	controller.superController = topController;
  [controller showInView:controller.view animated:YES];
  [controller release];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
		[self compose:[self.URL absoluteString]];
  }
  else if (buttonIndex == 1) {
		NSString* url = [Etc mobileYouTubeURL:[self.URL absoluteString]];
		[UIPasteboard generalPasteboard].string = url;
		TTAlert([NSString stringWithFormat:@"Link ready to be pasted: %@", url]);
  }
	else if (buttonIndex == 2) {
		[[UIApplication sharedApplication] openURL:self.URL];
	}
}

#pragma mark -
#pragma mark TTPostControllerDelegate

- (void)postController: (TTPostController*)postController
           didPostText: (NSString*)text
            withResult: (id)result {
	NSString* postId = [result objectForKey:@"id"];
	TTOpenURL([Etc toPostIdPath:[Etc fullPostId:postId andFeedId:[FacebookJanitor sharedInstance].currentUser.userId]
										 andTitle:@"Shared link"]);
}

- (BOOL)postController:(TTPostController *)postController willPostText:(NSString *)text {
  return NO;
}

@end
