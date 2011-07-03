//
//  NotificationsModel.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-07-01.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "NotificationsModel.h"
#import "Notification.h"
#import "FacebookJanitor.h"

@implementation NotificationsModel

@synthesize notifications = _notifications;

- (void) dealloc {
  TT_RELEASE_SAFELY(_notifications);
  [super dealloc];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
  if (!self.isLoading) {
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:@"1" forKey:@"include_read"];
    FBRequest* fbRequest = [[FacebookJanitor sharedInstance].facebook createRequestWithMethodName:@"notifications.getList" andParams:params andHttpMethod:@"GET" andDelegate:nil];
    [[FacebookModel createRequest:fbRequest cachePolicy:TTURLRequestCachePolicyNetwork delegate:self] send]; //TODO: use cachePolicy arg
  }
}

- (Notification*)createNotificationFromEntry:(NSDictionary *)entry {
  Notification* notification = [[Notification alloc] init];
  
  notification.created = [NSDate dateWithTimeIntervalSince1970:[[entry objectForKey:@"created_time"] intValue]];
  notification.notificationId = [entry objectForKey:@"notification_id"];
  notification.type = [entry objectForKey:@"object_type"];
  notification.objectId = [entry objectForKey:@"object_id"];
  notification.fromId = [entry objectForKey:@"sender_id"];
  notification.fromAvatar = [FacebookJanitor avatarForId:notification.fromId];
  notification.icon = [entry objectForKey:@"icon_url"];
  notification.message = [entry objectForKey:@"title_text"];
  notification.isNew = [(NSNumber*)[entry objectForKey:@"is_unread"] boolValue];
  
  if ([notification.type isEqualToString:@"stream"] ) {
    notification.URL = [Etc toPostIdPath:notification.objectId andTitle:@"Post"];
  }
  else if ([notification.type isEqualToString:@"photo"] ) {
    notification.URL = [Etc toPostIdPath:notification.objectId andTitle:@"Photo"];
  }
  else if ([notification.type isEqualToString:@"note"] ) {
    notification.URL = [Etc toPostIdPath:notification.objectId andTitle:@"Note"];
  }
  else if ([notification.type isEqualToString:@"group"] ) {
    notification.URL = [Etc toFeedURLPath:notification.objectId name:@"Group"];
  }
  else if ([notification.type isEqualToString:@"event"] ) {
    notification.URL = [Etc toFeedURLPath:notification.objectId name:@"Event"];
  }
  return notification;
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
  TTURLJSONResponse* response = request.response;
  TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
  
  NSDictionary* data = response.rootObject;
  TTDASSERT([[data objectForKey:@"notifications"] isKindOfClass:[NSArray class]]);
  
  NSArray* entries = [data objectForKey:@"notifications"];
  
  NSMutableArray* notifications = [[NSMutableArray alloc] initWithCapacity:[entries count]];

  TT_RELEASE_SAFELY(_notifications);
  
  for (NSDictionary* entry in entries) {
    [notifications addObject:[[self createNotificationFromEntry: entry] autorelease]];
  }
  _notifications = notifications;
  
  [super requestDidFinishLoad:request];
}

@end
