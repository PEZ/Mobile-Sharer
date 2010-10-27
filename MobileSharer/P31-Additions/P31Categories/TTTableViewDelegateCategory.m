//
//  TTTableViewDelegateCategory.m
//  DELETEME
//
//  Created by Mike on 5/6/10.
//  Copyright 2010 Prime31 Studios. All rights reserved.
//

#import "TTTableViewDelegateCategory.h"


@implementation TTTableViewDelegate(Category)

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	id<TTTableViewDataSource> dataSource = (id<TTTableViewDataSource>)tableView.dataSource;
	id object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
	
	// Added section to automatically wrap up any TTTableItem userInfo objects.  If it is a dictionary, it gets sent directly
	// If it is not, it is put in a dictionary and sent as they __userInfo__ key
	if( [object isKindOfClass:[TTTableLinkedItem class]] )
	{
		TTTableLinkedItem* item = object;
		
		if( item.URL && [_controller shouldOpenURL:item.URL] )
		{
			// If the TTTableItem has userInfo, wrap it up and send it along to the URL
			if( item.userInfo )
			{
				NSDictionary *userInfoDict;
				
				// If userInfo is a dictionary, pass it along else create a dictionary
				if( [item.userInfo isKindOfClass:[NSDictionary class]] )
				{
					userInfoDict = item.userInfo;
				}
				else
				{
					userInfoDict = [NSDictionary dictionaryWithObject:item.userInfo forKey:@"__userInfo__"];
				}
				
				[[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:item.URL]
														 applyQuery:userInfoDict]
														applyAnimated:YES]];
			}
			else
			{
				TTOpenURL( item.URL );
			}
		}
		
		if( [object isKindOfClass:[TTTableButton class]] )
		{
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
		}
		else if( [object isKindOfClass:[TTTableMoreButton class]] )
		{
			TTTableMoreButton* moreLink = (TTTableMoreButton*)object;
			moreLink.isLoading = YES;
			TTTableMoreButtonCell* cell
			= (TTTableMoreButtonCell*)[tableView cellForRowAtIndexPath:indexPath];
			cell.animating = YES;
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			
			if( moreLink.model )
				[moreLink.model load:TTURLRequestCachePolicyDefault more:YES];
			else
				[_controller.model load:TTURLRequestCachePolicyDefault more:YES];
		}
	}
	
	[_controller didSelectObject:object atIndexPath:indexPath];
}


- (void)tableView:(UITableView*)tableView touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	// If we have a menuView up we dismiss it ONLY if the touch was not on the menuView
	if( _controller.menuView )
	{
		UITouch *touch = [touches anyObject];
		CGPoint point = [touch locationInView:_controller.menuView];
		if( point.y < 0 || point.y > _controller.menuView.frame.size.height )
		{
			[_controller hideMenu:YES];
		}
	}
}

@end
