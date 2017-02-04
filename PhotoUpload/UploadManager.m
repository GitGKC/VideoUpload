//
//  UploadManager.m
//  PhotoUpload
//
//  Created by GKC on 2017/1/20.
//  Copyright © 2017年 GKC. All rights reserved.
//

#import "UploadManager.h"
#import <Qiniu/QiniuSDK.h>
#import <UIKit/UIKit.h>

#define  Test_Token  @"e5V7IxNlpwSgfK7xQJKi3PAV3c2vzQu0BqVhMtKW:KKfD3HqGXlG9-279glgyxDRdCzU=:eyJzY29wZSI6InVwdGVzdCIsImRlYWRsaW5lIjoxNDg0OTE4ODA1fQ=="

@interface UploadManager ()

@property (nonatomic,strong) QNUploadManager *upManager;//文件管理类  是个单例

@end

@implementation UploadManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        //文件管理类
        self.upManager = [[QNUploadManager alloc] init];
    }
    return self;
}

- (void)uploadAVPath:(NSString *)path {
    QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"percent == %.2f", percent);
    } params:nil checkCrc:NO cancellationSignal:nil];
    
    [self.upManager putFile:path key:[NSString stringWithFormat:@"%@%@.mov",[self currentTimeWithYMDHMS],[self randomStringWithLength:5]] token:Test_Token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//        NSLog(@"info-->%@", info);
        NSLog(@"状态码-->%d", info.statusCode);
        if (info.statusCode == 200) {
            NSLog(@"上传成功！");
        }
        //        NSLog(@"resp--->%@", resp);
    } option:opt];

}


- (NSString *)currentTimeWithYMDHMS
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *currentTime = [dateFormatter stringFromDate:[NSDate date]];
    return currentTime;
}

- (NSString *)randomStringWithLength:(NSInteger)len{
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (NSInteger i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    return randomString;
}


@end

