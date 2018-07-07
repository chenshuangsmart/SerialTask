//
//  ViewController.m
//  SerialTask
//
//  Created by cs on 2018/7/7.
//  Copyright © 2018年 cs. All rights reserved.
//

#import "ViewController.h"
#import "StartupSerialTasks.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self startSerialTasks];
}

// 开始异步执行多个任务
- (void)startSerialTasks {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncConcurrent---begin");
    
    // 创建队列
    dispatch_queue_t queue = dispatch_queue_create("net.banggood", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            [[StartupSerialTasks instance] addStartupTask:@"activity" withBlock:^(BFTaskCompletionSource *promise) {
                NSLog(@"活动页");
            }];
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            [[StartupSerialTasks instance] addStartedTask:@"push" withBlock:^(BFTaskCompletionSource *promise) {
                NSLog(@"推送");
            }];
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            [[StartupSerialTasks instance] addStartupTask:@"ad" withBlock:^(BFTaskCompletionSource *promise) {
                NSLog(@"广告页");
            }];
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"syncConcurrent---end");
}


@end
