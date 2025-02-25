//
//  AliyunOSSUpload.h
//  HuaYin
//
//  Created by 陈希 on 2020/7/30.
//  Copyright © 2020 陈希. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AliyunUpload                [AliyunOSSUpload aliyunInit]

typedef void(^UploadSuccessBlock)(NSString *obj,NSString *objKey);

typedef void(^UploadImageArrsSuccessBlock)(NSString *obj,NSMutableArray *imageNamesArr);

@interface AliyunOSSUpload : NSObject

+(AliyunOSSUpload *)aliyunInit;


//-(void)uploadImage:(NSArray*)imgArr imagesObject:(NSArray *)imagesObject success:(void (^)(NSString *obj))success;

- (void)upLoadImage:(UIImage *)selImage success:(UploadSuccessBlock) successBlock;

- (void)upLoadImages:(NSArray *)imageArr success:(UploadImageArrsSuccessBlock) successBlock;

//- (void)upLoadFile:(NSString *)outMp3path success:(UploadSuccessBlock) successBlock;
////上传本地文件
//- (void)upLoadFilesuccess:(UploadSuccessBlock) successBlock;

@end

