//
//  JGWebViewJavascriptBridgeController.m
//  JGWebAndJS
//
//  Created by 郭军 on 2019/10/25.
//  Copyright © 2019 JG. All rights reserved.
//

#import "JGWebViewJavascriptBridgeController.h"
#import "WebViewJavascriptBridge.h"

@interface JGWebViewJavascriptBridgeController () <UIWebViewDelegate>

@property WebViewJavascriptBridge *bridge;

@end

@implementation JGWebViewJavascriptBridgeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"test2" ofType:@"html"];
    NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
    
    // 开启日志
    [WebViewJavascriptBridge enableLogging];
    
    // 给哪个webview建立JS与OjbC的沟通桥梁
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [self.bridge setWebViewDelegate:self];
    [self renderButtons:webView];
    
    // JS主动调用OjbC的方法
    // 这是JS会调用getUserIdFromObjC方法，这是OC注册给JS调用的
    // JS需要回调，当然JS也可以传参数过来。data就是JS所传的参数，不一定需要传
    // OC端通过responseCallback回调JS端，JS就可以得到所需要的数据
    [self.bridge registerHandler:@"getUserIdFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        JGLog(@"js call getUserIdFromObjC, data from js is %@", data);
        if (responseCallback) {
            // 反馈给JS
            responseCallback(@{@"userId": @"123456"});
        }
    }];
    
    [self.bridge registerHandler:@"getBlogNameFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        JGLog(@"js call getBlogNameFromObjC, data from js is %@", data);
        if (responseCallback) {
            // 反馈给JS
            responseCallback(@{@"blogName": @"军哥的技术博客"});
        }
    }];
    
    [self.bridge callHandler:@"getUserInfos" data:@{@"职称": @"软件开发"} responseCallback:^(id responseData) {
        JGLog(@"from js: %@", responseData);
    }];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    JGLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    JGLog(@"webViewDidFinishLoad");
}

- (void)renderButtons:(UIWebView*)webView {
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    callbackButton.clipsToBounds = YES;
    callbackButton.layer.cornerRadius = 17.5;
    callbackButton.layer.borderWidth = 1.0;
    callbackButton.layer.borderColor = [UIColor redColor].CGColor;
    callbackButton.frame = CGRectMake(10, 600, 100, 35);
    callbackButton.titleLabel.font = font;
    [callbackButton setTitle:@"Add" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(onOpenBlogArticle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:callbackButton aboveSubview:webView];

    
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    reloadButton.clipsToBounds = YES;
    reloadButton.layer.cornerRadius = 17.5;
    reloadButton.layer.borderWidth = 1.0;
    reloadButton.layer.borderColor = [UIColor redColor].CGColor;
    reloadButton.frame = CGRectMake(140, 600, 100, 35);
    reloadButton.titleLabel.font = font;
    [reloadButton setTitle:@"Reload" forState:UIControlStateNormal];
    [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:reloadButton aboveSubview:webView];

}

- (void)onOpenBlogArticle:(id)sender {
    // 调用打开本demo的博文
    [self.bridge callHandler:@"openWebviewBridgeArticle" data:nil];
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
