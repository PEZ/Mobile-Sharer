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

- (id)initWithPost:(Post *)post quote:(BOOL)quote andDelegate:(id<TTPostControllerDelegate>)delegate {
  if (self = [super init]) {
    self.sharePost = post;
    self.title = quote ? @"“Share”" : @"Share";
    if (quote && post.message != NULL) {
      self.textView.text = [NSString stringWithFormat:@"“%@” (via %@)", post.message, post.fromName];
    }
    self.delegate = delegate;
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_post);
  [super dealloc];
}

- (void)post {
  if (!self.textView.text.isEmptyOrWhitespace || self.sharePost.shareURL) {
    Facebook* fb = [FacebookJanitor sharedInstance].facebook;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:self.textView.text forKey:@"message"];
    [Etc params:&params addObject:[Etc pictureURL:self.sharePost.picture] forKey:@"picture"];
    [Etc params:&params addObject:self.sharePost.shareURL forKey:@"link"];
    [Etc params:&params addObject:self.sharePost.linkTitle forKey:@"name"];
    [Etc params:&params addObject:self.sharePost.linkCaption forKey:@"caption"];
    [Etc params:&params addObject:self.sharePost.linkText forKey:@"description"];
    [Etc params:&params addObject:self.sharePost.source forKey:@"source"];
    NSString* path = [NSString stringWithFormat:@"me/%@",
                          ([self.sharePost.type isEqualToString:@"video"]) ? @"links" : @"feed"];
    [fb requestWithGraphPath:path
                   andParams:params
               andHttpMethod:@"POST"
                 andDelegate:self];
    [super post];
  }
}

#pragma mark -
#pragma mark TTPostController

- (NSString*)titleForError:(NSError*)error {
  return [NSString stringWithFormat:@"Posting link failed: %@", [error localizedDescription]];
}

- (NSString*)titleForActivity {
  return @"Posting link...";
}

#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest*)request didLoad:(id)result {
  [self dismissWithResult:result animated:YES];
}

@end
