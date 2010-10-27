//
//  TTTableViewCategory.m
//  DELETEME
//
//  Created by Mike on 5/6/10.
//  Copyright 2010 Prime31 Studios. All rights reserved.
//

#import "TTTableViewCategory.h"

static BOOL _styledLabelLinkSelectionOnly = NO;

@implementation TTTableView(Category)

- (void)setStyledLabelLinkSelectionOnly:(BOOL)newLinkSelectionOnly
{
	_styledLabelLinkSelectionOnly = newLinkSelectionOnly;
}


- (BOOL)styledLabelLinkSelectionOnly
{
	return _styledLabelLinkSelectionOnly;
}


- (void)setHighlightedLabel:(TTStyledTextLabel*)label
{
	if( label != _highlightedLabel )
	{
		_highlightedLabel.highlightedNode = nil;
		[_highlightedLabel release];
		_highlightedLabel = [label retain];
	}
	
	// If we are set to only allow selection of styled label links then we turn off table row selection if a label was touched
	if( _styledLabelLinkSelectionOnly ) // P31 Addition
		self.allowsSelection = ( label == nil );
}

@end
