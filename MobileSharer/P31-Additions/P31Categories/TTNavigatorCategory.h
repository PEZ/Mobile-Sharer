//
//  NSStringCategory.h
//  DELETEME
//
//  Created by Mike on 5/6/10.
//  Copyright 2010 Prime31 Studios. All rights reserved.
//


@interface TTNavigator(Category)

/**
 * Shortcut for calling [[TTNavigator navigator] openURL:query:animated:]
 */
UIViewController *TTOpenURLWithQuery( NSString *URL, NSDictionary *query, BOOL animated );


@end
