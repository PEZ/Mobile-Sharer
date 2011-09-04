//
//  FavoriteAdder.h
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-09-04.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//
#import "FavoriteUpdaterBase.h"

@protocol FavoriteAdderDelegate <FavoriteUpdaterDelegate>
- (void)addingFavoriteDone;
- (void)request:(TTURLRequest*)request addingFavoriteError:(NSError*)error;
@end

#import "FavoriteUpdaterBase.h"

@interface FavoriteAdder : FavoriteUpdaterBase <TTURLRequestDelegate> {
  @private
  NSString* _authorId;
}

- (id)initWithPostId:(NSString*)postId andUserId:(NSString*)userId andAuthorId:authorId
           andSecret:(NSString*)secret andDelegate:(id<FavoriteUpdaterDelegate>)delegate;

- (void)add;
@end