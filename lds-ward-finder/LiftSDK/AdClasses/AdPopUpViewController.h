//
//  AdPopUpViewController.h
//  LiftAdSDK
//
//  Created by Joshua Howland on 5/9/11.
//  Copyright 2011 jkhowland.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@protocol AdPopUpViewDelegate;

@interface AdPopUpViewController : UIViewController <MBProgressHUDDelegate> {

	id <AdPopUpViewDelegate> delegate_;
	
	UIWebView * webView;
	UIView * mview;
	NSString * webAddress;
	UIButton * button;
	MBProgressHUD *HUD;
	
	long long expectedLength;
	long long currentLength;
	
}

@property (nonatomic,assign) id<AdPopUpViewDelegate> delegate;

@property (nonatomic, retain) IBOutlet UIWebView * webView;
@property (nonatomic, retain) IBOutlet UIProgressView * progressBar;
@property (nonatomic, retain) IBOutlet UIView * mview;
@property (nonatomic, retain) IBOutlet UIButton	* button;
@property (nonatomic, retain) NSString * webAddress;

-(IBAction) dismissView;

- (void) setSite;

@end

@protocol AdPopUpViewDelegate <NSObject>

- (void)adPopUpViewDismissed;

@end


