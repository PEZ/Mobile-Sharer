
#import "Atlas.h"

NSString* kNavPathPrefix = @"ms://feed";
NSString* kFeedURLPath = @"ms://feed/(initWithFBFeedIdAndName:)/(name:)";
NSString* kAppLoginURLPath = @"ms://login";

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

@end