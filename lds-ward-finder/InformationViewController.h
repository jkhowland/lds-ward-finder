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

@property (nonatomic, weak) IBOutlet id <InformationViewControllerDelegate, NSObject> delegate;

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * phoneNumber;
@property (nonatomic, strong) NSString * bishopsName;
@property (nonatomic, strong) NSString * wardName;
@property (nonatomic, strong) NSString * firstMeetingTime;
@property (nonatomic, strong) NSString * worshipServiceTime;
@property (nonatomic, strong) NSString * mapImage;


-(id)initWithPageNumber:(int)page;
-(IBAction)mapIt:(id)sender;


@end


@protocol InformationViewControllerDelegate

- (void)infoViewDidPin:(InformationViewController*)showingInfoController;
- (void)infoViewDidMapIt:(InformationViewController*)showingInfoController;

@end
