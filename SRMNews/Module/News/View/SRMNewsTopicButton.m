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

- (void)initialize {
}
    
- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    NSMutableDictionary *attributesDictionary = [NSMutableDictionary dictionary];
    attributesDictionary[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    
    switch (state) {
        case UIControlStateNormal:
        attributesDictionary[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
        break;
        case UIControlStateSelected:
        attributesDictionary[NSForegroundColorAttributeName] = [UIColor colorwithHex:0xdf3030];
        break;
        default:
        break;
    }
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:title attributes:attributesDictionary];
    [self setAttributedTitle:attributedString forState:state];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    CGAffineTransform transform = selected ? CGAffineTransformMakeScale(1.3, 1.3) : CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = transform;
    }];
}
    
@end
