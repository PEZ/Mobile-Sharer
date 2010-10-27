//
//  TTFadingButtonContent.m
//  P31-Additions
//
//  Created by Mike DeSaro on 7/8/10.
//  Copyright 2010 FreedomVOICE. All rights reserved.
//

#import "TTFadingButtonContent.h"


@implementation TTFadingButtonContent

- (void)requestDidStartLoad:(TTURLRequest*)request
{
	[super requestDidStartLoad:request];
	
	_button.alpha = 0.0f;
}


- (void)requestDidFinishLoad:(TTURLRequest*)request
{
	[super requestDidFinishLoad:request];
	
	[UIView beginAnimations:nil context:NULL];
	_button.alpha = 1.0f;
	[UIView commitAnimations];
}


- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error
{
	[super request:request didFailLoadWithError:error];
	
	_button.alpha = 1.0f;
}


- (void)requestDidCancelLoad:(TTURLRequest*)request
{
	[super requestDidCancelLoad:request];
	
	_button.alpha = 1.0f;
}

@end
