//
//  ORAlertView.m
//  ORAlertView
//
//  Created by 郭存 on 15-7-14.
//  Copyright (c) 2015年 lucius. All rights reserved.
//

#import "ORAlertView.h"

#define HRSCREEN   [UIScreen mainScreen].bounds
#define HRMARGIN   30
#define HRPADDING  20
#define HRBTNW     40
#define HRDURATION 0.25

@interface ORAlertView()

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) UIView      *alertView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *detailLabel;
@property (nonatomic, strong) UIView      *bottomView;

@end

@implementation ORAlertView

// 初始化
- (instancetype)init
{
    if ([super init]) {
        self.bgView.backgroundColor = [UIColor blackColor];
        self.alertView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

// 单例
+ (ORAlertView *)sharedView
{
    static ORAlertView *alertView = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertView = [[self alloc] init];
    });
    
    return alertView;
}

+ (void)showViewTitle:(NSString *)title
              message:(NSString *)message
              warning:(ORAlertViewTypeWarning)warning
             delegate:(id<ORAlertViewDelegate>)delegate
         buttonTitles:(NSArray *)titles
{
    if (![ORAlertView sharedView].isShow) {
        [[ORAlertView sharedView] showViewTitle:title
                                        message:message
                                        warning:warning
                                       delegate:delegate
                                           type:ORAlertViewTypeAlert
                                   buttonTitles:titles];
    }
}

+ (void)showViewTitle:(NSString *)title
              message:(NSString *)message
              warning:(ORAlertViewTypeWarning)warning
             delegate:(id<ORAlertViewDelegate>)delegate
                 type:(ORAlertViewType)type
         buttonTitles:(NSArray *)titles
{
    [[ORAlertView sharedView] showViewTitle:title
                                    message:message
                                    warning:warning
                                   delegate:delegate
                                       type:type
                               buttonTitles:titles];
}

+ (void)showViewTitle:(NSString *)title
              message:(NSString *)message
             delegate:(id<ORAlertViewDelegate>)delegate
{
    if (![ORAlertView sharedView].isShow) {
        [[ORAlertView sharedView] showViewTitle:title
                                        message:message
                                        warning:ORAlertViewTypeWarningNone
                                       delegate:delegate
                                           type:ORAlertViewTypeAlert
                                   buttonTitles:@[@"确认"]];
    }
}

+ (void)showViewTitle:(NSString *)title
              message:(NSString *)message
              warning:(ORAlertViewTypeWarning)warning
             delegate:(id<ORAlertViewDelegate>)delegate
{
    if (![ORAlertView sharedView].isShow) {
        [[ORAlertView sharedView] showViewTitle:title
                                        message:message
                                        warning:warning
                                       delegate:delegate
                                           type:ORAlertViewTypeAlert
                                   buttonTitles:@[@"确认"]];
    }
    
}

- (void)showViewTitle:(NSString *)title
              message:(NSString *)message
              warning:(ORAlertViewTypeWarning)warning
             delegate:(id<ORAlertViewDelegate>)delegate
                 type:(ORAlertViewType)type
         buttonTitles:(NSArray *)titles
{
    self.type = warning;
    self.delegate = delegate;
    
    switch (warning) {
        case ORAlertViewTypeWarningRed:
            self.titleLabel.textColor = [UIColor redColor];
            break;
        case ORAlertViewTypeWarningOrange:
            self.titleLabel.textColor = [UIColor orangeColor];
            break;
        case ORAlertViewTypeWarningYellow:
            self.titleLabel.textColor = [UIColor yellowColor];
            break;
        case ORAlertViewTypeWarningBlue:
            self.titleLabel.textColor = [UIColor blueColor];
            break;
        default:
            self.titleLabel.textColor = [UIColor blackColor];
            break;
    }
    
    switch (type) {
        case ORAlertViewTypeAlert:
            [self layoutForAlert:titles];
            break;
        case ORAlertViewTypeActionSheet:
            [self layoutForActionSheet:titles];
            break;
        default:
            break;
    }
    
    [self updateViewWithMessage:message type:type titles:titles.count];
    [self showInView:nil animated:YES];
    
    self.titleLabel.text = title;
}

