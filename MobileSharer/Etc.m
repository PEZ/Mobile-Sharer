//
//  Etcetera.m
//  MobileSharer
//
//  Created by PEZ on 2010-10-23.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "FacebookJanitor.h"
#import "RegexKitLite.h"

CGFloat   kAvatarImageWidth   = 35;
CGFloat   kAvatarImageHeight  = 35;
CGFloat   kIconImageWidth   = 16;
CGFloat   kIconImageHeight  = 16;
CGFloat   kDisclosureWidth  = 23;

NSString* kNavPathPrefix = kUrlScheme @"://feed";
NSString* kFeedURLPath = kUrlScheme @"://feed/(initWithFBFeedId:)/(andName:)";
NSString* kFavoritesFeedPrefix = kUrlScheme @"://favorites";
NSString* kFavoritesFeedURLPath = kUrlScheme @"://favorites/(initWithName:)/(andSecret:)/(andUserId:)";
NSString* kNotificationsURLPath = kUrlScheme @"://notifications";
NSString* kConnectionsPathPrefix = kUrlScheme @"://connections";
NSString* kConnectionsURLPath = kUrlScheme @"://connections/(initWithFBConnectionsPath:)/(andName:)";
NSString* kPostIdPathPrefix = kUrlScheme @"://post";
NSString* kPostIdPath = kUrlScheme @"://post/(initWithPostId:)/(andTitle:)";
NSString* kFavoritePostIdPath = kUrlScheme @"://post/(initWithPostId:)/(andTitle:)/(isFavorite:)";
NSString* kAppStartURLPath = kUrlScheme @"://login";
NSString* kCommentPath = kUrlScheme @"://comment";

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

+ (NSString*) toFavoritesFeedURLPath:(NSString *)name andSecret:(NSString*)secret andUserId:(NSString*)userId {
  NSString* url = [NSString stringWithFormat:@"%@/%@/%@/%@",
                   kFavoritesFeedPrefix,
                   [self urlEncode:name],
                   secret,
                   userId];
  return url;
}

+ (NSString*) toConnectionsURLPath:(NSString*)connectionsPath andName:(NSString*)name {
  return [NSString stringWithFormat:@"%@/%@/%@", kConnectionsPathPrefix, connectionsPath, [self urlEncode:name]];
}

+ (NSString*) toPhotoURLPath:(NSString*)photoId {
  return [[FacebookJanitor sharedInstance].facebook
          createRequestWithGraphPath:[NSString stringWithFormat:@"%@/picture", photoId] andDelegate:nil].serializedURL;
}

+ (NSString *) toPhotoPostPathFromFBHREF:(NSString *)href {
  return [self toPostIdPath:[href stringByMatching:@"fbid=([0-9]+)" capture:1] andTitle:@"Photo"];
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
    return [(NSString*)[pic objectAtIndex:[pic count] > 1 ? 1 : 0] stringByReplacingPercentEscapesUsingEncoding:kCFStringEncodingUTF8];
  }
  return nil;
}

+ (NSString*)mobileYouTubeURL:(NSString*)url {
  if (url) {
    NSArray* pic = [url componentsSeparatedByString:@"desktop_uri="];
    return [(NSString*)[pic objectAtIndex:[pic count] > 1 ? 1 : 0] stringByReplacingPercentEscapesUsingEncoding:kCFStringEncodingUTF8];
  }
  return nil;
}

+ (NSString*)quotedMessage:(NSString*)message quoting:(NSString*)name {
  return [NSString stringWithFormat:@"“%@” (via %@)", message, name];
}

+ (void)alert:(NSString*)message withTitle:(NSString*)title {
  UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:title
                                                   message:message
                                                  delegate:nil
                                         cancelButtonTitle:TTLocalizedString(@"OK", @"")
                                         otherButtonTitles:nil] autorelease];
  [alert show];
}

+ (void)copyText:(NSString*)text {
  [UIPasteboard generalPasteboard].string = text;
  [Etc alert:text withTitle:@"Ready to paste:"];  
}

@end
