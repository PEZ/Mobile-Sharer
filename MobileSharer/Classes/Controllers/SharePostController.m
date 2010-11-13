//
//  CommentsPostController.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-11.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "SharePostController.h"


@implementation SharePostController

@synthesize sharePost = _post;

- (id)initWithPost:(Post *)post andDelegate:(id<TTPostControllerDelegate>)delegate {
  if (self = [super init]) {
    self.sharePost = post;
    self.title = @"Share";
    if (post.message != NULL) {
      self.textView.text = [NSString stringWithFormat:@"\"%@\" (via %@)", post.message, post.fromName];
    }
    self.delegate = delegate;
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_post);
  [super dealloc];
}

- (NSMutableDictionary*)params:(NSMutableDictionary**)params addObject:(id)object forKey:(id)key {
  if (object) {
    [*params setObject:object forKey:key];
  }
  return *params;
}

- (NSString*)pictureURL:(NSString*)url {
  if (url) {
    NSArray* pic = [url componentsSeparatedByString:@"url="];
    if ([pic count] > 1) {
      return [(NSString*)[pic objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:kCFStringEncodingUTF8];
    }
  }
  return nil;
}

- (void)post {
  if (!self.textView.text.isEmptyOrWhitespace) {
    Facebook* fb = [FacebookJanitor sharedInstance].facebook;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:self.textView.text forKey:@"message"];
    if ([self.sharePost.type isEqualToString:@"link"]) {
      [self params:&params addObject:self.sharePost.linkURL forKey:@"link"];
      [self params:&params addObject:self.sharePost.linkText forKey:@"description"];
      [self params:&params addObject:self.sharePost.linkCaption forKey:@"caption"];
      [self params:&params addObject:self.sharePost.linkTitle forKey:@"name"];
      [self params:&params addObject:[self pictureURL:self.sharePost.picture] forKey:@"picture"];
    }
    [fb requestWithGraphPath:[NSString stringWithFormat:@"me/feed", self.sharePost.postId]
                   andParams:params
               andHttpMethod:@"POST"
                 andDelegate:self];
    [super post];
  }
}

- (NSString*)titleForError:(NSError*)error {
  return [NSString stringWithFormat:@"Posting link failed: %@", [error localizedDescription]];
}

- (NSString*)titleForActivity {
  return @"Posting link...";
}

@end
