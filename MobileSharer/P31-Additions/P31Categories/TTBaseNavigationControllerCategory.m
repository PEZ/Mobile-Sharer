//
//  TTBaseNavigationControllerCategory.m
//  P31-Additions
//
//  Created by Mike on 6/5/10.
//  Copyright 2010 Prime31 Studios. All rights reserved.
//

#import "TTBaseNavigationControllerCategory.h"


@implementation TTBaseNavigationController(Category)

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTBaseNavigationController overrides

- (void)pushViewController:(UIViewController*)controller animatedWithTransition:(UIViewAnimationTransition)transition
{
	[self pushViewController:controller animated:NO];
	
	// Are we adding a standard UIViewAnimationTransition or custom? (custom will be 10 or greater)
	if( transition < 10 )
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:ttkDefaultFlipTransitionDuration];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
		[UIView setAnimationTransition:transition forView:self.view cache:YES];
		[UIView commitAnimations];
	}
	else
	{
		switch( transition )
		{
			case kUIViewAnimationTransitionZoomIn:
			{
				// Create a keyframe animation to zoom in/out
				CAKeyframeAnimation *zoomIn = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
				zoomIn.delegate = self;
				zoomIn.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:1.0], nil];
				zoomIn.duration = ttkDefaultTransitionDuration;
				[controller.view.layer addAnimation:zoomIn forKey:@"transformScale"];
				
				break;
			}
			case kUIViewAnimationTransitionZoomOut:
			{
				// Create a keyframe animation to zoom in/out
				CAKeyframeAnimation *zoomOut = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
				zoomOut.delegate = self;
				zoomOut.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0], [NSNumber numberWithFloat:0.0], nil];
				zoomOut.duration = ttkDefaultTransitionDuration;
				[controller.view.layer addAnimation:zoomOut forKey:@"transformScale"];
				
				break;
			}
			case kUIViewAnimationTransitionFadeIn:
			{
				// Create a fade animation and apply it to the superview's layer
				CATransition *animation = [CATransition animation];
				[animation setType:kCATransitionFade];
				[self.view.superview.layer addAnimation:animation forKey:@"layerAnimation"];
				
				break;
			}
			case kUIViewAnimationTransitionFadeOut:
			{
				// Create a fade animation and apply it to the superview's layer
				CATransition *animation = [CATransition animation];
				[animation setType:kCATransitionFade];
				[self.view.superview.layer addAnimation:animation forKey:@"layerAnimation"];
				
				break;
			}
			case kUIViewAnimationTransitionMoveIn:
			case kUIViewAnimationTransitionMoveOut:
			{
				// Create a fade animation and apply it to the superview's layer
				CATransition *animation = [CATransition animation];
				[animation setType:kCATransitionMoveIn];
				[self.view.superview.layer addAnimation:animation forKey:@"layerAnimation"];
				
				break;
			}
			case kUIViewAnimationTransitionPushIn:
			case kUIViewAnimationTransitionPushOut:
			{
				// Create a fade animation and apply it to the superview's layer
				CATransition *animation = [CATransition animation];
				[animation setType:kCATransitionPush];
				[self.view.superview.layer addAnimation:animation forKey:@"layerAnimation"];
				
				break;
			}
			case kUIViewAnimationTransitionRevealIn:
			case kUIViewAnimationTransitionRevealOut:
			{
				// Create a fade animation and apply it to the superview's layer
				CATransition *animation = [CATransition animation];
				[animation setType:kCATransitionReveal];
				[animation setSubtype:kCATransitionFromTop];
				[self.view.superview.layer addAnimation:animation forKey:@"layerAnimation"];
				
				break;
			}
		}
	}
}


