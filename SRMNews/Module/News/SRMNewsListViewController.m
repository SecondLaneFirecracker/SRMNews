//
//  SRMNewsListViewController.m
//  SRMNews
//
//  Created by marksong on 1/11/17.
//  Copyright © 2017 S.R. All rights reserved.
//

#import "SRMNewsListViewController.h"
#import "Masonry.h"

@interface SRMNewsListViewController ()

@property (nonatomic) UILabel *topicLabel;

@end

@implementation SRMNewsListViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor lightGrayColor];
    UILabel *topicLabel = [UILabel new];
    [self.view addSubview:topicLabel];
    [topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    self.topicLabel = topicLabel;
}

- (void)setTopic:(NSString *)topic {
    _topic = topic;
    self.topicLabel.text = topic;
    [self.topicLabel sizeToFit];
}

@end
