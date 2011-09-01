//
//  FeedDataSourceBase.h
//  
//
//  Created by Peter Stromberg on 2011-09-01.
//  Copyright 2011 NA. All rights reserved.
//

#import "FeedModelBase.h"

@interface FeedDataSourceBase : TTListDataSource

@property (nonatomic, retain) FeedModelBase* feedModel;

@end
