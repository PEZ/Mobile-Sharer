//
//  TTLauncherViewCategory.m
//  DELETEME
//
//  Created by Mike on 5/6/10.
//  Copyright 2010 Prime31 Studios. All rights reserved.
//

#import "TTLauncherViewCategory.h"
#import "Three20UI/TTLauncherButton.h"


@interface TTLauncherView(Private)
- (void)startDraggingButton:(TTLauncherButton*)button withEvent:(UIEvent*)event;
@end



@implementation TTLauncherView(Category)

- (void)editHoldTimer:(NSTimer*)timer
{
	_editHoldTimer = nil;
	
	if( [_delegate respondsToSelector:@selector(launcherViewShouldBeginEditing:)] ) // P31 Addition
	{
		if( ![_delegate performSelector:@selector(launcherViewShouldBeginEditing:) withObject:self] )
			return;
	}
	
	[self beginEditing];
	
	TTUserInfo* info = timer.userInfo;
	TTLauncherButton* button = info.weakRef;
	UIEvent* event = info.strongRef;
	
	button.selected = NO;
	button.highlighted = NO;
	[self startDraggingButton:button withEvent:event];
}

@end
