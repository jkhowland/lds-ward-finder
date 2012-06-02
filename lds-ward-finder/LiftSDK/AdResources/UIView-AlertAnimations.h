//
//  UIView-AlertAnimations.h
//  Custom Alert View
//
//  Created by jeff on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIView(AlertAnimations)
- (void)doTurnInAnimation;
- (void)doTurnInAnimationWithDelegate:(id)animationDelegate;
- (void)doSlideInAnimation;
- (void)doSlideInAnimationWithDelegate:(id)animationDelegate;
- (void)doPopInAnimation;
- (void)doPopInAnimationWithDelegate:(id)animationDelegate;
- (void)doFadeInAnimation;
- (void)doFadeInAnimationWithDelegate:(id)animationDelegate;
- (void)doFadeOutAnimation;
- (void)doFadeOutAnimationWithDelegate:(id)animationDelegate;

@end
