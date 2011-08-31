//
//  FeedModel.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-08.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "FacebookModel.h"

#import "FeedModelBase.h"

@interface FeedModel : FeedModelBase {
}

@property (nonatomic, retain)   NSString* feedId;

- (id)initWithFeedId:(NSString*)feedId;

@end
