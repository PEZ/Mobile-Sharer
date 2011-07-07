//
//  DefaultStyleSheet.m
//  Mini Collector
//
//  Created by PEZ on 2010-08-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DefaultStyleSheet.h"


@implementation DefaultStyleSheet

#pragma mark -
#pragma mark colors

- (UIColor*)darkColorA {
  return RGBACOLOR(31, 31, 31, 0.4);
}

- (UIColor*)darkColor {
  return RGBCOLOR(31, 31, 31);
}

- (UIColor*)mediumColor {
  return RGBCOLOR(121, 121, 121);
}

- (UIColor*)lightColor {
  return RGBCOLOR(247, 247, 247);
}

- (UIColor*)toolbarTintColor {
  return RGBACOLOR(100, 122, 152, 0.95);
}

- (UIColor*)navigationBarTintColor {
  return RGBACOLOR(100, 122, 152, 0.95);
}

- (UIColor*)tabBarTintColor {
  return RGBACOLOR(100, 122, 152, 0.95);
}

- (UIColor*)notificationColor {
  return RGBACOLOR(10, 20, 40, 0.07);
}

#pragma mark -
#pragma mark buttons

- (UIFont*)commentLikeButtonFont {
  return [UIFont systemFontOfSize:12];
}

- (TTTextStyle*)commentLikeButton {
  return [TTTextStyle styleWithFont:TTSTYLEVAR(commentLikeButtonFont) color:TTSTYLEVAR(linkTextColor) next:
           nil];
}

- (TTShapeStyle*)defaultButton:(UIControlState)state {
  if (state == UIControlStateNormal) {
    return
    [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:8] next:
     [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, 0, 1, 0) next:
      [TTShadowStyle styleWithColor:RGBACOLOR(255,255,255,0) blur:1 offset:CGSizeMake(0, 1) next:
       [TTLinearGradientFillStyle styleWithColor1:RGBCOLOR(255, 255, 255)
                                           color2:RGBCOLOR(216, 221, 231) next:
        [TTSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 next:
         [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(10, 12, 9, 12) next:
          [TTTextStyle styleWithFont:nil color:TTSTYLEVAR(linkTextColor)
                         shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                        shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
  } else if (state == UIControlStateHighlighted) {
    return
    [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:8] next:
     [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, 0, 1, 0) next:
      [TTShadowStyle styleWithColor:RGBACOLOR(255,255,255,0.9) blur:1 offset:CGSizeMake(0, 1) next:
       [TTLinearGradientFillStyle styleWithColor1:RGBCOLOR(225, 225, 225)
                                           color2:RGBCOLOR(196, 201, 221) next:
        [TTSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 next:
         [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(10, 12, 9, 12) next:
          [TTTextStyle styleWithFont:nil color:[UIColor whiteColor]
                         shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                        shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
  } else {
    return nil;
  }
}

- (TTStyle*)forwardButton:(UIControlState)state {
  TTShape* shape = [TTRoundedRightArrowShape shapeWithRadius:4.5];
  //UIColor* tintColor = RGBCOLOR(0, 0, 0);
  return [TTSTYLESHEET toolbarButtonForState:state shape:shape tintColor:TTSTYLEVAR(toolbarTintColor) font:nil];
}

- (TTShapeStyle *) avatar {
  return [TTShapeStyle styleWithShape:[TTRectangleShape shape] next:
          [TTSolidBorderStyle styleWithColor:[self darkColor] width:0.5 next:
           [TTContentStyle styleWithNext:nil]]];
  
}

#pragma mark -
#pragma mark table cells

- (TTStyle*)feedAvatar {
  return [TTBoxStyle styleWithMargin:UIEdgeInsetsMake(kTableCellSmallMargin, kTableCellSmallMargin, kTableCellSmallMargin, 0)
                             padding:UIEdgeInsetsZero
                             minSize:CGSizeZero
                            position:TTPositionAbsolute
                                next:[self avatar]];
}

- (TTStyle*)tableMessageContentStyle:(BOOL)hasDisclosure {
  return [TTBoxStyle styleWithMargin:UIEdgeInsetsMake(kTableCellSmallMargin,
                                                      kAvatarImageWidth + kTableCellSmallMargin * 2,
                                                      kTableCellSmallMargin,
                                                      kTableCellSmallMargin + hasDisclosure ? kDisclosureWidth : 0)
                             padding:UIEdgeInsetsZero
                             minSize:CGSizeZero
                            position:TTPositionStatic
                                next:nil];
}

- (TTStyle*)tableMessageContent {
  return [self tableMessageContentStyle:NO];
}

- (TTStyle*)tableMessageContentWithDisclosure {
  return [self tableMessageContentStyle:YES];
}


- (TTStyle*)tableCellNewNotification {
  return [TTBoxStyle styleWithMargin:UIEdgeInsetsZero next:
          [TTSolidFillStyle styleWithColor:[self notificationColor] next:
           nil]];
}

- (TTBoxStyle*)tablePostImage {
  return [TTBoxStyle styleWithMargin:UIEdgeInsetsMake(0, 0, 0, 5)
                             padding:UIEdgeInsetsMake(0, 0, 0, 0)
                             minSize:CGSizeZero position:TTPositionStatic next:
                       nil];
}

- (TTBoxStyle*)articleImage {
  return [TTBoxStyle styleWithMargin:UIEdgeInsetsMake(0, kTableCellSmallMargin, kTableCellSmallMargin, 0)
                             padding:UIEdgeInsetsZero
                             minSize:CGSizeZero
                            position:TTPositionFloatRight
                                next:nil];
}

- (TTBoxStyle*)tableAttachmentText {
  return [TTBoxStyle styleWithFloats:TTPositionStatic next:nil];
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
  return [self tableSubTextColor];
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

- (TTBoxStyle*)appInfo {
  return [TTBoxStyle styleWithMargin:UIEdgeInsetsMake(kTableCellSmallMargin, kTableCellSmallMargin, kTableCellSmallMargin, kTableCellSmallMargin)
                             padding:UIEdgeInsetsZero
                             minSize:CGSizeZero
                            position:TTPositionStatic next:nil];
}

- (TTBoxStyle*)tableMetaText {
  return [TTBoxStyle styleWithMargin:UIEdgeInsetsMake(kTableCellSmallMargin, 0, 0, kTableCellSmallMargin) next:
          [TTTextStyle styleWithFont:TTSTYLEVAR(tableMetaFont) color:TTSTYLEVAR(tableMetaTextColor) next:
           nil]];
}

- (TTBoxStyle*)tableMetaIcon {
  return [TTBoxStyle styleWithMargin:UIEdgeInsetsMake(0, 0, 0, kTableCellSmallMargin)
                             padding:UIEdgeInsetsZero
                             minSize:CGSizeZero
                            position:TTPositionStatic next:nil];
}


- (TTTextStyle*)tableSubText {
  return [TTTextStyle styleWithFont:TTSTYLEVAR(tableFont) color:TTSTYLEVAR(tableSubTextColor) next:nil];
}

@end
