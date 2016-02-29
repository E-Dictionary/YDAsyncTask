//
//  HoonyTaskManager.m
//  TaskManager
//
//  Created by Cloud_胡 on 16/2/24.
//  Copyright © 2016年 Cloud_HLH. All rights reserved.
//

#import "YDTaskManager.h"
#import "YDTaskObject.h"

@interface HoonyTaskManager ()<HoonyTaskDelegate>

@property (nonatomic , strong)NSMutableDictionary * runTaskDictionary;

@property (nonatomic , strong)NSMutableDictionary * runTaskFlagDictionary;

@end

@implementation HoonyTaskManager

#pragma mark - 初始化控件 参数 属性

- (NSMutableDictionary *)runTaskDictionary
{
    if (!_runTaskDictionary) {
        _runTaskDictionary = [NSMutableDictionary dictionary];
    }
    return _runTaskDictionary;
}

- (NSMutableDictionary *)runTaskFlagDictionary
{
    if (!_runTaskFlagDictionary) {
        _runTaskFlagDictionary = [NSMutableDictionary dictionary];
    }
    return _runTaskFlagDictionary;
}

#pragma mark -

+ (instancetype)manager
{
    static id indexManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        indexManager = [self new];
    });
    return indexManager;
}

- (void)managerThisTask:(HoonyTaskObject *)indexTask
{
    if (indexTask && ![indexTask isCancelTask])
    {
        if (indexTask.serialFlagInt == __WITH_OUT_SERIAL_FLAG__)
        {
            static NSInteger indexFlagInt = 0;
            indexTask.serialFlagInt = ++indexFlagInt;
            [indexTask addDelegate:self];
        }
        [self.runTaskDictionary setObject:indexTask forKey:[NSNumber numberWithInteger:indexTask.serialFlagInt]];
        [self.runTaskFlagDictionary setObject:indexTask forKey:indexTask.flagString];
    }
}

#pragma mark - HoonyTaskDelegate

/**
 *  任务开始
 */
- (void)prepareTaskWithTask:(id)sender
{
}

/**
 *  任务结果回调
 *
 *  @param result 结果
 */
- (void)resultOfTask:(id)result withTask:(id)sender
{
    [self taskFinish:sender];
}

/**
 *  任务被取消回调
 *
 *  @param parameters 任务取消时所拥有的参数
 */
- (void)cancelOfTask:(id)parameters withTask:(id)sender
{
    [self taskFinish:sender];
}

- (void)taskFinish:(HoonyTaskObject *)indexTask
{
    [self.runTaskDictionary removeObjectForKey:[NSNumber numberWithInteger:indexTask.serialFlagInt]];
    [self.runTaskFlagDictionary removeObjectForKey:indexTask.flagString];
}

#pragma mark - 开放API
- (BOOL)taskIsExistWithFlagString:(NSString *)flagString
{
    if ([self taskByFlagString:flagString])
    {
        return YES;
    }
    return NO;
}

- (BOOL)taskIsExistWithSerialFlagInt:(NSInteger)serialFlagInt
{
    if ([self taskBySerialFlagInt:serialFlagInt])
    {
        return YES;
    }
    return NO;
}

- (NSArray *)taskByFlagString:(NSString *)flagString
{
    NSLog(@"--%@",self.runTaskFlagDictionary);
    if ([self.runTaskFlagDictionary allKeys].count < [self.runTaskDictionary allKeys].count)
    {
        NSMutableArray * indexMutableArray = [NSMutableArray array];
        for (HoonyTaskObject * indexObject in [self.runTaskDictionary allValues])
        {
            if ([indexObject.flagString isEqualToString:flagString])
            {
                [indexMutableArray addObject:indexObject];
            }
        }
        return indexMutableArray;
    }else
    {
        HoonyTaskObject * indexObject = [self.runTaskFlagDictionary objectForKey:flagString];
        if (indexObject) {
            return @[indexObject];
        }else
        {
            return nil;
        }
        
    }
}

- (HoonyTaskObject *)taskBySerialFlagInt:(NSInteger)serialFlagInt
{
    return [self.runTaskDictionary objectForKey:[NSNumber numberWithInteger:serialFlagInt]];
}

@end
