//
//  UIColor+Hex.m
//  SRMNews
//
//  Created by marksong on 12/30/16.
//  Copyright © 2016 S.R. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (instancetype)colorwithHex:(NSInteger)hex {
    return [[self class] colorwithHex:hex alpha:1];
}

+ (instancetype)colorwithHex:(NSInteger)hex alpha:(CGFloat)alpha {
    UIColor *color = [[self class] colorWithR:(hex >> 16) & 0xff G:(hex >> 8) & 0xff B:hex & 0xff A:alpha];
    
    return color;
}

+ (instancetype)colorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue {
    return [[self class] colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
}

+ (instancetype)colorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue A:(CGFloat)alpha {
    return [[self class] colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

@end
