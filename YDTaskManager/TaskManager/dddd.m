//
//  dddd.m
//  TaskManager
//
//  Created by Cloud_胡 on 16/2/25.
//  Copyright © 2016年 Cloud_HLH. All rights reserved.
//

#import "dddd.h"
#import "YDTaskManager.h"
#import "YDTaskObject.h"

@interface dddd ()<HoonyTaskDelegate>

@property (nonatomic , strong)HoonyTaskObject * ss;

@end

@implementation dddd

- (void)dealloc
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray * indexObjects = [[HoonyTaskManager manager] taskByFlagString:@"sss"];
    HoonyTaskObject * indexObject = indexObjects[0];
    self.ss = indexObject;
    [indexObject addDelegate:self];
}

- (void)progressOfTask:(CGFloat)progress withUserInfo:(id)userInfo withTask:(id)sender
{
    NSLog(@"another--%f",progress);
}

- (void)prepareTaskWithTask:(id)sender
{
}

@end
