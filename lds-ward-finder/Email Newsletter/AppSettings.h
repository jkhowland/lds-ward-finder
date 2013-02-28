//
//  AppSettings.h
//  WWTBTH
//
//  Created by Joshua Howland on 4/5/11.
//  Copyright 2011 jkhowland.com. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kTypeKey = @"type";
static NSString * const kAddressKey = @"address";
static NSString * const kIdKey = @"id";
static NSString * const kNameKey = @"name";
static NSString * const kPhoneKey = @"phone";
static NSString * const kPositionKey = @"position";
static NSString * const kCityKey = @"city";
static NSString * const kCountryKey = @"country";
static NSString * const kCountyKey = @"county";
static NSString * const kStateKey = @"state";
static NSString * const kStreetKey = @"street";
static NSString * const kZipKey = @"zip";
static NSString * const kHoursKey = @"hours";
static NSString * const kTitleKey = @"title";
static NSString * const kContactsKey = @"contacts";
static NSString * const kWorshipTimeKey = @"worshipTime";
static NSString * const kLatitudeKey = @"latitude";
static NSString * const kLongitudeKey = @"longitude";

static NSString * const kWardType = @"ward";
static NSString * const kYSAType = @"ward.ysa";

@interface AppSettings : NSObject {

}

@property (nonatomic, weak) NSString * defaultType;
@property (nonatomic) BOOL invitedToRegister;
@property (nonatomic) int launchCount;
@property (nonatomic) BOOL gpsPurchased;
@property (nonatomic) BOOL newVersionInvited;
@property (nonatomic, strong, readonly) NSArray *userWards;

+ (AppSettings*)sharedSettings;

- (void) addWardToUserWards:(NSDictionary *)wardDictionary;

@end
