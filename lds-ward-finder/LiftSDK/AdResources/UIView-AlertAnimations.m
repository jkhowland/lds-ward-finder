//
//  UIView-AlertAnimations.m
//  Custom Alert View
//
//  Created by jeff on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIView-AlertAnimations.h"
#import <QuartzCore/QuartzCore.h>

#define kAnimationDuration  0.2555

@implementation UIView(AlertAnimations)

- (void)doTurnInAnimation;
{
	[self doTurnInAnimationWithDelegate:nil];
}

- (void)doTurnInAnimationWithDelegate:(id)animationDelegate 
{
	
	CALayer *viewLayer = self.layer;

	[viewLayer removeAllAnimations];
	
	CATransform3D startTransform = CATransform3DMakeRotation(3.141f/2.0f, 0.0f, -1.0f, 0.0f);
	startTransform.m34 = 0.001f;
	startTransform.m14 = -0.0015f;
	
	CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	transformAnimation.removedOnCompletion = NO;
	transformAnimation.duration = 2.0f;
	transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transformAnimation.fromValue = [NSValue valueWithCATransform3D:startTransform];
	transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
	CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	theGroup.delegate = animationDelegate;
	theGroup.duration = 2.0f;
	[theGroup setValue:[NSNumber numberWithInt:self.tag] forKey:@"viewToCloseTag"];
	theGroup.animations = [NSArray arrayWithObjects:transformAnimation, nil];
	theGroup.removedOnCompletion = NO;
	theGroup.fillMode = kCAFillModeBoth;
	[viewLayer addAnimation:theGroup forKey:@"flipViewClosed"];
		
}

- (void)doSlideInAnimation
{

	[self doSlideInAnimationWithDelegate:nil];
	
}

- (void)doSlideInAnimationWithDelegate:(id)animationDelegate
{
	CALayer *viewLayer = self.layer;
	CATransition *slideInAnimation = [CATransition animation];
	[slideInAnimation setDuration:0.5];
	[slideInAnimation setType:kCATransitionPush];
	[slideInAnimation setSubtype:kCATransitionFromRight];
	[slideInAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	
	slideInAnimation.delegate = animationDelegate;
	
	[viewLayer addAnimation:slideInAnimation forKey:@"SwitchToView1"];
	
	
	
}



- (void)doPopInAnimation
{
    [self doPopInAnimationWithDelegate:nil];
}
- (void)doPopInAnimationWithDelegate:(id)animationDelegate
{
    CALayer *viewLayer = self.layer;
    CAKeyframeAnimation* popInAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    popInAnimation.duration = kAnimationDuration;
    popInAnimation.values = [NSArray arrayWithObjects:
                             [NSNumber numberWithFloat:0.6],
                             [NSNumber numberWithFloat:1.1],
                             [NSNumber numberWithFloat:.9],
                             [NSNumber numberWithFloat:1],
                             nil];
    popInAnimation.keyTimes = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0],
                               [NSNumber numberWithFloat:0.6],
                               [NSNumber numberWithFloat:0.8],
                               [NSNumber numberWithFloat:1.0], 
                               nil];    
    popInAnimation.delegate = animationDelegate;
    
    [viewLayer addAnimation:popInAnimation forKey:@"transform.scale"];  
}
- (void)doFadeInAnimation
{
    [self doFadeInAnimationWithDelegate:nil];
}
- (void)doFadeInAnimationWithDelegate:(id)animationDelegate
{
    CALayer *viewLayer = self.layer;
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
    fadeInAnimation.duration = kAnimationDuration;
    fadeInAnimation.delegate = animationDelegate;
    [viewLayer addAnimation:fadeInAnimation forKey:@"opacity"];
}

- (void)doFadeOutAnimation
{
    [self doFadeOutAnimationWithDelegate:nil];
}
- (void)doFadeOutAnimationWithDelegate:(id)animationDelegate
{
    CALayer *viewLayer = self.layer;
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:0.0];
    fadeInAnimation.duration = 3.5555;
    fadeInAnimation.delegate = animationDelegate;
    [viewLayer addAnimation:fadeInAnimation forKey:@"opacity"];
}

@end
