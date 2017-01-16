//
//  SRMNewsViewController.m
//  SRMNews
//
//  Created by marksong on 12/30/16.
//  Copyright © 2016 S.R. All rights reserved.
//

#import "SRMNewsViewController.h"
#import "SRMNewsListViewController.h"
#import "SRMNewsTopicButton.h"
#import "UIColor+Hex.h"
#import "Masonry.h"

@interface SRMNewsViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *topicScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *newsListScrollView;
@property (weak, nonatomic) IBOutlet UIView *leftContainerView;
@property (weak, nonatomic) IBOutlet UIView *centerContainerView;
@property (weak, nonatomic) IBOutlet UIView *rightContainerView;
@property (nonatomic) SRMNewsTopicButton *currentTopicButton;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSArray *topicArray;

@end

@implementation SRMNewsViewController

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeNavigationItem];
    [self initializeTopicScrollView];
    [self initializeNewsListScrollView];
    [self didTouchTopicButton:self.topicScrollView.subviews.firstObject];
}

#pragma mark - Responder
    
- (void)didTouchTopicButton:(SRMNewsTopicButton *)topicButton {
    if (self.currentTopicButton == topicButton) {
        return;
    }
    
    // 点击话题按钮时直接显示对应列表，因为无滑动过程，所以要单独设置动效。
    [self.currentTopicButton setSelectionEffectlevel:0 withAnimationDuration:0.3];
    [topicButton setSelectionEffectlevel:1 withAnimationDuration:0.3];
    [self resetCurrentTopicButton:topicButton];
    [self resetDisplayedViewAtIndex:topicButton.tag];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index;
    
    if (scrollView.contentOffset.x > CGRectGetWidth([UIScreen mainScreen].bounds)) {
        if (self.currentIndex != self.topicArray.count - 1) {
            index = (self.currentIndex + 1) % self.topicArray.count;
        } else {
            return;
        }
    } else if (scrollView.contentOffset.x < CGRectGetWidth([UIScreen mainScreen].bounds)) {
        if (self.currentIndex != 0) {
            index = (self.currentIndex - 1 + self.topicArray.count) % self.topicArray.count;
        } else {
            return;
        }
    } else {
        if (self.currentIndex == 0) {
            index = self.currentIndex + 1;
        } else if (self.currentIndex == self.topicArray.count - 1) {
            index = self.currentIndex - 1;
        } else {
            return;
        }
    }

    SRMNewsTopicButton *topicButton = self.topicScrollView.subviews[index];
    [self resetCurrentTopicButton:topicButton];
    [self resetDisplayedViewAtIndex:index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat value = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    
    if (value < 0 || value > 2) {
        return;
    }
    
    NSInteger index = (self.currentIndex - 1 + (NSInteger)floor(value) + self.topicArray.count) % self.topicArray.count;
    
    if (self.currentIndex == 0) {
        index = (self.currentIndex + (NSInteger)floor(value) + self.topicArray.count) % self.topicArray.count;
    } else if (self.currentIndex == self.topicArray.count - 1) {
        index = (self.currentIndex - 2 + (NSInteger)floor(value) + self.topicArray.count) % self.topicArray.count;
    }
    
    float level = 1 - fmodf(value, 1);
    SRMNewsTopicButton *topicButton = self.topicScrollView.subviews[index];
    topicButton.selectionEffectlevel = level;

    if (index < self.topicArray.count - 1) {
        SRMNewsTopicButton *nextTopicButton = self.topicScrollView.subviews[index + 1];
        nextTopicButton.selectionEffectlevel = 1 - level;
    }
}
    
#pragma mark - Private

- (void)initializeNavigationItem {
    UIImage *titleImage = [UIImage imageNamed:@"news_nav_title_img"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    self.navigationItem.titleView = titleImageView;
}

- (void)initializeTopicScrollView {
    static const CGFloat kTopicInterval = 10;
    __block CGFloat pointX = kTopicInterval;
    
    [self.topicArray enumerateObjectsUsingBlock:^(NSDictionary *topicDictionary, NSUInteger index, BOOL * _Nonnull stop) {
        UIButton *topicButton = [SRMNewsTopicButton buttonWithType:UIButtonTypeCustom];
        topicButton.tag = index;
        [topicButton setTitle:topicDictionary[@"tname"] forState:UIControlStateNormal];
        [topicButton sizeToFit];
        [topicButton addTarget:self action:@selector(didTouchTopicButton:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat pointY = (40 - CGRectGetHeight(topicButton.frame)) / 2;
        topicButton.frame = CGRectMake(pointX, pointY, CGRectGetWidth(topicButton.frame) + kTopicInterval * 2, CGRectGetHeight(topicButton.frame));
        [self.topicScrollView addSubview:topicButton];
        pointX += CGRectGetWidth(topicButton.frame);
    }];
    
    self.topicScrollView.contentSize = CGSizeMake(pointX + kTopicInterval, 0);
}

- (void)initializeNewsListScrollView {
    self.newsListScrollView.contentSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 3, 0);
    
    [self.topicArray enumerateObjectsUsingBlock:^(NSDictionary *topicDictionary, NSUInteger index, BOOL * _Nonnull stop) {
        UIViewController *newsListController = [SRMNewsListViewController new];
        newsListController.view.backgroundColor = [UIColor lightGrayColor];
        UILabel *topicLabel = [UILabel new];
        topicLabel.text = topicDictionary[@"tname"];
        [topicLabel sizeToFit];
        topicLabel.center = newsListController.view.center;
        [newsListController.view addSubview:topicLabel];
        [topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(newsListController.view);
        }];
        [self addChildViewController:newsListController];
    }];
}
    
- (void)resetCurrentTopicButton:(SRMNewsTopicButton *)topicButton {
    CGFloat offsetX = topicButton.center.x - CGRectGetWidth(self.newsListScrollView.frame) / 2;
    offsetX = MAX(offsetX, 0);
    offsetX = MIN(offsetX, self.topicScrollView.contentSize.width - CGRectGetWidth(self.topicScrollView.frame));
    [self.topicScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    self.currentTopicButton = topicButton;
}

- (void)resetDisplayedViewAtIndex:(NSInteger)index {
    self.currentIndex = index;
    NSInteger count = self.topicArray.count;
    CGFloat offsetX = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    
    if (index == 0) {
        index = index + 1;
        offsetX = 0;
    } else if (index == count - 1) {
        index = index - 1;
        offsetX = CGRectGetWidth([UIScreen mainScreen].bounds) * 2;
    }
    
    NSInteger leftIndex = (index - 1 + count) % count;
    NSInteger rightIndex = (index + 1) % count;
    [self containerView:self.leftContainerView showView:self.childViewControllers[leftIndex].view];
    [self containerView:self.centerContainerView showView:self.childViewControllers[index].view];
    [self containerView:self.rightContainerView showView:self.childViewControllers[rightIndex].view];
    self.newsListScrollView.contentOffset = CGPointMake(offsetX, 0);
}

- (void)containerView:(UIView *)containerView showView:(UIView *)view {
    [containerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [containerView addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(containerView);
    }];
}

#pragma mark - Getter

- (NSArray *)topicArray {
    if (!_topicArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"news_topic" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        _topicArray = dataDictionary[@"tList"];
    }
    
    return _topicArray;
}

@end
