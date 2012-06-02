//
//  AppListingsViewController.m
//  LDSWordSearch
//
//  Created by Joshua Howland on 1/10/12.
//  Copyright (c) 2012 LDS Mobile Apps LLC. All rights reserved.
//

#import "AppListingsViewController.h"

@implementation AppListingsViewController

@synthesize pageNumber;

-(id)initWithPageNumber:(int)page {
    if (self = [super initWithNibName:@"AppListingsViewController" bundle:nil]) {
        pageNumber = page;
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
    // Do any additional setup after loading the view from its nib.

    [self hideAllPages];
    
    if(pageNumber==0)page0.hidden=NO;
    if(pageNumber==1)page1.hidden=NO;
    if(pageNumber==2)page2.hidden=NO;
    if(pageNumber==3)page3.hidden=NO;
    if(pageNumber==4)page4.hidden=NO;


}

-(void)hideAllPages {
    page0.hidden=YES;
    page1.hidden=YES;
    page2.hidden=YES;
    page3.hidden=YES;
    page4.hidden=YES;
}

- (IBAction) safariLink:(NSString *) navURL {
	
	NSString *urlString = navURL;
    //	NSURL *safariURL = [NSURL URLWithString: navURL];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: urlString]];
    
    //	[[UIApplication sharedApplication] openURL:appStoreUrl];
    
}
-(IBAction) socialButton:(id)sender {
    
	UIButton * socialB = sender;
    
	NSString * socialURL = @"";
	
	
	if(socialB.tag == 0) 
    {socialURL = @"http://liftmn.com/mobileland/lds-word-search/";
		[self safariLink:socialURL];
	}

    if(socialB.tag == 1) 
    {socialURL = @"http://click.linksynergy.com/fs-bin/stat?id=J9ctC9ORkAk&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1=http%253A%252F%252Fitunes.apple.com%252Fus%252Fapp%252Flds-millionaire-who-wants%252Fid408822618%253Fmt%253D8%2526uo%253D4%2526partnerId%253D30";
		[self safariLink:socialURL];
	}
    
	if(socialB.tag == 2) 
    {socialURL = @"http://click.linksynergy.com/fs-bin/stat?id=J9ctC9ORkAk&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1=http%253A%252F%252Fitunes.apple.com%252Fus%252Fapp%252Flds-voices-masteries-prophets%252Fid360825968%253Fmt%253D8%2526uo%253D4%2526partnerId%253D30";
		[self safariLink:socialURL];
	}
    
	if(socialB.tag == 3) 
    {socialURL = @"http://click.linksynergy.com/fs-bin/stat?id=J9ctC9ORkAk&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1=http%253A%252F%252Fitunes.apple.com%252Fus%252Fapp%252Flds-around-the-world-book%252Fid448767319%253Fmt%253D8%2526uo%253D4%2526partnerId%253D30";
		[self safariLink:socialURL];
	}
	
    
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
