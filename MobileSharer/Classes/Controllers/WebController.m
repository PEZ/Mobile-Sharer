//
//  WebController.m
//  MobileSharer
//
//  Created by PEZ on 2010-11-30.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "WebController.h"
#import "RegexKitLite.h"

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

@end
