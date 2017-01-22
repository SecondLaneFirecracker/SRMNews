//
//  SRMNewsView.h
//  SRMNews
//
//  Created by marksong on 1/11/17.
//  Copyright © 2017 S.R. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRMNewsView : UIView

- (void)initializeWithController:(UIViewController *)controller topicArray:(NSArray<NSString *> *)topicArray;
- (void)centerTopicButtonAtIndex:(NSInteger)index;
- (void)updateTopicButtonStyle;

@end
