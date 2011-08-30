//
//  ComposePostController.m
//  MobileSharer
//
//  Created by PEZ on 2010-12-07.
//  Copyright 2010 Better Than Tomorrow. All rights reserved.
//

#import "ComposePostController.h"
#import "RegexKitLite.h"

static const CGFloat kLinkFieldHeight = 24;
static const CGFloat kMarginX = 5;
static const CGFloat kMarginY = 6;

@implementation ComposePostController

@synthesize link = _link;
@synthesize feedId = _feedId;
@synthesize linkField = _linkField;
@synthesize message = _message;

- (id)initWithFeedId:(NSString*)feedId andLink:(NSString*)theLink andTitle:(NSString*)title
         andDelegate:(id<TTPostControllerDelegate>)delegate {
  if ((self = [super init])) {
    self.feedId = feedId;
    self.link = theLink;
    self.title = title;
    self.delegate = delegate;
  }
  return self;
}

- (id)initWithFeedId:(NSString*)feedId andMessage:(NSString*)message andLink:(NSString*)theLink andTitle:(NSString*)title
         andDelegate:(id<TTPostControllerDelegate>)delegate {
  if ((self = [self initWithFeedId:feedId andLink:theLink andTitle:title andDelegate:delegate])) {
    self.message = message;
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_feedId);
  TT_RELEASE_SAFELY(_link);
  TT_RELEASE_SAFELY(_linkField);
  TT_RELEASE_SAFELY(_message);
  [super dealloc];
}

- (void)loadView {
  [super loadView];
  if (_message != nil) {
    self.textView.text = _message;
  }
  _linkField = [[UITextField alloc] init];
  _linkField.placeholder = @"Link url (if any)";
  if (TTIsStringWithAnyText(_link) && !_link.isWhitespaceAndNewlines) {
    _linkField.text = _link;
  }
  _linkField.font = TTSTYLEVAR(font);
  _linkField.textColor = [UIColor blackColor];
  _linkField.keyboardAppearance = UIKeyboardAppearanceAlert;
  _linkField.backgroundColor = [UIColor clearColor];//TTSTYLEVAR(lightColor);
  _linkField.borderStyle = UITextBorderStyleRoundedRect;
  //_linkField.layer.cornerRadius = 5;
  //_linkField.clipsToBounds = YES;
  _linkField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  _linkField.autocorrectionType = UITextAutocorrectionTypeNo;
  [self.view addSubview:_linkField];
}

- (void)layoutTextEditor {
  CGFloat keyboard = TTKeyboardHeightForOrientation(TTInterfaceOrientation());
  if (TTIsPad()) {
    keyboard += kMarginY * 2; // Just moving the link field up some on iPad.
  }
  _screenView.frame = CGRectMake(0, _navigationBar.bottom,
                                 self.view.orientationWidth,
                                 self.view.orientationHeight - (keyboard+_navigationBar.height) - kLinkFieldHeight - kMarginY);

  _textView.frame = CGRectMake(kMarginX, kMarginY+_navigationBar.height,
                               _screenView.width - kMarginX*2,
                               _screenView.height - kMarginY*2);
  _textView.hidden = NO;

  _linkField.frame = CGRectMake(kMarginX, _screenView.bottom + kMarginY, _textView.width, kLinkFieldHeight);
  _linkField.hidden = NO;
}

- (void)showInView:(UIView*)view animated:(BOOL)animated {
  [super showInView:view animated:animated];
  if (animated) {
    _linkField.hidden = YES;
  }
  _linkField.text = _link;
}

- (void)showAnimationDidStop {
  _textView.hidden = NO;
  _linkField.hidden = NO;
}

- (void)cancel {
  if (![_linkField.text isEqualToString:_link]) {
    UIAlertView* cancelAlertView = [[[UIAlertView alloc] initWithTitle:
                                     TTLocalizedString(@"Cancel", @"")
                                                               message:TTLocalizedString(@"Are you sure you want to cancel?", @"")
                                                              delegate:self cancelButtonTitle:TTLocalizedString(@"Yes", @"")
                                                     otherButtonTitles:TTLocalizedString(@"No", @""), nil] autorelease];
    [cancelAlertView show];
  }
  else {
    [super cancel];
  }
}

- (void)post {
    if ((TTIsStringWithAnyText(self.textView.text) && !self.textView.text.isWhitespaceAndNewlines) || (TTIsStringWithAnyText(_linkField.text) && !_linkField.text.isWhitespaceAndNewlines)) {
    Facebook* fb = [FacebookJanitor sharedInstance].facebook;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:self.textView.text forKey:@"message"];
    if (TTIsStringWithAnyText(_linkField.text) && !_linkField.text.isWhitespaceAndNewlines) {
      if ([_linkField.text isMatchedByRegex:@"^http://m.youtube.com/"]) {
        _linkField.text = [Etc mobileYouTubeURL:_linkField.text];
      }
      [Etc params:&params addObject:_linkField.text forKey:@"link"];
    }
    [Etc params:&params addObject:@"http://dl.dropbox.com/u/3259215/img/Share/share-picture.png" forKey:@"picture"];
    NSString* path = [NSString stringWithFormat:@"%@/%@", _feedId, [_linkField.text isMatchedByRegex:@"^http://(www[.])?youtube[.]com"] ? @"links" : @"feed"];
    [fb requestWithGraphPath:path
                   andParams:params
               andHttpMethod:@"POST"
                 andDelegate:self];
    [super post];
  }
}

#pragma mark -
#pragma mark TTPostController

//- (NSString*)titleForError:(NSError*)error {
//	NSDictionary* userError = [[error userInfo] objectForKey:@"error"];
//  return [NSString stringWithFormat:@"Posting failed.\n\n%@\n(Type: %@)",
//					[userError objectForKey:@"message"], [userError objectForKey:@"type"]];
//}

- (NSString*)titleForActivity {
  return @"Posting ...";
}

#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest*)request didLoad:(id)result {
  [self dismissWithResult:result animated:YES];
}

@end
