//
//  SILogFileManager.m
//  NSLogRedirect
//
//  Created by Silence on 2018/12/25.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "SILogFileManager.h"


#ifndef LogFileName
#define LogFileName @"SILog.log"
#endif

@interface SILogFileManager ()

@property (copy, nonatomic) NSString *filePath;
@property (strong, nonatomic)  SIFileMonitor *monitor;

@end

@implementation SILogFileManager

+ (instancetype)shareInstance {
    static SILogFileManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SILogFileManager alloc]init];
    });
    return manager;
}

- (void)start {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    self.filePath = [cachePath stringByAppendingPathComponent:LogFileName];
    // 改写NSLog的输出
    freopen([self.filePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([self.filePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

- (NSString *)readLog {
    NSString *content = [NSString stringWithContentsOfFile:self.filePath encoding:NSUTF8StringEncoding error:nil];
    return content;
}

- (void)clearLog {
    [@"" writeToFile:self.filePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

- (void)monitorLog:(ChangeAction)changeAction {
    self.monitor = [SIFileMonitor monitorForFile:self.filePath changeAction:^(FileChangeType type) {
        if (changeAction) {
            changeAction(type);
        }
    }];
}

- (void)stopMonitorLog {
    self.monitor = nil;
}




@end
