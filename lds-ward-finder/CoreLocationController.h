//
//  CoreLocationController.h
//  lds-ward-finder
//
//  Created by Joshua Howland on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CoreLocationController : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locMgr;
	id __weak delegate;
}

@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic, weak) id delegate;

@end

@protocol CoreLocationControllerDelegate 
@required
- (void)locationUpdate:(CLLocation *)location; // Our location updates are sent here
- (void)locationError:(NSError *)error; // Any errors are sent here
@end