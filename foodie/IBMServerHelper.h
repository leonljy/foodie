//
//  WeatherBonyServerHelper.h
//  PokoWeather
//
//  Created by Leonljy on 2015. 7. 9..
//  Copyright (c) 2015년 Favorie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPRequestOperationManager.h>

@interface IBMServerHelper : NSObject
typedef void (^ArrayBlock)(NSArray *results);
typedef void (^SuccessBlock)(id responseObject);
typedef void (^FailureBlock)(NSError *error);

@property (assign) BOOL isReachable;

+ (IBMServerHelper *)sharedInstance;
-(void)getRecognitionForImage:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
-(NSData *)post:(NSString *)postString url:(NSString*)urlString;

@end
