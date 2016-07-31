//
//  SunbeamTimerManager.m
//  Pods
//
//  Created by sunbeam on 16/7/31.
//
//

#import "SunbeamTimerManager.h"

#import "STimerEventDispatcher.h"

#define SUNBEAM_TIMER_SERVICE_VERSION @"0.1.2"

#define NSTIMER_USERINFO_IDENTIFIER_KEY @"userInfo_identifier"

#define NSTIMER_USERINFO_SELF_KEY @"userInfo_self"

@interface SunbeamTimerManager() <STimerEventListener>

// STimer list {"STimer identifier":"STimer"}
@property (nonatomic, strong, readwrite) NSMutableDictionary* stimerList;

@property (nonatomic, copy) NSString* addSTimerToken;

@property (nonatomic, copy) NSString* destroySTimerToken;

@property (nonatomic, copy) NSString* clearSTimerToken;

@property (nonatomic, copy) NSString* executeSTimerToken;

@end

@implementation SunbeamTimerManager

+ (SunbeamTimerManager *) sharedSunbeamTimerManager {
    static SunbeamTimerManager *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self initEventListener];
        [self initSTimerToken];
    }
    
    return self;
}

// 初始化STimer执行时Token
- (void) initSTimerToken
{
    self.addSTimerToken = @"add STimer token";
    self.destroySTimerToken = @"destroy STimer token";
    self.clearSTimerToken = @"clear STimer token";
    self.executeSTimerToken = @"execute STimer token";
    NSLog(@"Sunbeam Timer Service %@", SUNBEAM_TIMER_SERVICE_VERSION);
}

//初始化EventListener
- (void) initEventListener
{
    [[STimerEventDispatcher sharedSTimerEventDispatcher] addListener:self];
}

- (void)dealloc
{
    [[STimerEventDispatcher sharedSTimerEventDispatcher] removeListener:self];
}

// 添加STimer
- (void) addSTimer:(NSString *) identifier name:(NSString *) name desc:(NSString *) desc timeInterval:(NSTimeInterval) timeInterval userInfo:(NSDictionary *) userInfo repeats:(BOOL) repeats
{
    // 添加之前先销毁
    [self destroySTimer:identifier];
    
    STimer* stimer = [[STimer alloc] init];
    stimer.identifier = identifier;
    stimer.name = name;
    stimer.desc = desc;
    stimer.repeats = repeats;
    NSMutableDictionary* userInfoDictionary = [[NSMutableDictionary alloc] init];
    [userInfoDictionary setObject:identifier forKey:NSTIMER_USERINFO_IDENTIFIER_KEY];
    if (userInfo) {
        [userInfoDictionary setObject:userInfo forKey:NSTIMER_USERINFO_SELF_KEY];
    }
    stimer.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(stimerExecuteSelector:) userInfo:userInfoDictionary repeats:repeats];
    // 更新STimer cache
    [[STimerEventDispatcher sharedSTimerEventDispatcher] dispatchEvent:stimer eventType:STimerEventType_Add params:nil];
}

// 销毁STimer
- (void) destroySTimer:(NSString *) identifier
{
    if ([self checkSTimerExist:identifier]) {
        STimer* stimer = [self.stimerList objectForKey:identifier];
        [stimer.timer invalidate];
        stimer.timer = nil;
        // 更新STimer cache
        [[STimerEventDispatcher sharedSTimerEventDispatcher] dispatchEvent:stimer eventType:STimerEventType_Destroy params:nil];
    }
}

// 销毁所有STimer
- (void) clearAllSTimer
{
    // 更新STimer cache
    [[STimerEventDispatcher sharedSTimerEventDispatcher] dispatchEvent:nil eventType:STimerEventType_Clear params:nil];
}

// 检查指定identifier的STimer是否存在
- (BOOL) checkSTimerExist:(NSString *) identifier
{
    if (identifier == nil || [@"" isEqualToString:identifier]) {
        return NO;
    }
    
    STimer* stimer = [self.stimerList objectForKey:identifier];
    
    if (stimer) {
        return YES;
    }
    
    return NO;
}


#pragma mark - timer selector
// NSTimer execute selector
- (void) stimerExecuteSelector:(NSTimer *) timer
{
    @synchronized (self.executeSTimerToken) {
        NSTimer* tempTimer = timer;
        if ([self.delegate respondsToSelector:@selector(SunbeamTimerExecute:userInfo:)]) {
            NSDictionary* userInfo = tempTimer.userInfo;
            [self destroySTimer:[userInfo objectForKey:NSTIMER_USERINFO_IDENTIFIER_KEY]];
            [self.delegate SunbeamTimerExecute:[userInfo objectForKey:NSTIMER_USERINFO_IDENTIFIER_KEY] userInfo:[userInfo objectForKey:NSTIMER_USERINFO_SELF_KEY]];
        }
    }
}

#pragma mark - cache update
#pragma mark - cache update
- (void)stimerAdd:(STimer *)stimer params:(NSMutableDictionary *)params
{
    @synchronized (self.addSTimerToken) {
        [self.stimerList setObject:stimer forKey:stimer.identifier];
        NSLog(@"定时器添加：%@", stimer);
        if ([self.delegate respondsToSelector:@selector(SunbeamTimerAdded:)]) {
            [self.delegate SunbeamTimerAdded:stimer.identifier];
        }
    }
}

- (void)stimerDestroy:(STimer *)stimer params:(NSMutableDictionary *)params
{
    @synchronized (self.destroySTimerToken) {
        [self.stimerList removeObjectForKey:stimer.identifier];
        NSLog(@"定时器销毁：%@", stimer);
        if ([self.delegate respondsToSelector:@selector(SunbeamTimerDestroy:)]) {
            [self.delegate SunbeamTimerDestroy:stimer.identifier];
        }
    }
}

- (void)stimerClear
{
    @synchronized (self.clearSTimerToken) {
        NSMutableDictionary* tempSTimerList = self.stimerList;
        NSLog(@"定时器清空：%@", self.stimerList);
        for (STimer* stimer in [tempSTimerList allValues]) {
            [self destroySTimer:stimer.identifier];
        }
        if ([self.delegate respondsToSelector:@selector(SunbeamTimerClear:)]) {
            [self.delegate SunbeamTimerClear:tempSTimerList];
        }
    }
}

#pragma mark - timer cache init
- (NSMutableDictionary *)stimerList
{
    if (_stimerList == nil) {
        _stimerList = [[NSMutableDictionary alloc] init];
    }
    
    return _stimerList;
}

@end
