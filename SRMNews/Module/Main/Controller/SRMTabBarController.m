//
//  SRMTabBarController.m
//  SRMNews
//
//  Created by marksong on 12/30/16.
//  Copyright © 2016 S.R. All rights reserved.
//

#import "SRMTabBarController.h"
#import "UIColor+Hex.h"

@interface SRMTabBarController ()

@end

@implementation SRMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = [UIColor colorwithHex:0xdf3030];
    
    for (UIViewController *controller in self.viewControllers) {
        UITabBarItem *tabBarItem = controller.tabBarItem;
        tabBarItem.selectedImage = [tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
        [tabBarItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    }
}

@end
