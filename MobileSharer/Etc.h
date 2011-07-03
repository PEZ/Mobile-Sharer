//
//  Etcetera.h
//  MobileSharer
//
//  Created by PEZ on 2010-10-23.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "Post.h"

extern CGFloat   kAvatarImageWidth;
extern CGFloat   kAvatarImageHeight;
extern CGFloat   kIconImageWidth;
extern CGFloat   kIconImageHeight;

extern NSString* kNavPathPrefix;
extern NSString* kFeedURLPath;
extern NSString* kNotificationsURLPath;
extern NSString* kConnectionsPathPrefix;
extern NSString* kConnectionsURLPath;
extern NSString* kPostPathPrefix;
extern NSString* kPostIdPathPrefix;
extern NSString* kPostIdPath;
extern NSString* kAppStartURLPath;
extern NSString* kFacebookLoginPath;
extern NSString* kCommentPath;

extern NSString* kAppStoreId;

@interface Etc : NSObject {
}

+ (NSString*) xmlEscape:(NSString*)unescapedString;
+ (NSString*) urlEncode:(NSString*)unencodedString;

+ (NSString *) toFeedURLPath:(NSString *)feedId name:(NSString *)name;
+ (NSString*) toConnectionsURLPath:(NSString*)connectionsPath andName:(NSString*)name;
+ (NSString *) toPhotoURLPath:(NSString *)photoId;
+ (NSString*) toPostIdPath:(NSString*)postId andTitle:(NSString*)title;

+ (NSMutableDictionary*)params:(NSMutableDictionary**)params addObject:(id)object forKey:(id)key;
+ (NSString*)pictureURL:(NSString*)url;
+ (NSString*)mobileYouTubeURL:(NSString*)url;
+ (NSString*)fullPostId:(NSString*)postId andFeedId:(NSString*)feedId;

@end
