//
//  HoonyTaskObject.h
//  TaskManager
//
//  Created by Cloud_胡 on 16/2/24.
//  Copyright © 2016年 Cloud_HLH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define __HOONY_PROGRESS_CGFLOAT__ @"HoonyTaskProgressBlockCGFloat"

typedef CGFloat (^HoonyTaskProgressBlock)();
@protocol HoonyTaskDataSource <NSObject>

@required

/**
 *  任务开始在后台运行
 *
 *  @param parameters 任务所涉及的参数
 *
 *  @return 任务所得的结果
 */
- (id)taskInBackground:(id)parameters;

@end

@protocol HoonyTaskDelegate <NSObject>

@optional

/**
 *  任务开始
 */
- (void)prepareTaskWithTask:(id)sender;

/**
 *  任务结果回调
 *
 *  @param result 结果
 */
- (void)resultOfTask:(id)result withTask:(id)sender;

/**
 *  任务被取消回调
 *
 *  @param parameters 任务取消时所拥有的参数
 */
- (void)cancelOfTask:(id)parameters withTask:(id)sender;

/**
 *  进度条回调
 *
 *  @param progress 当前进度
 *  @param sender   当前任务
 */
- (void)progressOfTask:(CGFloat)progress withUserInfo:(id)userInfo withTask:(id)sender;


@end

//这是表示没有随机码时的数值
#define __WITH_OUT_SERIAL_FLAG__ 0
#define __TASK_DEFAULT_TYPE__ @"Default"

@interface HoonyTaskObject : NSObject

@property (nonatomic , assign) NSInteger serialFlagInt;

/**
 *  这是这个任务的特征 默认是Default
 */
@property (nonatomic , strong) NSString * flagString;

@property (nonatomic , weak) id<HoonyTaskDataSource> dataSource;

/**
 *  使用任务类型创建一个任务
 *
 *  @param typeString 任务类型
 *
 *  @return 返回一个任务对象
 */
- (instancetype)initWithTaskFlagString:(NSString *)typeString;

- (void)refreshTheProgress:(CGFloat)progress withUserInfo:(id)userInfo;

/**
 *  添加一个代理回调对象 可以不唯一
 *
 *  @param delegate 实现了HoonyTaskDelegate的类
 */
- (void)addDelegate:(id<HoonyTaskDelegate>)delegate;

/**
 *  开始这个任务
 *
 *  @param parameters 这个任务所需要的参数
 */
- (void)executeThisTaskWithparameters:(id)parameters;

/**
 *  添加代理回调对象
 *
 *  @param delegate  实现了HoonyTaskDelegate的类
 *  @param indexPath 插入的优先级
 */
- (void)addDelegate:(id<HoonyTaskDelegate>)delegate atIndexPath:(NSInteger)indexPath;

///**
// *  任务开始
// */
//- (void)prepareTask;
//
///**
// *  任务开始在后台运行
// *
// *  @param parameters 任务所涉及的参数
// *
// *  @return 任务所得的结果
// */
//- (id)taskInBackground:(id)parameters;
//
///**
// *  任务结果回调
// *
// *  @param result 结果
// */
//- (void)resultOfTask:(id)result;
//
///**
// *  任务被取消回调
// *
// *  @param parameters 任务取消时所拥有的参数
// */
//- (void)cancelOfTask:(id)parameters;

/**
 *  取消任务
 */
- (void)cancel;

/**
 *  判断当前任务是否已经取消
 *
 *  @return 已经取消是True 没有取消False
 */
- (BOOL)isCancelTask;

/**
 *  重新开始
 *
 *  @return 返回一个全新的任务
 */
- (instancetype)reStart;

@end
