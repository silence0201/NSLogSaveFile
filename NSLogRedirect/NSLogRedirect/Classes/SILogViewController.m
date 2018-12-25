//
//  SILogViewController.m
//  NSLogRedirect
//
//  Created by Silence on 2018/12/25.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "SILogViewController.h"


@interface SILogViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation SILogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"控制台";
    self.view.backgroundColor = [UIColor whiteColor];
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.editable = NO;
    [self.view addSubview:self.textView];
    
    __weak SILogViewController *weakSelf = self;
    [self updateTextView];
    [[SILogFileManager shareInstance] startMonitorLog:^(FileChangeType type) {
        [weakSelf updateTextView];
    }];
    NSLog(@"-------------Start--------------");
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"清理" style:UIBarButtonItemStyleDone target:self action:@selector(clear)];
}

- (void)updateTextView {
    self.textView.text = [[SILogFileManager shareInstance] readLog];
}

- (void)clear {
    self.textView.text = nil;
    self.textView.contentOffset = CGPointZero;
    [[SILogFileManager shareInstance] clearLog];
}


@end
