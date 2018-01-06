//
//  MKCommonHelper.m
//  jianke
//
//  Created by xiaomk on 16/2/25.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#import "MKCommonHelper.h"
#import "UIHelper.h"
#import "WDConst.h"

@implementation MKCommonHelper
Impl_SharedInstance(MKCommonHelper);

//邮箱校验
+ (BOOL)validateEmail:(NSString*)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//电话号码校验
+ (NSString *)getPhoneWithString:(NSString *)string{
    
    if(string.length < 11){
        return nil;
    }
//    NSError *error;
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^1[3|4|5|7|8][0-9]\\d{8}$" options:0 error:&error];
//    if (!error) {
//        NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
//        if (match) {
//            return [string substringWithRange:match.range];
//        }
//    }else{
//    
//        DLog(@"效验error:%@",error);
//    }
    MKCommonHelper *helper = [[MKCommonHelper alloc]init];
    
    NSString *pattern; pattern=@"\\d*";
    NSError *error;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    [regex enumerateMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (NSMatchingReportProgress==flags) {
            
        }else{ /** * 系统内置方法 */
            if (NSTextCheckingTypePhoneNumber==result.resultType) {
                helper.result = [string substringWithRange:result.range];
                
            } /** * 长度为11位的数字串 */
            if (result.range.length==11) {
                helper.result =[string substringWithRange:result.range];

            }
            
        }
    }];


    return helper.result;
}
//url效验
+ (NSString *)getUrlWithString:(NSString *)string{
    
    if (string.length < 5) {
        return nil;
    }
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)" options:0 error:&error];
    if (!error) {
        NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
        if (match) {
            return [string substringWithRange:match.range];
        }
    }else{
        
        DLog(@"效验error:%@",error);
    }
    

    
    return nil;


}
//传入数组，根据 key 字段 获取字母 首拼音， 返回排序好的字母数组
+ (NSArray*)getNoRepeatSortLetterArray:(NSArray*)array letterKey:(NSString*)letterKey{
    // 获取字母数组
    NSArray* tempArray = [array valueForKey:letterKey];
    
    // 去重
    NSMutableDictionary* tempDic = [[NSMutableDictionary alloc] init];
    for (NSString *letter in tempArray) {
        [tempDic setObject:letter forKey:letter];
    }
    // 排序
    NSSortDescriptor *desc = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray* descArray = [NSArray arrayWithObject:desc];
    NSArray* sortArray = [tempDic.allValues sortedArrayUsingDescriptors:descArray];
    
    // 拼音首字母转换为大写
    NSMutableArray* upLetterArray = [NSMutableArray array];
    for (NSString* letter in sortArray) {
        NSString* tempLetter = [NSString stringWithString:letter.uppercaseString];
        [upLetterArray addObject:tempLetter];
    }
    return upLetterArray;
}

+ (NSString*)getChineseNameFirstPinyinWithName:(NSString*)name{
    return [[self hanziToPinyinWith:name isChineseName:YES] substringToIndex:1];
}

+ (NSString*)hanziToPinyinWith:(NSString*)hanziStr isChineseName:(BOOL)isChineseName{
    if (hanziStr.length == 0) {
        return hanziStr;
    }
    
    NSMutableString* ms = [[NSMutableString alloc] initWithString:hanziStr];
    CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO);     //转拼音
    CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO);   //去声调
    if (isChineseName) {
        if ([[(NSString*)hanziStr substringToIndex:1] compare:@"长"] == NSOrderedSame) {
            [ms replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chang"];
        }
        if ([[(NSString *)hanziStr substringToIndex:1] compare:@"沈"] == NSOrderedSame){
            [ms replaceCharactersInRange:NSMakeRange(0, 4)withString:@"shen"];
        }
        if ([[(NSString *)hanziStr substringToIndex:1] compare:@"厦"] == NSOrderedSame){
            [ms replaceCharactersInRange:NSMakeRange(0, 3)withString:@"xia"];
        }
        if ([[(NSString *)hanziStr substringToIndex:1] compare:@"地"] == NSOrderedSame){
            [ms replaceCharactersInRange:NSMakeRange(0, 2)withString:@"di"];
        }
        if ([[(NSString *)hanziStr substringToIndex:1] compare:@"重"] == NSOrderedSame){
            [ms replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chong"];
        }
    }
  
    return ms;
}




+ (UIImage*)createQrImageWithUrl:(NSString*)urlStr withImgWidth:(CGFloat)imgWidth{
    
    NSData* stringData = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *ciImage = qrFilter.outputImage;
    
    CGRect extent = CGRectIntegral(ciImage.extent);
    
    CGFloat scale = MIN(imgWidth/CGRectGetWidth(extent), imgWidth/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent)* scale;
    size_t height = CGRectGetHeight(extent)* scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGColorSpaceRelease(cs);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    UIImage* qrImage = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    return qrImage;
}


/** 保存网络图片到相册 */
- (void)saveImageToPhotoLibWithImageUrl:(NSString *)imageUrl{
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    UIImage* image = [UIImage imageWithData:data];
    
    if (image) {
        [self saveImageToPhotoLib:image];
    }
}

/** 保存图片到相册 */
- (void)saveImageToPhotoLib:(UIImage*)image{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    NSString* msg = nil;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    [UIHelper toast:msg];
}

/** 打印所有字体 */
+ (void)printAllFont{
    NSArray* familyNames = [[NSArray alloc]initWithArray:[UIFont familyNames]];
    NSArray* fontNames;
    NSInteger indFamily, indFont;
    ELog(@"familyNames count: %lu", (unsigned long)familyNames.count);
    for (indFamily = 0; indFamily < familyNames.count; ++indFamily) {
        ELog(@"family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
        for (indFont = 0; indFont < fontNames.count; indFont++) {
            ELog(@"     font name:%@", [fontNames objectAtIndex:indFont]);
        }
    }
}
@end
