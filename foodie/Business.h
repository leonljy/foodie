//
//  Business.h
//  foodie
//
//  Created by Leonljy on 2015. 9. 19..
//  Copyright (c) 2015년 Favorie&John. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Business : NSObject
@property (strong, nonatomic) NSString *businessId;
@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSDictionary *locationInfo;
@property (strong, nonatomic) NSString *name;
@property CGFloat rating;
@property (strong,nonatomic) NSURL *url;
@property (strong,nonatomic) NSURL *urlMobile;
@property NSInteger reviewCount;
@property (strong, nonatomic) NSArray *foods;
@property CGFloat distance;

+(Business *)initWithDic:(NSDictionary *)result;
-(CLLocationDistance)getDistanceWithCurrentLocation:(CLLocation *)location;
@end