- (void)layoutForAlert:(NSArray *)titles
{
    for (UIView *view in self.bottomView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat btnW = self.alertView.frame.size.width / titles.count;
    
    for (int i = 0; i < titles.count; i ++)
    {
        NSString *str = titles[i];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnW * i, 0, btnW - 0.5, HRBTNW)];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.bottomView addSubview:btn];
        
        if (i == 0) {
            [btn addTarget:self action:@selector(confirmButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        } else if (i == 1) {
            [btn addTarget:self action:@selector(cancelButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [btn addTarget:self action:@selector(otherButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)layoutForActionSheet:(NSArray *)titles
{
    for (UIView *view in self.bottomView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat btnH = 40.5f;
    
    for (int i = 0; i < titles.count; i ++)
    {
        NSString *str = titles[i];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, btnH * i, CGRectGetWidth(self.alertView.frame), HRBTNW)];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.bottomView addSubview:btn];
        
        if (i == 0) {
            [btn addTarget:self action:@selector(confirmButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        } else if (i == 1) {
            [btn addTarget:self action:@selector(cancelButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [btn addTarget:self action:@selector(otherButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)updateViewWithMessage:(NSString *)message type:(ORAlertViewType)type titles:(NSInteger)count
{
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.detailLabel.frame), MAXFLOAT);
    CGSize msgSize = [message sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:maxSize];
    
    self.detailLabel.frame = CGRectMake(HRPADDING, CGRectGetMaxY(self.titleLabel.frame) + HRPADDING / 2, CGRectGetWidth(self.alertView.frame) - (HRPADDING * 2), msgSize.height);
    
    switch (type) {
        case ORAlertViewTypeAlert:
            self.alertView.frame = CGRectMake(HRMARGIN, (HRSCREEN.size.height - (HRPADDING * 4 + HRBTNW + msgSize.height)) / 2, HRSCREEN.size.width - (HRMARGIN * 2) - 1, HRPADDING * 4 + HRBTNW + msgSize.height);
            self.lineView.frame = CGRectMake(0, CGRectGetHeight(self.alertView.frame) - HRBTNW, CGRectGetWidth(self.alertView.frame), 0.5);
            self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.alertView.frame) - HRBTNW + 1, CGRectGetWidth(self.alertView.frame) - 1, HRBTNW);
            break;
        case ORAlertViewTypeActionSheet:
            self.alertView.frame = CGRectMake(HRMARGIN, (HRSCREEN.size.height - (HRPADDING * 4 + HRBTNW + msgSize.height)) / 2, HRSCREEN.size.width - (HRMARGIN * 2) - 1, HRPADDING * 4 + msgSize.height + (HRBTNW * count));
            self.lineView.frame = CGRectMake(0, CGRectGetHeight(self.alertView.frame) - (HRBTNW * count), CGRectGetWidth(self.alertView.frame), 0.5);
            self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.alertView.frame) - (HRBTNW * count) - 1, CGRectGetWidth(self.alertView.frame), HRBTNW * count);
        default:
            break;
    }
    
    
    self.detailLabel.text = message;
}

- (void)showInView:(UIView *)view animated:(BOOL)animated
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    
    self.frame = view.bounds;
    self.userInteractionEnabled = YES;
    self.isShow = YES;
    
    [view addSubview:self];
    
    if (animated) {
        [UIView animateWithDuration:HRDURATION animations:^{
            self.bgView.alpha = 0.3;
            self.alertView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)hide
{
    [UIView animateWithDuration:HRDURATION animations:^{
        self.bgView.alpha = 0;
        self.alertView.alpha = 0;
    } completion:^(BOOL finished) {
        self.isShow = NO;
        [self removeFromSuperview];
        
        if ([_delegate respondsToSelector:@selector(alertViewDidHide:)]) {
            [_delegate alertViewDidHide:self];
        }
        
    }];
}

- (void)confirmButtonOnClick:(id)sender
{
    [self hide];
    
    if ([_delegate respondsToSelector:@selector(alertViewDidConfirmButtonSelected:)]) {
        [_delegate alertViewDidConfirmButtonSelected:sender];
    }
}

- (void)cancelButtonOnClick:(id)sender
{
    [self hide];
    
    if ([_delegate respondsToSelector:@selector(alertViewDidCancelButtonSelected:)]) {
        [_delegate alertViewDidCancelButtonSelected:sender];
    }
}

- (void)otherButtonOnClick:(id)sender
{
    [self hide];
    
    if ([_delegate respondsToSelector:@selector(alertViewDidOtherButtonSelected:)]) {
        [_delegate alertViewDidOtherButtonSelected:sender];
    }
}

#pragma mark -- 懒加载 --
- (UIImageView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIImageView alloc] initWithFrame:HRSCREEN];
        _bgView.alpha = 0;
        _bgView.userInteractionEnabled = YES;
        [self addSubview:_bgView];
        
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        //        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (UIView *)alertView
{
    if (!_alertView) {
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(HRMARGIN, HRSCREEN.size.height / 2, HRSCREEN.size.width - (HRMARGIN * 2), HRMARGIN * 2)];
        _alertView.layer.cornerRadius = 8.0f;
        _alertView.alpha = 0;
        _alertView.clipsToBounds = YES;
        [self addSubview:_alertView];
    }
    return _alertView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, HRPADDING, CGRectGetWidth(self.alertView.frame), HRMARGIN)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:19];
        [self.alertView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(HRMARGIN, CGRectGetMaxY(self.titleLabel.frame) + HRPADDING, CGRectGetWidth(self.alertView.frame) - (HRMARGIN * 2), HRPADDING)];
        _detailLabel.numberOfLines = 0;
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.font = [UIFont systemFontOfSize:16];
        [self.alertView addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UIImageView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.alertView.frame) - HRMARGIN, CGRectGetWidth(self.alertView.frame), 0.5)];
        // 添加自定义图片
        _lineView.image = [UIImage imageNamed:@"line"];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        [self.alertView addSubview:_lineView];
    }
    return _lineView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.alertView.frame) - HRMARGIN, CGRectGetWidth(self.alertView.frame), HRMARGIN)];
        _bottomView.backgroundColor = [UIColor lightGrayColor];
        [self.alertView addSubview:_bottomView];
    }
    return _bottomView;
}


@end
