//
//  LiftInfoViewController.h
//  WWTBTH
//
//  Created by Joshua Howland on 4/23/11.
//  Copyright 2011 jkhowland.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SettingsViewControllerDelegate;


@interface LiftInfoViewController : UIViewController <UIScrollViewDelegate>{
    
    IBOutlet UIScrollView * scrollView;
    IBOutlet UIPageControl * pageControl;
    
    float kNumberOfPages;
    BOOL pageControlUsed;
    
    IBOutlet UIButton *highlightedButton1;
    IBOutlet UIButton *highlightedButton2;
    
	
	id<SettingsViewControllerDelegate> _delegate;	
}


@property (nonatomic,assign) id<SettingsViewControllerDelegate> delegate;

@property (nonatomic, retain) UIScrollView * scrollView;
@property (nonatomic, retain) UIPageControl * pageControl;
@property (nonatomic, retain) NSMutableArray * appListingViews;


- (IBAction)changePage:(id)sender;
- (void)loadScrollViewWithPage:(int)page;

-(IBAction)userPressedNewsletter:(id)sender;

-(IBAction) socialButton:(id)sender;
- (void) bannerButton:(NSString *) navURL;
- (void) safariLink:(NSString *) navURL;
- (void) showNewsletterAnimated:(BOOL)animated;


- (IBAction)done:(id)sender;

@end


@protocol SettingsViewControllerDelegate


- (void)liftInfoViewControllerDidFinish:(LiftInfoViewController*)liftInfoViewController;
@optional

@end
