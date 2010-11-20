//
//  DefaultStyleSheet.m
//  Mini Collector
//
//  Created by PEZ on 2010-08-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DefaultStyleSheet.h"


@implementation DefaultStyleSheet

- (UIColor*)darkColorA {
  return RGBACOLOR(31, 31, 31, 0.4);
}

- (UIColor*)darkColor {
  return RGBCOLOR(31, 31, 31);
}

- (UIColor*)mediumColor {
  return RGBCOLOR(121, 121, 121);
}

- (UIColor*)toolbarTintColor {
  return RGBCOLOR(171, 171, 171);
}

- (UIColor*)lightColor {
  return RGBCOLOR(247, 247, 247);
}


#pragma mark -
#pragma mark views

//- (UIColor*)navigationBarTintColor {
//  return [self darkColor];
//}

#pragma mark -
#pragma mark table cells
- (TTStyle*)avatar {
  return
  [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:5] next:
   [TTSolidBorderStyle styleWithColor:[self darkColor] width:0.5 next:
    [TTContentStyle styleWithNext:nil]]];
}

- (TTBoxStyle*)tablePostImage {
  return [TTBoxStyle styleWithMargin:UIEdgeInsetsMake(0, 0, 0, 5)
                             padding:UIEdgeInsetsMake(0, 0, 0, 0)
                             minSize:CGSizeZero position:TTPositionFloatLeft next:
                       nil];
}


- (UIFont*)tableFont {
  return [UIFont systemFontOfSize:14];
}

- (UIColor*)tableSubTextColor {
  return [self mediumColor];
}

- (UIFont*)tableMetaFont {
  return [UIFont systemFontOfSize:12];
}

- (UIColor*)tableMetaTextColor {
  return RGBCOLOR(11, 91, 216);
}

- (UIFont*)tableTitleFont {
  return [UIFont boldSystemFontOfSize:14];
}

- (UIColor*)tableTitleTextColor {
  return [self darkColor];
}

- (UIColor*)tableTextColor {
  return [self darkColor];
}

- (TTTextStyle*)tableTitleText {
  return [TTTextStyle styleWithFont:TTSTYLEVAR(tableTitleFont) color:TTSTYLEVAR(tableTitleTextColor) next:nil];
}

- (TTTextStyle*)tableText {
  return [TTTextStyle styleWithFont:TTSTYLEVAR(tableFont) color:TTSTYLEVAR(tableTextColor) next:nil];
}

- (TTTextStyle*)tableMetaText {
  return [TTTextStyle styleWithFont:TTSTYLEVAR(tableMetaFont) color:TTSTYLEVAR(tableMetaTextColor) next:nil];
}

- (TTTextStyle*)tableSubText {
  return [TTTextStyle styleWithFont:TTSTYLEVAR(tableFont) color:TTSTYLEVAR(tableSubTextColor) next:nil];
}

@end
