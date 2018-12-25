//
//  SILogFileManager.h
//  NSLogRedirect
//
//  Created by Silence on 2018/12/25.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "SIFileMonitor.h"

NS_ASSUME_NONNULL_BEGIN

@interface SILogFileManager : NSObject

+ (instancetype)shareInstance;

- (void)start;

- (NSString *)readLog;
- (void)clearLog;

- (void)startMonitorLog:(ChangeAction)changeAction;
- (void)stopMonitorLog;

@end

NS_ASSUME_NONNULL_END
