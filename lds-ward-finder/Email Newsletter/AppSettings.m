//
//  AppSettings.m
//  WWTBTH
//
//  Created by Joshua Howland on 4/5/11.
//  Copyright 2011 jkhowland.com. All rights reserved.
//

#import "AppSettings.h"
#import "SynthesizeSingleton.h"


static NSString *const kInvitedToRegister = @"invitedToRegister";
static NSString *const kNewVersionInvited = @"newVersionInvited";
static NSString *const kLaunchCount = @"launchCount";
static NSString *const kGpsPurchased = @"gpsPurchased";


@implementation AppSettings


SYNTHESIZE_SINGLETON_FOR_CLASS(AppSettings, sharedSettings);

- (BOOL)invitedToRegister {
	return [[NSUserDefaults standardUserDefaults] boolForKey:kInvitedToRegister];
}

- (void)setInvitedToRegister:(BOOL)invitedToRegister {
	
	[[NSUserDefaults standardUserDefaults] setBool:invitedToRegister forKey:kInvitedToRegister];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (BOOL)newVersionInvited {
	return [[NSUserDefaults standardUserDefaults] boolForKey:kInvitedToRegister];
}

- (void)setNewVersionInvited:(BOOL)newVersionInvited {
	
	[[NSUserDefaults standardUserDefaults] setBool:newVersionInvited forKey:kNewVersionInvited];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (int) launchCount {
	return [[NSUserDefaults standardUserDefaults] boolForKey:kLaunchCount];

}

- (void) setLaunchCount:(int)launchCount {
    
	[[NSUserDefaults standardUserDefaults] setBool:launchCount forKey:kLaunchCount];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (BOOL) gpsPurchased {

    return [[NSUserDefaults standardUserDefaults] boolForKey:kGpsPurchased];
    
}

- (void) setGpsPurchased:(BOOL)gpsPurchased {
    
	[[NSUserDefaults standardUserDefaults] setBool:gpsPurchased forKey:kGpsPurchased];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
}




@end
