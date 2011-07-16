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

- (id)initWithPostId:(NSString*)postId andMessage:(NSString*)message
         andDelegate:(id<TTPostControllerDelegate>)delegate {
  if ((self = [self initWithPostId:postId andDelegate:delegate])) {
    self.textView.text = message;
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_postId);
  [super dealloc];
}

- (void)post {
  if (TTIsStringWithAnyText(self.textView.text) && !self.textView.text.isWhitespaceAndNewlines) {
    Facebook* fb = [FacebookJanitor sharedInstance].facebook;
    [fb requestWithGraphPath:[NSString stringWithFormat:@"%@/comments", _postId]
                   andParams:[NSMutableDictionary dictionaryWithObject:self.textView.text forKey:@"message"]
               andHttpMethod:@"POST"
                 andDelegate:self];
    [super post];
  }
}

@end
