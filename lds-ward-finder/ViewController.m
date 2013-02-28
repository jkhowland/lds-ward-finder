//
//  ViewController.m
//  lds-ward-finder
//
//  Created by Joshua Howland on 12/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "JSONKit.h"

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
    [savedDictionary release];
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

- (IBAction)liftSettingsDash {
	
    LiftInfoViewController *viewController = [[LiftInfoViewController alloc] init];
	viewController.delegate = self;
    
	[self presentModalViewController:viewController animated:YES];
	
}


-(IBAction)menuButtonPressed:(id)sender 
{    
    if(![centralView isLeftSidebarOnTop]) [centralView swapSidebarViewIndecies];
    [centralView revealSidebar: ![centralView isSidebarShowing]];    
    
}

-(IBAction)plusButtonPressed:(id)sender 
{    
    if([centralView isLeftSidebarOnTop]) [centralView swapSidebarViewIndecies];
    [centralView revealSidebarRight: ! [centralView isSidebarShowingRight]];    
    
}

- (IBAction)searchButtonsPressed:(id)sender {
    
    [self dismissKeyboard:sender];

    //once was SUBMIT Values
    hudDisplayed = YES;
 
    if([centralView isSidebarShowing]) [self menuButtonPressed:self];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
	
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    // Show the HUD while the provided method executes in a new thread
    [centralView.contentView addSubview:screen2];
    
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    
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
    [HUD showWhileExecuting:@selector(additionalSearchTypeUpdate:) onTarget:self withObject:nil animated:YES];
    
}

- (void) additionalSearchTypeUpdate:(id)sender {

    //Get the ID
    
    NSString * defaultId = [[[savedDictionary objectForKey:[AppSettings sharedSettings].defaultType] objectForKey:kIdKey] stringValue];

    [self updateDetailsToWardWithID:defaultId];
    
    kNumberOfPages++;
    
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    
    pageControl.numberOfPages = kNumberOfPages;
    pageControl.currentPage = kNumberOfPages-1;

    
    [self performSelectorOnMainThread:@selector(loadScrollViewOnMainSelector) withObject:nil waitUntilDone:NO];
    
}


- (void)liftInfoViewControllerDidFinish:(LiftInfoViewController*) liftInfoViewController {
	//[self.mainView snapToPage];
	
    centralView.frame = CGRectMake(0, 0, 320, 460);
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)openInMaps:(InformationViewController*)showingInfoController {
    
    NSString * urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@",showingInfoController.address];
    
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
    
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    
    
    if(!useGPSCoordinates) { //set if users presses 'GPS Search Button'
                
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
        
        
        [self geoCodeUsingAddress:geoSearch];
        
        if(badInfo){
            
            [HUD hide:YES afterDelay:1];
            
            NSLog(@"it's bad info");
            
            UIApplication* app = [UIApplication sharedApplication];
            app.networkActivityIndicatorVisible = NO;
            
            return;
            
        }
        

        
    }
    
    useGPSCoordinates = NO;
    
    // create url to contact LDS.org for value
    NSString *requestString = [NSString stringWithFormat:@"http://www.lds.org/rcmaps/services/layers/assigned?latitude=%f&longitude=%f&lang=eng", latitude, longitude];
    
    NSError* err = nil;
    NSURLResponse* response = nil;
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease];
    
    NSURL*URL = [NSURL URLWithString:requestString];
    [request setURL:URL];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:30];
    NSData* jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSArray * assignedArray = [jsonData objectFromJSONData];
    
    //Use default setting to find ward they want
    
    savedDictionary = nil;
    
    NSMutableDictionary * assignedLocations = [[[NSMutableDictionary alloc] init] autorelease];
    
    for (NSDictionary *rawAssign in assignedArray) {
        
        [assignedLocations setObject:rawAssign forKey:[rawAssign objectForKey:kTypeKey]];
        
    }    
    
    savedDictionary = [assignedLocations retain];
        
    //Get the ID
    
    NSDictionary *ward = [assignedLocations objectForKey:[AppSettings sharedSettings].defaultType];
    NSString * defaultId = [ward objectForKey:kIdKey];

    //Get the details for the ID
    [self updateDetailsToWardWithID:defaultId];

        answerFound = YES;
    
        if(hudDisplayed) { 
        
            UIApplication* app = [UIApplication sharedApplication];
            app.networkActivityIndicatorVisible = NO;
                
            [self performSelectorOnMainThread:@selector(loadScrollViewOnMainSelector) withObject:nil waitUntilDone:YES];
        
        }
}


