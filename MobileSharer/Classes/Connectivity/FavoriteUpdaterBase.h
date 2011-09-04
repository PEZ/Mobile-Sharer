//
//  FavoriteUpdaterBase.h
//  
//
//  Created by Peter Stromberg on 2011-09-04.
//  Copyright 2011 NA. All rights reserved.
//
#import "FavoritesSettings.h"

@protocol FavoriteUpdaterDelegate <NSObject>
@end


@interface FavoriteUpdaterBase : NSObject {
@protected
  NSString* _postId;
  NSString* _userId;
  NSString* _secret;
  id<FavoriteUpdaterDelegate> _delegate;
}

@property (nonatomic) BOOL isLoading;

- (id)initWithPostId:(NSString*)postId andUserId:(NSString*)userId andSecret:(NSString*)secret andDelegate:(id<FavoriteUpdaterDelegate>)delegate;

@end
