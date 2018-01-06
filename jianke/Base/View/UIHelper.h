//
//  UIHelper.h
//  jianke
//
//  Created by xiaomk on 15/9/7.
//  Copyright (c) 2015年 xianshijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DLAVAlertView.h"
#import "MKUIHelper.h"
#import "XSJUIHelper.h"

@interface UIHelper : NSObject<UITextViewDelegate>


#pragma mark - 场景切换
+ (void)showLoginVCWithBlock:(MKBlock)block;


/** block返回的参数为nil 表示取消 */
+ (void)showLoginVCWithNeedUpDateEpInfo:(BOOL)isUpdateEpInfo block:(MKBlock)block;

+ (void)loginOutToView;
+ (void)hideCustomWindow;

#pragma mark - view 通用方法
////将 vc 设置成根 控制器
//+ (void)setWindowRootVCWith:(UIViewController*)vc;
+ (void)setKeyWindowWithVC:(id)vc;
+ (id)getVCFromStoryboard:(NSString *)nameStoryboard identify:(NSString *)nameVC;
//归档
+ (UIView *)duplicate:(UIView *)view;

#pragma mark - debug 可用 遍历view下的子控件并打印
+ (void)printSubViewWithView:(UIView*)superView;

+ (UIView *)addImage:(NSString *)img to:(UIView *)parent WithStr:(NSString *)str;

#pragma mark - 计算 label size
+ (CGSize)getSizeWithString:(NSString*)string width:(CGFloat)width font:(UIFont*)font;

#pragma mark - showMsg Alert
+ (void)showMsg:(NSString *)msg;
+ (void)showMsg:(NSString *)msg andTitle:(NSString *)title;
+ (void)showNoTitleMsg:(NSString*)msg;
+ (void)showMsg:(NSString *)msg title:(NSString *)title okBtnTitle:(NSString *)btnTitle;
+ (void)toast:(NSString *)msg;
+ (void)showConfirmMsg:(NSString*)msg completion:(DLAVAlertViewCompletionHandler)completion;
+ (void)showConfirmMsg:(NSString*)msg okButton:(NSString*)okButton completion:(DLAVAlertViewCompletionHandler)completion;
+ (void)showConfirmMsg:(NSString*)msg title:(NSString *)title okButton:(NSString*)okButton completion:(DLAVAlertViewCompletionHandler)completion;
+ (void)showConfirmMsg:(NSString*)msg title:(NSString *)title cancelButton:(NSString*)cancelTitle completion:(DLAVAlertViewCompletionHandler)completion;
+ (void)showConfirmMsg:(NSString*)msg title:(NSString *)title cancelButton:(NSString*)cancelTitle okButton:(NSString*)okTitle completion:(DLAVAlertViewCompletionHandler)completion;
+ (void)showMsgBoxWithTitle:(NSString*)title msg:(NSString*)msg cancelButton:(NSString*)cancelTitle okButton:(NSString*)okTitle completion:(DLAVAlertViewCompletionHandler)completion;
- (void)showTextFieldMsgBoxWithTitle:(NSString*)title msg:(NSString*)msg placeholder:(NSString*)placeholder cancelButton:(NSString*)cancelTitle okButton:(NSString*)okTitle completion:(DLAVAlertViewCompletionHandler)completion;

#pragma mark - 默认占位 图片
+ (UIImage*)getDefaultHead;
+ (UIImage*)getDefaultHeadRect;
+ (UIImage*)getDefaultImage;
+ (UIImage*)getDefaultAdBgImage;
+ (UIImageView*)createShadowLine;

#pragma mark - 九宫格图片设置
+ (UIImage*)getRectImage:(NSString*)imgName with:(UIEdgeInsets)uidegeInsets;

#pragma mark - 设置 view 的 圆角 和 边框
+ (void)setBorderWidth:(CGFloat)width andColor:(UIColor*)color withView:(UIView*)view;

+ (void)setCorner:(UIView *)view;
+ (void)setCorner:(UIView *)view withValue:(CGFloat)value;
+ (void)setToCircle:(UIView *)view;

#pragma mark - 显示message到指定View中
/** 显示message到指定View中 */
+ (void)showMessage:(NSString *)message toView:(UIView *)view;

#pragma mark - 替换字符串
+ (NSMutableString *)replaceString:(NSString*)originStr str1:(NSString*)str1 toStr2:(NSString*)str2;

#pragma mark - 添加 无网络 无数据 view
+ (UIView *)noDataViewWithTitleArr:(NSArray *)noDataTipArr titleColor:(UIColor*)titleColor image:(NSString *)image button:(NSString *)btnTitle isAbsoluteWidth:(BOOL)isAbsoluteWidth isFullScreen:(BOOL)isFullScreen;   //支持非全屏高度,自适应高度
+ (UIView *)noDataViewWithTitleArr:(NSArray *)noDataTipArr titleColor:(UIColor*)titleColor image:(NSString *)image button:(NSString *)btnTitle isAbsoluteWidth:(BOOL)isAbsoluteWidth;
+ (UIView *)noDataViewWithTitleArr:(NSArray *)noDataTipArr titleColor:(UIColor*)titleColor image:(NSString *)image button:(NSString *)btnTitle;
+ (UIView *)noDataViewWithTitle:(NSString *)noDataTip image:(NSString *)image;
+ (UIView *)noDataViewWithTitle:(NSString *)noDataTip titleColor:(UIColor*)titleColor image:(NSString *)image;
+ (UIView *)noDataViewWithTitle:(NSString *)noDataTip titleColor:(UIColor*)titleColor image:(NSString *)image button:(NSString *)btnTitle;
+ (UIView *)noDataViewWithTitle:(NSString *)noDataTip;

#pragma mark - 转菊花
/** 转菊花 */
+ (void)showLoading:(BOOL)isShow withMessage:(NSString *)message;

#pragma mark - 创建UITableView
+ (UITableView *)createTableViewWithStyle:(UITableViewStyle) style delegate:(id)target onView:(UIView *)view;

#pragma mark - IM 收到消息 音效
+ (void)playSound;

#pragma mark - 其他 没用到的
/** 在指定View中显示loading动画 */
+ (UIView *)loadingWithMessage:(NSString *)message;
+ (UIView*)addNoDataViewTo:(UIView*)parent WithStr:(NSString*)str;
+ (UIView*)addNoDataViewTo:(UIView*)parent;



+ (void)showSwitchAnimationWindowIsToEP:(BOOL)isToEP;
+ (void)hideSwitchAnimationWindow;

/** 打开岗位推荐 界面 */
+ (void)openInsterJobVCWithRootVC:(UIViewController*)rootVC;
@end

