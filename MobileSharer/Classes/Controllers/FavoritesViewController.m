//
//  FavoritesViewController.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-08-30.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "FavoritesViewController.h"

@implementation FavoritesViewController


- (id)initWithName:(NSString *)name {
  if ((self = [super initWithNibName:nil bundle:nil])) {
    self.title = name;
    self.variableHeightRows = YES;
  }
  return self;
}

@end
