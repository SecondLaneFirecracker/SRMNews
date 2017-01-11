//
//  SRMNewsTopicButton.m
//  SRMNews
//
//  Created by marksong on 1/9/17.
//  Copyright © 2017 S.R. All rights reserved.
//

#import "SRMNewsTopicButton.h"
#import "UIColor+Hex.h"

@implementation SRMNewsTopicButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize {
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self setTitleColor:[UIColor colorwithHex:0x333333] forState:UIControlStateNormal];
}

- (void)setSelectionEffectlevel:(float)selectionEffectlevel {
    _selectionEffectlevel = selectionEffectlevel;
    CGFloat scale = 1 + 0.3 * selectionEffectlevel;
    self.transform = CGAffineTransformMakeScale(scale, scale);
    NSInteger redValue = (NSInteger)((0xdf - 0x33) * selectionEffectlevel) << 16;
    NSInteger colorHex = redValue + 0x333333;
    [self setTitleColor:[UIColor colorwithHex:colorHex] forState:UIControlStateNormal];
}

- (void)setSelectionEffectlevel:(float)selectionEffectlevel withAnimationDuration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration animations:^{
        self.selectionEffectlevel = selectionEffectlevel;
    }];
}

@end
