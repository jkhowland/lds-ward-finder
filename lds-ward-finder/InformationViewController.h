//
//  InformationViewController.h
//  lds-ward-finder
//
//  Created by Joshua Howland on 12/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InformationViewControllerDelegate;

@interface InformationViewController : UIViewController <UIWebViewDelegate> {

    id<NSObject, InformationViewControllerDelegate> delegate;
    
    IBOutlet UITextView * addressField;
    IBOutlet UITextView * phoneNumberField;
    IBOutlet UITextView * bishopsNameField;
    IBOutlet UILabel * wardNameField;
    IBOutlet UILabel * firstMeetingTimeField;
    IBOutlet UILabel * worshipServiceTimeField;
    IBOutlet UIWebView * mapImageField;
    
    NSString * _address;
    NSString * _phoneNumber;
    NSString * _bishopsName;
    NSString * _wardName;
    NSString * _firstMeetingTime;
    NSString * _worshipServiceTime;
    NSString * _mapImage;

}

@property (nonatomic, assign) IBOutlet id <InformationViewControllerDelegate, NSObject> delegate;

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * bishopsName;
@property (nonatomic, retain) NSString * wardName;
@property (nonatomic, retain) NSString * firstMeetingTime;
@property (nonatomic, retain) NSString * worshipServiceTime;
@property (nonatomic, retain) NSString * mapImage;


-(id)initWithPageNumber:(int)page;
-(IBAction)mapIt:(id)sender;


@end


@protocol InformationViewControllerDelegate

- (void)infoViewDidPin:(InformationViewController*)showingInfoController;
- (void)infoViewDidMapIt:(InformationViewController*)showingInfoController;

@end
