//
//  LiftAdView.h
//  LiftAdSDK
//
//  Created by Joshua Howland on 5/9/11.
//  Copyright 2011 jkhowland.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiftAdRequiredConstants.h"


@protocol LiftAdViewDelegate;

@interface LiftAdView : UIView <UIWebViewDelegate,UIActionSheetDelegate> {
	
	NSString *appId_;
	
	NSMutableDictionary * adParameters_;
	
	id <LiftAdViewDelegate> delegate_;
	
	BOOL bannerLoaded_;
	
	UIButton *adButton;

	NSString * currentContentSizeIdentifier_;
	
	UIWebView * bannerWebView_;
	
	UIWebView * previousBannerWebView_;
	
	NSString * loadedPageContents_;
	
	NSString * _currentLink;
	
	CGRect frameB;
	
	NSString * ad_Background_Color_;
	
	NSString * ad_Text_Color_;
	
	NSString * ad_Border_Color_;
	
	int ad_Bottom_Margin_Pad_;
	
	int ad_Bottom_Margin_Phone_;
	
	int ad_Border_Height_;
	
	BOOL ad_Border_Visible_;
	
	BOOL ad_Shadow_Visible_;
	
	BOOL ad_Text_Shadow_Visible_;
	
	BOOL ad_Text_Shadow_Black_;
		
}

@property (nonatomic,copy) NSString *appId;
@property (nonatomic, assign) NSMutableDictionary * adParameters;
@property (nonatomic,assign) id<LiftAdViewDelegate> delegate;

@property (nonatomic, retain) UIButton *adButton;
@property (nonatomic, assign) NSString * ad_Background_Color;
@property (nonatomic, assign) NSString * ad_Text_Color;
@property (nonatomic, assign) NSString * ad_Border_Color;

@property (nonatomic, assign) int ad_Bottom_Margin_Pad;
@property (nonatomic, assign) int ad_Bottom_Margin_Phone;
@property (nonatomic, assign) int ad_Border_Height;
@property (nonatomic, assign) BOOL ad_Border_Visible;
@property (nonatomic, assign) BOOL ad_Shadow_Visible;
@property (nonatomic, assign) BOOL ad_Text_Shadow_Visible;
@property (nonatomic, assign) BOOL ad_Text_Shadow_Black;

@property (nonatomic, copy) NSString *currentContentSizeIdentifier;
@property(nonatomic, readonly, getter=isBannerLoaded) BOOL bannerLoaded;
@property (copy) NSString * currentLink;


- (id)initWithAppId:(NSString*)appId;
- (void) reloadAd;
- (void) startLoadingAd;

- (CGSize) sizeFromBannerContentSizeIdentifier:(NSString *)contentSizeIdentifier;
- (void) setBannerCenterDefault;
- (void) setBannerCenterOrigin;

- (void) adLoadOrReloadDidFail;
- (void) releaseWebBanner;
- (void) adBannerDidRecieveTouchInput;

@end

@protocol LiftAdViewDelegate <NSObject>

@optional
- (void) adViewDidLoadAd: (LiftAdView *) adView;
- (void) adViewWillUnload: (LiftAdView *) adView;

- (BOOL) adViewActionShouldBegin:(LiftAdView *)adView;
- (void) adViewDidFailToLoad:(LiftAdView *)adView;

@end


