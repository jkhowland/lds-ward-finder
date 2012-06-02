//
//  LiftAdView.m
//  LiftAdSDK
//
//  Created by Joshua Howland on 5/9/11.
//  Copyright 2011 jkhowland.com. All rights reserved.
//


#import "LiftAdView.h"
#import <QuartzCore/QuartzCore.h>

#define LIFT_APP_NAME				[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey]
#define LIFT_EXIT_MESSAGE			[NSString stringWithFormat:@"%@ will quit to open this link.", LIFT_APP_NAME]
#define LIFT_GO_MESSAGE				[NSString stringWithFormat:@"Continue"]
#define LIFT_CANCEL_MESSAGE			[NSString stringWithFormat:@"Cancel"]


@interface UIView (FindUIViewController)

- (UIViewController*)firstAvailableUIViewController;

- (id)traverseResponderChainForUIViewController;

@end

@implementation UIView (FindUIViewController)

- (UIViewController*)firstAvailableUIViewController {
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id)traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

@end

@implementation LiftAdView

@synthesize appId = appId_;
@synthesize delegate = delegate_;
@synthesize bannerLoaded = bannerLoaded_;
@synthesize currentLink = _currentLink;
@synthesize adButton;
@synthesize adParameters = adParameters_;
@synthesize ad_Background_Color = ad_Background_Color_;
@synthesize ad_Text_Color = ad_Text_Color_;
@synthesize ad_Border_Color = ad_Border_Color_;
@synthesize ad_Bottom_Margin_Pad = ad_Bottom_Margin_Pad_;
@synthesize ad_Bottom_Margin_Phone = ad_Bottom_Margin_Phone_;
@synthesize ad_Border_Height = ad_Border_Height_;
@synthesize ad_Border_Visible = ad_Border_Visible_;
@synthesize ad_Shadow_Visible = ad_Shadow_Visible_;
@synthesize ad_Text_Shadow_Visible = ad_Text_Shadow_Visible_;
@synthesize ad_Text_Shadow_Black = ad_Text_Shadow_Black_;


- (id)initWithAppId:(NSString*)appId {	
	
	appId_ = [appId copy];
	
    if ((self = [super initWithFrame:CGRectZero])) {
		
		if(currentContentSizeIdentifier_ == nil)
		{
			currentContentSizeIdentifier_ = [AdViewContentSizeIdentifierPhonePortrait retain];
		}
		
			
		NSString *filePath = [[NSBundle mainBundle] pathForResource:@"developerSettings" ofType:@"plist"];  
		
		adParameters_ = [[NSMutableDictionary dictionaryWithContentsOfFile:filePath] retain];
	
		ad_Background_Color_ = [adParameters_ objectForKey:@"Ad_Background_Color"];
		ad_Text_Color_ = [adParameters_ objectForKey:@"Ad_Text_Color"];
		ad_Border_Color_ = [adParameters_ objectForKey:@"Ad_Border_Color"];
		ad_Bottom_Margin_Pad_ = [[adParameters_ objectForKey:@"Ad_Bottom_Margin_Pad"] intValue];
		ad_Bottom_Margin_Phone_ = [[adParameters_ objectForKey:@"Ad_Bottom_Margin_Phone"] intValue];
		ad_Border_Height_ = [[adParameters_ objectForKey:@"Ad_Border_Height"] intValue];
		ad_Border_Visible_ = [[adParameters_ objectForKey:@"Ad_Border_Visible"] boolValue];
		ad_Shadow_Visible_ = [[adParameters_ objectForKey:@"Ad_Shadow_Visible"] boolValue];
		ad_Text_Shadow_Visible_ = [[adParameters_ objectForKey:@"Ad_Text_Shadow_Visible"] boolValue];
		ad_Text_Shadow_Black_ = [[adParameters_ objectForKey:@"Ad_Text_Shadow_Black"] boolValue];
		
		if([ad_Border_Color_ isEqualToString:@"Black"])
			self.backgroundColor = [UIColor blackColor];
		else if([ad_Border_Color_ isEqualToString:@"Blue"])
			self.backgroundColor = [UIColor blueColor];
		else if([ad_Border_Color_ isEqualToString:@"Brown"])
			self.backgroundColor = [UIColor brownColor];
		else if([ad_Border_Color_ isEqualToString:@"Cyan"])
			self.backgroundColor = [UIColor cyanColor];
		else if([ad_Border_Color_ isEqualToString:@"Dark Gray"])
			self.backgroundColor = [UIColor darkGrayColor];
		else if([ad_Border_Color_ isEqualToString:@"Gray"])
			self.backgroundColor = [UIColor grayColor];
		else if([ad_Border_Color_ isEqualToString:@"Green"])
			self.backgroundColor = [UIColor greenColor];
		else if([ad_Border_Color_ isEqualToString:@"Light Gray"])
			self.backgroundColor = [UIColor lightGrayColor];
		else if([ad_Border_Color_ isEqualToString:@"Magenta"])
			self.backgroundColor = [UIColor magentaColor];
		else if([ad_Border_Color_ isEqualToString:@"Orange"])
			self.backgroundColor = [UIColor orangeColor];
		else if([ad_Border_Color_ isEqualToString:@"Purple"])
			self.backgroundColor = [UIColor purpleColor];
		else if([ad_Border_Color_ isEqualToString:@"Red"])
			self.backgroundColor = [UIColor redColor];
		else if([ad_Border_Color_ isEqualToString:@"White"])
			self.backgroundColor = [UIColor whiteColor];
		else if([ad_Border_Color_ isEqualToString:@"Yellow"])
			self.backgroundColor = [UIColor yellowColor];
		else {
			ad_Border_Visible_ = NO;
		}
		
		if(ad_Shadow_Visible_) {
					
			self.layer.masksToBounds = NO;
			self.layer.shadowOffset = CGSizeMake(0, 10);
			self.layer.shadowRadius = 10;
			self.layer.shadowOpacity = 0.7;
			
		}
		self.hidden = YES;

		[self sizeToFit];

		[self performSelector:@selector(triggerReload) withObject:nil afterDelay:0];

	}

	return self;
}
	

