//
//  NCIServerEngine.m
//  NewCentury
//
//  Created by Stenson on 16/1/19.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#import "ZEServerEngine.h"
#import "ZESettingLocalData.h"

#import "ZELoginViewController.h"

#import "ZEHomeVC.h"

#define kServerErrorNotLogin                @"E020601" // 用户未登陆
#define kServerErrorLoginTimeOut            @"E020602" // 登陆超时
#define kServerErrorReqTimeOut              @"E020603" // 请求超时
#define kServerErrorIllegalReq              @"E020604" // 非法请求

static ZEServerEngine *serverEngine = nil;

@interface ZEServerEngine()

@property (nonatomic,strong) NSMutableArray * taskArr;

@end

@implementation ZEServerEngine

+ (ZEServerEngine *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serverEngine = [[ZEServerEngine alloc] initSingle];
    });
    return serverEngine;
}

-(id)initSingle
{
    self = [super init];
    if ( self) {
        self.taskArr = [NSMutableArray array];
    }
    return self;
}

-(void)requestWithParams:(NSMutableDictionary *)params
                    path:(NSString * )path
              httpMethod:(NSString *)httpMethod
                 success:(ServerResponseSuccessBlock)successBlock
                    fail:(ServerResponseFailBlock)failBlock
{
    NSString * serverAdress = nil;
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    if ([httpMethod isEqualToString:HTTPMETHOD_GET]) {
        [sessionManager GET:path parameters:nil
                   progress:nil
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSDictionary * responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                        if ([responseDic isKindOfClass:[NSDictionary class]] && [ZEUtil isNotNull:responseDic]) {
                            if (successBlock != nil) {
                                successBlock(responseDic);
                            }
                        }
        }
                    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        if ([[error.userInfo objectForKey:@"NSLocalizedDescription"] rangeOfString:@"401"].location != NSNotFound) {
                            [sessionManager.operationQueue cancelAllOperations];
                            [ZEServerEngine showMainVC];
                        }
                        if (error != nil) {
                            failBlock(error);
                        }
                       }];
    }else if ([httpMethod isEqualToString:HTTPMETHOD_POST]){
        [sessionManager POST:serverAdress
                  parameters:params progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if ([[error.userInfo objectForKey:@"NSLocalizedDescription"] rangeOfString:@"401"].location != NSNotFound) {
                             [sessionManager.operationQueue cancelAllOperations];
                             [ZEServerEngine showMainVC];
                         }
                         if (error != nil) {
                             failBlock(error);
                         }
                     }];
    }
}

+(void)showMainVC
{
    [ZESettingLocalData deleteCookie];
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    
    ZEHomeVC  * mainVC = [[ZEHomeVC alloc]init];
    UINavigationController * navVC = [[UINavigationController alloc]initWithRootViewController:mainVC];
    
    if ([[(UINavigationController *)[ZEUtil getCurrentVC] viewControllers] count] > 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kRelogin object:nil];
        keyWindow.rootViewController = navVC;
    }
}



-(void)requestWithJsonDic:(NSDictionary *)jsonDic
        withServerAddress:(NSString *)serverAddress
                  success:(ServerResponseSuccessBlock)successBlock
                     fail:(ServerResponseFailBlock)failBlock;
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;

    NSData *cookiesdata = [ZESettingLocalData getCookie];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            NSLog(@" REQUEST  ====================   %@",[cookie value]);

        }
    }

    NSURLSessionDataTask *task = [manager POST:serverAddress
              parameters:jsonDic
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
  
                     NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
                     NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookiesArray];
//                     if(![cookiesdata length]) {
                         [ZESettingLocalData setCookie:data];
//                     }
                     
                     NSError * err = nil;
                     NSDictionary * responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&err];
                                          
                     if ([ZEUtil isNotNull:responseObject]) {
                         successBlock(responseDic);
                     }
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     if (error != nil) {
                         failBlock(error);
                     }
                 }];
    
    [self.taskArr addObject:task];
}

-(void)downloadFiletWithJsonDic:(NSDictionary *)jsonDic
              withServerAddress:(NSString *)serverAddress
                       fileName:(NSString *)fileName
                   withProgress:(void (^)(CGFloat progress))progressBlock
                        success:(ServerResponseSuccessBlock)successBlock
                           fail:(ServerResponseFailBlock)failBlock
{
    
    NSString * serverAdress = serverAddress;
    //Configuring the session manager
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    
    NSData *cookiesdata = [ZESettingLocalData getCookie];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }

