//
//  ViewController.h
//  lds-ward-finder
//
//  Created by Joshua Howland on 12/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTRevealSidebarView.h"
#import "JTNavigationView.h"
#import "MBProgressHUD.h"
#import "InformationViewController.h"
#import "LiftInfoViewController.h"
#import "UIView+firstResponder.h"
#import "UIView+Position.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "AppSettings.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AddThis.h"
#import "CoreLocationController.h"
#import <MapKit/MapKit.h>

@class TPKeyboardAvoidingScrollView;

@interface ViewController : UIViewController <SuccessPopupDelegate, UITextFieldDelegate,UIScrollViewDelegate,UIWebViewDelegate,SettingsViewControllerDelegate,MBProgressHUDDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,CoreLocationControllerDelegate,MKMapViewDelegate, MKReverseGeocoderDelegate,UIWebViewDelegate> {
    
    MKMapView *mapView;
    
    MKReverseGeocoder *reverseGeocoder;
    CLGeocoder * reverseCLGeocoder;
	
    CoreLocationController *CLController;
    NSString * locLabel;
    
    //Ad Elements
	//LiftAdView * adBanner;
    //LiftAdView * adInterstitial;
    //bool adInterstitialLoaded;
    
    //bool displayTimeUp;
    bool answerFound;
    //int seconds;
	//NSTimer *timer;	

// Sliding view
    
    IBOutlet JTRevealSidebarView * centralView;
 
    IBOutlet UIView * startscreen;
    IBOutlet UIView * screen1;
    IBOutlet UIView * screen2;
    IBOutlet UIView * screen3;
    IBOutlet UIView * coverScreen;
    
    UIWebView * testLoadView;
    
    UIButton * menuButton;
    
    MBProgressHUD *HUD;
    
    
    //Splash Elements
    IBOutlet UIView * coverView;
    UIWebView * webview;
    
	BOOL taskInProgress;    
    BOOL hudDisplayed;
    BOOL leftToSignUp;
    BOOL badInfo;
    
    //Search and scrape
    
    SEL methodForExecution;
	id targetForExecution;
	id objectForExecution;

    //successview controller stuff
    
    IBOutlet UIScrollView * scrollView;
    IBOutlet UIPageControl * pageControl;
    
    BOOL pageControlUsed;
    float kNumberOfPages;

    TPKeyboardAvoidingScrollView *keyScrollView;

    NSString * meetinghouseID;
    NSString * initialAddress;
    NSString * initialFirstMeeting;
    NSString * initialWorshipService;
    NSString * loadedPageContents;
    NSString * wardURL;
    NSString * initialWardName;
    NSString * initialBishopName;
    NSString * initialBishopPhone;
    NSString * initialMapImage;
    
    NSString * latitudeLabel;
    NSString * longitudeLabel;
    
    NSString * formCode;
    
    float latitude;
    float longitude;
    
    IBOutlet UIToolbar *keyboardToolbar;
    UISegmentedControl *nextPreviousControl;  
    
    BOOL keyboardToolbarShouldHide;
    MKPlacemark * initialPlacemark;
    BOOL useGPSCoordinates;
    
    CLLocation * initialLocation;
    BOOL haveCoordinate;

}

@property (nonatomic, retain) MKPlacemark *placemark;

@property (nonatomic, retain) UIScrollView * scrollView;
@property (nonatomic, retain) UIPageControl * pageControl;
@property (nonatomic, retain) NSMutableArray * informationViews;

@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *keyScrollView;
@property (nonatomic, retain) IBOutlet UITextField * textField1;
@property (nonatomic, retain) IBOutlet UITextField * textField2;
@property (nonatomic, retain) IBOutlet UITextField * textField3;
@property (nonatomic, retain) IBOutlet UITextField * textField4;
@property (nonatomic, retain) IBOutlet UITextField * textField5;

@property (nonatomic, retain) UISegmentedControl *nextPreviousControl;
@property (nonatomic, retain) UIToolbar *keyboardToolbar;

@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;
@property (nonatomic, retain) CLGeocoder *reverseCLGeocoder;

@property (nonatomic, retain) CoreLocationController *CLController;

//keyboard actions
- (IBAction)nextPrevious:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)editingChanged:(id)sender;
- (IBAction)submitValues:(id)sender;

//scrollviewactions
- (IBAction)changePage:(id)sender;
- (void)loadScrollViewWithPage:(int)page;
-(IBAction)openInMaps:(id)sender;

- (IBAction)menuButtonPressed:(id)sender;

- (void) infoViewDidPin:(InformationViewController*)showingInfoController;
- (void) presentSuccessView;
- (void) geoCodeUsingAddress:(NSString *)address;
- (void) settings;
- (void) setupWebView;
- (void) hideDefaultImg;
- (void) animateWebView;
- (void) removeWebView;
- (void) otherSetupAfterViewLoads;


- (void)keyboardWillShow:(NSNotification *)notification;
- (IBAction)searchButtonsPressed:(id)sender;
- (void) loadScrollViewOnMainSelector;

- (IBAction)reverseGeocodeCurrentLocation;
- (void)myTask;
- (void) gpsPlusMyTask;

- (IBAction)showNewsletterAnimated:(BOOL)animated;

@end