- (CGSize)sizeThatFits:(CGSize)size {
	
	
	return [self sizeFromBannerContentSizeIdentifier:currentContentSizeIdentifier_];
	
}


- (CGSize)sizeFromBannerContentSizeIdentifier:(NSString *)contentSizeIdentifier {
	
	
	if([contentSizeIdentifier isEqualToString:AdViewContentSizeIdentifierPhoneLandscape]) {
		return CGSizeMake(AdWidthLandscapePhone, AdHeightLandscapePhone + (ad_Border_Visible_ ? + ad_Border_Height_ : 0));
		
	}
	if([contentSizeIdentifier isEqualToString:AdViewContentSizeIdentifierPad]) {
		return CGSizeMake(AdWidthPad, AdHeightPad + (ad_Border_Visible_ ? + ad_Border_Height_ : 0));
	}
	if([contentSizeIdentifier isEqualToString:AdViewContentSizeIdentifierPhoneInterstitial]) {
		return CGSizeMake(AdWidthInterstitialPhone, AdHeightInterstitialPhone + (ad_Border_Visible_ ? + ad_Border_Height_ : 0));
	}
	
	return CGSizeMake(AdWidthPortraitPhone, AdHeightPortraitPhone + (ad_Border_Visible_ ? + ad_Border_Height_ : 0));
	
}


- (void) releaseWebBanner {
		
	if(bannerLoaded_==YES)
	{
		if ([self.delegate respondsToSelector:@selector(adViewWillUnload:)])
		{[delegate_ adViewWillUnload:self];}    
	}	
	
	if(bannerWebView_){
		[bannerWebView_ removeFromSuperview];
		bannerWebView_ = nil;
	}
	
	
	bannerLoaded_ = NO;
	[self startLoadingAd];
	
	return;

}


- (void)triggerReload {
    [self performSelectorOnMainThread:@selector(reloadAd) withObject:nil waitUntilDone:NO];
}


-(void) reloadAd {
	
	
	if(bannerLoaded_==YES)
	{
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector :@selector(triggerReload) object :nil];
	
		if ([self.delegate respondsToSelector:@selector(adViewWillUnload:)])
		{[delegate_ adViewWillUnload:self];}    
	}
	
    bannerLoaded_ = NO;
	[self startLoadingAd];
	
	return;
}


