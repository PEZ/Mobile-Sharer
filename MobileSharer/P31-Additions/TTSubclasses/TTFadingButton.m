//
//  TTFadingButton.m
//  P31-Additions
//
//  Created by Mike DeSaro on 7/8/10.
//  Copyright 2010 FreedomVOICE. All rights reserved.
//

#import "TTFadingButton.h"
#import "TTFadingButtonContent.h"


@interface TTButton()
- (id)keyForState:(UIControlState)state;
@end



@implementation TTFadingButton

+ (TTButton*)buttonWithStyle:(NSString*)selector
{
	TTFadingButton* button = [[[TTFadingButton alloc] init] autorelease];
	[button setStylesWithSelector:selector];
	return button;
}


- (TTButtonContent*)contentForState:(UIControlState)state
{
	if( !_content )
		_content = [[NSMutableDictionary alloc] init];
	
	id key = [self keyForState:state];
	TTButtonContent* content = [_content objectForKey:key];
	if( !content )
	{
		content = [[[TTFadingButtonContent alloc] initWithButton:self] autorelease];
		[_content setObject:content forKey:key];
	}
	
	return content;
}

@end
