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
    business.url = [NSURL URLWithString:result[@"url"]];
    business.urlMobile = [NSURL URLWithString:result[@"mobile_url"]];
    business.reviewCount = [result[@"review_count"] integerValue];
    business.ratingImage = [NSURL URLWithString:result[@"rating_img_url_large"]];
    return business;
}

-(CLLocationDistance)getDistanceWithCurrentLocation:(CLLocation *)location{
    NSDictionary *coordinate = self.locationInfo[@"coordinate"];
    double latitude = [coordinate[@"latitude"] doubleValue];
    double longitude = [coordinate[@"longitude"] doubleValue];
    
    CLLocation *locationStore = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocationDistance distance = [location distanceFromLocation:locationStore];
    distance = distance * 0.000621371; 
    return distance;
}
@end
