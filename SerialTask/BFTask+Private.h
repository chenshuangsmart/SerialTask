/**
 * Copyright (c) 2015-present, Parse, LLC.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Foundation/Foundation.h>
#import <Bolts/BFExecutor.h>
#import <Bolts/BFTask.h>


@interface BFExecutor (Background)

+ (instancetype)defaultPriorityBackgroundExecutor;

@end

@interface BFTask (Private)

- (BFTask *)continueAsyncWithBlock:(BFContinuationBlock)block;
- (BFTask *)continueAsyncWithSuccessBlock:(BFContinuationBlock)block;

- (BFTask *)continueImmediatelyWithBlock:(BFContinuationBlock)block;
- (BFTask *)continueImmediatelyWithSuccessBlock:(BFContinuationBlock)block;

- (BFTask *)continueWithResult:(id)result;
- (BFTask *)continueWithSuccessResult:(id)result;

/**
 Same as `waitForResult:error withMainThreadWarning:YES`
 */
- (id)waitForResult:(NSError **)error;

/**
 Waits until this operation is completed, then returns its value.
 This method is inefficient and consumes a thread resource while its running.

 @param error          If an error occurs, upon return contains an `NSError` object that describes the problem.
 @param warningEnabled `BOOL` value that

 @return Returns a `self.result` if task completed. `nil` - if cancelled.
 */
- (id)waitForResult:(NSError **)error withMainThreadWarning:(BOOL)warningEnabled;

@end

extern void forceLoadCategory_BFTask_Private();
