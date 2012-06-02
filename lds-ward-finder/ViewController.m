//
//  ViewController.m
//  lds-ward-finder
//
//  Created by Joshua Howland on 12/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController


@synthesize pageControl;
@synthesize scrollView;
@synthesize informationViews;
@synthesize reverseGeocoder;
@synthesize reverseCLGeocoder;

@synthesize keyScrollView;
@synthesize textField1 = _textField1;
@synthesize textField2 = _textField2;
@synthesize textField3 = _textField3;
@synthesize textField4 = _textField4;
@synthesize textField5 = _textField5;

@synthesize nextPreviousControl;
@synthesize keyboardToolbar;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark - View Lifecycle


- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	
    if (![AppSettings sharedSettings].invitedToRegister) {
        
        if (buttonIndex == [alertView cancelButtonIndex]) {
            [AppSettings sharedSettings].newVersionInvited = YES;
            [AppSettings sharedSettings].invitedToRegister = YES;
        
        } 
        else if (buttonIndex == 1) {
            [AppSettings sharedSettings].newVersionInvited = YES;
            [AppSettings sharedSettings].invitedToRegister = YES;
            [self showNewsletterAnimated:YES];
		}
        else if (buttonIndex ==2) {
            [AppSettings sharedSettings].newVersionInvited = YES;
            [AppSettings sharedSettings].invitedToRegister = NO;
            [AppSettings sharedSettings].launchCount = 0;
            
        }
	}
    else if(![AppSettings sharedSettings].newVersionInvited) {
        
        if (buttonIndex == [alertView cancelButtonIndex]) {
            [AppSettings sharedSettings].newVersionInvited = YES;
            [AppSettings sharedSettings].invitedToRegister = YES;
            
        } 
        else if (buttonIndex == 1) {
            [AppSettings sharedSettings].newVersionInvited = YES;
            [AppSettings sharedSettings].invitedToRegister = YES;
            [self showNewsletterAnimated:YES];
		}
        else if (buttonIndex ==2) {
            [AppSettings sharedSettings].newVersionInvited = YES;
            [AppSettings sharedSettings].invitedToRegister = NO;
            [AppSettings sharedSettings].launchCount = 0;
            
        }

    
    }
}

- (void)viewDidLoad {
    
    [AppSettings sharedSettings].gpsPurchased = YES;
    
    if([AppSettings sharedSettings].launchCount == 0){
        
        if (![AppSettings sharedSettings].invitedToRegister) {
            
            UIAlertView *dialog = [[[UIAlertView alloc] initWithTitle:@"We'd love to keep in touch for support, and to share news about other apps we're working on. Sign up for our newsletter."
                                                              message:nil
                                                             delegate:self 
                                                    cancelButtonTitle:@"No Thanks"
                                                    otherButtonTitles:@"Subscribe Now", @"Remind Me Later", nil] autorelease];
            [dialog show];
             
        }
        [AppSettings sharedSettings].launchCount++;
        
    }
    else if (![AppSettings sharedSettings].newVersionInvited) {
        
        UIAlertView *dialog = [[[UIAlertView alloc] initWithTitle:@"We hope you like our new update to this app. We'd love to keep in touch for support, and to share news about other apps we're working on. Sign up for our newsletter."
                                                          message:nil
                                                         delegate:self 
                                                cancelButtonTitle:@"No Thanks"
                                                otherButtonTitles:@"Subscribe Now", @"Remind Me Later", nil] autorelease];
        [dialog show];
        
        
        
        
    }
    else {
        
        [AppSettings sharedSettings].launchCount++;
        
    }

    
    haveCoordinate = NO;
    
    [super viewDidLoad];
        
    CLController = [[CoreLocationController alloc] init];
	CLController.delegate = self;
	[CLController.locMgr startUpdatingLocation];
    
    //TODO - Write a plist to the app, and load that plist when this view loads
    
    kNumberOfPages = 1;
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    
    for (unsigned i = 0; i < 12; i++) {
        [controllers addObject:[NSNull null]];
    }
    
    
    self.informationViews = controllers;
    
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    pageControl.numberOfPages = kNumberOfPages-1;
    pageControl.currentPage = kNumberOfPages-1;
        
    // Create a default style RevealSidebarView
    centralView = [[JTRevealSidebarView defaultViewWithFrame:self.view.bounds] retain];
    
    [centralView.contentView addSubview:startscreen];
    
    [centralView.sidebarView pushView:screen1 animated:NO];
    [centralView.sidebarViewRight pushView:screen3 animated:NO];    
    
    centralView.frame = CGRectMake(0, 20, 320, 460);
    [self.view addSubview:centralView];
    [self.view addSubview:coverScreen];
    
    webview = [[[UIWebView alloc] init] autorelease];
    
    webview.alpha = 0;
    [self.view addSubview:webview];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0f];	
    webview.alpha = 1; // also fade to transparent
    [UIView commitAnimations];
    
    
    webview.frame = CGRectMake(0, 0, 320, 480);
    
    NSString * text = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"appsbylift" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil] retain];	
    [webview loadHTMLString:text baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    [text release];
    
    [self performSelector:@selector(removeWebView) withObject:nil afterDelay:4];  
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];	
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