- (void)startLoadingAd {
		
    previousBannerWebView_ = bannerWebView_;
    	
	bannerWebView_ = [[[UIWebView alloc] initWithFrame:CGRectMake(0, (ad_Border_Visible_ ? ad_Border_Height_ : 0), self.bounds.size.width, self.bounds.size.height - (ad_Border_Visible_ ? ad_Border_Height_ : 0))] autorelease];
	bannerWebView_.delegate = self;

    if (previousBannerWebView_) {
        [self insertSubview:bannerWebView_ belowSubview:previousBannerWebView_];
    } else {
        [self addSubview:bannerWebView_];
    }
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"liftad" ofType:@"html"];
	NSMutableString *fileText = [NSMutableString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
		
	NSString *aContentSizeIdentifier = currentContentSizeIdentifier_;
	
	[fileText replaceOccurrencesOfString:@"APP_ID" withString:appId_ options:0 range:NSMakeRange(0, [fileText length])];
	[fileText replaceOccurrencesOfString:@"AD_BACKGROUND_COLOR" withString:ad_Background_Color_ options:0 range:NSMakeRange(0, [fileText length])];
	[fileText replaceOccurrencesOfString:@"AD_TEXT_COLOR" withString:ad_Text_Color_ options:0 range:NSMakeRange(0, [fileText length])];

	if(ad_Text_Shadow_Visible_) {
		if(ad_Text_Shadow_Black_) [fileText replaceOccurrencesOfString:@"LIFT_TEXT_SHADOW" withString:LIFT_TEXT_SHADOW_BLACK options:0 range:NSMakeRange(0, [fileText length])];
		else {[fileText replaceOccurrencesOfString:@"LIFT_TEXT_SHADOW" withString:LIFT_TEXT_SHADOW_WHITE options:0 range:NSMakeRange(0, [fileText length])];}
	}
	else {[fileText replaceOccurrencesOfString:@"LIFT_TEXT_SHADOW" withString:LIFT_TEXT_SHADOW_NONE options:0 range:NSMakeRange(0, [fileText length])];
	}
	
	if([aContentSizeIdentifier isEqualToString:AdViewContentSizeIdentifierPhonePortrait]){
		[fileText replaceOccurrencesOfString:@"AD_LOCAL_CSS" withString:AD_LOCAL_CSS_PHONE_PORT options:0 range:NSMakeRange(0, [fileText length])];
		[fileText replaceOccurrencesOfString:@"AD_SERVERSIDE_CSS" withString:AD_SERVERSIDE_CSS_PHONE_PORT options:0 range:NSMakeRange(0, [fileText length])];
	}
	if([aContentSizeIdentifier isEqualToString:AdViewContentSizeIdentifierPhoneLandscape]){
		[fileText replaceOccurrencesOfString:@"AD_LOCAL_CSS" withString:AD_LOCAL_CSS_PHONE_LAND options:0 range:NSMakeRange(0, [fileText length])];
		[fileText replaceOccurrencesOfString:@"AD_SERVERSIDE_CSS" withString:AD_SERVERSIDE_CSS_PHONE_LAND options:0 range:NSMakeRange(0, [fileText length])];
	}
	if([aContentSizeIdentifier isEqualToString:AdViewContentSizeIdentifierPad]){
		[fileText replaceOccurrencesOfString:@"AD_LOCAL_CSS" withString:AD_LOCAL_CSS_PAD options:0 range:NSMakeRange(0, [fileText length])];
		[fileText replaceOccurrencesOfString:@"AD_SERVERSIDE_CSS" withString:AD_SERVERSIDE_CSS_PAD options:0 range:NSMakeRange(0, [fileText length])];
	}
	if([aContentSizeIdentifier isEqualToString:AdViewContentSizeIdentifierPhoneInterstitial]){
		[fileText replaceOccurrencesOfString:@"AD_LOCAL_CSS" withString:AD_LOCAL_CSS_PHONE_INTER options:0 range:NSMakeRange(0, [fileText length])];
		[fileText replaceOccurrencesOfString:@"AD_SERVERSIDE_CSS" withString:AD_SERVERSIDE_CSS_PHONE_INTER options:0 range:NSMakeRange(0, [fileText length])];
	}
	

	[bannerWebView_ loadHTMLString:fileText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
	
	return;
}


- (void) webViewDidFinishLoad:(UIWebView *) webview {
	
	loadedPageContents_ = [webview stringByEvaluatingJavaScriptFromString: 
					  @"document.body.innerHTML"];

		//Create ranges to find the actual link tag
		NSRange rangeStart = [loadedPageContents_ rangeOfString:@"a href="];
		if(rangeStart.location != NSNotFound)
		{
			NSRange rangeEnd = [loadedPageContents_ rangeOfString:@">" options:NSCaseInsensitiveSearch range:NSMakeRange(rangeStart.location + rangeStart.length, [loadedPageContents_ length] - (rangeStart.location + rangeStart.length))];
			
			//Use the ranges above to find the link. Subtracting 20 because they are sending back a target. We need to cut that off so we just get a URL
			NSRange trueRange = NSMakeRange((rangeStart.location + rangeStart.length + 1), (rangeEnd.location - (rangeStart.location + rangeStart.length + 1) - 20));
			
			//Set the currentLink to the URL. This variable is used in the transparent buttons click event to tell the application what to load
			_currentLink = [[loadedPageContents_ substringWithRange:trueRange] retain];
						
			if([loadedPageContents_ rangeOfString:@"ADS by LIFT"].location != NSNotFound)
			{
				//The string is there
				[previousBannerWebView_ removeFromSuperview];
				previousBannerWebView_ = nil;
				
				bannerLoaded_ = YES;
				
				if ([self.delegate respondsToSelector:@selector(adViewDidLoadAd:)]){
					//delegate has an adViewShouldBegin method definition
					[delegate_ adViewDidLoadAd:self];
				}
				
			}
			else {
				
				bannerLoaded_ = NO;
				self.hidden = YES;
			}
		}		

		if(bannerLoaded_){
	
			NSString * aContentSizeIdentifier = currentContentSizeIdentifier_;
			
			if([aContentSizeIdentifier isEqualToString:AdViewContentSizeIdentifierPhoneLandscape]) {
				frameB = CGRectMake(0, 0, AdWidthLandscapePhone, AdHeightLandscapePhone + (ad_Border_Visible_ ? + ad_Border_Height_ : 0));

			}
			if([aContentSizeIdentifier isEqualToString:AdViewContentSizeIdentifierPad]) {
				frameB = CGRectMake(0, 0, AdWidthPad, AdHeightPad + (ad_Border_Visible_ ? + ad_Border_Height_: 0));

			}
			if([aContentSizeIdentifier isEqualToString:AdViewContentSizeIdentifierPhoneInterstitial]) {
				frameB = CGRectMake(10, 10, AdWidthInterstitialPhone-20, AdHeightInterstitialPhone-20);
		
			} 
			else {
	
				frameB = CGRectMake(0, 0, AdWidthPortraitPhone, AdHeightPortraitPhone + (ad_Border_Visible_ ? + ad_Border_Height_: 0));
			
			}
			
			
			//Create a button that overlays the view so that we receive a touch event no matter where the user goes
			adButton = [UIButton buttonWithType:UIButtonTypeCustom];
			
			UIImage * transparentImg = [UIImage imageNamed:@"transparentImg.png"];
			UIImage * darkenedImg = [UIImage imageNamed:@"darkenedImg.png"];
			
			[adButton setBackgroundImage:transparentImg forState:UIControlStateNormal];
			[adButton setBackgroundImage:darkenedImg forState:UIControlStateHighlighted];
			adButton.frame = frameB;
			
			//			adButton = [[[UIButton alloc] initWithFrame:frameB] autorelease];
			[adButton addTarget:self action:@selector(adButtonClick) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
			
			
			//Add the button on top of the Webview
			[self addSubview:adButton];
			
			
			[self performSelector:@selector(triggerReload) withObject:nil afterDelay:120.0f];
			self.hidden = NO;    
			
      } else {
            //Don't Load
			[self adLoadOrReloadDidFail];
        } 
    }


- (void) setBannerCenterDefault {

	/*
	self.center = CGPointMake(self.bounds.size.width/2, 
							  self.bounds.size.height/2);

	
	*/
	 
	// from a UIView subclass... returns nil if UIViewController not available
	UIViewController * parentController = [self firstAvailableUIViewController];		
	
	self.center = CGPointMake(parentController.view.bounds.size.width - self.bounds.size.width/2, 
							  parentController.view.bounds.size.height - self.bounds.size.height/2);
	 	
	
	return;
}

- (void) setBannerCenterOrigin {

	self.center = CGPointMake(self.bounds.size.width/2, 
							  self.bounds.size.height/2);

}

- (BOOL) contentSizeIdentifierIsValid:(NSString *) aCurrentContentSizeIdentifier {

	if([aCurrentContentSizeIdentifier isEqualToString:AdViewContentSizeIdentifierPhoneInterstitial] || [aCurrentContentSizeIdentifier isEqualToString:AdViewContentSizeIdentifierPad] || [aCurrentContentSizeIdentifier isEqualToString:AdViewContentSizeIdentifierPhoneLandscape] || [aCurrentContentSizeIdentifier isEqualToString:AdViewContentSizeIdentifierPhonePortrait]) {
		return YES;
	} 
	
	return NO;
	
}

- (NSString *) currentContentSizeIdentifier {
	
	return currentContentSizeIdentifier_;
}


- (void) setCurrentContentSizeIdentifier:(NSString *) aCurrentContentSizeIdentifier
{
	if([self contentSizeIdentifierIsValid:aCurrentContentSizeIdentifier]){
		
	if(![currentContentSizeIdentifier_ isEqualToString:aCurrentContentSizeIdentifier])
	{		
		
	[currentContentSizeIdentifier_ autorelease]; 
	
	currentContentSizeIdentifier_ = [aCurrentContentSizeIdentifier copy];
	
		[self sizeToFit];
		
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector :@selector(triggerReload) object :nil];
		
		[self performSelector:@selector(releaseWebBanner) withObject:nil afterDelay:0];
	}
		
	}
	
	return;
}


//Respond to the overlay buttons click
- (void) adButtonClick
{
    [self adBannerDidRecieveTouchInput];
}


- (void) adBannerDidRecieveTouchInput
{
		
		if ([self.delegate respondsToSelector:@selector(adViewActionShouldBegin:)]){
			//delegate has an adViewShouldBegin method definition
			
			if([delegate_ adViewActionShouldBegin:self]){
				//delegate allows adViewAction to begin
				
				UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:LIFT_EXIT_MESSAGE delegate:self cancelButtonTitle:LIFT_CANCEL_MESSAGE destructiveButtonTitle:nil otherButtonTitles:LIFT_GO_MESSAGE, nil];
				
				popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
				
				UIViewController * parentController = [self firstAvailableUIViewController];						
				[popupQuery showInView:parentController.view];
				[popupQuery release];
																					
			}
			else{
				//delegate does NOT allow adViewAction to beginny 
				return;
			}
		}
		else {
			
			
			//delegate does NOT have an adViewShouldBegin method definition
			UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:LIFT_EXIT_MESSAGE delegate:self cancelButtonTitle:LIFT_CANCEL_MESSAGE destructiveButtonTitle:nil otherButtonTitles:LIFT_GO_MESSAGE, nil];
			
			popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
			
			UIViewController * parentController = [self firstAvailableUIViewController];						
			[popupQuery showInView:parentController.view];
			[popupQuery release];				
			}
				
	}
	
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:_currentLink]];
    } else if (buttonIndex == 1) {
		return;
    }
}



- (void) adLoadOrReloadDidFail {
	 
	if ([self.delegate respondsToSelector:@selector(adViewDidFailToLoad:)]){
		//delegate has an adViewShouldBegin method definition
		[delegate_ adViewDidFailToLoad:self];
	}
			
	return;
	
}																  



	
- (void)dealloc {
	[adParameters_ release];
	[appId_ release];
	[currentContentSizeIdentifier_ release];
    [super dealloc];
}






																  
																  

@end
