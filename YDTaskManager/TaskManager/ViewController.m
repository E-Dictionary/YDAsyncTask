//
//  ViewController.m
//  TaskManager
//
//  Created by Cloud_胡 on 16/2/24.
//  Copyright © 2016年 Cloud_HLH. All rights reserved.
//

#import "ViewController.h"
#import "YDTaskObject.h"
#import "HoonyTaskManager/YDTaskManager.h"

@interface ViewController ()<HoonyTaskDelegate,HoonyTaskDataSource>
{
    NSTimer * timer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    HoonyTaskObject * indexObject = [[HoonyTaskObject alloc] initWithTaskFlagString:@"sss"];
    indexObject.dataSource = self;
    [indexObject addDelegate:self];
    [indexObject executeThisTaskWithparameters:@"sdsd"];
    
    HoonyTaskObject * indexObject1 = [HoonyTaskObject new];
    indexObject1.dataSource = self;
    [indexObject1 addDelegate:self];
    [indexObject1 executeThisTaskWithparameters:@"sdsd"];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refresh:) userInfo:@{@"sdsd":indexObject} repeats:YES];
    
//    timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(refresh:) userInfo: repeats:YES];
//    [timer fire];
}

- (void)refresh:(NSTimer * )sender
{
    NSDictionary * indexDic = sender.userInfo;
    HoonyTaskObject * indexObject = indexDic[@"sdsd"];
    static CGFloat progress = 0.1;
    if (progress < 1) {
        progress += 0.1;
    }
    [indexObject refreshTheProgress:progress withUserInfo:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)taskInBackground:(id)parameters
{
    
    [NSThread sleepForTimeInterval:3.0];
    
    NSError * ii = [NSError errorWithDomain:@"这是一个错误" code:19 userInfo:@{@"ac":@"ss",@"ct":@"sdsd"}];
    
    
    return ii;
}

#pragma mark - HoonyTaskDelegate

/**
 *  任务开始
 */
- (void)prepareTaskWithTask:(id)sender
{
}

- (void)progressOfTask:(CGFloat)progress withUserInfo:(id)userInfo withTask:(id)sender
{
    NSLog(@"--%f",progress);
}

/**
 *  任务结果回调
 *
 *  @param result 结果
 */
- (void)resultOfTask:(id)result withTask:(id)sender
{
    if ([[result class] isSubclassOfClass:[NSError class]]) {
//        [sender reStart];
    }
}

/**
 *  任务被取消回调
 *
 *  @param parameters 任务取消时所拥有的参数
 */
- (void)cancelOfTask:(id)parameters withTask:(id)sender
{
}


@end
