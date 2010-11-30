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
#pragma mark FBRequestDelegate

- (void)requestLoading:(FBRequest*)request {
  //NSLog(@"request loading");
}

- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response {
  //NSLog(@"response recieved: %@", response);
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
  DLog(@"Posting failed: %@", error);
  [self failWithError:error];
}

- (void)request:(FBRequest*)request didLoad:(id)result {
  [self dismissWithResult:result animated:YES];
}

@end
