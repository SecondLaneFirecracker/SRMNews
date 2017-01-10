//
//  SRMNewsTopicButton.h
//  SRMNews
//
//  Created by marksong on 1/9/17.
//  Copyright © 2017 S.R. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRMNewsTopicButton : UIButton

// 可设值的范围为0到1，0为默认未选中状态，文字颜色为深灰，正常大小，1为完全选中状态，文字颜色为亮红，放大1.3倍。
@property (nonatomic) float selectionEffectlevel;

- (void)setSelectionEffectlevel:(float)selectionEffectlevel withAnimationDuration:(NSTimeInterval)duration;

@end
