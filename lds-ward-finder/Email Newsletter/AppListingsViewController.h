//
//  AppListingsViewController.h
//  LDSWordSearch
//
//  Created by Joshua Howland on 1/10/12.
//  Copyright (c) 2012 LDS Mobile Apps LLC. All rights reserved.
//



@interface AppListingsViewController : UIViewController {

    IBOutlet UIView * page0;
    IBOutlet UIView * page1;
    IBOutlet UIView * page2;
    IBOutlet UIView * page3;
    IBOutlet UIView * page4;

}

@property (nonatomic, assign) int pageNumber;

-(void)hideAllPages;
-(id)initWithPageNumber:(int)page;
- (IBAction) safariLink:(NSString *) navURL;

@end
