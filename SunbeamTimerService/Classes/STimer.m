//
//  STimer.m
//  Pods
//
//  Created by sunbeam on 16/7/31.
//
//

#import "STimer.h"

@implementation STimer

-(NSString *)description
{
    return [NSString stringWithFormat:@"STimer[%@][%@][%@][%f][%@][%@]", self.identifier, self.name, self.desc, self.timer.timeInterval, self.timer.userInfo, self.timer];
}

@end
