
#import "Atlas.h"

NSString* kNavPathPrefix = @"ms://feed";
NSString* kFeedURLPath = @"ms://feed/(initWithFBFeedIdAndName:)/(name:)";
NSString* kPostPathPrefix = @"ms://post";
NSString* kPostPath = @"ms://post/(initWithNavigatorURL:)";
NSString* kAppLoginURLPath = @"ms://login";
NSString* kCommentPath = @"ms://comment";

NSString* urlEncode(NSString* unencodedString) {
  return (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                             (CFStringRef)unencodedString,
                                                             NULL,
                                                             (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                             kCFStringEncodingUTF8 );
}

@implementation Atlas

+ (NSString *) toFeedURLPath:(NSString *)feedId name:(NSString *)name {
  NSString* url = [NSString stringWithFormat:@"%@/%@/%@",
                   kNavPathPrefix,
                   feedId,
                   urlEncode(name)];
  NSLog(@"%@", url);
  return url;
}

+ (NSString *) toPostPath:(Post *)post {
  NSString* url = [NSString stringWithFormat:@"%@/%@",
                   kPostPathPrefix,
                   post.postId];
  NSLog(@"%@", url);
  return url;
}

@end