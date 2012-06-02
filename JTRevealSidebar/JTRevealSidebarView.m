/*
 * This file is part of the JTRevealSidebar package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "JTRevealSidebarView.h"
#import "JTNavigationView.h"

@implementation JTRevealSidebarView

@synthesize sidebarView, sidebarViewRight, contentView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _state.isShowing = 0;
        _stateRight.isShowingRight = 0;
        _onTop.isOnTop = 0;
    }
    return self;
}

#pragma mark Properties

- (void)setContentView:(JTNavigationView *)aContentView {
    [contentView removeFromSuperview];
    [contentView autorelease], contentView = nil;
    contentView = [aContentView retain];
    [self insertSubview:aContentView atIndex:2];
}

- (void)setSidebarView:(JTNavigationView *)aSidebarView {
    [sidebarView removeFromSuperview];
    [sidebarView autorelease], sidebarView = nil;
    sidebarView = [aSidebarView retain];
    [self insertSubview:sidebarView atIndex:1];
    _onTop.isOnTop = 1;
}

- (void)setSidebarViewRight:(JTNavigationView *)aSidebarViewRight {
    [sidebarViewRight removeFromSuperview];
    [sidebarViewRight autorelease], sidebarViewRight = nil;
    sidebarViewRight = [aSidebarViewRight retain];
    [self insertSubview:sidebarViewRight atIndex:0];
}

- (void)swapSidebarViewIndecies {
    
    if(_onTop.isOnTop == 1){
        [self sendSubviewToBack:sidebarView];
        _onTop.isOnTop = 0;
    }
    else{
        [self sendSubviewToBack:sidebarViewRight];
        _onTop.isOnTop = 1;
        
    }
    return;

}

- (BOOL)isLeftSidebarOnTop {

    return _onTop.isOnTop == 1 ? YES : NO;

}

- (BOOL)isSidebarShowing {
    return _state.isShowing == 1 ? YES : NO;
}

- (BOOL)isSidebarShowingRight {
    return _stateRight.isShowingRight == 1 ? YES : NO;
}

#pragma mark Instance method

- (void)revealSidebar:(BOOL)shouldReveal {
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.3];
    if (shouldReveal) {
        contentView.frame = CGRectOffset(contentView.bounds, CGRectGetWidth(sidebarView.frame), 0);
    } else {
        contentView.frame = contentView.bounds;
    }
    [UIView commitAnimations];
    _state.isShowing = shouldReveal ? 1 : 0;
}

- (void)revealSidebarRight:(BOOL)shouldReveal {
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.3];
    if (shouldReveal) {
        contentView.frame = CGRectOffset(contentView.bounds, -CGRectGetWidth(sidebarViewRight.frame), 0);
    } else {
        contentView.frame = contentView.bounds;
    }
    [UIView commitAnimations];
    _stateRight.isShowingRight = shouldReveal ? 1 : 0;
}

#pragma mark Class method

+ (JTRevealSidebarView *)defaultViewWithFrame:(CGRect)frame {
    JTRevealSidebarView *revealView = [[JTRevealSidebarView alloc] initWithFrame:frame];
    revealView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    JTNavigationView *sidebarView = [[[JTNavigationView alloc] initWithFrame:CGRectMake(0, 0, 270, CGRectGetHeight(frame))] autorelease];
    {
        [sidebarView setNavigationBarHidden:YES animated:NO];
        sidebarView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
        revealView.sidebarView = sidebarView;
    }
    
    JTNavigationView *sidebarViewRight = [[[JTNavigationView alloc] initWithFrame:CGRectMake(50, 0, 270, CGRectGetHeight(frame))] autorelease];
    {
        [sidebarViewRight setNavigationBarHidden:YES animated:NO];
        sidebarViewRight.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
        revealView.sidebarViewRight = sidebarViewRight;
    }

    JTNavigationView *contentView = [[[JTNavigationView alloc] initWithFrame:(CGRect){CGPointZero, frame.size} animationStyle:JTNavigationViewAnimationStyleCoverUp] autorelease];
    {
        contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        contentView.backgroundColor = [UIColor lightGrayColor];
        revealView.contentView = contentView;
    }

    return [revealView autorelease];
}

@end