- (void)dealloc {
	
    [initialLocation release];
    [reverseGeocoder release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [CLController release];
    [wardURL release];
	[keyboardToolbar release], keyboardToolbar = nil;
	[nextPreviousControl release], nextPreviousControl = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark - GEO locations

- (IBAction)reverseGeocodeCurrentLocation
{
    NSString *reqSysVer = @"5.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending){
    
        self.reverseGeocoder =
        [[[MKReverseGeocoder alloc] initWithCoordinate:initialLocation.coordinate] autorelease];
        reverseGeocoder.delegate = self;
        [reverseGeocoder start];    
        
    }
    else {
    self.reverseGeocoder =
        [[[MKReverseGeocoder alloc] initWithCoordinate:initialLocation.coordinate] autorelease];
        reverseGeocoder.delegate = self;
        [reverseGeocoder start];    
    }
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot obtain address."
														message:errorMessage
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    initialPlacemark = placemark;
}


#pragma mark -
#pragma mark - IBActions on page

- (IBAction)showNewsletterAnimated:(BOOL)animated {
    
    /*#if defined (FREE_CHURCH_VERSION)
     
     
     NSString * mailURL = @"http://liftgames.us2.list-manage.com/subscribe?u=274b7588cdec7e982eeaacd6e&id=87cc1062d9&group[1][128]=true";
     
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString: mailURL]];
     
     #elif defined (FULL_CHURCH_VERSION)
     
     */
    
    NSString * mailURL = @"http://liftgames.us2.list-manage.com/subscribe?u=274b7588cdec7e982eeaacd6e&id=87cc1062d9&group[1][256]=true";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: mailURL]];
    
    //#endif
    
}

- (IBAction) safariLink:(NSString *) navURL {
	
	NSString *urlString = navURL;
    //	NSURL *safariURL = [NSURL URLWithString: navURL];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: urlString]];
    
    //	[[UIApplication sharedApplication] openURL:appStoreUrl];
    
}

- (IBAction)gpssearch:(id)sender {

    if(latitudeLabel) {
        
    //once was SUBMIT Values
    hudDisplayed = YES;
    useGPSCoordinates = YES;
    
    if([centralView isSidebarShowing]) [self menuButtonPressed:self];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
	
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	

        
    // Show the HUD while the provided method executes in a new thread
    [centralView.contentView addSubview:screen2];
    
    [HUD showWhileExecuting:@selector(gpsPlusMyTask) onTarget:self withObject:nil animated:YES];
    
    }
    else{
        UIAlertView *alert = [[[UIAlertView alloc] 
                               initWithTitle: @"Sorry" 
                               message:@"We couldn't get your GPS location. Try again later, or use a manual search."
                               delegate:nil
                               cancelButtonTitle:nil 
                               otherButtonTitles:@"OK", nil] autorelease];
        
        [alert show];

    
    }
}

- (void) gpsPlusMyTask {

    [self reverseGeocodeCurrentLocation];
    [self myTask];

}

- (void)locationUpdate:(CLLocation *)location {
    //NSString * text = [NSString stringWithFormat:@"latitude:%@ longitude:%@",location.coordinate.latitude,location.coordinate.longitude];
    
    latitude = location.coordinate.latitude;
	longitude = location.coordinate.longitude;

    latitudeLabel = [NSString stringWithFormat:@"%f",latitude];
    
    initialLocation = [location retain];
    haveCoordinate = YES;
    
    
    NSLog(@"location updated");

}

- (void)locationError:(NSError *)error {
	locLabel = [error description];
}


- (IBAction)liftSettingsDash {
	
    LiftInfoViewController *viewController = [[LiftInfoViewController alloc] init];
	viewController.delegate = self;
    
	[self presentModalViewController:viewController animated:YES];
	
}


-(IBAction)menuButtonPressed:(id)sender 
{    
    if(![centralView isLeftSidebarOnTop]) [centralView swapSidebarViewIndecies];
    [centralView revealSidebar: ! [centralView isSidebarShowing]];    
    
}

-(IBAction)plusButtonPressed:(id)sender 
{    
    if([centralView isLeftSidebarOnTop]) [centralView swapSidebarViewIndecies];
    [centralView revealSidebarRight: ! [centralView isSidebarShowingRight]];    
    
}

- (IBAction)searchButtonsPressed:(id)sender {
    
    //once was SUBMIT Values
    hudDisplayed = YES;
 
    /*
     
     -(IBAction)submitValues:(id)sender {
     
     [self dismissKeyboard:sender];
     
     if(!adInterstitialLoaded) {
     
     
     HUD = [[MBProgressHUD alloc] initWithView:self.view];
     [self.view addSubview:HUD];
     
     HUD.delegate = self;
     HUD.labelText = @"Loading";
     
     [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
     }
     else {
     
     hudDisplayed = NO;
     
     seconds = 5;
     displayTimeUp=NO;
     timer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
     
     [self showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
     
     }
     }
     
     
    */
    
    
    
    if([centralView isSidebarShowing]) [self menuButtonPressed:self];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
	
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    // Show the HUD while the provided method executes in a new thread
    [centralView.contentView addSubview:screen2];
    
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    
}


-(void) showSearchResults {
    
    sleep(3);
    
    [self performSelectorOnMainThread:@selector(loadScrollViewOnMainSelector) withObject:nil waitUntilDone:NO];
    
}

- (void) loadScrollViewOnMainSelector {

    [self loadScrollViewWithPage:kNumberOfPages-1];
    [self loadScrollViewWithPage:kNumberOfPages];

    

}

- (IBAction)additionalSearchButtonsPressed:(id)sender {
    
    if([centralView isSidebarShowingRight])[self plusButtonPressed:self];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
	
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(addSearchResults) onTarget:self withObject:nil animated:YES];
    
}

- (void)addSearchResults {
    
    sleep(3);
    
    kNumberOfPages++;
    
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    
    pageControl.numberOfPages = kNumberOfPages;
    pageControl.currentPage = kNumberOfPages-1;
    
    [self loadScrollViewWithPage:kNumberOfPages-1];
    [self loadScrollViewWithPage:kNumberOfPages];
    
}


