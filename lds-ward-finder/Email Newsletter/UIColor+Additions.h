//
//  UIColor+Additions.h
//  Common
//
//  Created by Campbell, Hilton on 11/26/09.
//  Copyright 2010 LDS Mobile Apps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

extern void RGBtoHSV(float r, float g, float b, float* h, float* s, float* v);
extern void HSVtoRGB( float *r, float *g, float *b, float h, float s, float v);

@interface UIColor (Additions)

+ (UIColor*)selectionColor;

+ (UIColor*)colorForHex:(NSString*)hexColor;

- (UIColor*)multiplyHue:(CGFloat)hd saturation:(CGFloat)sd value:(CGFloat)vd;

@end
