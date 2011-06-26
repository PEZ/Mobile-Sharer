//
//  PostController.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PostController.h"


@implementation PostController

#pragma mark -
#pragma mark TTPostController

- (NSString*)titleForError:(NSError*)error {
	NSDictionary* userError = [[error userInfo] objectForKey:@"error"];
  return [NSString stringWithFormat:@"Posting failed.\n%@",
					userError ? [userError objectForKey:@"message"] : [error localizedDescription]];
}

- (NSString*)titleForActivity {
  return @"Posting ...";
}

//- (void)dismissWithResult:(id)result animated:(BOOL)animated {
//	[[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(void*)UIDeviceOrientationPortrait];
//	[super dismissWithResult:result animated:animated];
//}
//
//- (void)dismissPopupViewControllerAnimated:(BOOL)animated {
//	[[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(void*)UIDeviceOrientationPortrait];
//	[super dismissPopupViewControllerAnimated:animated];
//}

#pragma mark -
#pragma mark FBRequestDelegate

- (void)requestLoading:(FBRequest*)request {
  //DLog(@"request loading");
}

- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response {
  //DLog(@"response recieved: %@", response);
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
  DLog(@"Posting failed: %@", error);
  [self failWithError:error];
}

- (void)request:(FBRequest*)request didLoad:(id)result {
  [self dismissWithResult:result animated:YES];
}

@end
