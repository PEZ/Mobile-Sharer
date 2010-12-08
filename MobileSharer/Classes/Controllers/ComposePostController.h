//
//  ComposePostController.h
//  MobileSharer
//
//  Created by PEZ on 2010-12-07.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "PostController.h"

@interface ComposePostController : PostController {
  NSString* _link;
  NSString* _feedId;
  UITextField* _linkField;
}

@property (nonatomic, retain) NSString* link;
@property (nonatomic, retain) NSString* feedId;
@property (nonatomic, retain) UITextField* linkField;

- (id)initWithFeedId:(NSString*)feedId andLink:(NSString*)link andTitle:(NSString*)title
         andDelegate:(id<TTPostControllerDelegate>)delegate;

@end
