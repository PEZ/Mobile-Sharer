//
//  Etcetera.m
//  MobileSharer
//
//  Created by PEZ on 2010-10-23.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "Etc.h"
#import "FacebookJanitor.h"

CGFloat   kAvatarImageWidth   = 35;
CGFloat   kAvatarImageHeight  = 35;
CGFloat   kIconImageWidth   = 16;
CGFloat   kIconImageHeight  = 16;

NSString* kNavPathPrefix = @"ms://feed";
NSString* kFeedURLPath = @"ms://feed/(initWithFBFeedId:)/(andName:)";
NSString* kPostIdPathPrefix = @"ms://post";
NSString* kPostIdPath = @"ms://post/(initWithPostId:)/(andTitle:)";
NSString* kAppLoginURLPath = @"ms://login";
NSString* kFacebookLoginPath = @"fb139083852806042://";
NSString* kCommentPath = @"ms://comment";

NSString* kAppStoreId = @"406870483";

@implementation Etc

+ (NSString*) urlEncode:(NSString*)unencodedString {
  return [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                              kCFStringEncodingUTF8 ) autorelease];
}

+ (NSString*) xmlEscape:(NSString*)unescapedString {
  return [[[unescapedString
             stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]
            stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"]
           stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"]
  ;//stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
}

+ (NSString*) toFeedURLPath:(NSString*)feedId name:(NSString *)name {
  NSString* url = [NSString stringWithFormat:@"%@/%@/%@",
                   kNavPathPrefix,
                   feedId,
                   [self urlEncode:name]];
  return url;
}

+ (NSString*) toPhotoURLPath:(NSString*)photoId {
  return [[[FacebookJanitor sharedInstance].facebook
            getRequestWithGraphPath:[NSString stringWithFormat:@"%@/picture", photoId] andDelegate:nil] getConnectURL];
}

+ (NSString*) toPostIdPath:(NSString*)postId andTitle:(NSString*)title {
  NSString* url = [NSString stringWithFormat:@"%@/%@/%@", kPostIdPathPrefix, postId, [self urlEncode:title]];
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

+ (NSString*)mobileYouTubeURL:(NSString*)url {
  if (url) {
    NSArray* pic = [url componentsSeparatedByString:@"desktop_uri="];
    if ([pic count] > 1) {
      return [(NSString*)[pic objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:kCFStringEncodingUTF8];
    }
  }
  return nil;
}

+ (NSString*)fullPostId:(NSString*)postId andFeedId:(NSString*)feedId {
	if ([postId isMatchedByRegex:@"_"]) {
		return postId;
	}
	else {
		return [NSString stringWithFormat:@"%@_%@", feedId, postId];
	}
}

@end
