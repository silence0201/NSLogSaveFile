//
//  SIFileMonitor.m
//  NSLogRedirect
//
//  Created by Silence on 2018/12/25.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "SIFileMonitor.h"

@interface SIFileMonitor () {
    dispatch_source_t _source;
    int _fileDescriptor;
}

@property (nonatomic,strong) NSURL *fileURL;
@property (nonatomic,copy) ChangeAction action;

@end

@implementation SIFileMonitor

+ (instancetype)fileMonitorForFile:(NSString *)filePath changeAction:(ChangeAction)action {
    SIFileMonitor *monitor = [[[self class]alloc]init];
    monitor.fileURL = [NSURL URLWithString:filePath];
    monitor.action = action;
    return monitor;
}

+ (instancetype)monitorForFile:(NSString *)filePath changeAction:(ChangeAction)action {
    SIFileMonitor *monitor = [[[self class]alloc]init];
    monitor.fileURL = [NSURL URLWithString:filePath];
    monitor.action = action;
    [monitor startMonitor];
    return monitor;
}

- (void)startMonitor {
    _fileDescriptor = open([[_fileURL path] fileSystemRepresentation],
                           O_EVTONLY);
    dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,
                                     _fileDescriptor,
                                     DISPATCH_VNODE_ATTRIB | DISPATCH_VNODE_DELETE | DISPATCH_VNODE_EXTEND | DISPATCH_VNODE_LINK | DISPATCH_VNODE_RENAME | DISPATCH_VNODE_REVOKE | DISPATCH_VNODE_WRITE,
                                     defaultQueue);
    __weak SIFileMonitor *weakSelf = self;
    dispatch_source_set_event_handler(_source, ^{
        __strong SIFileMonitor *strongSelf = weakSelf;
        unsigned long eventTypes = dispatch_source_get_data(strongSelf->_source);
        [strongSelf handleEvents:eventTypes];
    });
}

- (void)stopMonitor {
    close(_fileDescriptor);
    dispatch_source_cancel(_source);
    _fileDescriptor = 0;
    _source = nil;
}

- (void)handleEvents:(unsigned long)eventTypes {
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL closeDispatchSource = NO;
        NSMutableSet *eventSet = [[NSMutableSet alloc] initWithCapacity:7];
        
        if (eventTypes & FileATTRIB) {
            [eventSet addObject:@(FileATTRIB)];
        }
        
        if (eventTypes & FileDELETE) {
            [eventSet addObject:@(FileDELETE)];
            closeDispatchSource = YES;
        }
        
        if (eventTypes & FileEXTEND) {
            [eventSet addObject:@(FileEXTEND)];
        }
        
        if (eventTypes & FileLINK) {
            [eventSet addObject:@(FileLINK)];
        }
        
        if (eventTypes & FileRENAME) {
            [eventSet addObject:@(FileRENAME)];
            closeDispatchSource = YES;
        }
        
        if (eventTypes & FileREVOKE) {
            [eventSet addObject:@(FileREVOKE)];
        }
        
        if (eventTypes & FileWRITE) {
            [eventSet addObject:@(FileWRITE)];
        }
        
        for (NSNumber *eventType in eventSet) {
            if (self.action) {
                self.action([eventType unsignedIntegerValue]);
            }
        }
        
        if (closeDispatchSource) {
            [self stopMonitor];
        }
    });
}

- (void)dealloc {
    [self stopMonitor];
}

@end
