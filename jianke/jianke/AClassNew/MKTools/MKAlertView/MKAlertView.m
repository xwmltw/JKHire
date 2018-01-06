//
//  MKAlertView.m
//  MKDevelopSolutions
//
//  Created by xiaomk on 16/5/16.
//  Copyright © 2016年 xiaomk. All rights reserved.
//

#import "MKAlertView.h"

#pragma mark - ***** MKAlertView ******
@interface MKAlertView()<UIAlertViewDelegate>
@property (nonatomic, copy) MKAlertViewBlock block;
@end

@implementation MKAlertView

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle supportCancelGesture:(BOOL)supportCancelGesture completion:(MKAlertViewBlock)completion{
    MKAlertView* alert = [[MKAlertView alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle confirmButtonTitle:confirmButtonTitle completion:completion];
    [alert show];
    
    if (supportCancelGesture) {
        UITapGestureRecognizer *recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:alert action:@selector(handleTapBehind:)];
        [recognizerTap setNumberOfTapsRequired:1];
        recognizerTap.cancelsTouchesInView = NO;
        [[UIApplication sharedApplication].keyWindow addGestureRecognizer:recognizerTap];
    }
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle completion:(MKAlertViewBlock)completion{
    [self alertWithTitle:title message:message cancelButtonTitle:cancelButtonTitle confirmButtonTitle:confirmButtonTitle supportCancelGesture:NO completion:completion];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle viewController:(UIViewController *)vc completion:(MKAlertControllerBlock)completion{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        NSAssert(NO, @"systemVersion must >= 8.0");
        return;
    }
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completion(action, 0);
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completion(action, 1);
    }];
    [alert addAction:cancleAction];
    [alert addAction:confirmAction];
    [vc presentViewController:alert animated:YES completion:nil];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle completion:(MKAlertViewBlock)completion{
    
    self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:confirmButtonTitle, nil];
    if (self) {
        self.block = completion;
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (self.block) {
        self.block(alertView, buttonIndex);
    }
}

- (void)handleTapBehind:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint location = [sender locationInView:nil];
        if (![self pointInside:[self convertPoint:location fromView:self.window] withEvent:nil]){
            [self.window removeGestureRecognizer:sender];
            [self dismissWithClickedButtonIndex:2 animated:YES];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