- (UIViewController*)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition
{
	// Don't pop the viewController yet because if we are zooming it out, we need it to stick around
	UIViewController *poppedController = [self.viewControllers lastObject];
	
	// Are we popping a standard UIViewAnimationTransition or custom? (custom will be 10 or greater)
	if( transition < 10 )
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:ttkDefaultFlipTransitionDuration];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
		[UIView setAnimationTransition:transition forView:self.view cache:NO];
		[UIView commitAnimations];
	}
	else
	{
		switch( transition )
		{
			case kUIViewAnimationTransitionZoomIn:
			{
				// Create a keyframe animation to zoom in/out
				CAKeyframeAnimation *zoomIn = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
				zoomIn.delegate = self;
				zoomIn.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.01], [NSNumber numberWithFloat:1.0], nil];
				zoomIn.duration = ttkDefaultTransitionDuration;
				[poppedController.view.layer addAnimation:zoomIn forKey:@"transformScale"];
				
				break;
			}
			case kUIViewAnimationTransitionZoomOut:
			{
				// Create a keyframe animation to zoom in/out
				CAKeyframeAnimation *zoomOut = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
				zoomOut.delegate = self;
				zoomOut.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0], [NSNumber numberWithFloat:0.0], nil];
				zoomOut.duration = ttkDefaultTransitionDuration;
				[poppedController.view.layer addAnimation:zoomOut forKey:@"transformScale"];
				
				// Create a fade animation and apply it to the superview's layer
				CATransition *animation = [CATransition animation];
				[animation setType:kCATransitionFade];
				[self.view.superview.layer addAnimation:animation forKey:@"layerAnimation"];

				break;
			}
			case kUIViewAnimationTransitionFadeIn:
			{
				// Create a fade animation and apply it to the superview's layer
				CATransition *animation = [CATransition animation];
				[animation setType:kCATransitionFade];
				[self.view.superview.layer addAnimation:animation forKey:@"layerAnimation"];

				break;
			}
			case kUIViewAnimationTransitionFadeOut:
			{
				// Create a fade animation and apply it to the superview's layer
				CATransition *animation = [CATransition animation];
				[animation setType:kCATransitionFade];
				[self.view.superview.layer addAnimation:animation forKey:@"layerAnimation"];
				
				break;
			}
			case kUIViewAnimationTransitionMoveOut:
			case kUIViewAnimationTransitionMoveIn:
			{
				// Create a fade animation and apply it to the superview's layer
				CATransition *animation = [CATransition animation];
				[animation setType:kCATransitionMoveIn];
				[animation setSubtype:kCATransitionFromRight];
				[self.view.superview.layer addAnimation:animation forKey:@"layerAnimation"];
				
				break;
			}
			case kUIViewAnimationTransitionPushIn:
			case kUIViewAnimationTransitionPushOut:
			{
				// Create a fade animation and apply it to the superview's layer
				CATransition *animation = [CATransition animation];
				[animation setType:kCATransitionPush];
				[animation setSubtype:kCATransitionFromRight];
				[self.view.superview.layer addAnimation:animation forKey:@"layerAnimation"];
				
				break;
			}
			case kUIViewAnimationTransitionRevealIn:
			case kUIViewAnimationTransitionRevealOut:
			{
				// Create a fade animation and apply it to the superview's layer
				CATransition *animation = [CATransition animation];
				[animation setType:kCATransitionReveal];
				[animation setSubtype:kCATransitionFromBottom];
				[self.view.superview.layer addAnimation:animation forKey:@"layerAnimation"];
				
				break;
			}
		}
	}
	
	// We will do the actual viewController popping after a short delay for zooms
	if( transition == kUIViewAnimationTransitionZoomIn || transition == kUIViewAnimationTransitionZoomOut )
	{
		// To ensure that the view is removed from the stack before the animation completes (to avoid flicker) pop the VC just before the animation is done
		[self performSelector:@selector(popViewControllerAnimated:) withObject:nil afterDelay:ttkDefaultTransitionDuration - 0.15];
		return poppedController;
	}
	
	return [self popViewControllerAnimated:NO];
}


- (UIViewAnimationTransition)invertTransition:(UIViewAnimationTransition)transition
{
	switch( transition )
	{
		case UIViewAnimationTransitionCurlUp:
			return UIViewAnimationTransitionCurlDown;
		case UIViewAnimationTransitionCurlDown:
			return UIViewAnimationTransitionCurlUp;
		case UIViewAnimationTransitionFlipFromLeft:
			return UIViewAnimationTransitionFlipFromRight;
		case UIViewAnimationTransitionFlipFromRight:
			return UIViewAnimationTransitionFlipFromLeft;
		
		case kUIViewAnimationTransitionZoomOut:
			return kUIViewAnimationTransitionZoomIn;
		case kUIViewAnimationTransitionZoomIn:
			return kUIViewAnimationTransitionZoomOut;
		case kUIViewAnimationTransitionFadeOut:
			return kUIViewAnimationTransitionFadeIn;
		case kUIViewAnimationTransitionFadeIn:
			return kUIViewAnimationTransitionFadeOut;
		case kUIViewAnimationTransitionMoveIn:
			return kUIViewAnimationTransitionMoveOut;
		case kUIViewAnimationTransitionMoveOut:
			return kUIViewAnimationTransitionMoveIn;
		case kUIViewAnimationTransitionPushIn:
			return kUIViewAnimationTransitionPushOut;
		case kUIViewAnimationTransitionPushOut:
			return kUIViewAnimationTransitionPushIn;
		case kUIViewAnimationTransitionRevealIn:
			return kUIViewAnimationTransitionRevealOut;
		case kUIViewAnimationTransitionRevealOut:
			return kUIViewAnimationTransitionRevealIn;
			
		default:
			return UIViewAnimationTransitionNone;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark CAAnimation Delegate

- (void)animationDidStop:(CAAnimation*)theAnimation finished:(BOOL)flag
{
	// Call the standard, UIViewTransition didStop selector
	[self pushAnimationDidStop];
}


@end
