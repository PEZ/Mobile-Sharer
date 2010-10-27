#import "TTFacebookSearchFeedViewController.h"

#import "TTFacebookSearchFeedDataSource.h"

@implementation TTFacebookSearchFeedViewController


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = @"Facebook feed";
    self.variableHeightRows = YES;
  }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
  self.dataSource = [[[TTFacebookSearchFeedDataSource alloc]
                      initWithSearchQuery:@"three20"] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

@end

