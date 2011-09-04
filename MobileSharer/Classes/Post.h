//
//  Post.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-08.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "StyledTableIconDataItem.h"

@interface Post : StyledTableIconDataItem {
}

@property (nonatomic, retain) NSDate*   updated;
@property (nonatomic, retain) NSString* postId;
@property (nonatomic, retain)   NSString* type;
@property (nonatomic, retain)   NSString* fromName;
@property (nonatomic, retain)   NSString* toId;
@property (nonatomic, retain)   NSString* toName;
@property (nonatomic, retain)   NSString* picture;
@property (nonatomic, retain)   NSString* linkCaption;
@property (nonatomic, retain)   NSString* linkURL;
@property (nonatomic, retain)   NSString* shareURL;
@property (nonatomic, retain)   NSString* linkTitle;
@property (nonatomic, retain)   NSString* linkText;
@property (nonatomic, retain)   NSString* source;
@property (nonatomic, retain) NSNumber* likes;
@property (nonatomic, retain) NSNumber* commentCount;
@property (nonatomic)         BOOL      canComment;
@property (nonatomic)         BOOL      canLike;
@property (nonatomic)         BOOL      isFavorite;

+ (NSString*)fullPostId:(NSString*)postId andFeedId:(NSString*)feedId;

@end
