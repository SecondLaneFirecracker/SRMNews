//
//  SRMNewsViewController.m
//  SRMNews
//
//  Created by marksong on 12/30/16.
//  Copyright © 2016 S.R. All rights reserved.
//

#import "SRMNewsViewController.h"
#import "SRMNewsTopicButton.h"
#import "UIColor+Hex.h"
#import "Masonry.h"

@interface SRMNewsViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *topicScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *newsListScrollView;
@property (nonatomic) SRMNewsTopicButton *currentTopicButton;
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
    
    [self.currentTopicButton setSelectionEffectlevel:0 withAnimationDuration:0.3];
    [topicButton setSelectionEffectlevel:1 withAnimationDuration:0.3];
    self.currentTopicButton = topicButton;
    // 使[- setContentOffset: animated:]方法执行后不触发代理方法[- scrollViewDidScroll:]的唯一一次执行，否则影响话题按钮设置动效。
    self.newsListScrollView.delegate = nil;
    CGFloat offsetX = topicButton.tag * CGRectGetWidth(self.newsListScrollView.frame);
    [self.newsListScrollView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
    self.newsListScrollView.delegate = self;
    [self scrollViewDidEndDecelerating:self.newsListScrollView];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    SRMNewsTopicButton *topicButton = self.topicScrollView.subviews[index];
    self.currentTopicButton = topicButton;
    [self scrollTopicButtonToCenter:topicButton];
    [self addNewsListViewAtIndex:index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat value = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    
    if (value < 0 || value > self.topicArray.count - 1) {
        return;
    }
    
    NSInteger index = (NSInteger)value;
    float level = value - index;
    SRMNewsTopicButton *topicButton = self.topicScrollView.subviews[index];
    topicButton.selectionEffectlevel = 1 - level;
    
    if (index < self.topicArray.count - 1) {
        SRMNewsTopicButton *nextTopicButton = self.topicScrollView.subviews[index + 1];
        nextTopicButton.selectionEffectlevel = level;
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
    self.newsListScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.newsListScrollView.frame) * self.topicArray.count, 0);
    // 使初始化时新闻列表 scrollView 为第一页的设置可以出发滑动代理，完成新闻列表页面的加载。
    self.newsListScrollView.contentOffset = CGPointMake(-1, 0);
    
    [self.topicArray enumerateObjectsUsingBlock:^(NSDictionary *topicDictionary, NSUInteger index, BOOL * _Nonnull stop) {
        UIViewController *newsListController = [UIViewController new];
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
    
- (void)scrollTopicButtonToCenter:(UIButton *)topicButton {
    CGFloat offsetX = topicButton.center.x - CGRectGetWidth(self.newsListScrollView.frame) / 2;
    offsetX = MAX(offsetX, 0);
    offsetX = MIN(offsetX, self.topicScrollView.contentSize.width - CGRectGetWidth(self.topicScrollView.frame));
    [self.topicScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}
    
- (void)addNewsListViewAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromCGRect(self.newsListScrollView.bounds));
    UIView *newsListView = self.childViewControllers[index].view;
    UIView *leftView = index > 0 ? self.childViewControllers[index - 1].view : nil;
    UIView *rightView = index < self.childViewControllers.count - 1 ? self.childViewControllers[index + 1].view : nil;
    
    if (!newsListView.superview) {
        newsListView.frame = self.newsListScrollView.bounds;
        [self.newsListScrollView addSubview:newsListView];
        NSLog(@"%@", NSStringFromCGRect(newsListView.frame));
    }
    
    if (leftView && !leftView.superview) {
        CGRect frame = self.newsListScrollView.bounds;
        leftView.frame = CGRectMake(CGRectGetMinX(frame) - CGRectGetWidth(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame));
        [self.newsListScrollView addSubview:leftView];
        NSLog(@"%@", NSStringFromCGRect(leftView.frame));
    }
    
    if (rightView && !rightView.superview) {
        CGRect frame = self.newsListScrollView.bounds;
        rightView.frame = CGRectMake(CGRectGetMinX(frame) + CGRectGetWidth(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame));
        [self.newsListScrollView addSubview:rightView];
        NSLog(@"%@", NSStringFromCGRect(rightView.frame));
    }
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
