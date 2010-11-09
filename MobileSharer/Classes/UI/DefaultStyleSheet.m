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
  return RGBACOLOR(11, 21, 41, 0.4);
}

- (UIColor*)darkColor {
  return RGBCOLOR(11, 21, 41);
}

- (UIColor*)mediumColor {
  return RGBCOLOR(111, 121, 141);
}

- (UIColor*)lightColor {
  return RGBCOLOR(247, 247, 247);
}


#pragma mark -
#pragma mark views

- (UIColor*)navigationBarTintColor {
  return [self darkColor];
}

#pragma mark -
#pragma mark table cells
- (TTStyle*)avatar {
  return
  [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:5] next:
   [TTSolidBorderStyle styleWithColor:[self darkColor] width:0.5 next:
    [TTContentStyle styleWithNext:nil]]];
}

- (TTStyle*)tablePostImage {
  return [TTContentStyle styleWithNext:nil];
}


- (UIFont*)tableFont {
  return [UIFont systemFontOfSize:14];
}

- (UIColor*)tableSubTextColor {
  return [self mediumColor];
}

- (UIFont*)tableTimestampFont {
  return [UIFont systemFontOfSize:12];
}

- (UIColor*)timestampTextColor {
  return RGBCOLOR(11, 91, 216);
}

- (UIFont*)tableTitleFont {
  return [UIFont boldSystemFontOfSize:14];
}

- (UIColor*)tableTitleTextColor {
  return [self darkColor];
}

- (TTTextStyle*)tableTitleText {
  return [TTTextStyle styleWithFont:TTSTYLEVAR(tableTitleFont) color:TTSTYLEVAR(tableTitleTextColor) next:nil];
}

- (TTTextStyle*)tableSubText {
  return [TTTextStyle styleWithFont:TTSTYLEVAR(tableFont) color:TTSTYLEVAR(tableSubTextColor) next:nil];
}

@end
