//
//  NSStringCategory.m
//  DELETEME
//
//  Created by Mike on 5/6/10.
//  Copyright 2010 Prime31 Studios. All rights reserved.
//

#import "NSStringCategory.h"


@implementation NSString(Category)


- (NSString*)stringByURLEncodingStringParameter
{
	// NSURL's stringByAddingPercentEscapesUsingEncoding: does not escape
	// some characters that should be escaped in URL parameters, like / and ?; 
	// we'll use CFURL to force the encoding of those
	//
	// We'll explicitly leave spaces unescaped now, and replace them with +'s
	//
	// Reference: http://www.ietf.org/rfc/rfc3986.txt
	
	NSString *resultStr = self;
	
	CFStringRef originalString = (CFStringRef) self;
	CFStringRef leaveUnescaped = CFSTR(" ");
	CFStringRef forceEscaped = CFSTR("!*'();:@&=+$,/?%#[]");
	
	CFStringRef escapedStr;
	escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
														 originalString,
														 leaveUnescaped, 
														 forceEscaped,
														 kCFStringEncodingUTF8);
	
	if( escapedStr )
	{
		NSMutableString *mutableStr = [NSMutableString stringWithString:(NSString *)escapedStr];
		CFRelease(escapedStr);
		
		// replace spaces with plusses
		[mutableStr replaceOccurrencesOfString:@" "
									withString:@"%20"
									   options:0
										 range:NSMakeRange(0, [mutableStr length])];
		resultStr = mutableStr;
	}
	return resultStr;
}


- (NSString*)stringByDecodingHTMLEntitiesManually
{
	NSRange ampRange = [self rangeOfString:@"&"];
	
	if( ampRange.location == NSNotFound )
	{
		return self;
	}
	else
	{
		
		NSMutableString *escaped = [NSMutableString stringWithString:self];
		
		NSArray *entities = [NSArray arrayWithObjects: 
							 @"&amp;", @"&lt;", @"&gt;", @"&quot;",
							 /* 160 = nbsp */
							 @"&nbsp;", @"&iexcl;", @"&cent;", @"&pound;", @"&curren;", @"&yen;", @"&brvbar;",
							 @"&sect;", @"&uml;", @"&copy;", @"&ordf;", @"&laquo;", @"&not;", @"&shy;", @"&reg;",
							 @"&macr;", @"&deg;", @"&plusmn;", @"&sup2;", @"&sup3;", @"&acute;", @"&micro;",
							 @"&para;", @"&middot;", @"&cedil;", @"&sup1;", @"&ordm;", @"&raquo;", @"&frac14;",
							 @"&frac12;", @"&frac34;", @"&iquest;", @"&Agrave;", @"&Aacute;", @"&Acirc;",
							 @"&Atilde;", @"&Auml;", @"&Aring;", @"&AElig;", @"&Ccedil;", @"&Egrave;",
							 @"&Eacute;", @"&Ecirc;", @"&Euml;", @"&Igrave;", @"&Iacute;", @"&Icirc;", @"&Iuml;",
							 @"&ETH;", @"&Ntilde;", @"&Ograve;", @"&Oacute;", @"&Ocirc;", @"&Otilde;", @"&Ouml;",
							 @"&times;", @"&Oslash;", @"&Ugrave;", @"&Uacute;", @"&Ucirc;", @"&Uuml;", @"&Yacute;",
							 @"&THORN;", @"&szlig;", @"&agrave;", @"&aacute;", @"&acirc;", @"&atilde;", @"&auml;",
							 @"&aring;", @"&aelig;", @"&ccedil;", @"&egrave;", @"&eacute;", @"&ecirc;", @"&euml;",
							 @"&igrave;", @"&iacute;", @"&icirc;", @"&iuml;", @"&eth;", @"&ntilde;", @"&ograve;",
							 @"&oacute;", @"&ocirc;", @"&otilde;", @"&ouml;", @"&divide;", @"&oslash;", @"&ugrave;",
							 @"&uacute;", @"&ucirc;", @"&uuml;", @"&yacute;", @"&thorn;", @"&yuml;", nil];
		
		NSArray *characters = [NSArray arrayWithObjects:@"&", @"<", @">", @"\"", nil];
		
		int i, count = [entities count], characterCount = [characters count];
		
		// Html
		for( i = 0; i < count; i++ )
		{
			NSRange range = [self rangeOfString: [entities objectAtIndex:i]];
			if( range.location != NSNotFound )
			{
				if( i < characterCount )
				{
					[escaped replaceOccurrencesOfString:[entities objectAtIndex: i] 
											 withString:[characters objectAtIndex:i] 
												options:NSLiteralSearch 
												  range:NSMakeRange(0, [escaped length])];
				}
				else
				{
					[escaped replaceOccurrencesOfString:[entities objectAtIndex: i] 
											 withString:[NSString stringWithFormat: @"%C", (160-characterCount) + i] 
												options:NSLiteralSearch 
												  range:NSMakeRange(0, [escaped length])];
				}
			}
		}
		
		// Decimal & Hex
		NSRange start, finish, searchRange = NSMakeRange(0, [escaped length]);
		i = 0;
		
		while( i < [escaped length] )
		{
			start = [escaped rangeOfString: @"&#" 
								   options: NSCaseInsensitiveSearch 
									 range: searchRange];
			
			finish = [escaped rangeOfString: @";" 
									options: NSCaseInsensitiveSearch 
									  range: searchRange];
			
			if( start.location != NSNotFound && finish.location != NSNotFound &&
			   finish.location > start.location )
			{
				NSRange entityRange = NSMakeRange(start.location, (finish.location - start.location) + 1);
				NSString *entity = [escaped substringWithRange: entityRange];     
				NSString *value = [entity substringWithRange: NSMakeRange(2, [entity length] - 2)];
				
				[escaped deleteCharactersInRange: entityRange];
				
				if( [value hasPrefix: @"x"] )
				{
					unsigned tempInt = 0;
					NSScanner *scanner = [NSScanner scannerWithString: [value substringFromIndex: 1]];
					[scanner scanHexInt: &tempInt];
					[escaped insertString: [NSString stringWithFormat: @"%C", tempInt] atIndex: entityRange.location];
				}
				else
				{
					[escaped insertString: [NSString stringWithFormat: @"%C", [value intValue]] atIndex: entityRange.location];
				}
				i = start.location;
			}
			else i++;
			searchRange = NSMakeRange( i, [escaped length] - i );
		}
		
		return escaped;    // Note this is autoreleased
	}
}

@end