//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.operationQueue.maxConcurrentOperationCount = 5;
    //Most URLs I come across are in string format so to convert them into an NSURL and then instantiate the actual request
    NSURL *formattedURL = [NSURL URLWithString:serverAdress];
    NSURLRequest *request = [NSURLRequest requestWithURL:formattedURL];
    
    //Watch the manager to see how much of the file it's downloaded
    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        //Convert totalBytesWritten and totalBytesExpectedToWrite into floats so that percentageCompleted doesn't get rounded to the nearest integer
        CGFloat written = totalBytesWritten;
        CGFloat total = totalBytesExpectedToWrite;
        CGFloat percentageCompleted = written/total;
        //Return the completed progress so we can display it somewhere else in app
        progressBlock(percentageCompleted);
    }];
    
    //Start the download
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //Getting the path of the document directory
        //        判断文件夹路径是否存在 不存在就创建文件夹路径
        NSFileManager * fileManager = [[NSFileManager alloc]init];
        if (![fileManager fileExistsAtPath:CACHEPATH]) {
            [fileManager createDirectoryAtPath:CACHEPATH withIntermediateDirectories:YES attributes:nil error:nil];
        }
        //        获取文件缓存路径目标文件夹 同时把视频文件命名为filename
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        NSURL *fullURL = [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",CACHEPATH,fileName]];
        
        return fullURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (!error) {
            NSString * filePath = [NSString stringWithFormat:@"%@/%@",CACHEPATH,fileName];
            successBlock(filePath);
        } else {
            //Otherwise return the error block
            failBlock(error);
        }
        
    }];
    
    [downloadTask resume];
}


-(void)requestWithJsonDic:(NSDictionary *)jsonDic
             withImageArr:(NSArray *)arr
        withServerAddress:(NSString *)serverAddress
                  success:(ServerResponseSuccessBlock)successBlock
                     fail:(ServerResponseFailBlock)failBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30.f;
    
    NSData *cookiesdata = [ZESettingLocalData getCookie];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
    
    [manager                  POST:serverAddress
                        parameters:nil
         constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
             
             [formData appendPartWithFormData:[[ZEServerEngine dictionaryToJson:jsonDic] dataUsingEncoding:NSUTF8StringEncoding]  name:@"JSONBODY"];
             
             for (int i = 0 ; i < arr.count; i ++) {
                 UIImage *image = arr[i];
                 NSData *imageData = UIImageJPEGRepresentation([self fixOrientation:image],0.1);

                 NSString *fileName = [NSString stringWithFormat:@"image%d.jpg",i];
                 
                 [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
             }
             
         }
                          progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
             NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookiesArray];
             if(![cookiesdata length]) {
                 [ZESettingLocalData setCookie:data];
             }
             NSError * err = nil;
             NSDictionary * responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&err];
             
             if ([ZEUtil isNotNull:responseObject]) {
                 successBlock(responseDic);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if (error != nil) {
                 failBlock(error);
             }
         }];
}
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}



+(UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage *)image
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
    
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


-(void)showLoginVC
{
    ZELoginViewController * loginVC = [[ZELoginViewController alloc]init];
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow setRootViewController:loginVC];
}

-(void)cancelAllTask
{
    [self.taskArr enumerateObjectsUsingBlock:^(NSURLSessionDataTask *taskObj, NSUInteger idx, BOOL * _Nonnull stop) {

        [taskObj cancel];
    }];
    [self.taskArr removeAllObjects];
}

#pragma mark - 发送普通请求接口

-(void)sendCommonRequestWithJsonDic:(NSDictionary *)jsonDic
        withServerAddress:(NSString *)serverAddress
                  success:(ServerResponseSuccessBlock)successBlock
                     fail:(ServerResponseFailBlock)failBlock;
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    
//    NSData *cookiesdata = [ZESettingLocalData getCookie];
//    if([cookiesdata length]) {
//        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
//        NSHTTPCookie *cookie;
//        for (cookie in cookies) {
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//        }
//    }
    
    NSURLSessionDataTask *task = [manager POST:serverAddress
                                    parameters:jsonDic
                                      progress:nil
                                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                                           NSError * err = nil;
//                                           NSLog(@" ====  %@",responseObject);
//                                           NSDictionary * responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&err];

                                           if ([ZEUtil isNotNull:responseObject]) {
                                               successBlock(responseObject);
                                           }
                                       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                           if (error != nil) {
                                               failBlock(error);
                                           }
                                       }];
    
    [self.taskArr addObject:task];
}



@end
