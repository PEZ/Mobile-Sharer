//
//  FeedModelBase.h
//  
//
//  Created by Peter Stromberg on 2011-08-30.
//  Copyright 2011 NA. All rights reserved.
//

#import "FacebookModel.h"

@interface FeedModelBase : TTURLRequestModel

@property (nonatomic, retain)   NSMutableArray*  posts;

- (NSArray*)entriesFromResponse:(TTURLJSONResponse*)response;
- (void)addEntry:(NSDictionary *)entry toPosts:(NSMutableArray *)posts;

@end
