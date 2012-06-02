/*
 * This file is part of the JTRevealSidebar package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */


#import <UIKit/UIKit.h>

@class JTNavigationView;

@interface JTRevealSidebarView : UIView {
    struct {
        unsigned int isShowing:1;
    } _state;
    
    struct {
        unsigned int isShowingRight:1;
    } _stateRight;
    
    struct {
        unsigned int isOnTop:1;
    }_onTop;
        
}

@property (nonatomic, retain) JTNavigationView *sidebarView;
@property (nonatomic, retain) JTNavigationView *sidebarViewRight;
@property (nonatomic, retain) JTNavigationView *contentView;

- (void)revealSidebar:(BOOL)shouldReveal;
- (void)revealSidebarRight:(BOOL)shouldReveal;
- (BOOL)isSidebarShowing;
- (BOOL)isSidebarShowingRight;
- (BOOL)isLeftSidebarOnTop;
- (void)swapSidebarViewIndecies;

+ (JTRevealSidebarView *)defaultViewWithFrame:(CGRect)frame;

@end
