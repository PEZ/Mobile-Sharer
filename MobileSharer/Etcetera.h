//
//  Etcetera.h
//  MobileSharer
//
//  Created by PEZ on 2010-10-23.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "Post.h"

extern NSString* kNavPathPrefix;
extern NSString* kFeedURLPath;
extern NSString* kPostPathPrefix;
extern NSString* kPostPath;
extern NSString* kPostIdPathPrefix;
extern NSString* kPostIdPath;
extern NSString* kAppLoginURLPath;
extern NSString* kFacebookLoginPath;
extern NSString* kCommentPath;

@interface Etcetera : NSObject {
}

+ (NSString*) urlEncode:(NSString*)unencodedString;

+ (NSString *) toFeedURLPath:(NSString *)feedId name:(NSString *)name;
+ (NSString *) toPostPath:(Post*)post;
+ (NSString *) toPostIdPath:(NSString*)postId;

+ (NSMutableDictionary*)params:(NSMutableDictionary**)params addObject:(id)object forKey:(id)key;
+ (NSString*)pictureURL:(NSString*)url;

@end