- (void)updateDetailsToWardWithID:(NSString *)wardID {

    // create url to contact LDS.org for value
    NSString *detailString = [NSString stringWithFormat:@"http://www.lds.org/rcmaps/services/layers/details?lang=eng&id=%@&layer=ward", wardID];
    
    NSError* errDetail = nil;
    NSURLResponse* responseDetail = nil;
    NSMutableURLRequest* requestDetail = [[[NSMutableURLRequest alloc] init] autorelease];
    
    NSURL*URLDetail = [NSURL URLWithString:detailString];
    [requestDetail setURL:URLDetail];
    [requestDetail setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [requestDetail setTimeoutInterval:30];
    NSData* jsonDataDetail = [NSURLConnection sendSynchronousRequest:requestDetail returningResponse:&responseDetail error:&errDetail];
    
    NSDictionary * details = [jsonDataDetail objectFromJSONData];
    
    initialWardName = nil;
    
    initialWardName = [details objectForKey:kNameKey];
    initialWardName = [initialWardName stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    initialWardName = [initialWardName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    
    //set address to the string
    
    initialAddress = nil;
    
    initialAddress = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",[[details objectForKey:kAddressKey] objectForKey:kStreetKey],[[details objectForKey:kAddressKey] objectForKey:kCityKey],[[details objectForKey:kAddressKey] objectForKey:kStateKey],[[details objectForKey:kAddressKey] objectForKey:kZipKey],[[details objectForKey:kAddressKey] objectForKey:kCountryKey]];
    initialAddress = [initialAddress stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    initialAddress = [initialAddress stringByReplacingOccurrencesOfString:@"<null>" withString:@""];    
    initialAddress = [initialAddress lowercaseString];
    initialAddress = [initialAddress capitalizedString];
    
    //set first meeting to string
    
    initialFirstMeeting = nil;
    
    initialFirstMeeting = [details objectForKey:kHoursKey];
    
    //set worship service to string
    initialWorshipService = nil;
    
    initialWorshipService = [details objectForKey:kWorshipTimeKey];
    
    float latVal = [[[details objectForKey:kPositionKey] objectForKey:kLatitudeKey] floatValue];
    float longVal = [[[details objectForKey:kPositionKey] objectForKey:kLongitudeKey] floatValue];
    
    NSString * locationString = [NSString stringWithFormat:@"%f,%f",latVal,longVal];
    
    NSString * firstHalf = [NSString stringWithFormat:@"<html><body style=\"margin: 0px; padding: 0px;\"><img style=\"-webkit-user-select: none\" src=\"http://maps.googleapis.com/maps/api/staticmap?center=%@&amp;markers=color:blue%7C",locationString];
    
    NSString * secondHalf = [NSString stringWithFormat:@"%@&amp;zoom=14&amp;size=106x106&amp;sensor=false\"></body></html>",locationString];
    
    NSString * imageHTML = [NSString stringWithFormat:@"%@%@",firstHalf,secondHalf];
    
    initialMapImage = [imageHTML retain];
    
    //Check number of contacts
    
    int contactCount = [[details objectForKey:kContactsKey] count];
    
    if(contactCount){
        //set bishop name to string
        initialBishopName = [NSString stringWithFormat:@"%@ %@",[[[details objectForKey:kContactsKey] objectAtIndex:0] objectForKey:kTitleKey],[[[details objectForKey:kContactsKey] objectAtIndex:0] objectForKey:kNameKey]];
        initialBishopName = [initialBishopName stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        initialBishopName = [initialBishopName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        initialBishopName = [initialBishopName lowercaseString];
        initialBishopName = [initialBishopName capitalizedString];
        
        //set bishop phone to the string
        initialBishopPhone = [[[details objectForKey:kContactsKey] objectAtIndex:0] objectForKey:kPhoneKey];
        initialBishopPhone = [initialBishopPhone stringByReplacingOccurrencesOfString:@"+" withString:@""];
    } 
    
}


- (void)infoViewDidPin:(InformationViewController*)showingInfoController {


    
}


- (void)infoViewDidMapIt:(InformationViewController*)showingInfoController {

    infoViewSentMe = YES;
    [self openInMaps:showingInfoController];
    
}

#pragma mark -
#pragma mark Screen 3 Methods

-(IBAction)checkboxSelected:(id)sender
{
    UIButton *btn = (UIButton *) sender; 
    
    if([btn isSelected]){ 
    
        [btn setSelected:NO]; 
        
    }
    else
    { 
        
        [btn setSelected:YES]; 
    
    }
}


#pragma mark -
#pragma mark Paging Scroll View Methods


- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
    
    // replace the placeholder if necessary
    InformationViewController *controller = [informationViews objectAtIndex:page];    
        controller = [[InformationViewController alloc] initWithPageNumber:page];
        controller.delegate = self;
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


- (IBAction)anotherSearch:(id)sender {
    [centralView revealSidebar: YES];

    
    
}



@end
