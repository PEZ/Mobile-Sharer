//
//  NSStringCategory.h
//  DELETEME
//
//  Created by Mike on 5/6/10.
//  Copyright 2010 Prime31 Studios. All rights reserved.
//


@interface NSString(Category)

/**
 * URL encodes a string
 */
- (NSString*)stringByURLEncodingStringParameter;


/**
 * Decodes any HTML entities manually
 */
- (NSString*)stringByDecodingHTMLEntitiesManually;

@end
