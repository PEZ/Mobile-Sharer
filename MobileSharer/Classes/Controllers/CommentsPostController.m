//
//  CommentsPostController.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-11.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "CommentsPostController.h"


@implementation CommentsPostController

@synthesize postId = _postId;

- (id)initWithPostId:(NSString *)postId andDelegate:(id<TTPostControllerDelegate>)delegate {
  if (self = [super init]) {
    self.postId = postId;
    self.title = @"Comment";
    self.delegate = delegate;    
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_postId);
  [super dealloc];
}

- (void)post {
  if (!self.textView.text.isEmptyOrWhitespace) {
    Facebook* fb = [FacebookJanitor sharedInstance].facebook;
    [fb requestWithGraphPath:[NSString stringWithFormat:@"%@/comments", self.postId]
                   andParams:[NSMutableDictionary dictionaryWithObject:self.textView.text forKey:@"message"]
               andHttpMethod:@"POST"
                 andDelegate:self];
    [super post];
  }
}

#pragma mark -
#pragma mark TTPostControllerDelegate

- (NSString*)titleForError:(NSError*)error {
  return [NSString stringWithFormat:@"Posting comment failed: %@", [error localizedDescription]];
}

- (NSString*)titleForActivity {
  return @"Posting comment...";
}

#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response {
  //NSLog(@"response recieved: %@", response);
}

@end
