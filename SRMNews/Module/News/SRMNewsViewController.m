//
//  SRMNewsViewController.m
//  SRMNews
//
//  Created by marksong on 12/30/16.
//  Copyright © 2016 S.R. All rights reserved.
//

#import "SRMNewsViewController.h"

@interface SRMNewsViewController ()

@end

@implementation SRMNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeView];
}

#pragma mark - Private

- (void)initializeView {
    UIImage *titleImage = [UIImage imageNamed:@"news_nav_title_img"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    self.navigationItem.titleView = titleImageView;
}

@end
