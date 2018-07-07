//
//  StartupSerialTasks.m
//  SerialTask
//
//  Created by cs on 2018/7/7.
//  Copyright © 2018年 cs. All rights reserved.
//

#import "StartupSerialTasks.h"
#import <Bolts/BFTaskCompletionSource.h>
#import "BFTask+Private.h"

static bool isAppStarted = NO;

@implementation StartupSerialTasks {
    BFTask *_chainStartupTask;
    BFTask *_chainStartedTask;
}

+ (StartupSerialTasks *)instance {
    static StartupSerialTasks *_instance = nil;
    
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _chainStartupTask = [BFTask taskWithResult:@"_chainStartupTask"];
        _chainStartedTask = [BFTask taskWithResult:@"_chainStartedTask"];
        
        // 这里增加一个不断判断是否启动完成的处理处理完再执行
        _chainStartedTask = [_chainStartedTask continueAsyncWithBlock:^id(BFTask<id> *t) {
            BFTaskCompletionSource *asyncRes = [BFTaskCompletionSource taskCompletionSource];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                while (isAppStarted) {
                    sleep(1);
                }
                [asyncRes trySetResult:@YES];
            });
            return asyncRes.task;
        }];
    }
    return self;
}

// 保证启动时不会各种异步的处理一并的出现
- (void)addStartupTask:(NSString *)key withBlock:(void (^)(BFTaskCompletionSource *promise))block {
    _chainStartupTask = [_chainStartupTask continueAsyncWithBlock:^id(BFTask<id> *t) {
        BFTaskCompletionSource *asyncRes = [BFTaskCompletionSource taskCompletionSource];
        // 如果调用的是在主线程,这里则回调回主线程调用.
        dispatch_async([NSThread isMainThread] ? dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0) : dispatch_get_main_queue(), ^{
            block(asyncRes);
        });
        return asyncRes.task;
    }];
}

// 保证启动后不会各种异步的处理一并的出现
- (void)addStartedTask:(NSString *)key withBlock:(void (^)(BFTaskCompletionSource *promise))block {
    _chainStartedTask = [_chainStartedTask continueAsyncWithBlock:^id(BFTask<id> *t) {
        BFTaskCompletionSource *asyncRes = [BFTaskCompletionSource taskCompletionSource];
        block(asyncRes);
        return asyncRes.task;
    }];
}

- (void)addStartedTaskDeepLink:(NSURL *)url {
    [self addStartedTask:@"coldDeepLink" withBlock:^(BFTaskCompletionSource *promise) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 开始执行deepLink 任务
            [promise trySetResult:@YES];
        });
    }];
}

@end
