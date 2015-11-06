//
//  ViewController.m
//  05-DemoLog
//
//  Created by qingyun on 15/7/21.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"
#import "common.h"
#import "NSString+Additions.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    YMLog(@"hello world!");
    
    NSString *mobileNum = @"1573722222";
    
    if ([mobileNum isValidMobilePhoneNumber]) {
        NSLog(@"是合法的手机号");
    } else {
        NSLog(@"不是合法的手机号");
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
