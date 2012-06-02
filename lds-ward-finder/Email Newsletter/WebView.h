//
//  WebView.h
//  WWTBTH
//
//  Created by Joshua Howland on 5/1/11.
//  Copyright 2011 jkhowland.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface WebView : UIViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
	
	UIWebView * webView;
	UIView * mview;
	NSString * webAddress;
	
}

@property (nonatomic, retain) IBOutlet UIWebView * webView;
@property (nonatomic, retain) IBOutlet UIView * mview;
@property (nonatomic, retain) NSString * webAddress;

-(IBAction) dismissView;
-(IBAction) showActionSheet:(id)sender;

- (void) setSite;


@end
