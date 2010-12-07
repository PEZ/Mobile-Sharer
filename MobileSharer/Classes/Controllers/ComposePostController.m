//
//  ComposePostController.m
//  MobileSharer
//
//  Created by PEZ on 2010-12-07.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "ComposePostController.h"


@implementation ComposePostController

@synthesize link = _link;
@synthesize feedId = _feedId;

- (id)initWithFeedId:(NSString*)feedId andLink:(NSString*)link andTitle:(NSString*)title
         andDelegate:(id<TTPostControllerDelegate>)delegate {
  if (self = [super init]) {
    self.feedId = feedId;
    self.link = link;
    self.title = title;
    self.delegate = delegate;
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_feedId);
  TT_RELEASE_SAFELY(_link);
  [super dealloc];
}

- (void)post {
  if (!self.textView.text.isEmptyOrWhitespace) {
    Facebook* fb = [FacebookJanitor sharedInstance].facebook;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:self.textView.text forKey:@"message"];
    [Etc params:&params addObject:_link forKey:@"link"];
    NSString* path = [NSString stringWithFormat:@"%@/%@", _feedId,
                      ([_link isEmptyOrWhitespace]) ? @"feed" : @"links"];
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
  return [NSString stringWithFormat:@"Posting failed: %@", [error localizedDescription]];
}

- (NSString*)titleForActivity {
  return @"Posting ...";
}

#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest*)request didLoad:(id)result {
  [self dismissWithResult:result animated:YES];
}

@end