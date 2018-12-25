//
//  SIFileMonitor.h
//  NSLogRedirect
//
//  Created by Silence on 2018/12/25.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FileChangeType) {
    FileDELETE = DISPATCH_VNODE_DELETE,
    FileWRITE = DISPATCH_VNODE_WRITE,
    FileEXTEND = DISPATCH_VNODE_EXTEND,
    FileATTRIB = DISPATCH_VNODE_ATTRIB,
    FileLINK = DISPATCH_VNODE_LINK,
    FileRENAME = DISPATCH_VNODE_RENAME,
    FileREVOKE = DISPATCH_VNODE_REVOKE,
    FileFUNLOCK = DISPATCH_VNODE_FUNLOCK,
};

NS_ASSUME_NONNULL_BEGIN

typedef void(^ChangeAction)(FileChangeType type) ;

/// 文件监听
@interface SIFileMonitor : NSObject

/// 创建文件监听者对象
+ (instancetype)fileMonitorForFile:(NSString *)filePath
                      changeAction:(ChangeAction)action;

/// 创建文件监听者对象并开始监听
+ (instancetype)monitorForFile:(NSString *)filePath
                  changeAction:(ChangeAction)action;

- (void)startMonitor;
- (void)stopMonitor;

@end

NS_ASSUME_NONNULL_END
