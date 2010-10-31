//
//  FeedPostItem.m
//  MobileSharer
//
//  Created by PEZ on 2010-10-30.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "FeedPostItem.h"

// Core
#import "Three20Core/TTCorePreprocessorMacros.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation FeedPostItem

@synthesize title        = _title;
@synthesize timestamp    = _timestamp;
@synthesize likes        = _likes;
@synthesize commentCount = _commentCount;
@synthesize icon         = _icon;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  TT_RELEASE_SAFELY(_title);
  TT_RELEASE_SAFELY(_timestamp);
  TT_RELEASE_SAFELY(_likes);
  TT_RELEASE_SAFELY(_commentCount);
  TT_RELEASE_SAFELY(_icon);
  
  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class public

+ (id)itemWithPost:(FeedPost*)post andURL:(NSString*)URL {
  FeedPostItem* item = [[[self alloc] init] autorelease];
  item.title = post.fromName;
  item.text = post.message;
  item.timestamp = post.created;
  item.imageURL = post.fromAvatar;
  item.imageStyle = TTSTYLE(avatar);
  item.URL = URL;
  item.likes = post.likes;
  item.commentCount = post.commentCount;
  item.icon = post.icon;
  return item;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSCoding


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder*)decoder {
  if (self = [super initWithCoder:decoder]) {
    self.title = [decoder decodeObjectForKey:@"title"];
    self.timestamp = [decoder decodeObjectForKey:@"timestamp"];
    self.imageURL = [decoder decodeObjectForKey:@"imageURL"];
    self.imageStyle = [decoder decodeObjectForKey:@"imageStyle"];
    self.URL = [decoder decodeObjectForKey:@"URL"];
    self.likes = [decoder decodeObjectForKey:@"likes"];
    self.commentCount = [decoder decodeObjectForKey:@"commentCount"];
    self.icon = [decoder decodeObjectForKey:@"icon"];
  }
  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)encodeWithCoder:(NSCoder*)encoder {
  [super encodeWithCoder:encoder];
  if (self.title) {
    [encoder encodeObject:self.title forKey:@"title"];
  }
  if (self.timestamp) {
    [encoder encodeObject:self.timestamp forKey:@"timestamp"];
  }
  if (self.imageURL) {
    [encoder encodeObject:self.imageURL forKey:@"imageURL"];
  }
  if (self.imageStyle) {
    [encoder encodeObject:self.imageURL forKey:@"imageStyle"];
  }
  if (self.URL) {
    [encoder encodeObject:self.imageURL forKey:@"URL"];
  }
  if (self.likes) {
    [encoder encodeObject:self.title forKey:@"likes"];
  }
  if (self.commentCount) {
    [encoder encodeObject:self.title forKey:@"commentCount"];
  }
  if (self.icon) {
    [encoder encodeObject:self.title forKey:@"icon"];
  }
}


@end
