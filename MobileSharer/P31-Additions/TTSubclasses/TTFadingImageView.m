//
//  TTFadeingImageView.m
//  P31-Additions
//
//  Created by Mike DeSaro on 7/8/10.
//  Copyright 2010 FreedomVOICE. All rights reserved.
//

#import "TTFadingImageView.h"


@implementation TTFadingImageView

- (void)imageViewDidStartLoad
{
	self.alpha = 0.0f;
}


- (void)imageViewDidLoadImage:(UIImage*)image
{
	[UIView beginAnimations:nil context:NULL];
	self.alpha = 1.0f;
	[UIView commitAnimations];
}

@end
