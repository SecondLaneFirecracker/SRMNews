//
//  SRMNewsView.m
//  SRMNews
//
//  Created by marksong on 1/11/17.
//  Copyright © 2017 S.R. All rights reserved.
//

#import "SRMNewsView.h"
#import "SRMNewsTopicButton.h"
#import "Masonry.h"

@interface SRMNewsView ()

@property (weak, nonatomic) IBOutlet UIScrollView *topicScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *newsListScrollView;

@end

@implementation SRMNewsView

#pragma mark - Public

- (void)initializeWithController:(UIViewController *)controller topicArray:(NSArray<NSString *> *)topicArray {
    [self initializeNavigationItemOfController:controller];
    [self initializeTopicScrollViewWithTopicArray:topicArray];
    [self initializeNewsListScrollViewWithTopicArray:topicArray];
}

- (void)centerTopicButtonAtIndex:(NSInteger)index {
    SRMNewsTopicButton *topicButton = self.topicScrollView.subviews[index];
    CGFloat offsetX = topicButton.center.x - CGRectGetWidth(self.newsListScrollView.frame) / 2;
    offsetX = MAX(offsetX, 0);
    offsetX = MIN(offsetX, self.topicScrollView.contentSize.width - CGRectGetWidth(self.topicScrollView.frame));
    [self.topicScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void)updateTopicButtonStyle {
    CGFloat width = CGRectGetWidth(self.newsListScrollView.frame);
    CGFloat value = self.newsListScrollView.contentOffset.x / width;
    CGFloat count = self.newsListScrollView.contentSize.width / width;
    
    if (value < 0 || value > count - 1) {
        return;
    }
    
    NSInteger index = (NSInteger)value;
    float level = value - index;
    SRMNewsTopicButton *topicButton = self.topicScrollView.subviews[index];
    topicButton.selectionEffectlevel = 1 - level;
    
    // 若 offset 正好为整数倍时，则会修改当前 topic 及后一个 topic，所以要针对最后一个做边界判断。
    if (index < count - 1) {
        SRMNewsTopicButton *nextTopicButton = self.topicScrollView.subviews[index + 1];
        nextTopicButton.selectionEffectlevel = level;
    }
}

#pragma mark - Private

- (void)initializeNavigationItemOfController:(UIViewController *)controller {
    UIImage *titleImage = [UIImage imageNamed:@"news_nav_title_img"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    controller.navigationItem.titleView = titleImageView;
}

- (void)initializeTopicScrollViewWithTopicArray:(NSArray<NSString *> *)topicArray {
    static const CGFloat kTopicInterval = 10;
    __block CGFloat pointX = kTopicInterval;
    
    [topicArray enumerateObjectsUsingBlock:^(NSString *topic, NSUInteger index, BOOL * _Nonnull stop) {
        UIButton *topicButton = [SRMNewsTopicButton buttonWithType:UIButtonTypeCustom];
        topicButton.tag = index;
        [topicButton setTitle:topic forState:UIControlStateNormal];
        [topicButton sizeToFit];
        CGFloat pointY = (40 - CGRectGetHeight(topicButton.frame)) / 2;
        topicButton.frame = CGRectMake(pointX, pointY, CGRectGetWidth(topicButton.frame) + kTopicInterval * 2, CGRectGetHeight(topicButton.frame));
        [self.topicScrollView addSubview:topicButton];
        pointX += CGRectGetWidth(topicButton.frame);
    }];
    
    self.topicScrollView.contentSize = CGSizeMake(pointX + kTopicInterval, 0);
}

- (void)initializeNewsListScrollViewWithTopicArray:(NSArray<NSString *> *)topicArray {
    __block UIImageView *lastLogoView;
    
    [topicArray enumerateObjectsUsingBlock:^(NSString *topic, NSUInteger index, BOOL * _Nonnull stop) {
        UIImage *logoImage = [UIImage imageNamed:@"news_list_logo_img"];
        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
        logoImageView.contentMode = UIViewContentModeCenter;
        [self.newsListScrollView insertSubview:logoImageView atIndex:0];
        
        [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.newsListScrollView);
            make.top.equalTo(self.newsListScrollView);
            
            if (index == 0) {
                make.left.equalTo(self.newsListScrollView);
            } else {
                make.left.equalTo(lastLogoView.mas_right);
            }
            
            if (index == topicArray.count - 1) {
                make.right.equalTo(self.newsListScrollView);
            }
        }];
        
        lastLogoView = logoImageView;
    }];
}

@end
