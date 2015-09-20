//
//  Business.m
//  foodie
//
//  Created by Leonljy on 2015. 9. 19..
//  Copyright (c) 2015년 Favorie&John. All rights reserved.
//

#import "Business.h"

@implementation Business
//@property (strong, nonatomic) NSString *businessId;
//@property (strong, nonatomic) NSURL *image;
//@property (strong, nonatomic) NSString *phoneNumber;
//@property (strong, nonatomic) NSDictionary *locationInfo;
//@property (strong, nonatomic) NSString *name;
//@property CGFloat rating;
//@property (strong,nonatomic) NSURL *url;
//@property (strong,nonatomic) NSURL *urlMobile;
//@property NSInteger reviewCount;


+(Business *)initWithDic:(NSDictionary *)result{
    Business *business = [Business new];
    business.businessId = result[@"id"];
    business.imageUrl = [NSURL URLWithString:@"image_url"];
    business.phoneNumber = result[@"phone"];
    business.locationInfo = result[@"location"];
    business.name = result[@"name"];
    business.rating = [result[@"rating"] doubleValue];
    business.url = [NSURL URLWithString:@"url"];
    business.urlMobile = [NSURL URLWithString:@"mobile_url"];
    business.reviewCount = [result[@"review_count"] integerValue];
    return business;
}

-(CLLocationDistance)getDistanceWithCurrentLocation:(CLLocation *)location{
    NSDictionary *dicLocation = self.locationInfo[@"location"];
    NSDictionary *coordinate = dicLocation[@"coordinate"];
    double latitude = [coordinate[@"latitude"] doubleValue];
    double longitude = [coordinate[@"longitude"] doubleValue];
    
    CLLocation *locationStore = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocationDistance distance = [location distanceFromLocation:locationStore];
    return distance;
}
@end
