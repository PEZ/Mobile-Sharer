//
//  FavoriteRemover.h
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-09-05.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "FavoriteUpdaterBase.h"

@protocol FavoriteRemoverDelegate <FavoriteUpdaterDelegate>
- (void)removingFavoriteDone;
- (void)request:(TTURLRequest*)request removingFavoriteError:(NSError*)error;
@end

@interface FavoriteRemover : FavoriteUpdaterBase <TTURLRequestDelegate> {
}

- (void)remove;
@end