//
//  ViewController.m
//  NSLogRedirect
//
//  Created by Silence on 2018/12/25.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "ViewController.h"
#import "SILogViewController.h"

@interface ViewController (){
    NSTimer *_timer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"查看Log" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gotoLogPage) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    btn.center = self.view.center;
    [self.view addSubview:btn];
    
    [[SILogFileManager shareInstance] start];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"Hello,World -- %ld",random());
    }];
}

- (void)gotoLogPage {
    [self.navigationController pushViewController:[SILogViewController new] animated:YES];
}


@end
