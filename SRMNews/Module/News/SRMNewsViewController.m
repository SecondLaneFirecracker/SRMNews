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
@property (nonatomic) SRMNewsListViewController *leftNewsListController;
@property (nonatomic) SRMNewsListViewController *centerNewsListController;
@property (nonatomic) SRMNewsListViewController *rightNewsListController;
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
    
    // 点击话题按钮时直接显示对应列表，因为无滑动过程，所以要单独设置动效。
    [self.currentTopicButton setSelectionEffectlevel:0 withAnimationDuration:0.3];
    [topicButton setSelectionEffectlevel:1 withAnimationDuration:0.3];
    CGFloat offsetX = topicButton.tag * CGRectGetWidth(self.newsListScrollView.frame);
    [self.newsListScrollView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
    [self scrollViewDidEndDecelerating:self.newsListScrollView];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    [self showNewsListAboutTopicAtIndex:index];
    SRMNewsTopicButton *topicButton = self.topicScrollView.subviews[index];
    [self scrollNewCurrentTopicButton:topicButton];
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
    
    // 若 offset 正好为整数倍时，则会修改当前 topic 及后一个 topic，所以要针对最后一个做边界判断。
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
    [self addDefaultLogoBackgroundView];
    self.leftNewsListController = [SRMNewsListViewController new];
    [self.newsListScrollView addSubview:self.leftNewsListController.view];
    self.centerNewsListController = [SRMNewsListViewController new];
    [self.newsListScrollView addSubview:self.centerNewsListController.view];
    self.rightNewsListController = [SRMNewsListViewController new];
    [self.newsListScrollView addSubview:self.rightNewsListController.view];
}

- (void)addDefaultLogoBackgroundView {
    __block UIImageView *lastLogoView;
    [self.topicArray enumerateObjectsUsingBlock:^(NSDictionary *topicDictionary, NSUInteger index, BOOL * _Nonnull stop) {
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
            
            if (index == self.topicArray.count - 1) {
                make.right.equalTo(self.newsListScrollView);
            }
        }];
        
        lastLogoView = logoImageView;
    }];
}

- (void)scrollNewCurrentTopicButton:(SRMNewsTopicButton *)topicButton {
    self.currentTopicButton = topicButton;
    CGFloat offsetX = topicButton.center.x - CGRectGetWidth(self.newsListScrollView.frame) / 2;
    offsetX = MAX(offsetX, 0);
    offsetX = MIN(offsetX, self.topicScrollView.contentSize.width - CGRectGetWidth(self.topicScrollView.frame));
    [self.topicScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void)showNewsListAboutTopicAtIndex:(NSInteger)index {
    CGFloat width = CGRectGetWidth(self.newsListScrollView.frame);
    CGFloat height = CGRectGetHeight(self.newsListScrollView.frame);
    
    if (index == 0) {
        index = index + 1;
    } else if (index == self.topicArray.count - 1) {
        index = index - 1;
    }
    
    self.leftNewsListController.topic = self.topicArray[index - 1][@"tname"];
    self.centerNewsListController.topic = self.topicArray[index][@"tname"];
    self.rightNewsListController.topic = self.topicArray[index + 1][@"tname"];
    // 初始渲染新闻列表 view 时，新闻列表 scroll view 的尺寸未设置正确，而之后新闻列表 view 随着 scroll view 的尺寸改变，也只会改变自己的尺寸，原点不会改变，所以为了新闻列表 view 的原点能够设置正确，原点 x 轴的增量要使用屏幕宽度。
    self.leftNewsListController.view.frame = CGRectMake([UIScreen mainWidth] * (index - 1), 0, width, height);
    self.centerNewsListController.view.frame = CGRectMake([UIScreen mainWidth] * index, 0, width, height);
    self.rightNewsListController.view.frame = CGRectMake([UIScreen mainWidth] * (index + 1), 0, width, height);
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
