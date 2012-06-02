//
//  InformationViewController.m
//  lds-ward-finder
//
//  Created by Joshua Howland on 12/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "InformationViewController.h"

@implementation InformationViewController

@synthesize address = _address;
@synthesize bishopsName = _bishopsName;
@synthesize phoneNumber = _phoneNumber;
@synthesize wardName = _wardName;
@synthesize firstMeetingTime = _firstMeetingTime;
@synthesize worshipServiceTime = _worshipServiceTime;
@synthesize mapImage = _mapImage;



-(id)initWithPageNumber:(int)page {
    if (self = [super initWithNibName:@"InformationViewController" bundle:nil]) {

    }
    return self;
   
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    addressField.text = _address;
    firstMeetingTimeField.text = _firstMeetingTime;
    worshipServiceTimeField.text = _worshipServiceTime;
    wardNameField.text = _wardName;
    phoneNumberField.text = _phoneNumber;
    bishopsNameField.text = _bishopsName;
     
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
    
    NSError *error;
    BOOL succeed = [_mapImage writeToFile:[documentsDirectory stringByAppendingPathComponent:@"saveme.html"] atomically:YES encoding:NSUTF8StringEncoding error:&error];
                  
    
    if (!succeed){
        // Handle error here
        NSLog(@"Fail");
    }
    
    [mapImageField loadHTMLString:_mapImage baseURL:nil];
    
//    [mapImageField loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"saveme" ofType:@"html"]isDirectory:NO]]];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView {

    NSLog(@"Webview done");

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

   return YES;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
