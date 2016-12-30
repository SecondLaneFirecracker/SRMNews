//
//  UIColor+Hex.h
//  SRMNews
//
//  Created by marksong on 12/30/16.
//  Copyright © 2016 S.R. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (instancetype)colorwithHex:(NSInteger)hex;
+ (instancetype)colorwithHex:(NSInteger)hex alpha:(CGFloat)alpha;
+ (instancetype)colorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue;
+ (instancetype)colorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue A:(CGFloat)alpha;

@end
