//
//  WebView.m
//  WWTBTH
//
//  Created by Joshua Howland on 5/1/11.
//  Copyright 2011 jkhowland.com. All rights reserved.
//

#import "WebView.h"


@implementation WebView

@synthesize webView;
@synthesize mview;
@synthesize webAddress;


-(IBAction)showActionSheet:(id)sender {
	
	 UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Send Link to:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Safari", @"Email", nil];
	 popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	 [popupQuery showInView:self.view];
	 
	 [popupQuery release];
	 }
	 
	 /*
	 - (void)myButtonHandlerAction
	 {
	 
	
	// Create the item to share (in this example, a url)
	NSURL *sUrl = [NSURL URLWithString:@"http://liftgames.com/lds-millionaire/"];
	SHKItem *item = [SHKItem URL:sUrl title:@"Who Wants To Be A Millionaire"];
	
	// Get the ShareKit action sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	
	// Display the action sheet
	[actionSheet showInView:mview];
	//[actionSheet showFromToolbar:navigationController.toolbar];
}

*/
 -(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
 if (buttonIndex == 0) {
 
 NSLog(@"0");
	 [[UIApplication sharedApplication] openURL:[NSURL URLWithString: webAddress]];

 
 } else if (buttonIndex == 1) {
 
 MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
 controller.mailComposeDelegate = self;
 [controller setSubject:@"Great things from Lift Games"];
 [controller setMessageBody:[NSString stringWithFormat:@"Just wanted to make sure to remember to connect with Lift Games. %@",webAddress] isHTML:NO];

 if (controller) [self presentModalViewController:controller animated:YES];
 
 } else if (buttonIndex == 2) {
 
 NSLog(@"Cancel Pressed");
 
 }
 }
 

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	if ( result == MFMailComposeResultFailed )
	{
		// Sending failed - display an error message to the user.
		NSString* message = [NSString stringWithFormat:@"Error sending email '%@'. Please try again, or cancel the operation.", [error localizedDescription]];
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error Sending Email" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alertView show];
	}
	else
	{
		// If we got here - everything should have gone as the user wanted - dismiss the modal view.
		[self dismissModalViewControllerAnimated:YES];
	}
}


-(IBAction) dismissView {
	
	[self dismissModalViewControllerAnimated:YES];
	
}

- (void) setSite{
	
	//NSLog(webAddress);
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webAddress]]]; 
	
	
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {	
	
	UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet:)];
	self.navigationItem.rightBarButtonItem = actionButton;
	[actionButton release];
	
	[super viewDidLoad];

	
	/* [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webAddress]]]; 
	 
	 [webView stringByEvaluatingJavaScriptFromString:@"document. body.style.zoom = 1.0;"];
	 
	 int scroll=0; //Pixels to scroll
	 NSString* s=[[NSString alloc] initWithFormat:@"window.scrollTo(0, %i)",scroll];
	 [webView stringByEvaluatingJavaScriptFromString:s];
	 */
	
	[self setSite];
	
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
