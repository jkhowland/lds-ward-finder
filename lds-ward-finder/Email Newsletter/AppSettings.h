//
//  AppSettings.h
//  WWTBTH
//
//  Created by Joshua Howland on 4/5/11.
//  Copyright 2011 jkhowland.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppSettings : NSObject {

}

@property (nonatomic) BOOL invitedToRegister;
@property (nonatomic) int launchCount;
@property (nonatomic) BOOL gpsPurchased;
@property (nonatomic) BOOL newVersionInvited;

+ (AppSettings*)sharedSettings;

@end
