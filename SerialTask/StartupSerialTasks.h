//
//  StartupSerialTasks.h
//  SerialTask
//
//  Created by cs on 2018/7/7.
//  Copyright © 2018年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts/BFTask.h>
#import <Bolts/BFTaskCompletionSource.h>

@interface StartupSerialTasks : NSObject

+ (StartupSerialTasks *)instance;

// 添加启动时任务
- (void)addStartupTask:(NSString *)key withBlock:(void (^)(BFTaskCompletionSource *promise))block;

// 添加启动完毕后要做的事情
- (void)addStartedTask:(NSString *)key withBlock:(void (^)(BFTaskCompletionSource *promise))block;

// 添加 deepLink 执行
- (void)addStartedTaskDeepLink:(NSURL *)url;

@end
