/*
 *  LiftAdRequiredConstants.h
 *  LiftAdSDK
 *
 *  Created by Joshua Howland on 5/24/11.
 *  Copyright 2011 jkhowland.com. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


/*
 These sets the margin below the ad on the iPad and iPhone layout
 */
#define AdWidthPortraitPhone		320		// double
#define AdWidthLandscapePhone		480		// double
#define AdHeightPortraitPhone		75		// double
#define AdHeightLandscapePhone		50		// double
#define AdWidthInterstitialPhone	320		// double
#define AdHeightInterstitialPhone	480		// double
#define AdWidthPad		210		// double
#define AdHeightPad		130		// double

/*
 Css for the Ad
 */

#define AD_LOCAL_CSS_PAD				[NSString stringWithFormat:@"ipad.css"]
#define AD_LOCAL_CSS_PHONE_PORT			[NSString stringWithFormat:@"iphoneport.css"]
#define AD_LOCAL_CSS_PHONE_LAND			[NSString stringWithFormat:@"iphoneland.css"]
#define AD_LOCAL_CSS_PHONE_INTER		[NSString stringWithFormat:@"iphoneinter.css"]

#define AD_SERVERSIDE_CSS_PAD					[NSString stringWithFormat:@"http://c595967.r67.cf2.rackcdn.com/ipad.css"]
#define AD_SERVERSIDE_CSS_PHONE_PORT			[NSString stringWithFormat:@"http://c595967.r67.cf2.rackcdn.com/iphoneport.css"]
#define AD_SERVERSIDE_CSS_PHONE_LAND			[NSString stringWithFormat:@"http://c595967.r67.cf2.rackcdn.com/iphoneland.css"]
#define AD_SERVERSIDE_CSS_PHONE_INTER			[NSString stringWithFormat:@"http://c595967.r67.cf2.rackcdn.com/iphoneinter.css"]

#define AdViewContentSizeIdentifierPhoneInterstitial	[NSString stringWithFormat:@"ADBannerContentSizeIdentifierPhoneInterstitial"]
#define AdViewContentSizeIdentifierPhonePortrait		[NSString stringWithFormat:@"ADBannerContentSizeIdentifierPhonePortrait"]
#define AdViewContentSizeIdentifierPhoneLandscape		[NSString stringWithFormat:@"ADBannerContentSizeIdentifierPhoneLandscape"]
#define AdViewContentSizeIdentifierPad					[NSString stringWithFormat:@"ADBannerContentSizeIdentifierPad"]

#define UIInterfaceOrientationIsPortrait(orientation)  ((orientation) == UIInterfaceOrientationPortrait || (orientation) == UIInterfaceOrientationPortraitUpsideDown)
#define UIInterfaceOrientationIsLandscape(orientation) ((orientation) == UIInterfaceOrientationLandscapeLeft || (orientation) == UIInterfaceOrientationLandscapeRight)

#define LIFT_TEXT_SHADOW_NONE	[NSString stringWithFormat:@"text-shadow: 0 0 0 rgba(0, 0, 0, 0);"]
#define LIFT_TEXT_SHADOW_BLACK [NSString stringWithFormat:@"text-shadow: 0 -1px 1px rgba(0, 0, 0, .9);"]
#define LIFT_TEXT_SHADOW_WHITE [NSString stringWithFormat:@"text-shadow: 0 -1px 1px rgba(255, 255, 255, .9);"]