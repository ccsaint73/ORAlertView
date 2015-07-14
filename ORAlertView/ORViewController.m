//
//  ORViewController.m
//  ORAlertView
//
//  Created by 郭存 on 15-7-14.
//  Copyright (c) 2015年 lucius. All rights reserved.
//

#import "ORViewController.h"
#import "ORAlertView.h"

@interface ORViewController () <ORAlertViewDelegate>

@end

@implementation ORViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
  
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [ORAlertView showViewTitle:@"测试"
                       message:@"测试数据"
                       warning:ORAlertViewTypeWarningRed
                      delegate:self
                          type:ORAlertViewTypeActionSheet
                  buttonTitles:@[@"确定", @"取消", @"其他"]];
}

// 点击确定按钮
- (void)alertViewDidConfirmButtonSelected:(id)sender
{
    
}

// 点击取消按钮
- (void)alertViewDidCancelButtonSelected:(id)sender
{

}

// 点击其他按钮
- (void)alertViewDidOtherButtonSelected:(id)sender
{

}

@end
