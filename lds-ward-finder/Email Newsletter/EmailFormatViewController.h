//
//  EmailFormatViewController.h
//  WWTBTH
//
//  Created by Joshua Howland on 4/5/11.
//  Copyright 2011 jkhowland.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmailFormatViewControllerDelegate;

@interface EmailFormatViewController : UITableViewController {
	id<EmailFormatViewControllerDelegate> _delegate;
	NSUInteger _selectedRowIndex;
}

@property (nonatomic,assign) id<EmailFormatViewControllerDelegate> delegate;
@property (nonatomic,copy) NSString *format;

@end

@protocol EmailFormatViewControllerDelegate

- (void)emailFormatViewController:(EmailFormatViewController*)viewController didSelectFormat:(NSString*)format;

@end
