//
//  STimerEventDispatcher.h
//  Pods
//
//  Created by sunbeam on 16/7/31.
//
//

#import <Foundation/Foundation.h>

#import "STimer.h"

typedef NS_ENUM(NSInteger, STimerEventType) {
    STimerEventType_Add = 0,
    STimerEventType_Destroy = 1,
    STimerEventType_Clear = 2,
};

@protocol STimerEventListener <NSObject>

@optional
// stimer初始化
- (void) stimerAdd:(STimer *) stimer params:(NSMutableDictionary *) params;

// stimer销毁
- (void) stimerDestroy:(STimer *) stimer params:(NSMutableDictionary *) params;

// stimer清理
- (void) stimerClear;

@end

@interface STimerEventDispatcher : NSObject

+ (STimerEventDispatcher *) sharedSTimerEventDispatcher;

// 监听者
@property (nonatomic, strong) NSMutableArray* listeners;

- (void) addListener:(id<STimerEventListener>) listener;

- (void) removeListener:(id<STimerEventListener>) listener;

- (void) dispatchEvent:(STimer *) stimer eventType:(STimerEventType) eventType params:(NSMutableDictionary *) params;

@end
