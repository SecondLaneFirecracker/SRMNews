//
//  UIScreen+Size.m
//  SRMNews
//
//  Created by marksong on 17/01/2017.
//  Copyright © 2017 S.R. All rights reserved.
//

#import "UIScreen+Size.h"

@implementation UIScreen (Size)

+ (CGSize)mainSize {
    return [self mainScreen].bounds.size;
}

+ (CGFloat)mainWidth {
    return CGRectGetWidth([self mainScreen].bounds);
}

+ (CGFloat)mainHeight {
    return CGRectGetHeight([self mainScreen].bounds);
}

@end
