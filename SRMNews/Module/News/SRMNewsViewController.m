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
#import "UIScreen+Size.h"
#import "Masonry.h"

@interface SRMNewsViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *topicScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *newsListScrollView;
@property (weak, nonatomic) IBOutlet UIView *leftContainerView;
@property (weak, nonatomic) IBOutlet UIView *centerContainerView;
@property (weak, nonatomic) IBOutlet UIView *rightContainerView;
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
    // 避免默认点击第一个 topic 时触发重复点击的判断。
    self.currentIndex = 1;
    [self didTouchTopicButton:self.topicScrollView.subviews.firstObject];
}

#pragma mark - Responder
    
- (void)didTouchTopicButton:(SRMNewsTopicButton *)topicButton {
    SRMNewsTopicButton *currentTopicButton = self.topicScrollView.subviews[self.currentIndex];
    
    if (currentTopicButton == topicButton) {
        return;
    }
    
    // 点击话题按钮时直接显示对应列表，因为无滑动过程，所以要单独设置动效。
    [currentTopicButton setSelectionEffectlevel:0 withAnimationDuration:0.3];
    [topicButton setSelectionEffectlevel:1 withAnimationDuration:0.3];
    [self scrollNewCurrentTopicButton:topicButton];
    self.currentIndex = topicButton.tag;
    [self resetDisplayedViewAtIndex:self.currentIndex];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > [UIScreen mainWidth]) {
        if (self.currentIndex == self.topicArray.count - 1) {
            return;
        } else if (self.currentIndex == 0) {
            self.currentIndex = self.currentIndex + 2;
        } else {
            self.currentIndex = self.currentIndex + 1;
        }
    } else if (scrollView.contentOffset.x < [UIScreen mainWidth]) {
        if (self.currentIndex == 0) {
            return;
        } else if (self.currentIndex == self.topicArray.count - 1) {
            self.currentIndex = self.currentIndex - 2;
        } else {
            self.currentIndex = self.currentIndex - 1;
        }
    } else {
        if (self.currentIndex == 0) {
            self.currentIndex = self.currentIndex + 1;
        } else if (self.currentIndex == self.topicArray.count - 1) {
            self.currentIndex = self.currentIndex - 1;
        } else {
            return;
        }
    }

    SRMNewsTopicButton *topicButton = self.topicScrollView.subviews[self.currentIndex];
    [self scrollNewCurrentTopicButton:topicButton];
    [self resetDisplayedViewAtIndex:self.currentIndex];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    SRMNewsTopicButton *topicButton = self.topicScrollView.subviews[self.currentIndex];
    CGFloat value = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    
    // 判断新闻列表 scroll view 滑动的不同方向，修改 topic button 的样式。因为不支持轮播，所以
    // 要考虑左右两个边界的情况。
    if (value > 1 && value <= 2) {
        value = value - 1;
        
        if (self.currentIndex == self.topicArray.count - 1) {
            // 右边界情况，左边 view 滑入。
            topicButton.selectionEffectlevel = value;
            topicButton = self.topicScrollView.subviews[self.currentIndex - 1];
            topicButton.selectionEffectlevel = 1 - value;
        } else if (self.currentIndex == 0) {
            // 左边界情况，快速滑动使右边边第三个 view 滑入。
            topicButton = self.topicScrollView.subviews[self.currentIndex + 1];
            topicButton.selectionEffectlevel = 1 - value;
            topicButton = self.topicScrollView.subviews[self.currentIndex + 2];
            topicButton.selectionEffectlevel = value;
        } else {
            // 默认情况，右边 view 滑入。
            topicButton.selectionEffectlevel = 1 - value;
            topicButton = self.topicScrollView.subviews[self.currentIndex + 1];
            topicButton.selectionEffectlevel = value;
        }
    } else if (value >= 0 && value < 1) {
        if (self.currentIndex == 0) {
            // 左边界情况，右边 view 滑入。
            topicButton.selectionEffectlevel = 1- value;
            topicButton = self.topicScrollView.subviews[self.currentIndex + 1];
            topicButton.selectionEffectlevel = value;
        } else if (self.currentIndex == self.topicArray.count - 1) {
            // 右边界情况，快速滑动使左边第三个 view 滑入。
            topicButton = self.topicScrollView.subviews[self.currentIndex - 1];
            topicButton.selectionEffectlevel = value;
            topicButton = self.topicScrollView.subviews[self.currentIndex - 2];
            topicButton.selectionEffectlevel = 1 - value;
        } else {
            // 默认情况，左边 view 滑入。
            topicButton.selectionEffectlevel = value;
            topicButton = self.topicScrollView.subviews[self.currentIndex - 1];
            topicButton.selectionEffectlevel = 1 - value;
        }
    } else if (value == 1) {
        if (self.currentIndex == 0) {
            // 左边界情况，右边 view 完成滑入。
            topicButton.selectionEffectlevel = 1 - value;
            topicButton = self.topicScrollView.subviews[self.currentIndex + 1];
            topicButton.selectionEffectlevel = value;
        } else if (self.currentIndex == self.topicArray.count - 1) {
            // 右边界情况，左边 view 完成滑入。
            topicButton.selectionEffectlevel = value - 1;
            topicButton = self.topicScrollView.subviews[self.currentIndex - 1];
            topicButton.selectionEffectlevel = 1 - (value - 1);
        } else {
            // 默认情况，滑入未完成，恢复到当前 view。另一种情况是，滑入完成后，重新设置 scroll
            // view 内容及位置后的一次触发。
            topicButton.selectionEffectlevel = value;
            topicButton = self.topicScrollView.subviews[self.currentIndex - 1];
            topicButton.selectionEffectlevel = 1 - value;
            topicButton = self.topicScrollView.subviews[self.currentIndex + 1];
            topicButton.selectionEffectlevel = 1 - value;
        }
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
    
- (void)scrollNewCurrentTopicButton:(SRMNewsTopicButton *)topicButton {
    CGFloat offsetX = topicButton.center.x - CGRectGetWidth(self.newsListScrollView.frame) / 2;
    offsetX = MAX(offsetX, 0);
    offsetX = MIN(offsetX, self.topicScrollView.contentSize.width - CGRectGetWidth(self.topicScrollView.frame));
    [self.topicScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void)resetDisplayedViewAtIndex:(NSInteger)index {
    CGFloat offsetX = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    if (index == 0) {
        index = index + 1;
        offsetX = 0;
    } else if (index == self.topicArray.count - 1) {
        index = index - 1;
        offsetX = CGRectGetWidth([UIScreen mainScreen].bounds) * 2;
    }
    
    [self containerView:self.leftContainerView showView:self.childViewControllers[index - 1].view];
    [self containerView:self.centerContainerView showView:self.childViewControllers[index].view];
    [self containerView:self.rightContainerView showView:self.childViewControllers[index + 1].view];
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