- (void)liftInfoViewControllerDidFinish:(LiftInfoViewController*) liftInfoViewController {
	//[self.mainView snapToPage];
	
    centralView.frame = CGRectMake(0, 0, 320, 460);
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)openInMaps:(id)sender {
    
    NSString * urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@",initialAddress];
    
    NSString *escaped_urlString =  [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escaped_urlString]];
}


#pragma mark -
#pragma mark - share methods


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error  {   
    NSString *message = @"";
    // Notifies users about errors associated with the interface
    switch (result) {
        case MFMailComposeResultCancelled:
            message = @"Mail: canceled";
            break;
        case MFMailComposeResultSaved:
            message = @"Mail: saved";
            break;
        case MFMailComposeResultSent:
        {
            message = @"Mail: sent";
            
            //Your code
            
            
        }
            break;
        case MFMailComposeResultFailed:
            message = @"Mail: failed";
            break;
        default:
            message = @"Mail: not sent";
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)share:(id)sender
{	
    
	UIActionSheet * shareSheet = [[UIActionSheet alloc] initWithTitle:@"Share or Save" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Twitter", @"Facebook", @"Message", @"Email", nil];
    
    shareSheet.delegate = self;
    
    [shareSheet showInView:self.view];
    [shareSheet release];
    
    //	SHKItem *item = [SHKItem text:text];
    //	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	
    //	[actionSheet showFromToolbar:self.navigationController.toolbar];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *text;
	NSString *twitterText;
    NSString *emailText;
    
    twitterText = [NSString stringWithFormat:@"Found an LDS ward at %@ that starts at %@ with Ward Finder",initialAddress,initialFirstMeeting];
    
    text = [NSString stringWithFormat:@"I found an LDS church and time with LDS Ward Finder: %@ - First meeting: %@ - Worship service: %@     ",initialAddress,initialFirstMeeting,initialWorshipService];
    
    emailText = [NSString stringWithFormat:@"<strong>Address:</strong><br/>%@ <br/><br/><strong>First meeting: </strong>%@ <br/><strong>Worship service:</strong> %@<br/><br/><strong>Ward URL:</strong> %@<br/><br/><strong>Check out Ward Finder app!</strong> http://appsbylift.com/apps/lds-ward-finder/",initialAddress,initialFirstMeeting,initialWorshipService,wardURL];
    
    twitterText = [twitterText stringByReplacingOccurrencesOfString:@", United States" withString:@""];
    
    
    [AddThisSDK setAddThisPubId:@"ra-4eda3ed73c9d7c1b"];
    [AddThisSDK setAddThisApplicationId:@"4eda7478663f015e"];
    
    [AddThisSDK setFacebookAPIKey:@"254395284615023"];
	[AddThisSDK setFacebookAuthenticationMode:ATFacebookAuthenticationTypeFBConnect];
    
    [AddThisSDK setTwitterConsumerKey:@"3423s3gwsPdUorz0TWF30Q"];
    [AddThisSDK setTwitterConsumerSecret:@"W0LXV71buxJdqzvqpeiA0WnsfUiG2BCZB18sBgZCB4"];
    [AddThisSDK setTwitterCallBackURL:@"http://appsbylift.com"];
    
    [AddThisSDK setTwitterViaText:@"liftmn"];
    
    switch (buttonIndex) {
        case 0:
            [AddThisSDK shareURL:@"http://liftmn.com/wfd"
                     withService:@"twitter"
                           title:@"LDS Ward Finder found the chapel and time for us."
                     description:twitterText];
            break;
        case 1:
            [AddThisSDK shareURL:@"http://liftmn.com/wfd"
                     withService:@"facebook"
                           title:@"LDS Ward Finder found the chapel and time for us."
                     description:text];
            break;
        case 2:
            [self sendTextMessage:text];
            
            break;
        case 3:
            
            [self emailCurrentPage:emailText];
            
            break;
            
            
            break;
    }
    
}

-(void)sendTextMessage:(NSString *) withBody {
    
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = withBody;    
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }    
    
    
}

-(IBAction)emailCurrentPage:(NSString *) text {
    
    NSString *textToBeSend = text;
    
    MFMailComposeViewController *mailComposer;
    mailComposer=[[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate=self;
    [mailComposer setSubject:@"Found the church and time with Ward Finder"];
    [mailComposer setMessageBody:textToBeSend isHTML:YES];
    [self presentModalViewController:mailComposer animated:YES];
    
    [mailComposer release];
    
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	[self dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");  
    else 
        NSLog(@"Message failed");
}


#pragma mark -
#pragma mark - Scrape Task

- (void)myTask {
    
    NSString *result;
    
    if(useGPSCoordinates) {
    
        useGPSCoordinates = NO;
        
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        
        //use address from form to generate string to send in to geoCodeUsingAddress
        
        // Get the Latitude Longitude
        
        // somehow determine if the information isn't enough 

        if(badInfo){
            
            [HUD hide:YES afterDelay:1];
            
            NSLog(@"it's bad info");
            
            UIApplication* app = [UIApplication sharedApplication];
            app.networkActivityIndicatorVisible = NO;
            
            return;
            
        }
        
        //use geocode and address to generate link to correct map
        
        //escaped address is only street location
        
        NSString * address = [[[NSString alloc]init]autorelease];
        if([initialPlacemark.thoroughfare isEqualToString:@""]){
            if([initialPlacemark.subThoroughfare isEqualToString:@""]){
            address = @"";
            }
            else {
                address = [NSString stringWithFormat:@"&a=%@",initialPlacemark.subThoroughfare];
            }
        }
        else {
            if([initialPlacemark.subThoroughfare isEqualToString:@""]){
                address = [NSString stringWithFormat:@"&a=%@",initialPlacemark.thoroughfare];
            }
            else {
                address = [NSString stringWithFormat:@"&a=%@%20%@",initialPlacemark.subThoroughfare, initialPlacemark.thoroughfare];                
            }
        
        }
        NSString *escaped_address =  [address stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        
        NSString * city = [[[NSString alloc]init]autorelease];
        if([initialPlacemark.locality isEqualToString:@""]) {
            city = @"";
        }
        else {
            city = [NSString stringWithFormat:@"&c=%@",initialPlacemark.locality];
        }
        NSString *escaped_city =  [city stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        

        
        
        
        NSString * state = [[[NSString alloc]init]autorelease];
        if([initialPlacemark.administrativeArea isEqualToString:@""]) {
            state = @"";
        }
        else {
            state = [NSString stringWithFormat:@"&s=%@",initialPlacemark.administrativeArea];
        }
        NSString *escaped_state =  [state stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        
        
        NSString * postal = [[[NSString alloc]init]autorelease];
        if([initialPlacemark.postalCode isEqualToString:@""]) {
            postal = @"";
        }
        else {
            postal = [NSString stringWithFormat:@"&p=%@",initialPlacemark.postalCode];        
        }
        NSString *escaped_postal =  [postal stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        
        NSString * nation = [[[NSString alloc]init]autorelease];
        if([initialPlacemark.country isEqualToString:@""]) {
            nation = @"";
        }
        else {
            nation = [NSString stringWithFormat:@"&p=%@",initialPlacemark.country];        
        }
        NSString *escaped_nation =  [nation stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];

        
        
        // create url to contact LDS.org for value
        NSString *requestString = [NSString stringWithFormat:@"http://lds.org/maps/m/index.jsf?lat=%f&lng=%f%@%@%@%@%@&assign=wards", latitude, longitude, escaped_address, escaped_city, escaped_state, escaped_postal, escaped_nation];
        
        NSURL *url = [NSURL URLWithString:requestString];
        
        
        result = [NSString stringWithContentsOfURL: url encoding: NSUTF8StringEncoding error:NULL];
        
        
        
    }
    else {
        
        
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        
        //use address from form to generate string to send in to geoCodeUsingAddress
        
        NSString * nation = [[[NSString alloc]init]autorelease];
        if([_textField5.text isEqualToString:@""]) {
            nation = @" United States";
        }
        else {
            nation = [NSString stringWithFormat:@"&n=%@",_textField5.text];        
        }
        NSString *escaped_nation =  [nation stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        
        NSString * geoSearch = [[[NSString alloc] init]autorelease];
        geoSearch = [NSString stringWithFormat:@"%@ %@, %@ %@ %@",_textField1.text,_textField2.text,_textField3.text,_textField4.text,nation];
        if([geoSearch isEqualToString:@" ,    United States"]) {
            [HUD hide:YES afterDelay:1];
            
            NSLog(@"it's blank");
            
            UIAlertView *alert = [[[UIAlertView alloc] 
                                   initWithTitle: @"Sorry" 
                                   message:@"We couldn't find a church with the info given."
                                   delegate:nil
                                   cancelButtonTitle:nil 
                                   otherButtonTitles:@"OK", nil] autorelease];
            
            [alert show];
            
            UIApplication* app = [UIApplication sharedApplication];
            app.networkActivityIndicatorVisible = NO;
            
            return;
            
        }
        
        
        [self geoCodeUsingAddress:geoSearch];    //[self geoCodeUsingAddress:@"273 E 9670 S Sandy, UT 84070"];
        
        if(badInfo){
            
            [HUD hide:YES afterDelay:1];
            
            NSLog(@"it's bad info");
            
            UIApplication* app = [UIApplication sharedApplication];
            app.networkActivityIndicatorVisible = NO;
            
            return;
            
        }
        
        //use geocode and address to generate link to correct map
        
        //escaped address is only street location
        NSString * address = [[[NSString alloc]init]autorelease];
        if([_textField1.text isEqualToString:@""]) {
            address = @"";
        }
        else {
            address = [NSString stringWithFormat:@"&a=%@",_textField1.text];
        }
        NSString *escaped_address =  [address stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        NSString * city = [[[NSString alloc]init]autorelease];
        if([_textField2.text isEqualToString:@""]) {
            city = @"";
        }
        else {
            city = [NSString stringWithFormat:@"&c=%@",_textField2.text];
        }
        NSString *escaped_city =  [city stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        NSString * state = [[[NSString alloc]init]autorelease];
        if([_textField3.text isEqualToString:@""]) {
            state = @"";
        }
        else {
            state = [NSString stringWithFormat:@"&s=%@",_textField3.text];
        }
        NSString *escaped_state =  [state stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        NSString * postal = [[[NSString alloc]init]autorelease];
        if([_textField4.text isEqualToString:@""]) {
            postal = @"";
        }
        else {
            postal = [NSString stringWithFormat:@"&p=%@",_textField4.text];        
        }
        
        NSString *escaped_postal =  [postal stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
  
    NSString *requestString = [NSString stringWithFormat:@"http://lds.org/maps/m/index.jsf?lat=%f&lng=%f%@%@%@%@%@&assign=wards", latitude, longitude, escaped_address, escaped_city, escaped_state, escaped_postal, escaped_nation];
        
        
    NSURL *url = [NSURL URLWithString:requestString];
    
        
    result = [NSString stringWithContentsOfURL: url encoding: NSUTF8StringEncoding error:NULL];
    
        NSLog(@"Hello world");
        int x = 0;
        
        
    }
    
    
    
    
        
    //I need to find the range for the ID still
    NSRange rangeStart = [result rangeOfString:@"index.jsf?id"];
    
    if(rangeStart.location != NSNotFound)
    {
        NSRange rangeEnd = [result rangeOfString:@">" options:NSCaseInsensitiveSearch range:NSMakeRange(rangeStart.location + rangeStart.length, [result length] - (rangeStart.location + rangeStart.length))];
        
        //Use the ranges above to find the link. Subtracting 20 because they are sending back a target. We need to cut that off so we just get a URL
        NSRange trueRange = NSMakeRange((rangeStart.location + rangeStart.length + 1), (rangeEnd.location - (rangeStart.location + rangeStart.length + 1) - 1));
        
        //set meetinghouseID to the string
        meetinghouseID = [[result substringWithRange:trueRange] retain];
    }
    
    wardURL = [[NSString stringWithFormat:@"http://lds.org/maps/m/index.jsf?id=%@",meetinghouseID] retain];
    
    NSURL * url1 = [NSURL URLWithString:wardURL];
    
    
    loadedPageContents = [NSString stringWithContentsOfURL: url1 encoding: NSUTF8StringEncoding error:NULL];

    
    //Create ranges to find the actual link tag
    NSRange rangeStart00 = [loadedPageContents rangeOfString:@"<img src="];
    
    if(rangeStart00.location != NSNotFound)
    {
        NSRange rangeEnd00 = [loadedPageContents rangeOfString:@" />" options:NSCaseInsensitiveSearch range:NSMakeRange(rangeStart00.location + rangeStart00.length, [loadedPageContents length] - (rangeStart00.location + rangeStart00.length))];
        
        //Use the ranges above to find the link. Subtracting 200 because they are sending back a target. We need to cut that off so we just get a URL
        NSRange trueRange00 = NSMakeRange((rangeStart00.location + rangeStart00.length + 0), (rangeEnd00.location - (rangeStart00.location + rangeStart00.length + 0) - 0));
        
        NSString * imageURL = [[[NSString alloc] init]autorelease];
        
        //set address to the string
        imageURL = [[loadedPageContents substringWithRange:trueRange00] copy];
                
        imageURL = [imageURL stringByReplacingOccurrencesOfString:@"amp;" withString:@""];

        NSRange rangeEndSig = [imageURL rangeOfString:@"&signature="];
                
        if(rangeEndSig.location != NSNotFound)
        {
            NSRange rangeStartSig = NSMakeRange(0, 0);
            
            //Use the ranges above to find the link. Subtracting 200 because they are sending back a target. We need to cut that off so we just get a URL
            NSRange trueRangeSig = NSMakeRange((rangeStartSig.location + rangeStartSig.length), (rangeEndSig.location - (rangeStartSig.location + rangeStartSig.length + 0) - 0));

            NSString * signatureImageURL = [[imageURL substringWithRange:trueRangeSig] copy];
            
            imageURL = signatureImageURL;
        }
            
        imageURL = [NSString stringWithFormat:@"<html><body style=\"margin: 0px; padding: 0px;\"><img src=%@\" height=\"106\" width=\"106\" /></body></html>",imageURL];
        
        imageURL = [imageURL stringByReplacingOccurrencesOfString:@"client=gme-lds&" withString:@""];

        
        initialMapImage = [imageURL retain];
        
    }  

    
    
    //Create ranges to find the actual link tag
    NSRange rangeStart0 = [loadedPageContents rangeOfString:@"Selected location"];
    
    if(rangeStart0.location != NSNotFound)
    {
        NSRange rangeEnd0 = [loadedPageContents rangeOfString:@"subtitle" options:NSCaseInsensitiveSearch range:NSMakeRange(rangeStart0.location + rangeStart0.length, [loadedPageContents length] - (rangeStart0.location + rangeStart0.length))];
        
        //Use the ranges above to find the link. Subtracting 20 because they are sending back a target. We need to cut that off so we just get a URL
        NSRange trueRange0 = NSMakeRange((rangeStart0.location + rangeStart0.length + 34), (rangeEnd0.location - (rangeStart0.location + rangeStart0.length + 34) - 18));
        
        //set address to the string
        initialWardName = [[loadedPageContents substringWithRange:trueRange0] copy];
        
        
        initialWardName = [initialWardName stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
        initialWardName = [initialWardName stringByReplacingOccurrencesOfString:@"\n" withString:@"  "];        
        initialWardName = [initialWardName stringByReplacingOccurrencesOfString:@"  			<br />" withString:@" "];
        initialWardName = [initialWardName stringByReplacingOccurrencesOfString:@"  " withString:@" "];
                
    }  

    
    
    //Create ranges to find the actual link tag
    NSRange rangeStart1 = [loadedPageContents rangeOfString:@"address"];
    
    if(rangeStart1.location != NSNotFound)
    {
        NSRange rangeEnd1 = [loadedPageContents rangeOfString:@"label" options:NSCaseInsensitiveSearch range:NSMakeRange(rangeStart1.location + rangeStart1.length, [loadedPageContents length] - (rangeStart1.location + rangeStart1.length))];
        
        //Use the ranges above to find the link. Subtracting 20 because they are sending back a target. We need to cut that off so we just get a URL
        NSRange trueRange1 = NSMakeRange((rangeStart1.location + rangeStart1.length + 11), (rangeEnd1.location - (rangeStart1.location + rangeStart1.length + 11) - 18));
        
        //set address to the string
        initialAddress = [[loadedPageContents substringWithRange:trueRange1] copy];
        
        
        initialAddress = [initialAddress stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
        initialAddress = [initialAddress stringByReplacingOccurrencesOfString:@"\n" withString:@"  "];        
        initialAddress = [initialAddress stringByReplacingOccurrencesOfString:@"  			<br />" withString:@" "];
        
        initialAddress = [initialAddress lowercaseString];
        initialAddress = [initialAddress capitalizedString];
        
        
    }  
    
    //Create ranges to find the actual link tag
    NSRange rangeStart2 = [loadedPageContents rangeOfString:@"First Meeting:"];
    
    if(rangeStart2.location != NSNotFound)
    {
        NSRange rangeEnd2 = [loadedPageContents rangeOfString:@"</div" options:NSCaseInsensitiveSearch range:NSMakeRange(rangeStart2.location + rangeStart2.length, [loadedPageContents length] - (rangeStart2.location + rangeStart2.length))];
        
        //Use the ranges above to find the link. Subtracting 20 because they are sending back a target. We need to cut that off so we just get a URL
        NSRange trueRange2 = NSMakeRange((rangeStart2.location + rangeStart2.length), (rangeEnd2.location - (rangeStart2.location + rangeStart2.length)));
        
        //set address to the string
        initialFirstMeeting = [[loadedPageContents substringWithRange:trueRange2] copy];
        
        initialFirstMeeting = [initialFirstMeeting stringByReplacingOccurrencesOfString:@"</label>" withString:@""];
        
        initialFirstMeeting = [initialFirstMeeting stringByReplacingOccurrencesOfString:@"				<span>" withString:@""];
        
        initialFirstMeeting = [initialFirstMeeting stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
        
        initialFirstMeeting = [initialFirstMeeting stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
    }
    
    //Create ranges to find the actual link tag
    NSRange rangeStart3 = [loadedPageContents rangeOfString:@"Worship Service:"];
    
    if(rangeStart3.location != NSNotFound)
    {
        NSRange rangeend3 = [loadedPageContents rangeOfString:@"</div" options:NSCaseInsensitiveSearch range:NSMakeRange(rangeStart3.location + rangeStart3.length, [loadedPageContents length] - (rangeStart3.location + rangeStart3.length))];
        
        //Use the ranges above to find the link. Subtracting 30 because they are sending back a target. We need to cut that off so we just get a URL
        NSRange trueRange3 = NSMakeRange((rangeStart3.location + rangeStart3.length), (rangeend3.location - (rangeStart3.location + rangeStart3.length)));
        
        //set address to the string
        initialWorshipService = [[loadedPageContents substringWithRange:trueRange3] copy];
        
        
        initialWorshipService = [initialWorshipService stringByReplacingOccurrencesOfString:@"</label>" withString:@""];
        
        initialWorshipService = [initialWorshipService stringByReplacingOccurrencesOfString:@"				<span>" withString:@""];
        
        initialWorshipService = [initialWorshipService stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
        
        initialWorshipService = [initialWorshipService stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                
    }
    
    //Create ranges to find the actual link tag
    NSRange rangeStart4 = [loadedPageContents rangeOfString:@"Leader:"];
    
    if(rangeStart4.location != NSNotFound)
    {
        NSRange rangeEnd4 = [loadedPageContents rangeOfString:@"</span>" options:NSCaseInsensitiveSearch range:NSMakeRange(rangeStart4.location + rangeStart4.length, [loadedPageContents length] - (rangeStart4.location + rangeStart4.length))];
        
        //Use the ranges above to find the link. Subtracting 20 because they are sending back a target. We need to cut that off so we just get a URL
        NSRange trueRange4 = NSMakeRange((rangeStart4.location + rangeStart4.length + 20), (rangeEnd4.location - (rangeStart4.location + rangeStart4.length + 20) - 0));
        
        //set address to the string
        initialBishopName = [[loadedPageContents substringWithRange:trueRange4] copy];
        
        
        initialBishopName = [initialBishopName stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
        initialBishopName = [initialBishopName stringByReplacingOccurrencesOfString:@"\n" withString:@"  "];        
        initialBishopName = [initialBishopName stringByReplacingOccurrencesOfString:@"  			<br />" withString:@" "];
        initialBishopName = [initialBishopName stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        
        initialBishopName = [initialBishopName lowercaseString];
        initialBishopName = [initialBishopName capitalizedString];
        
    }  
    
    //Create ranges to find the actual link tag
    NSRange rangeStart5 = [loadedPageContents rangeOfString:@"tel:"];
    
    if(rangeStart5.location != NSNotFound)
    {
        NSRange rangeEnd5 = [loadedPageContents rangeOfString:@"</a>" options:NSCaseInsensitiveSearch range:NSMakeRange(rangeStart5.location + rangeStart5.length, [loadedPageContents length] - (rangeStart5.location + rangeStart5.length))];
        
        //Use the ranges above to find the link. Subtracting 20 because they are sending back a target. We need to cut that off so we just get a URL
        NSRange trueRange5 = NSMakeRange((rangeStart5.location + rangeStart5.length + 17), (rangeEnd5.location - (rangeStart5.location + rangeStart5.length + 17) - 0));
        
        //set address to the string
        initialBishopPhone = [[loadedPageContents substringWithRange:trueRange5] copy];
        
    
        initialBishopPhone = [initialBishopPhone stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
        initialBishopPhone = [initialBishopPhone stringByReplacingOccurrencesOfString:@"\n" withString:@"  "];        
        initialBishopPhone = [initialBishopPhone stringByReplacingOccurrencesOfString:@"  			<br />" withString:@" "];
        initialBishopPhone = [initialBishopPhone stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        
        initialBishopPhone = [initialBishopPhone lowercaseString];
        initialBishopPhone = [initialBishopPhone capitalizedString];
        
    }  
    
    answerFound = YES;
    
    if(hudDisplayed) { 
        
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = NO;
                
        [self performSelectorOnMainThread:@selector(loadScrollViewOnMainSelector) withObject:nil waitUntilDone:YES];
        
    }
    
    //load webview with url
    //webview finished loading should have correct code.
}



#pragma mark -
#pragma mark Paging Scroll View Methods


- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
    
    // replace the placeholder if necessary
    InformationViewController *controller = [informationViews objectAtIndex:page];    
        controller = [[InformationViewController alloc] initWithPageNumber:page];
        controller.firstMeetingTime = initialFirstMeeting;
        controller.worshipServiceTime = initialWorshipService;
        controller.address = initialAddress;
        controller.wardName = initialWardName;
    controller.bishopsName = initialBishopName;
    controller.phoneNumber = initialBishopPhone;
    controller.mapImage = initialMapImage;
        [informationViews replaceObjectAtIndex:page withObject:controller];
	
    // add the controller's view to the scroll view
    if (nil == controller.view.superview) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}


// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    // update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}




#pragma mark -
#pragma mark Geo Location Parsing Methods


- (void) geoCodeUsingAddress:(NSString *)address{
    
    int code = -1;
    int accuracy = -1;
    latitude = 0.0f;
    longitude = 0.0f;
    
    // setup maps api key
    NSString * MAPS_API_KEY = @"ABQIAAAAip2ePO3akRgmFMnjj5dC8BQyUjv40pGN84GguG_BimOGlC0_6hSlKtrXDzeRxtDPpchng5TOe5oYZw";
    
    NSString *escaped_address =  [address stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    // Contact Google and make a geocoding request
    NSString *requestString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv&oe=utf8&key=%@&sensor=false&gl=it", escaped_address, MAPS_API_KEY];
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSString *result = [NSString stringWithContentsOfURL: url encoding: NSUTF8StringEncoding error:NULL];
    if(result){
        // we got a result from the server, now parse it
        NSScanner *scanner = [NSScanner scannerWithString:result];
        [scanner scanInt:&code];
        if(code == 200){
            badInfo = NO;
            
            // everything went off smoothly
            [scanner scanString:@"," intoString:nil];
            [scanner scanInt:&accuracy];
            
            //NSLog(@"Accuracy: %d", accuracy);
            
            [scanner scanString:@"," intoString:nil];
            [scanner scanFloat:&latitude];
            [scanner scanString:@"," intoString:nil];
            [scanner scanFloat:&longitude];
            
            
            NSLog(@"Latitude = %f",latitude);
            NSLog(@"Longitude = %f",longitude);
            
            
            
        }
        else{
            badInfo = YES;
            // the server answer was not the one we expected
            UIAlertView *alert = [[[UIAlertView alloc] 
                                   initWithTitle: @"Sorry" 
                                   message:@"We couldn't find anything with the info given."
                                   delegate:nil
                                   cancelButtonTitle:nil 
                                   otherButtonTitles:@"OK", nil] autorelease];
            
            [alert show];
        }
        
    }
    else{
        badInfo = YES;
        // no result back from the server
        UIAlertView *alert = [[[UIAlertView alloc] 
                               initWithTitle: @"Dang" 
                               message:@"We don't have a connection to the server."
                               delegate:nil
                               cancelButtonTitle:nil 
                               otherButtonTitles:@"OK", nil] autorelease];
        
        [alert show];
        
    }
    
}



#pragma mark -
#pragma mark Button Actions

- (IBAction)dismissKeyboard:(id)sender
{
	[[self.view findFirstResponder] resignFirstResponder];
}

- (IBAction)nextPrevious:(id)sender
{
	UIView *responder = [self.view findFirstResponder];		
	
	switch([(UISegmentedControl *)sender selectedSegmentIndex]) {
		case 0:
			// previous
			if (responder == _textField1) {
				[_textField5 becomeFirstResponder];

			} else if (responder == _textField2) {
				[_textField1 becomeFirstResponder];

			} else if (responder == _textField3) {
				[_textField2 becomeFirstResponder];

			} else if (responder == _textField4) {
				[_textField3 becomeFirstResponder];

			} else if (responder == _textField5) {
				[_textField4 becomeFirstResponder];

			}			
			break;
		case 1:
			// next
			if (responder == _textField1) {
				[_textField2 becomeFirstResponder];

			} else if (responder == _textField2) {
				[_textField3 becomeFirstResponder];

			} else if (responder == _textField3) {
				[_textField4 becomeFirstResponder];

			} else if (responder == _textField4) {
				[_textField5 becomeFirstResponder];

            } else if (responder == _textField5) {
				[_textField1 becomeFirstResponder];

            }
			break;		
	}	
    
}

- (IBAction)editingChanged:(id)sender
{
	
}

#pragma mark -
#pragma mark WebView Splash animation


- (void) hideDefaultImg {
    
    coverScreen.hidden = YES;
    
}

- (void) animateWebView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5f];	
	webview.alpha = 0; // also fade to transparent
	[UIView commitAnimations];
	
}

-(void) removeWebView {
    
    [self hideDefaultImg];
    
    webview.alpha = 1;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7f];	
    webview.alpha = 0; // also fade to transparent
    [UIView commitAnimations];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];   
    
}



#pragma mark -
#pragma mark UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   [keyScrollView adjustOffsetToIdealIfNeeded];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	//keyboardToolbarShouldHide = NO;
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == _textField1) {
		[_textField2 becomeFirstResponder];
    } else if (textField == _textField2) {
		[_textField3 becomeFirstResponder];
	} else if (textField == _textField3) {
		[_textField4 becomeFirstResponder];

	} else if (textField == _textField4) {
		[_textField5 becomeFirstResponder];

	} else if (textField == _textField5) {
        [self dismissKeyboard:textField];
        [self searchButtonsPressed:_textField5];
	}		
	return NO;
}

#pragma mark -
#pragma mark UIWindow Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{	
	CGPoint beginCentre = [[[notification userInfo] valueForKey:UIKeyboardCenterBeginUserInfoKey] CGPointValue];
	CGPoint endCentre = [[[notification userInfo] valueForKey:UIKeyboardCenterEndUserInfoKey] CGPointValue];
	CGRect keyboardBounds = [[[notification userInfo] valueForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
	UIViewAnimationCurve animationCurve	= [[[notification userInfo] valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
	NSTimeInterval animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];		
	
	if (nil == keyboardToolbar) {
		
		if(nil == keyboardToolbar) {
			keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,44)];
			keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
			keyboardToolbar.tintColor = [UIColor darkGrayColor];
			
			UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard:)];
			UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
			
			UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:
																					 NSLocalizedString(@"Previous",@"Previous form field"),
																					 NSLocalizedString(@"Next",@"Next form field"),																				  
																					 nil]];
			control.segmentedControlStyle = UISegmentedControlStyleBar;
			control.tintColor = [UIColor darkGrayColor];
			control.momentary = YES;
			[control addTarget:self action:@selector(nextPrevious:) forControlEvents:UIControlEventValueChanged];			
			
			UIBarButtonItem *controlItem = [[UIBarButtonItem alloc] initWithCustomView:control];
			
			self.nextPreviousControl = control;
			
			
			NSArray *items = [[NSArray alloc] initWithObjects:controlItem, flex, barButtonItem, nil];
			[keyboardToolbar setItems:items];
			[control release];
			[barButtonItem release];
			[flex release];
			[items release];			
			
			keyboardToolbar.frame = CGRectMake(beginCentre.x - (keyboardBounds.size.width/2), 
											   beginCentre.y - (keyboardBounds.size.height/2) - keyboardToolbar.frame.size.height, 
											   keyboardToolbar.frame.size.width, 
											   keyboardToolbar.frame.size.height);				
			
			[self.view addSubview:keyboardToolbar];		
		}		
	}		
	
	[UIView beginAnimations:@"RS_showKeyboardAnimation" context:nil];	
	[UIView setAnimationCurve:animationCurve];
	[UIView setAnimationDuration:animationDuration];
	
	keyboardToolbar.alpha = 1.0;	
	keyboardToolbar.frame = CGRectMake(endCentre.x - (keyboardBounds.size.width/2), 
									   endCentre.y - (keyboardBounds.size.height/2) - keyboardToolbar.frame.size.height - self.view.frame.origin.y, 
									   keyboardToolbar.frame.size.width, 
									   keyboardToolbar.frame.size.height);
	
	[UIView commitAnimations];		
	
	//keyboardToolbarShouldHide = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
	if (nil == keyboardToolbar ){
        //|| !keyboardToolbarShouldHide) {
		return;
	}	
	
	//	CGPoint beginCentre = [[[notification userInfo] valueForKey:UIKeyboardCenterBeginUserInfoKey] CGPointValue];
	CGPoint endCentre = [[[notification userInfo] valueForKey:UIKeyboardCenterEndUserInfoKey] CGPointValue];
	CGRect keyboardBounds = [[[notification userInfo] valueForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
	UIViewAnimationCurve animationCurve	= [[[notification userInfo] valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
	NSTimeInterval animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];	
	
	[UIView beginAnimations:@"RS_hideKeyboardAnimation" context:nil];	
	[UIView setAnimationCurve:animationCurve];
	[UIView setAnimationDuration:animationDuration];
	
	
	keyboardToolbar.alpha = 0.0;
	keyboardToolbar.frame = CGRectMake(endCentre.x - (keyboardBounds.size.width/2), 
									   endCentre.y - (keyboardBounds.size.height/2) - keyboardToolbar.frame.size.height,
									   keyboardToolbar.frame.size.width, 
									   keyboardToolbar.frame.size.height);
	
	[UIView commitAnimations];
}



#pragma mark -
#pragma mark - HUD, Newsletter and Ad delegate methods


- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
	HUD = nil;
}

/*
- (void) adViewDidLoadAd: (LiftAdView *) adView {
	if(adView == adBanner){
        adBanner.hidden = NO;
		[adBanner doSlideInAnimationWithDelegate:self];}
    else {
        NSLog(@"Interstitial loaded");
        adInterstitialLoaded = YES;
        
        
        UILabel *broughtToYou = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 320, 30)];
        broughtToYou.text = @"While we get that address for you, take a look at our sponsor.";
        broughtToYou.numberOfLines = 2;
        broughtToYou.textAlignment =  UITextAlignmentCenter;
        [adInterstitial addSubview:broughtToYou];
        
        broughtToYou.backgroundColor = [UIColor clearColor];
        broughtToYou.font = [UIFont fontWithName:@"Helvetica" size: 12.0];
        
    }
}

- (void) adViewWillUnload: (LiftAdView *) adView {
	if(adView==adBanner){
        adBanner.hidden=YES;
	}
	else {
        
        adInterstitialLoaded= NO;
	}
}
 

- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated {
	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7f];	
    adInterstitial.alpha = 1; // also fade to transparent
    [UIView commitAnimations];
    
    
    methodForExecution = method;
    targetForExecution = [target retain];
    objectForExecution = [object retain];
	
    // Launch execution in new thread
	taskInProgress = YES;
    [NSThread detachNewThreadSelector:@selector(launchExecution) toTarget:self withObject:nil];
    
}
 */

- (void)launchExecution {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    // Start executing the requested task
    [targetForExecution performSelector:methodForExecution withObject:objectForExecution];
	
    // Task completed, update view in main thread (note: view operations should
    // be done only in the main thread)
    [self performSelectorOnMainThread:@selector(cleanUp) withObject:nil waitUntilDone:NO];
	
    [pool release];
}

- (void)cleanUp {
	taskInProgress = NO;
    [targetForExecution release];
    [objectForExecution release];
	
}





@end
