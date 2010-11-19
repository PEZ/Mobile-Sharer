//
//  DefaultStyleSheet.h
//  Mini Collector
//
//  Created by PEZ on 2010-08-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Three20Style/TTStyleSheet.h>
#import <Three20Style/TTDefaultStyleSheet.h>

@interface DefaultStyleSheet : TTDefaultStyleSheet

- (UIFont*)tableTimestampFont;
- (TTTextStyle*)tableText;
- (TTTextStyle*)tableTitleText;
- (TTTextStyle*)tableSubText;
- (UIColor*)tableTextColor;
- (UIColor*)darkColor;
- (UIColor*)mediumColor;
- (UIColor*)lightColor;

@end

