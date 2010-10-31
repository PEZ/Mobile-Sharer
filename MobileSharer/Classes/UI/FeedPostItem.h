//
//  FeedPostItem.h
//  MobileSharer
//
//  Created by PEZ on 2010-10-30.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "Three20UI/TTTableImageItem.h"
#import "FeedPost.h"

@interface FeedPostItem : TTTableImageItem {
  NSString* _title;
  NSDate*   _timestamp;
  NSNumber* _likes;
  NSNumber* _commentCount;  
  NSString* _icon;
}

@property (nonatomic, copy)   NSString*  title;
@property (nonatomic, retain) NSDate*    timestamp;
@property (nonatomic, retain) NSNumber*  likes;
@property (nonatomic, retain) NSNumber*  commentCount;
@property (nonatomic, copy)   NSString*  icon;

+ (id)itemWithPost:(FeedPost*)post andURL:(NSString*)URL;

@end
