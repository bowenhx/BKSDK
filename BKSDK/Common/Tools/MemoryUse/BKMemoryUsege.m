/**
 -  MemoryUsege.m
 -  BKMobile
 -  Created by HY on 16/12/20.
 -  Copyright © 2016年 com.mobile-kingdom.bkapps. All rights reserved.
 */

#import "BKMemoryUsege.h"
//获取当前设备可用内存的头文件
#import <sys/sysctl.h>
#import <mach/mach.h>
#import "BKDefineFile.h"

@implementation BKMemoryUsege

+ (BKMemoryUsege *)share {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)showMemoryView:(BOOL)isShow {
    
#ifdef  DEBUG
    if (isShow) {
        _lab = [[UILabel alloc] init];
        _lab.textColor = [UIColor blueColor];
        _lab.frame = CGRectMake(0, 15, SCREEN_WIDTH, 18);
        [_lab setFont:[UIFont systemFontOfSize:12]];
        [_lab setTextAlignment:NSTextAlignmentCenter];
        
        UIWindow *window =  [[UIApplication sharedApplication] keyWindow];
        [window addSubview:_lab];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFunction) userInfo:nil repeats:YES];
    }
#endif

}

//定时器
- (void)timerFunction {
    float memory = [self getMemoryUsage];
    float cpu = [self getCpuUsage];
    NSString *memoryStr = [NSString stringWithFormat:@"%.2f",memory];
    NSString *cpuStr = [NSString stringWithFormat:@"%.2f%%",cpu*100];
//    NSLog(@"---我是内存使用情况啊--- memory ：%@ mb    cpu：%@   ",memoryStr,cpuStr);
    _lab.text = [NSString stringWithFormat:@"  memory：%@M     cpu:%@",memoryStr,cpuStr];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:_lab];
}

//获取当前任务所占用的内存（单位：MB）
- (float)getMemoryUsage {
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount =TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    if(kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    float memory = taskInfo.resident_size / 1024.0 / 1024.0;
    return memory;
}

//获取当前任务所使用的cpu（百分比）
- (float)getCpuUsage {
    kern_return_t			kr = { 0 };
    task_info_data_t		tinfo = { 0 };
    mach_msg_type_number_t	task_info_count = TASK_INFO_MAX;
    
    kr = task_info( mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count );
    if ( KERN_SUCCESS != kr )
        return 0.0f;
    
    task_basic_info_t		basic_info = { 0 };
    thread_array_t			thread_list = { 0 };
    mach_msg_type_number_t	thread_count = { 0 };
    
    thread_info_data_t		thinfo = { 0 };
    thread_basic_info_t		basic_info_th = { 0 };
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads( mach_task_self(), &thread_list, &thread_count );
    if ( KERN_SUCCESS != kr )
        return 0.0f;
    
    long	tot_sec = 0;
    long	tot_usec = 0;
    float	tot_cpu = 0;
    
    for ( int i = 0; i < thread_count; i++ ) {
        mach_msg_type_number_t thread_info_count = THREAD_INFO_MAX;
        
        kr = thread_info( thread_list[i], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count );
        if ( KERN_SUCCESS != kr ) {
            return 0.0f;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        if ( 0 == (basic_info_th->flags & TH_FLAGS_IDLE) ) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
        }
    }
    
    kr = vm_deallocate( mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t) );
    if ( KERN_SUCCESS != kr ){
        return 0.0f;
    }
    return tot_cpu;
}


@end
