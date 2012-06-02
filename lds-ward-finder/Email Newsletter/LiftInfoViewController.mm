//
//  LiftInfoViewController.m
//  WWTBTH
//
//  Created by Joshua Howland on 4/23/11.
//  Copyright 2011 jkhowland.com. All rights reserved.
//

#import "LiftInfoViewController.h"
#import "AppSettings.h"
#import "WebView.h"
#import "AppListingsViewController.h"


@implementation LiftInfoViewController

@synthesize delegate = _delegate;
@synthesize pageControl;
@synthesize scrollView;
@synthesize appListingViews;


- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
	
    // replace the placeholder if necessary
    AppListingsViewController *controller = [appListingViews objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]) {
        controller = [[AppListingsViewController alloc] initWithPageNumber:page];
        
        //controller.address = self.initialAddress_;
        //controller.firstMeeting = self.initialFirstMeeting_;
        //controller.worshipService = self.initialWorshipService_;
        
        [appListingViews replaceObjectAtIndex:page withObject:controller];
    }
	
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

- (void) bannerButton:(NSString *) navURL
{
	WebView * web = [[[WebView alloc] init] autorelease];
	//web.delegate = self;
	
	NSString *urlString = navURL;
	
	web.webAddress = urlString;
	
	//adView.hidden = YES;	
	//[self presentModalViewController:webPop animated:YES];
	
	[self.navigationController pushViewController:web animated:YES];
	
	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    kNumberOfPages = 4;
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    
    for (unsigned i = 0; i < kNumberOfPages; i++) {
        [controllers addObject:[NSNull null]];
    }
    
    UIImage * transparentImg = [UIImage imageNamed:@"transparentImg.png"];
	UIImage * darkenedImg = [UIImage imageNamed:@"darkenedImg.png"];
    
	[highlightedButton1 setBackgroundImage:transparentImg forState:UIControlStateNormal];
	[highlightedButton1 setBackgroundImage:darkenedImg forState:UIControlStateHighlighted];
	[highlightedButton2 setBackgroundImage:transparentImg forState:UIControlStateNormal];
	[highlightedButton2 setBackgroundImage:darkenedImg forState:UIControlStateHighlighted];
    
    
    self.appListingViews = controllers;
    
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    pageControl.numberOfPages = kNumberOfPages;
    pageControl.currentPage = 0;
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    

    [super viewDidLoad];
}


- (IBAction)done:(id)sender {
	[_delegate liftInfoViewControllerDidFinish:self];
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

 @end

