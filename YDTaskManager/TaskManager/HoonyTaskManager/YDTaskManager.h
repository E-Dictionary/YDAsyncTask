//
//  HoonyTaskManager.h
//  TaskManager
//
//  Created by Cloud_胡 on 16/2/24.
//  Copyright © 2016年 Cloud_HLH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HoonyTaskObject;
@protocol HoonyTaskDelegate;

@interface HoonyTaskManager : NSObject

/**
 *  获取单例对象
 *
 *  @return 返回一个单例对象
 */
+ (instancetype)manager;

/**
 *  将任务添加到管理中
 *
 *  @param indexTask 当前管理
 */
- (void)managerThisTask:(HoonyTaskObject *)indexTask;

/**
 *  判断标示符的任务是否存在（任务存在的话一定存在，但是不一定是想要的）
 *
 *  @param flagString 唯一标示符 当出现标示符出现重复时 可能出现重复
 *
 *  @return 返回判断结果
 */
- (BOOL)taskIsExistWithFlagString:(NSString *)flagString;

/**
 *  判断随机码的任务是否存在（任务存在的话一定存在，且一定唯一）
 *
 *  @param serialFlagInt 自增的随机码
 *
 *  @return 返回判断结果
 */
- (BOOL)taskIsExistWithSerialFlagInt:(NSInteger)serialFlagInt;

/**
 *  返回相同标示码的任务
 *
 *  @param flagString 任务标示吗
 *
 *  @return 对应任务的数组
 */
- (NSArray *)taskByFlagString:(NSString *)flagString;

/**
 *  使用随机码获取到当前随机码所代表的 任务
 *
 *  @param serialFlagInt 任务的随机码
 *
 *  @return 返回对应的任务
 */
- (HoonyTaskObject *)taskBySerialFlagInt:(NSInteger)serialFlagInt;

@end
