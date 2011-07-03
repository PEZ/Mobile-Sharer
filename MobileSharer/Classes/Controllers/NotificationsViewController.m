//
//  NotificationsViewController.m
//  MobileSharer
//
//  Created by Peter Stromberg on 2011-06-30.
//  Copyright 2011 Better Than Tomorrow. All rights reserved.
//

#import "NotificationsViewController.h"


@implementation NotificationsViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = @"Notifications";
    self.variableHeightRows = YES;
  }
  
  return self;
}

- (void)dealloc {
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
  //self.dataSource = [[[NotificationsDataSource alloc]
  //                    initWithConnectionsPath:self.connectionsPath] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

@end

/*
 {
 "notifications": [
 {
 "notification_id": "107425365",
 "sender_id": 525768299,
 "recipient_id": 524913037,
 "created_time": 1309444672,
 "updated_time": 1309444672,
 "title_html": "<a href="http://www.facebook.com/cajsa.lindgardh" data-hovercard="/ajax/hovercard/user.php?id=525768299">Cajsa Sjöstedt Lindgårdh</a>, <a href="http://www.facebook.com/profile.php?id=1421516005" data-hovercard="/ajax/hovercard/user.php?id=1421516005">Bo C. Herlin</a>, and <a class="uiTooltip" href="/ajax/browser/dialog/?type=users&amp;ids%5B0%5D=100001280102768&amp;ids%5B1%5D=680742689&amp;ids%5B2%5D=633290734&amp;ids%5B3%5D=654421702&amp;ids%5B4%5D=677251724&amp;ids%5B5%5D=791804229&amp;ids%5B6%5D=680206157&amp;ids%5B7%5D=1458079281&amp;ids%5B8%5D=544748962&amp;ids%5B9%5D=600807760&amp;title=Friends+who+commented." rel="dialog">10 other friends<span class="uiTooltipWrap bottom left leftbottom"><span class="uiTooltipText uiTooltipNoWrap">Anna Norberg<br />N. Jonas Englund<br />Joakim Kämpe<br />David Wärmegård<br />Anders Jangbrand<br />Joakim Fagerström<br />Erik Eriksson<br />Oliver Flinck<br />Karolina Wicksén Jackson-Ward<br />Micha Toma</span></span></a> commented on your <a href="http://www.facebook.com/cobpez/posts/10150216015853038">status</a>.",
 "title_text": "Cajsa Sjöstedt Lindgårdh, Bo C. Herlin, and 10 other friends commented on your status.",
 "body_html": "Svår fråga. Vad är &quot;krig&quot;? Min svåger har varit i Afghanistan. Före det skulle jag sagt &quot;NEJ&quot; men nu tveksam. Tänker på Libyen och folket där. Jag vill hjälpa, men hur? ",
 "body_text": "Svår fråga. Vad är "krig"? Min svåger har varit i Afghanistan. Före det skulle jag sagt "NEJ" men nu tveksam. Tänker på Libyen och folket där. Jag vill hjälpa, men hur? ",
 "href": "http://www.facebook.com/cobpez/posts/10150216015853038",
 "app_id": 19675640871,
 "is_unread": 1,
 "is_hidden": 0,
 "object_id": "524913037_10150216015853038",
 "object_type": "stream",
 "icon_url": "http://static.ak.fbcdn.net/rsrc.php/v1/yr/r/B4fl7q9VLz5.gif"
 },
 {
 "notification_id": "107434372",
 "sender_id": 662557980,
 "recipient_id": 524913037,
 "created_time": 1309444484,
 "updated_time": 1309444484,
 "title_html": "<a href="http://www.facebook.com/anna.zettersten" data-hovercard="/ajax/hovercard/user.php?id=662557980">Anna Zettersten</a>, <a href="http://www.facebook.com/profile.php?id=588813436" data-hovercard="/ajax/hovercard/user.php?id=588813436">Sara Carlin</a>, and <a class="uiTooltip" href="/ajax/browser/dialog/?type=users&amp;ids%5B0%5D=656079071&amp;ids%5B1%5D=598521679&amp;title=Friends+who+commented." rel="dialog">2 other friends<span class="uiTooltipWrap bottom left leftbottom"><span class="uiTooltipText uiTooltipNoWrap">Rikard Söderberg<br />Elin Wedholm</span></span></a> also commented on <a href="http://www.facebook.com/profile.php?id=632222693" data-hovercard="/ajax/hovercard/user.php?id=632222693">Ulrika Hammar</a>'s <a href="http://www.facebook.com/permalink.php?story_fbid=10150226639967694&amp;id=632222693">status</a>.",
 "title_text": "Anna Zettersten, Sara Carlin, and 2 other friends also commented on Ulrika Hammar's status.",
 "body_html": "Fråga Tante Kovis! Hon vet besked om det mesta. Ha så himla skoj nu!!",
 "body_text": "Fråga Tante Kovis! Hon vet besked om det mesta. Ha så himla skoj nu!!",
 "href": "http://www.facebook.com/permalink.php?story_fbid=10150226639967694&id=632222693",
 "app_id": 19675640871,
 "is_unread": 1,
 "is_hidden": 0,
 "object_id": "632222693_10150226639967694",
 "object_type": "stream",
 "icon_url": "http://static.ak.fbcdn.net/rsrc.php/v1/yr/r/B4fl7q9VLz5.gif"
 },
 {
 "notification_id": "107433623",
 "sender_id": 525768299,
 "recipient_id": 524913037,
 "created_time": 1309444443,
 "updated_time": 1309444443,
 "title_html": "<a href="http://www.facebook.com/cajsa.lindgardh" data-hovercard="/ajax/hovercard/user.php?id=525768299">Cajsa Sjöstedt Lindgårdh</a> and <a href="http://www.facebook.com/katarina" data-hovercard="/ajax/hovercard/user.php?id=100000007327271">Katarina Strömberg</a> commented on your <a href="http://www.facebook.com/cobpez/posts/10150216053618038">status</a>.",
 "title_text": "Cajsa Sjöstedt Lindgårdh and Katarina Strömberg commented on your status.",
 "body_html": "Svårt att kommentera en så sorglig sak men ändå fin. Skickar lite varma tankar. Vem vet - det kanske gör lite gott. Barnen är det bästa vi har!",
 "body_text": "Svårt att kommentera en så sorglig sak men ändå fin. Skickar lite varma tankar. Vem vet - det kanske gör lite gott. Barnen är det bästa vi har!",
 "href": "http://www.facebook.com/cobpez/posts/10150216053618038",
 "app_id": 19675640871,
 "is_unread": 1,
 "is_hidden": 0,
 "object_id": "524913037_10150216053618038",
 "object_type": "stream",
 "icon_url": "http://static.ak.fbcdn.net/rsrc.php/v1/yr/r/B4fl7q9VLz5.gif"
 }
 ],
 "apps": [
 {
 "app_id": "19675640871",
 "api_key": "34315f488abaa596f1cdfa8829eef7c2",
 "canvas_name": null,
 "display_name": "Feed Comments",
 "icon_url": "http://static.ak.fbcdn.net/rsrc.php/v1/yr/r/B4fl7q9VLz5.gif",
 "logo_url": "http://photos-g.ak.fbcdn.net/photos-ak-snc1/v43/243/19675640871/app_1_19675640871_6604.gif",
 "company_name": "",
 "developers": [],
 "description": "",
 "category": "",
 "subcategory": "",
 "is_facebook_app": true,
 "daily_active_users": "0",
 "weekly_active_users": "0",
 "monthly_active_users": "0"
 }
 ]
 }
 */