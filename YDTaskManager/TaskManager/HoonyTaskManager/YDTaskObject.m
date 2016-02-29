//
//  HoonyTaskObject.m
//  TaskManager
//
//  Created by Cloud_胡 on 16/2/24.
//  Copyright © 2016年 Cloud_HLH. All rights reserved.
//

#import "YDTaskObject.h"
#import "YDTaskManager.h"

#import <objc/message.h>

typedef enum : NSUInteger
{
    HoonyTaskObjectTypePrepare,
    HoonyTaskObjectTypeExecute,
    HoonyTaskObjectTypePost,
    HoonyTaskObjectTypeCancel,
} HoonyTaskObjectStatus;



@interface HoonyTaskObject ()
{
    HoonyTaskObjectStatus _currentStatus;
    NSInteger _serialFlagInt;
}

@property (nonatomic , copy)HoonyTaskProgressBlock   progressBuildBlock;

@property (atomic , assign)HoonyTaskObjectStatus     currentStatus;

@property (nonatomic , copy) id currentParameters;

@property (nonatomic , strong) NSPointerArray * delegates;

@end

@implementation HoonyTaskObject

#pragma mark - 生命周期

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.flagString = __TASK_DEFAULT_TYPE__;
    }
    return self;
}

- (instancetype)initWithTaskFlagString:(NSString *)typeString
{
    self = [super init];
    if (self)
    {
        self.flagString = typeString;
    }
    return self;
}

- (void)refreshTheProgress:(CGFloat)progress withUserInfo:(id)userInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id indexDelegate in self.delegates) {
            if ([indexDelegate respondsToSelector:@selector(progressOfTask:withUserInfo:withTask:)]) {
                [indexDelegate progressOfTask:progress withUserInfo:userInfo withTask:self];
            }
        }
    });
}

#pragma mark - 初始化控件 参数 属性

- (void)setProgressBuildBlock:(HoonyTaskProgressBlock)block
{
    if (_progressBuildBlock) {
        _progressBuildBlock = nil;
    }
    _progressBuildBlock = block;
}

- (NSPointerArray *)delegates
{
    if (!_delegates) {
        _delegates = [NSPointerArray weakObjectsPointerArray];
    }
    return _delegates;
}

- (NSString *)flagString
{
    if (!_flagString) {
        _flagString = @"Default";
    }
    return _flagString;
}

- (void)setCurrentStatus:(HoonyTaskObjectStatus)currentStatus
{
    if (self.currentStatus != HoonyTaskObjectTypeCancel)
    {
        _currentStatus = currentStatus;
    }
    switch (currentStatus) {
        case HoonyTaskObjectTypeCancel:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                for (id indexDelegate in self.delegates) {
                    if ([indexDelegate respondsToSelector:@selector(cancelOfTask:withTask:)]) {
                        [indexDelegate cancelOfTask:self.currentParameters withTask:self];
                    }
                }
            });
        }
            break;
            
        default:
            break;
    }
}

- (HoonyTaskObjectStatus)currentStatus
{
    if (!_currentStatus) {
        _currentStatus = HoonyTaskObjectTypePrepare;
    }
    return _currentStatus;
}

#pragma mark -

- (void)addDelegate:(id<HoonyTaskDelegate>)delegate
{
    __block id indexDelegate = delegate;
    if ([[delegate class] isSubclassOfClass:[HoonyTaskManager class]]) {
        [self.delegates insertPointer:(__bridge void * _Nullable)(indexDelegate) atIndex:0];
    }else
    {
        [self.delegates addPointer:(__bridge void * _Nullable)(indexDelegate)];
    }
    
}

- (void)addDelegate:(id<HoonyTaskDelegate>)delegate atIndexPath:(NSInteger)indexPath
{
    __weak id indexDelegate = delegate;
    if (indexPath < self.delegates.count - 1)
    {
        if (indexPath > 0) {
            [self.delegates insertPointer:(__bridge void * _Nullable)(indexDelegate) atIndex:indexPath];
        }else
        {
            [self.delegates insertPointer:(__bridge void * _Nullable)(indexDelegate) atIndex:1];
        }
        
    }else
    {
        [self addDelegate:delegate];
    }
}

- (void)executeThisTaskWithparameters:(id)parameters
{
    
    [[HoonyTaskManager manager] managerThisTask:self];
    
    for (id indexDelegate in self.delegates) {
        if ([indexDelegate respondsToSelector:@selector(prepareTaskWithTask:)]) {
            [indexDelegate prepareTaskWithTask:self];
        }
    }
    self.currentStatus = HoonyTaskObjectTypeExecute;
    self.currentParameters = parameters;
    __block id result;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.dataSource)
        {
            result = [self.dataSource taskInBackground:parameters];
        }
        
        self.currentStatus = HoonyTaskObjectTypePost;
        
        //任务已被取消，调用cancelOfTask方法了 不再继续进行下去
        if (self.currentStatus != HoonyTaskObjectTypeCancel)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                for (id indexDelegate in self.delegates) {
                    if ([indexDelegate respondsToSelector:@selector(resultOfTask:withTask:)]) {
                        [indexDelegate resultOfTask:result withTask:self];
                    }
                }
            });
        }
    });
}

- (void)cancel
{
    self.currentStatus = HoonyTaskObjectTypeCancel;
}

- (BOOL)isCancelTask
{
    return self.currentStatus == HoonyTaskObjectTypeCancel;
}

- (instancetype)reStart
{
    HoonyTaskObject * newObject = [[self class] new];
    newObject.flagString = self.flagString;
    newObject.delegates = self.delegates;
    newObject.serialFlagInt = self.serialFlagInt;
    newObject.dataSource = self.dataSource;
    [newObject executeThisTaskWithparameters:self.currentParameters];
    return newObject;
}

- (NSInteger)serialFlagInt
{
    return _serialFlagInt;
}

- (void)setSerialFlagInt:(NSInteger)serialFlagInt
{
    _serialFlagInt = serialFlagInt;
}

@end
