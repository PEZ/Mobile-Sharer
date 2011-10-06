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
#import "RegexKitLite.h"

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
  Notification* notification = [[[Notification alloc] init] autorelease];
  @try {
    notification.notificationId = [entry objectForKey:@"notification_id"];
    notification.type = [entry objectForKey:@"object_type"];
    notification.objectId = [entry objectForKey:@"object_id"];
    notification.fromId = [entry objectForKey:@"sender_id"];
    notification.icon = [entry objectForKey:@"icon_url"];
    notification.message = [entry objectForKey:@"title_text"];
    notification.created = [NSDate dateWithTimeIntervalSince1970:[[entry objectForKey:@"created_time"] intValue]];
    notification.fromAvatar = [FacebookJanitor avatarForId:notification.fromId];
    notification.isNew = [(NSNumber*)[entry objectForKey:@"is_unread"] boolValue];
    NSString* href = [entry objectForKey:@"href"];
    if (notification.type != nil && ![notification.type isKindOfClass:[NSNull class]]) {
      if ([notification.type isEqualToString:@"stream"] ) {
        if (href && [href isKindOfClass:[NSString class]] && [href rangeOfString:@"sk=wall"].location != NSNotFound) {
          notification.URL = [Etc toFeedURLPath:[FacebookJanitor sharedInstance].currentUser.userId
                                           name:[FacebookJanitor sharedInstance].currentUser.userName];
        }
        else {
          notification.URL = [Etc toPostIdPath:notification.objectId andTitle:@"Post"];
        }
      }
      else if ([notification.type isEqualToString:@"photo"] ) {
        notification.URL = [Etc toPhotoPostPathFromFBHREF:[entry objectForKey:@"href"]];
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
      else if ([notification.type isEqualToString:@"friend"] ) {
        notification.URL = [Etc toFeedURLPath:notification.objectId name:@"Friend"];
      }
      else if ([href isMatchedByRegex:@"/posts/[0-9]+\\?"]){
        NSString *objectId = [href stringByMatching:@"/posts/([0-9]+)" capture:1];
        notification.URL = [Etc toPostIdPath:objectId andTitle:@"Post"];
      }
    }
  }
  @catch (NSException *exception) {
    DLog(@"Error converting entry to notification: %@", exception)
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
    [notifications addObject:[self createNotificationFromEntry: entry]];
  }
  _notifications = notifications;
  
  [super requestDidFinishLoad:request];
}

@end
