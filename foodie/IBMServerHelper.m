//
//  WeatherBonyServerHelper.m
//  PokoWeather
//
//  Created by Leonljy on 2015. 7. 9..
//  Copyright (c) 2015년 Favorie. All rights reserved.
//

#import "IBMServerHelper.h"

@interface IBMServerHelper()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation IBMServerHelper


static IBMServerHelper *instance;
static NSString* const SERVERURL = @"http://visual-recognition-nodejs-leonljy-313.mybluemix.net";
static NSInteger const VERSION = 1;
static NSNumber* numberVersion;

+ (IBMServerHelper *)sharedInstance{
    if(nil==instance){
        instance = [[IBMServerHelper alloc] init];
        
        instance.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:SERVERURL]];
        instance.manager.securityPolicy.allowInvalidCertificates = YES;
        instance.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        NSOperationQueue *operationQueue = instance.manager.operationQueue;
        
        numberVersion = [NSNumber numberWithInteger:VERSION];
        
        [instance.manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"ReachabilityStatus Via WWAN or WIFI");
                    [operationQueue setSuspended:NO];
                    instance.isReachable = YES;
                    break;
                case AFNetworkReachabilityStatusNotReachable:{
                    NSLog(@"ReachabilityStatus not reachable");
                    instance.isReachable = NO;
                    break;
                }
                default:
                    NSLog(@"Defualt ReachabilityStatus");
                    [operationQueue setSuspended:YES];
                    break;
            }
        }];
    }
    return instance;
}

//+(NSString *)getServerBaseURL{
//    return SERVERURL;
//}

- (void)errorHandler:(NSError *)error
           operation:(AFHTTPRequestOperation *)operation
             success:(void (^)(void))successBlock
             failure:(void (^)(NSError *))failureBlock{
    if (!self.isReachable){
        //        [self showNotReachable];
        
        failureBlock(error);
    } else {
        failureBlock(error);
    }
}


-(NSData *)post:(NSString *)postString url:(NSString*)urlString{
    
    //Response data object
    NSData *returnData = [[NSData alloc]init];
    
    //Build the Request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postString length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Send the Request
    returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    
    //Get the Result of Request
    NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
    
    bool debug = YES;
    
    if (debug && response) {
//        NSLog(@"Response >>>> %@",response);
    }
    
    
    return returnData;
}

-(void)getRecognitionForImage:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    NSString *urlString = [NSString stringWithFormat:@"/"];
    NSDictionary *parameters = @{@"url":[NSString stringWithFormat:@"%@", url], @"classifier":@"Food"};
    
    [self.manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error);
    }];
}


/*
-(void)showNotReachable{
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Internet.Status.Lost", @"InternetConnectionLost") message:NSLocalizedString(@"Internet.Status.Retry", @"Retry") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"General.OK", @"OK"), nil];
    [deleteAlert show];
}


# pragma mark - Server Interactions GET/POST/PUT/DELETE
-(void)searchRegionWithKeyword:(NSString *)keyword{
    NSString *urlString = [NSString stringWithFormat:@"index.php/search"];
    NSDictionary *parameters = @{@"keyword":keyword};
    
    [self.manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"JSON: %@", responseObject);
        [self.delegate responseSearchRegion:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"Error: %@", error);
        [self.delegate errorSearchRegion:error];
    }];
}


-(void)getAllWeatherWithPoints:(NSDictionary *)points{
    NSString *urlString = [NSString stringWithFormat:@"index.php/weather/all_point"];
    NSDictionary *parameters = @{@"points":points};
    
    [self.manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate responseAllWeatherPoints:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate errorAllWeatherPoints:error];
    }];
}

-(void)getAllWeatherWithPoints:(NSDictionary *)points successBlock:(WeatherBoniServerSuccessBlock)successBlock failureBlock:(WeatherBoniServerFailureBlock)failureBlock{
    NSString *urlString = [NSString stringWithFormat:@"index.php/weather/all_point"];
    NSDictionary *parameters = @{@"points":points};
    
    [self.manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error);
    }];
}


-(void)getAllWeatherWithLatitude:(double)latitude longitude:(double)longitude day:(NSInteger)day{
    NSString *urlString = [NSString stringWithFormat:@"index.php/weather/all"];
    NSDictionary *parameters = @{@"latitude":[NSString stringWithFormat:@"%f", latitude], @"longitude":[NSString stringWithFormat:@"%f", longitude], @"day":[NSNumber numberWithInteger:day]};
    
    [self.manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"JSON: %@", responseObject);
        [self.delegate responseAllWeather:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"Error: %@", error);
        [self.delegate errorAllWeather:error];
    }];
}


//
//-(void)getXYWithLatitude:(double)latitude longitude:(double)longitude{
//    NSString *urlString = [NSString stringWithFormat:@"weather/coordinate"];
//    NSDictionary *parameters = @{@"latitude":[NSString stringWithFormat:@"%f", latitude], @"longitude":[NSString stringWithFormat:@"%f", longitude]};
//    
//    NSLog(@"Dic: %@", parameters);
//    
//    [self.manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //        NSLog(@"JSON: %@", responseObject);
//        [self.delegate responseCoordinate:responseObject];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //        NSLog(@"Error: %@", error);
//        [self.delegate errorCoordinate:error];
//    }];
//}


-(void)getWeatherWithLatitude:(double)latitude longitude:(double)longitude day:(NSInteger)day date:(NSDate *)date successBlock:(WeatherBoniServerSuccessBlock)successBlock failureBlock:(WeatherBoniServerFailureBlock)failureBlock{
    NSString *urlString = [NSString stringWithFormat:@"index.php/weather/date"];
    NSDictionary *parameters = @{@"latitude":[NSString stringWithFormat:@"%f", latitude], @"longitude":[NSString stringWithFormat:@"%f", longitude], @"day":[NSNumber numberWithInteger:day], @"date":[NSString stringWithFormat:@"%@", date]};
    
    [self.manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error);
    }];
}


-(void)getAllWeatherWithLatitude:(double)latitude longitude:(double)longitude day:(NSInteger)day successBlock:(WeatherBoniServerSuccessBlock)successBlock failureBlock:(WeatherBoniServerFailureBlock)failureBlock{
    NSString *urlString = [NSString stringWithFormat:@"index.php/weather/all"];
    NSDictionary *parameters = @{@"latitude":[NSString stringWithFormat:@"%f", latitude], @"longitude":[NSString stringWithFormat:@"%f", longitude], @"day":[NSNumber numberWithInteger:day]};
    
    [self.manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error);
    }];
}


-(void)getPokoContentsWithArrayBlock:(WeatherBoniServerArrayBlock)successBlock failureBlock:(WeatherBoniServerFailureBlock)failureBlock{
    NSString *urlString = [NSString stringWithFormat:@"index.php/pokoarts"];
    
    [self.manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        NSMutableArray *contents = [NSMutableArray array];
        for(NSDictionary *dicContent in responseObject[@"content"]){
            PokoArtsContent *content = [PokoArtsContent initWithResponseObject:dicContent];
            [contents addObject:content];
        }
        successBlock(contents);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error);
    }];
}

-(void)eventTestWithUUID:(NSString *)uuid{
    NSString *urlString = [NSString stringWithFormat:@"index.php/test/background"];
    NSDictionary *parameters = @{@"uuid":uuid};
    
    [self.manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON For Event Testing: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error For Event Testing: %@", error);
    }];
}
 */


@end
