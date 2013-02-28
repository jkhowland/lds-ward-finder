//
//  AppSettings.m
//  WWTBTH
//
//  Created by Joshua Howland on 4/5/11.
//  Copyright 2011 jkhowland.com. All rights reserved.
//

#import "AppSettings.h"
#import "CWLSynthesizeSingleton.h"

static NSString *const kDefaultType = @"defaultType";
static NSString *const kInvitedToRegister = @"invitedToRegister";
static NSString *const kNewVersionInvited = @"newVersionInvited";
static NSString *const kLaunchCount = @"launchCount";
static NSString *const kGpsPurchased = @"gpsPurchased";
static NSString *const kUserWardsKey = @"userWards";

@implementation AppSettings

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(AppSettings, sharedSettings);

- (NSString *)defaultType {
	return [[NSUserDefaults standardUserDefaults] stringForKey:kDefaultType];
}

- (void)setDefaultType:(NSString *)defaultType {
	
	[[NSUserDefaults standardUserDefaults] setObject:defaultType forKey:kDefaultType];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
}



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


- (void) addWardToUserWards:(NSDictionary *)wardDictionary {

    NSArray * wardArray = [[NSUserDefaults standardUserDefaults] objectForKey:kUserWardsKey];
    
    NSMutableArray * newWardArray = [NSMutableArray arrayWithArray:wardArray];
    
    if(newWardArray == nil){
        newWardArray = [[NSMutableArray alloc] init];
    }
    
    [newWardArray addObject:wardDictionary];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:newWardArray] forKey:kUserWardsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *) userWards {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserWardsKey];
}

@end
