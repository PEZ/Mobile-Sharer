//
//  FacebookModel.h
//  MobileSharer
//
//  Created by PEZ on 2010-11-16.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "Post.h"
#import "FBConnect.h"

@interface FacebookModel : TTURLRequestModel {

}

+ (Post*) createPostFromEntry:(NSDictionary*)entry;
+ (TTURLRequest*)createRequest:(FBRequest*)fbRequest cachePolicy:(TTURLRequestCachePolicy)cachePolicy delegate:(id<TTURLRequestDelegate>)delegate;

@end
