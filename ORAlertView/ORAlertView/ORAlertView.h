//
//  ORAlertView.h
//  ORAlertView
//
//  Created by 郭存 on 15-7-14.
//  Copyright (c) 2015年 lucius. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ORAlertView;

// 警告类型
typedef enum {
    ORAlertViewTypeWarningNone,
    ORAlertViewTypeWarningRed,
    ORAlertViewTypeWarningOrange,
    ORAlertViewTypeWarningYellow,
    ORAlertViewTypeWarningBlue
}ORAlertViewTypeWarning;

// 提示框类型
typedef enum {
    ORAlertViewTypeAlert,
    ORAlertViewTypeActionSheet
}ORAlertViewType;

// 数据模型
@interface ORAlertViewModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) ORAlertViewTypeWarning type;

@end

// 协议
@protocol ORAlertViewDelegate <NSObject>

@optional

- (void)alertViewDidHide:(ORAlertView *)alertView ;
- (void)alertViewDidConfirmButtonSelected:(id)sender;
- (void)alertViewDidCancelButtonSelected:(id)sender;
- (void)alertViewDidOtherButtonSelected:(id)sender;

@end

@interface ORAlertView : UIView

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) ORAlertViewTypeWarning type;
@property (nonatomic, weak) id <ORAlertViewDelegate> delegate;

+ (ORAlertView *)sharedView;

+ (void)showViewTitle:(NSString *)title
              message:(NSString *)message
             delegate:(id<ORAlertViewDelegate>)delegate;

+ (void)showViewTitle:(NSString *)title
              message:(NSString *)message
              warning:(ORAlertViewTypeWarning)warning
             delegate:(id<ORAlertViewDelegate>)delegate;

+ (void)showViewTitle:(NSString *)title
              message:(NSString *)message
              warning:(ORAlertViewTypeWarning)warning
             delegate:(id<ORAlertViewDelegate>)delegate
         buttonTitles:(NSArray *)titles;

+ (void)showViewTitle:(NSString *)title
              message:(NSString *)message
              warning:(ORAlertViewTypeWarning)warning
             delegate:(id<ORAlertViewDelegate>)delegate
                 type:(ORAlertViewType)type
         buttonTitles:(NSArray *)titles;

- (void)hide;

@end
