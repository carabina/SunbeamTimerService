//
//  STimer.h
//  Pods
//
//  Created by sunbeam on 16/7/31.
//
//

#import <Foundation/Foundation.h>

@interface STimer : NSObject

// 唯一标识
@property (nonatomic, copy) NSString* identifier;

// 名称
@property (nonatomic, copy) NSString* name;

// 描述
@property (nonatomic, copy) NSString* desc;

// 是否循环执行
@property (nonatomic, assign) BOOL repeats;

// NSTimer
@property (nonatomic, strong) NSTimer* timer;

@end
