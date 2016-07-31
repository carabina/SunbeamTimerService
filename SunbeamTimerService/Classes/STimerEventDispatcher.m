//
//  STimerEventDispatcher.m
//  Pods
//
//  Created by sunbeam on 16/7/31.
//
//

#import "STimerEventDispatcher.h"

@implementation STimerEventDispatcher

+ (STimerEventDispatcher *) sharedSTimerEventDispatcher {
    static STimerEventDispatcher *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)addListener:(id<STimerEventListener>)listener
{
    if (listener == nil) {
        return;
    }
    
    [self.listeners addObject:listener];
}

- (void)removeListener:(id<STimerEventListener>)listener
{
    [self.listeners removeObject:listener];
}

- (void)dispatchEvent:(STimer *)stimer eventType:(STimerEventType)eventType params:(NSMutableDictionary *)params
{
    for (id<STimerEventListener> listener in self.listeners) {
        switch (eventType) {
            case STimerEventType_Add:
            {
                if ([listener respondsToSelector:@selector(stimerAdd:params:)]) {
                    [listener stimerAdd:stimer params:params];
                }
                
                break;
            }
                
            case STimerEventType_Destroy:
            {
                if ([listener respondsToSelector:@selector(stimerDestroy:params:)]) {
                    [listener stimerDestroy:stimer params:params];
                }
                
                break;
            }
                
            case STimerEventType_Clear:
            {
                if ([listener respondsToSelector:@selector(stimerClear)]) {
                    [listener stimerClear];
                }
                
                break;
            }
                
            default:
                break;
        }
    }
}

#pragma mark - setter/getter
- (NSMutableArray *)listeners
{
    if (_listeners == nil) {
        _listeners = [[NSMutableArray alloc] init];
    }
    
    return _listeners;
}

@end
