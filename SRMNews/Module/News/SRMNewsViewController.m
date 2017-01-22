//
//  SRMNewsViewController.m
//  SRMNews
//
//  Created by marksong on 12/30/16.
//  Copyright © 2016 S.R. All rights reserved.
//

#import "SRMNewsViewController.h"
#import "SRMNewsListViewController.h"
#import "SRMNewsView.h"
#import "SRMNewsTopicButton.h"
#import "SRMTopicService.h"
#import "SRMTopicModel.h"
#import "UIColor+Hex.h"
#import "UIScreen+Size.h"
#import "Masonry.h"

@interface SRMNewsViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *topicScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *newsListScrollView;
@property (nonatomic) SRMNewsView *rootView;
@property (nonatomic) SRMNewsListViewController *leftNewsListController;
@property (nonatomic) SRMNewsListViewController *centerNewsListController;
@property (nonatomic) SRMNewsListViewController *rightNewsListController;
@property (nonatomic) NSInteger currentTopicindex;
@property (nonatomic) NSArray *topicArray;
@property (nonatomic) NSArray *topicNameArray;

@end

@implementation SRMNewsViewController

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeTopicModel];
    self.rootView = (SRMNewsView *)self.view;
    [self.rootView initializeWithController:self topicArray:self.topicNameArray];
    [self registerTapHanlderForTopicButton];
    [self initializeNewsListController];
    // 为了触发默认选中第一个 topic。
    self.currentTopicindex = 1;
    [self didTouchTopicButton:self.topicScrollView.subviews.firstObject];
}

#pragma mark - Responder
    
- (void)didTouchTopicButton:(SRMNewsTopicButton *)topicButton {
    if (self.currentTopicindex == topicButton.tag) {
        return;
    }
    
    // 点击话题按钮时直接显示对应列表，因为无滑动过程，所以要单独设置动效。
    SRMNewsTopicButton *currentTopicButton = self.topicScrollView.subviews[self.currentTopicindex];
    [currentTopicButton setSelectionEffectlevel:0 withAnimationDuration:0.3];
    [topicButton setSelectionEffectlevel:1 withAnimationDuration:0.3];
    CGFloat offsetX = topicButton.tag * CGRectGetWidth(self.newsListScrollView.frame);
    [self.newsListScrollView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
    [self showTopicAtIndex:topicButton.tag];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    [self showTopicAtIndex:index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.rootView updateTopicButtonStyle];
}
    
#pragma mark - Private

- (void)registerTapHanlderForTopicButton {
    [self.topicScrollView.subviews enumerateObjectsUsingBlock:^(UIButton *topicButton, NSUInteger idx, BOOL * _Nonnull stop) {
        [topicButton addTarget:self action:@selector(didTouchTopicButton:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)initializeNewsListController {
    self.leftNewsListController = [SRMNewsListViewController new];
    [self.newsListScrollView addSubview:self.leftNewsListController.view];
    self.centerNewsListController = [SRMNewsListViewController new];
    [self.newsListScrollView addSubview:self.centerNewsListController.view];
    self.rightNewsListController = [SRMNewsListViewController new];
    [self.newsListScrollView addSubview:self.rightNewsListController.view];
}

- (void)showTopicAtIndex:(NSInteger)index {
    [self showNewsListAboutTopicAtIndex:index];
    [self.rootView centerTopicButtonAtIndex:index];
    self.currentTopicindex = index;
}

- (void)showNewsListAboutTopicAtIndex:(NSInteger)index {
    CGFloat width = CGRectGetWidth(self.newsListScrollView.frame);
    CGFloat height = CGRectGetHeight(self.newsListScrollView.frame);
    
    if (index == 0) {
        index = index + 1;
    } else if (index == self.topicArray.count - 1) {
        index = index - 1;
    }
    
    self.leftNewsListController.topic = self.topicArray[index - 1];
    self.centerNewsListController.topic = self.topicArray[index];
    self.rightNewsListController.topic = self.topicArray[index + 1];
    // 初始渲染新闻列表 view 时，新闻列表 scroll view 的尺寸未设置正确，而之后新闻列表 view 随着 scroll view 的尺寸改变，也只会改变自己的尺寸，原点不会改变，所以为了新闻列表 view 的原点能够设置正确，原点 x 轴的增量要使用屏幕宽度。
    self.leftNewsListController.view.frame = CGRectMake([UIScreen mainWidth] * (index - 1), 0, width, height);
    self.centerNewsListController.view.frame = CGRectMake([UIScreen mainWidth] * index, 0, width, height);
    self.rightNewsListController.view.frame = CGRectMake([UIScreen mainWidth] * (index + 1), 0, width, height);
}

- (void)initializeTopicModel {
    self.topicArray = [[SRMTopicService sharedInstance] getTopicList];
    self.topicNameArray = [[SRMTopicService sharedInstance] getTopicNameList];
}

@end
