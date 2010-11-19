//
//  Etcetera.m
//  MobileSharer
//
//  Created by PEZ on 2010-10-23.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "Etcetera.h"

NSString* kNavPathPrefix = @"ms://feed";
NSString* kFeedURLPath = @"ms://feed/(initWithFBFeedIdAndName:)/(name:)";
NSString* kPostPathPrefix = @"ms://post";
NSString* kPostPath = @"ms://post/(initWithNavigatorURL:)";
NSString* kPostIdPathPrefix = @"ms://postid";
NSString* kPostIdPath = @"ms://postid/(initWithPostId:)";
NSString* kAppLoginURLPath = @"ms://login";
NSString* kFacebookLoginPath = @"fb139083852806042://";
NSString* kCommentPath = @"ms://comment";

@implementation Etcetera

+ (NSString*) urlEncode:(NSString*)unencodedString {
  return [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                              kCFStringEncodingUTF8 ) autorelease];
}

+ (NSString*) toFeedURLPath:(NSString*)feedId name:(NSString *)name {
  NSString* url = [NSString stringWithFormat:@"%@/%@/%@",
                   kNavPathPrefix,
                   feedId,
                   [self urlEncode:name]];
  //NSLog(@"%@", url);
  return url;
}

+ (NSString*) toPostPath:(Post*)post {
  NSString* url = [NSString stringWithFormat:@"%@/%@",
                   kPostPathPrefix,
                   post.postId];
  //NSLog(@"%@", url);
  return url;
}

+ (NSString*) toPostIdPath:(NSString*)postId {
  NSString* url = [NSString stringWithFormat:@"%@/%@",
                   kPostIdPathPrefix,
                   postId];
  //NSLog(@"%@", url);
  return url;
}

+ (NSMutableDictionary*)params:(NSMutableDictionary**)params addObject:(id)object forKey:(id)key {
  if (object) {
    [*params setObject:object forKey:key];
  }
  return *params;
}

+ (NSString*)pictureURL:(NSString*)url {
  if (url) {
    NSArray* pic = [url componentsSeparatedByString:@"url="];
    if ([pic count] > 1) {
      return [(NSString*)[pic objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:kCFStringEncodingUTF8];
    }
  }
  return nil;
}

@end