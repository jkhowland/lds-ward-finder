//
//  AdPopUpViewController.m
//  LiftAdSDK
//
//  Created by Joshua Howland on 5/9/11.
//  Copyright 2011 jkhowland.com. All rights reserved.
//

#import "AdPopUpViewController.h"


@implementation AdPopUpViewController

@synthesize delegate = delegate_;
@synthesize webView;
@synthesize mview;
@synthesize webAddress;
@synthesize progressBar;
@synthesize button;

-(IBAction) dismissView {

	[self dismissModalViewControllerAnimated:YES];
	[delegate_ adPopUpViewDismissed];
}

- (void) setSite{
	
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webAddress]]]; 
	HUD = [[MBProgressHUD showHUDAddedTo:self.mview animated:YES] retain];

	
}


- (void) webViewDidFinishLoad:(UIWebView *) webview {
	
	[HUD hide:YES afterDelay:1];	
	webView.hidden = NO;

	button.hidden = NO;

	/*	To disable scrolling on the webview
	 
	UIView * row = nil;
	for(row in webView.subviews){
		if([row isKindOfClass:[UIScrollView class] ]){
			UIScrollView* scrollRow = (UIScrollView*) row;
			scrollRow.scrollEnabled = NO;
			scrollRow.bounces = NO;
		}
	}*/
	
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType 
{
	NSURL* LinkUrl = [request URL];
	
	if (UIWebViewNavigationTypeLinkClicked == navigationType)
	{
		[[UIApplication sharedApplication] openURL:LinkUrl];
		return NO;
	}
	else {
		return YES;
	}
	
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
	webView.hidden=YES;
    [super viewDidLoad];
	[self setSite];
	button.hidden = YES;
	
}

#pragma mark -
#pragma mark NSURLConnectionDelegete

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	expectedLength = [response expectedContentLength];
	currentLength = 0;
	HUD.mode = MBProgressHUDModeDeterminate;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	currentLength += [data length];
	HUD.progress = currentLength / (float)expectedLength;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    HUD.mode = MBProgressHUDModeCustomView;
	[HUD hide:YES afterDelay:2];
	[connection release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[HUD hide:YES];
	[connection release];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
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
