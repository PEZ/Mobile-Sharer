//
//  FeedModel.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-08.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "FacebookModel.h"

@interface FeedModel : TTURLRequestModel {
  NSString* _feedId;
  NSArray*  _posts;
}

@property (nonatomic, retain)   NSString* feedId;
@property (nonatomic, retain)   NSArray*  posts;

- (id)initWithFeedId:(NSString*)feedId;

@end
