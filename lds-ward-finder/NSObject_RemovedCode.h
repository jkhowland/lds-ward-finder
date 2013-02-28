//
//  NSObject_RemovedCode.h
//  lds-ward-finder
//
//  Created by Joshua Howland on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject ()

- (void)myTask {
    
    NSString *result;
    
    if(useGPSCoordinates) {
        
        useGPSCoordinates = NO;
        
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        
        //use address from form to generate string to send in to geoCodeUsingAddress
        
        // Get the Latitude Longitude
        
        // somehow determine if the information isn't enough 
        
        if(badInfo){
            
            [HUD hide:YES afterDelay:1];
            
            NSLog(@"it's bad info");
            
            UIApplication* app = [UIApplication sharedApplication];
            app.networkActivityIndicatorVisible = NO;
            
            return;
            
        }
        
        //use geocode and address to generate link to correct map
        
        //escaped address is only street location
        
        NSString * address = [[[NSString alloc]init]autorelease];
        if([initialPlacemark.thoroughfare isEqualToString:@""]){
            if([initialPlacemark.subThoroughfare isEqualToString:@""]){
                address = @"";
            }
            else {
                address = [NSString stringWithFormat:@"&a=%@",initialPlacemark.subThoroughfare];
            }
        }
        else {
            if([initialPlacemark.subThoroughfare isEqualToString:@""]){
                address = [NSString stringWithFormat:@"&a=%@",initialPlacemark.thoroughfare];
            }
            else {
                address = [NSString stringWithFormat:@"&a=%@%20%@",initialPlacemark.subThoroughfare, initialPlacemark.thoroughfare];                
            }
            
        }
        NSString *escaped_address =  [address stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        
        NSString * city = [[[NSString alloc]init]autorelease];
        if([initialPlacemark.locality isEqualToString:@""]) {
            city = @"";
        }
        else {
            city = [NSString stringWithFormat:@"&c=%@",initialPlacemark.locality];
        }
        NSString *escaped_city =  [city stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        
        
        
        
        NSString * state = [[[NSString alloc]init]autorelease];
        if([initialPlacemark.administrativeArea isEqualToString:@""]) {
            state = @"";
        }
        else {
            state = [NSString stringWithFormat:@"&s=%@",initialPlacemark.administrativeArea];
        }
        NSString *escaped_state =  [state stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        
        
        NSString * postal = [[[NSString alloc]init]autorelease];
        if([initialPlacemark.postalCode isEqualToString:@""]) {
            postal = @"";
        }
        else {
            postal = [NSString stringWithFormat:@"&p=%@",initialPlacemark.postalCode];        
        }
        NSString *escaped_postal =  [postal stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        
        NSString * nation = [[[NSString alloc]init]autorelease];
        if([initialPlacemark.country isEqualToString:@""]) {
            nation = @"";
        }
        else {
            nation = [NSString stringWithFormat:@"&p=%@",initialPlacemark.country];        
        }
        NSString *escaped_nation =  [nation stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        
        
        // create url to contact LDS.org for value
        NSString *requestString = [NSString stringWithFormat:@"http://lds.org/maps/m/index.jsf?lat=%f&lng=%f%@%@%@%@%@&assign=wards", latitude, longitude, escaped_address, escaped_city, escaped_state, escaped_postal, escaped_nation];
        
        NSURL *url = [NSURL URLWithString:requestString];
        
        
        result = [NSString stringWithContentsOfURL: url encoding: NSUTF8StringEncoding error:NULL];
        
        
        
    }
    else {
        
        
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        
        //use address from form to generate string to send in to geoCodeUsingAddress
        
        NSString * nation = [[[NSString alloc]init]autorelease];
        if([_textField5.text isEqualToString:@""]) {
            nation = @" United States";
        }
        else {
            nation = [NSString stringWithFormat:@"&n=%@",_textField5.text];        
        }
        NSString *escaped_nation =  [nation stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        
        NSString * geoSearch = [[[NSString alloc] init]autorelease];
        geoSearch = [NSString stringWithFormat:@"%@ %@, %@ %@ %@",_textField1.text,_textField2.text,_textField3.text,_textField4.text,nation];
        if([geoSearch isEqualToString:@" ,    United States"]) {
            [HUD hide:YES afterDelay:1];
            
            NSLog(@"it's blank");
            
            UIAlertView *alert = [[[UIAlertView alloc] 
                                   initWithTitle: @"Sorry" 
                                   message:@"We couldn't find a church with the info given."
                                   delegate:nil
                                   cancelButtonTitle:nil 
                                   otherButtonTitles:@"OK", nil] autorelease];
            
            [alert show];
            
            UIApplication* app = [UIApplication sharedApplication];
            app.networkActivityIndicatorVisible = NO;
            
            return;
            
        }
        
        
        [self geoCodeUsingAddress:geoSearch];    //[self geoCodeUsingAddress:@"273 E 9670 S Sandy, UT 84070"];
        
        if(badInfo){
            
            [HUD hide:YES afterDelay:1];
            
            NSLog(@"it's bad info");
            
            UIApplication* app = [UIApplication sharedApplication];
            app.networkActivityIndicatorVisible = NO;
            
            return;
            
        }
        
        //use geocode and address to generate link to correct map
        
        //escaped address is only street location
        NSString * address = [[[NSString alloc]init]autorelease];
        if([_textField1.text isEqualToString:@""]) {
            address = @"";
        }
        else {
            address = [NSString stringWithFormat:@"&a=%@",_textField1.text];
        }
        NSString *escaped_address =  [address stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        NSString * city = [[[NSString alloc]init]autorelease];
        if([_textField2.text isEqualToString:@""]) {
            city = @"";
        }
        else {
            city = [NSString stringWithFormat:@"&c=%@",_textField2.text];
        }
        NSString *escaped_city =  [city stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        NSString * state = [[[NSString alloc]init]autorelease];
        if([_textField3.text isEqualToString:@""]) {
            state = @"";
        }
        else {
            state = [NSString stringWithFormat:@"&s=%@",_textField3.text];
        }
        NSString *escaped_state =  [state stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        NSString * postal = [[[NSString alloc]init]autorelease];
        if([_textField4.text isEqualToString:@""]) {
            postal = @"";
        }
        else {
            postal = [NSString stringWithFormat:@"&p=%@",_textField4.text];        
        }
        
        NSString *escaped_postal =  [postal stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        
        NSString *requestString = [NSString stringWithFormat:@"http://lds.org/maps/m/index.jsf?lat=%f&lng=%f%@%@%@%@%@&assign=wards", latitude, longitude, escaped_address, escaped_city, escaped_state, escaped_postal, escaped_nation];
        
        
        NSURL *url = [NSURL URLWithString:requestString];
        
        
        result = [NSString stringWithContentsOfURL: url encoding: NSUTF8StringEncoding error:NULL];
        
        NSLog(@"Hello world");
        int x = 0;
        
        
    }
    
    
    
    
    
    //I need to find the range for the ID still
    NSRange rangeStart = [result rangeOfString:@"index.jsf?id"];
    
    if(rangeStart.location != NSNotFound)
    {
        NSRange rangeEnd = [result rangeOfString:@">" options:NSCaseInsensitiveSearch range:NSMakeRange(rangeStart.location + rangeStart.length, [result length] - (rangeStart.location + rangeStart.length))];
        
        //Use the ranges above to find the link. Subtracting 20 because they are sending back a target. We need to cut that off so we just get a URL
        NSRange trueRange = NSMakeRange((rangeStart.location + rangeStart.length + 1), (rangeEnd.location - (rangeStart.location + rangeStart.length + 1) - 1));
        
        //set meetinghouseID to the string
        meetinghouseID = [[result substringWithRange:trueRange] retain];
    }
    
    wardURL = [[NSString stringWithFormat:@"http://lds.org/maps/m/index.jsf?id=%@",meetinghouseID] retain];
    
    NSURL * url1 = [NSURL URLWithString:wardURL];
    
    
    loadedPageContents = [NSString stringWithContentsOfURL: url1 encoding: NSUTF8StringEncoding error:NULL];
    
    
    //Create ranges to find the actual link tag
    NSRange rangeStart00 = [loadedPageContents rangeOfString:@"<img src="];
    
    if(rangeStart00.location != NSNotFound)
    {
        NSRange rangeEnd00 = [loadedPageContents rangeOfString:@" />" options:NSCaseInsensitiveSearch range:NSMakeRange(rangeStart00.location + rangeStart00.length, [loadedPageContents length] - (rangeStart00.location + rangeStart00.length))];
        
        //Use the ranges above to find the link. Subtracting 200 because they are sending back a target. We need to cut that off so we just get a URL
        NSRange trueRange00 = NSMakeRange((rangeStart00.location + rangeStart00.length + 0), (rangeEnd00.location - (rangeStart00.location + rangeStart00.length + 0) - 0));
        
        NSString * imageURL = [[[NSString alloc] init]autorelease];
        
        //set address to the string
        imageURL = [[loadedPageContents substringWithRange:trueRange00] copy];
        
        imageURL = [imageURL stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
        
        NSRange rangeEndSig = [imageURL rangeOfString:@"&signature="];
        
        if(rangeEndSig.location != NSNotFound)
        {
            NSRange rangeStartSig = NSMakeRange(0, 0);
            
            //Use the ranges above to find the link. Subtracting 200 because they are sending back a target. We need to cut that off so we just get a URL
            NSRange trueRangeSig = NSMakeRange((rangeStartSig.location + rangeStartSig.length), (rangeEndSig.location - (rangeStartSig.location + rangeStartSig.length + 0) - 0));
            
            NSString * signatureImageURL = [[imageURL substringWithRange:trueRangeSig] copy];
            
            imageURL = signatureImageURL;
        }
        
        imageURL = [NSString stringWithFormat:@"<html><body style=\"margin: 0px; padding: 0px;\"><img src=%@\" height=\"106\" width=\"106\" /></body></html>",imageURL];
        
        imageURL = [imageURL stringByReplacingOccurrencesOfString:@"client=gme-lds&" withString:@""];
        
        
        initialMapImage = [imageURL retain];
        
    }  
    
    
    
    //Create ranges to find the actual link tag
    NSRange rangeStart0 = [loadedPageContents rangeOfString:@"Selected location"];
    
    if(rangeStart0.location != NSNotFound)
    {
        NSRange rangeEnd0 = [loadedPageContents rangeOfString:@"subtitle" options:NSCaseInsensitiveSearch range:NSMakeRange(rangeStart0.location + rangeStart0.length, [loadedPageContents length] - (rangeStart0.location + rangeStart0.length))];
        
        //Use the ranges above to find the link. Subtracting 20 because they are sending back a target. We need to cut that off so we just get a URL
        NSRange trueRange0 = NSMakeRange((rangeStart0.location + rangeStart0.length + 34), (rangeEnd0.location - (rangeStart0.location + rangeStart0.length + 34) - 18));
        
        //set address to the string
        initialWardName = [[loadedPageContents substringWithRange:trueRange0] copy];
        
        
        initialWardName = [initialWardName stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
        initialWardName = [initialWardName stringByReplacingOccurrencesOfString:@"\n" withString:@"  "];        
        initialWardName = [initialWardName stringByReplacingOccurrencesOfString:@"  			<br />" withString:@" "];
        initialWardName = [initialWardName stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        
    }  
    
    
    
    //Create ranges to find the actual link tag
    NSRange rangeStart1 = [loadedPageContents rangeOfString:@"address"];
    
    if(rangeStart1.location != NSNotFound)
    {
        NSRange rangeEnd1 = [loadedPageContents rangeOfString:@"label" options:NSCaseInsensitiveSearch range:NSMakeRange(rangeStart1.location + rangeStart1.length, [loadedPageContents length] - (rangeStart1.location + rangeStart1.length))];
        
        //Use the ranges above to find the link. Subtracting 20 because they are sending back a target. We need to cut that off so we just get a URL
        NSRange trueRange1 = NSMakeRange((rangeStart1.location + rangeStart1.length + 11), (rangeEnd1.location - (rangeStart1.location + rangeStart1.length + 11) - 18));
        
        //set address to the string
        initialAddress = [[loadedPageContents substringWithRange:trueRange1] copy];
        
        
        initialAddress = [initialAddress stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
        initialAddress = [initialAddress stringByReplacingOccurrencesOfString:@"\n" withString:@"  "];        
        initialAddress = [initialAddress stringByReplacingOccurrencesOfString:@"  			<br />" withString:@" "];
        
        initialAddress = [initialAddress lowercaseString];
        initialAddress = [initialAddress capitalizedString];
        
        
    }  
    
    //Create ranges to find the actual link tag
    NSRange rangeStart2 = [loadedPageContents rangeOfString:@"First Meeting:"];
    
    if(rangeStart2.location != NSNotFound)
    {
        NSRange rangeEnd2 = [loadedPageContents rangeOfString:@"</div" options:NSCaseInsensitiveSearch range:NSMakeRange(rangeStart2.location + rangeStart2.length, [loadedPageContents length] - (rangeStart2.location + rangeStart2.length))];
        
        //Use the ranges above to find the link. Subtracting 20 because they are sending back a target. We need to cut that off so we just get a URL
        NSRange trueRange2 = NSMakeRange((rangeStart2.location + rangeStart2.length), (rangeEnd2.location - (rangeStart2.location + rangeStart2.length)));
        
        //set address to the string
        initialFirstMeeting = [[loadedPageContents substringWithRange:trueRange2] copy];
        
        initialFirstMeeting = [initialFirstMeeting stringByReplacingOccurrencesOfString:@"</label>" withString:@""];
        
        initialFirstMeeting = [initialFirstMeeting stringByReplacingOccurrencesOfString:@"				<span>" withString:@""];
        
        initialFirstMeeting = [initialFirstMeeting stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
        
        initialFirstMeeting = [initialFirstMeeting stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
    }
    
    //Create ranges to find the actual link tag
    NSRange rangeStart3 = [loadedPageContents rangeOfString:@"Worship Service:"];
    
    if(rangeStart3.location != NSNotFound)
    {
        NSRange rangeend3 = [loadedPageContents rangeOfString:@"</div" options:NSCaseInsensitiveSearch range:NSMakeRange(rangeStart3.location + rangeStart3.length, [loadedPageContents length] - (rangeStart3.location + rangeStart3.length))];
        
        //Use the ranges above to find the link. Subtracting 30 because they are sending back a target. We need to cut that off so we just get a URL
        NSRange trueRange3 = NSMakeRange((rangeStart3.location + rangeStart3.length), (rangeend3.location - (rangeStart3.location + rangeStart3.length)));
        
        //set address to the string
        initialWorshipService = [[loadedPageContents substringWithRange:trueRange3] copy];
        
        
        initialWorshipService = [initialWorshipService stringByReplacingOccurrencesOfString:@"</label>" withString:@""];
        
        initialWorshipService = [initialWorshipService stringByReplacingOccurrencesOfString:@"				<span>" withString:@""];
        
        initialWorshipService = [initialWorshipService stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
        
        initialWorshipService = [initialWorshipService stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
    }
    
    //Create ranges to find the actual link tag
    NSRange rangeStart4 = [loadedPageContents rangeOfString:@"Leader:"];
    
    if(rangeStart4.location != NSNotFound)
    {
        NSRange rangeEnd4 = [loadedPageContents rangeOfString:@"</span>" options:NSCaseInsensitiveSearch range:NSMakeRange(rangeStart4.location + rangeStart4.length, [loadedPageContents length] - (rangeStart4.location + rangeStart4.length))];
        
        //Use the ranges above to find the link. Subtracting 20 because they are sending back a target. We need to cut that off so we just get a URL
        NSRange trueRange4 = NSMakeRange((rangeStart4.location + rangeStart4.length + 20), (rangeEnd4.location - (rangeStart4.location + rangeStart4.length + 20) - 0));
        
        //set address to the string
        initialBishopName = [[loadedPageContents substringWithRange:trueRange4] copy];
        
        
        initialBishopName = [initialBishopName stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
        initialBishopName = [initialBishopName stringByReplacingOccurrencesOfString:@"\n" withString:@"  "];        
        initialBishopName = [initialBishopName stringByReplacingOccurrencesOfString:@"  			<br />" withString:@" "];
        initialBishopName = [initialBishopName stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        
        initialBishopName = [initialBishopName lowercaseString];
        initialBishopName = [initialBishopName capitalizedString];
        
    }  
    
    //Create ranges to find the actual link tag
    NSRange rangeStart5 = [loadedPageContents rangeOfString:@"tel:"];
    
    if(rangeStart5.location != NSNotFound)
    {
        NSRange rangeEnd5 = [loadedPageContents rangeOfString:@"</a>" options:NSCaseInsensitiveSearch range:NSMakeRange(rangeStart5.location + rangeStart5.length, [loadedPageContents length] - (rangeStart5.location + rangeStart5.length))];
        
        //Use the ranges above to find the link. Subtracting 20 because they are sending back a target. We need to cut that off so we just get a URL
        NSRange trueRange5 = NSMakeRange((rangeStart5.location + rangeStart5.length + 17), (rangeEnd5.location - (rangeStart5.location + rangeStart5.length + 17) - 0));
        
        //set address to the string
        initialBishopPhone = [[loadedPageContents substringWithRange:trueRange5] copy];
        
        
        initialBishopPhone = [initialBishopPhone stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
        initialBishopPhone = [initialBishopPhone stringByReplacingOccurrencesOfString:@"\n" withString:@"  "];        
        initialBishopPhone = [initialBishopPhone stringByReplacingOccurrencesOfString:@"  			<br />" withString:@" "];
        initialBishopPhone = [initialBishopPhone stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        
        initialBishopPhone = [initialBishopPhone lowercaseString];
        initialBishopPhone = [initialBishopPhone capitalizedString];
        
    }  
    
    answerFound = YES;
    
    if(hudDisplayed) { 
        
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = NO;
        
        [self performSelectorOnMainThread:@selector(loadScrollViewOnMainSelector) withObject:nil waitUntilDone:YES];
        
    }
    
    //load webview with url
    //webview finished loading should have correct code.
}



@end
