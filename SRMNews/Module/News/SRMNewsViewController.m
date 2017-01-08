//
//  SRMNewsViewController.m
//  SRMNews
//
//  Created by marksong on 12/30/16.
//  Copyright © 2016 S.R. All rights reserved.
//

#import "SRMNewsViewController.h"
#import "UIColor+Hex.h"

@interface SRMNewsViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *topicScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *newsListScrollView;
@property (nonatomic) UILabel *currentTopicLable;
@property (nonatomic) NSArray *topicArray;

@end

@implementation SRMNewsViewController

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeNavigationItem];
    [self initializeTopicScrollView];
    [self initializeNewsListScrollView];
    [self didTapTopicLabel:self.topicScrollView.subviews.firstObject];
}

#pragma mark - Responder

- (void)handleTopicLabelTapGestureRecognizer:(UITapGestureRecognizer *)recognizer {
    [self didTapTopicLabel:(UILabel *)recognizer.view];
}

- (void)didTapTopicLabel:(UILabel *)topicLabel {
    topicLabel.textColor = [UIColor colorwithHex:0xdf3030];
    self.currentTopicLable.textColor = [UIColor blackColor];
    self.currentTopicLable = topicLabel;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    UIView *newsListView = self.childViewControllers[index].view;
    
    if (!newsListView.superview) {
        newsListView.frame = scrollView.bounds;
        [scrollView addSubview:newsListView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
}

#pragma mark - Private

- (void)initializeNavigationItem {
    UIImage *titleImage = [UIImage imageNamed:@"news_nav_title_img"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    self.navigationItem.titleView = titleImageView;
}

- (void)initializeTopicScrollView {
    __block CGFloat pointX = 5;
    
    [self.topicArray enumerateObjectsUsingBlock:^(NSDictionary *topicDictionary, NSUInteger index, BOOL * _Nonnull stop) {
        UILabel *topicLabel = [UILabel new];
        topicLabel.textAlignment = NSTextAlignmentCenter;
        topicLabel.text = topicDictionary[@"tname"];
        [topicLabel sizeToFit];
        CGFloat pointY = (40 - CGRectGetHeight(topicLabel.frame)) / 2;
        topicLabel.frame = CGRectMake(pointX, pointY, CGRectGetWidth(topicLabel.frame) + 10, CGRectGetHeight(topicLabel.frame));
        [self.topicScrollView addSubview:topicLabel];
        pointX += CGRectGetWidth(topicLabel.frame);
        topicLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTopicLabelTapGestureRecognizer:)];
        [topicLabel addGestureRecognizer:tapGestureRecognizer];
    }];
    
    self.topicScrollView.contentSize = CGSizeMake(pointX + 5, 0);
}

- (void)initializeNewsListScrollView {
    self.newsListScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.newsListScrollView.frame) * self.topicArray.count, 0);
    
    [self.topicArray enumerateObjectsUsingBlock:^(NSDictionary *topicDictionary, NSUInteger index, BOOL * _Nonnull stop) {
        UIViewController *newsListController = [UIViewController new];
        UILabel *topicLabel = [UILabel new];
        topicLabel.text = topicDictionary[@"tname"];
        [topicLabel sizeToFit];
        [newsListController.view addSubview:topicLabel];
        [self addChildViewController:newsListController];
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
