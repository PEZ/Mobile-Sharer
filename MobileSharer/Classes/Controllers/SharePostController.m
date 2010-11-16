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

- (void)post {
  if (!self.textView.text.isEmptyOrWhitespace) {
    Facebook* fb = [FacebookJanitor sharedInstance].facebook;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:self.textView.text forKey:@"message"];
    [Etcetera params:&params addObject:[Etcetera pictureURL:self.sharePost.picture] forKey:@"picture"];
    [Etcetera params:&params addObject:self.sharePost.linkURL forKey:@"link"];
    [Etcetera params:&params addObject:self.sharePost.linkTitle forKey:@"name"];
    [Etcetera params:&params addObject:self.sharePost.linkCaption forKey:@"caption"];
    [Etcetera params:&params addObject:self.sharePost.linkText forKey:@"description"];
    [Etcetera params:&params addObject:self.sharePost.source forKey:@"source"];
    NSString* path = [NSString stringWithFormat:@"me/%@",
                          ([self.sharePost.type isEqualToString:@"links"] ||
                           [self.sharePost.type isEqualToString:@"movie"]) ? @"link" : @"feed"];
    [fb requestWithGraphPath:path
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
