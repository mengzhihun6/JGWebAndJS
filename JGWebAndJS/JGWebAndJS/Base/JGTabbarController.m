//
//  JGTabbarController.m
//  JGWebAndJS
//
//  Created by 郭军 on 2019/10/25.
//  Copyright © 2019 JG. All rights reserved.
//

#import "JGTabbarController.h"
#import "JGNavigationController.h"

#import "JGWKWebViewController.h"
#import "JGWebViewJavascriptBridgeController.h"



@interface JGTabbarController ()

@end

@implementation JGTabbarController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UITabBar appearance].translucent = NO;
    
    //创建子控制器
    [self setUpChildViewControllers];
}


/**
 *  创建子控制器
 */
- (void)setUpChildViewControllers {
    
    [self setupChildVc:[[JGWKWebViewController alloc] init] title:@"首页" image:@"tabbar_msg_nor"  selectedImage:@"tabbar_msg_sel"];
    
    [self setupChildVc:[[JGWebViewJavascriptBridgeController alloc] init] title: @"我的" image:@"tabbar_me_nor" selectedImage:@"tabbar_me_sel"];
}


/**
 *  初始化控制器
 *
 *  @param vc            控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中图片
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    
    //    vc.tabBarItem.title = title;
    vc.title = title;
    
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:JGHexColor(@"#616DF2")} forState:UIControlStateSelected];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:JGHexColor(@"#878787")} forState:UIControlStateNormal];
    
    //包装一个导航控制器
    JGNavigationController *nav = [[JGNavigationController alloc] initWithRootViewController:vc];
    //隐藏tabbar
    [self addChildViewController:nav];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
