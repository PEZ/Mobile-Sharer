//
//  NSStringCategory.m
//  DELETEME
//
//  Created by Mike on 5/6/10.
//  Copyright 2010 Prime31 Studios. All rights reserved.
//

#import "NSStringCategory.h"


@implementation TTNavigator(Category)


UIViewController *TTOpenURLWithQuery( NSString *URL, NSDictionary *query, BOOL animated )
{
	return [[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:URL]
													applyQuery:query]
												   applyAnimated:animated]];
}

@end
