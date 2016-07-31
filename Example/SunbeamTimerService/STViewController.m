//
//  STViewController.m
//  SunbeamTimerService
//
//  Created by sunbeamChen on 07/31/2016.
//  Copyright (c) 2016 sunbeamChen. All rights reserved.
//

#import "STViewController.h"

#import <SunbeamTimerService/SunbeamTimerService.h>

@interface STViewController () <SunbeamTimerExecuteDelegate>

@end

@implementation STViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [SunbeamTimerManager sharedSunbeamTimerManager].delegate = self;
    
    [[SunbeamTimerManager sharedSunbeamTimerManager] addSTimer:@"5_STimer" name:@"5_STimer" desc:@"timer execute in 5s" timeInterval:5.0 userInfo:@{@"timeSeconds":@"5.0"} repeats:NO];
    
    [[SunbeamTimerManager sharedSunbeamTimerManager] addSTimer:@"10_STimer" name:@"10_STimer" desc:@"timer execute in 10s" timeInterval:10.0 userInfo:@{@"timeSeconds":@"10.0"} repeats:NO];
    
    [[SunbeamTimerManager sharedSunbeamTimerManager] addSTimer:@"20_STimer" name:@"20_STimer" desc:@"timer execute in 20s" timeInterval:20.0 userInfo:@{@"timeSeconds":@"20.0"} repeats:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// STimer执行回调
- (void) SunbeamTimerExecute:(NSString *) identifier userInfo:(NSDictionary *) userInfo
{
    NSLog(@"stimer [%@] 执行，userInfo为[%@]", identifier, userInfo);
    
    if ([@"5_STimer" isEqualToString:identifier]) {
        //[[SunbeamTimerManager sharedSunbeamTimerManager] destroySTimer:@"10_STimer"];
        [[SunbeamTimerManager sharedSunbeamTimerManager] clearAllSTimer];
    }
}

// STimer添加回调
- (void) SunbeamTimerAdded:(NSString *) identifier
{
    NSLog(@"stimer [%@] 添加", identifier);
}

// STimer销毁回调
- (void) SunbeamTimerDestroy:(NSString *) identifier
{
    NSLog(@"stimer [%@] 销毁", identifier);
}

// STimer清理回调
- (void) SunbeamTimerClear:(NSMutableDictionary *) clearSTimerList
{
    NSLog(@"stimer [%@] 清理", clearSTimerList);
}

@end
