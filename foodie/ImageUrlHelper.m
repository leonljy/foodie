//
//  ImageUrlHelper.m
//  foodie
//
//  Created by Leonljy on 2015. 9. 19..
//  Copyright (c) 2015년 Favorie&John. All rights reserved.
//

#import "ImageUrlHelper.h"
#import "TFHpple.h"
#import "Business.h"
#import "Food.h"

static ImageUrlHelper *instance;
static NSString *baseUrl = @"http://www.yelp.com/biz_photos/";
@implementation ImageUrlHelper
+ (ImageUrlHelper *)sharedInstance{
    if(nil==instance){
        instance = [[ImageUrlHelper alloc] init];
    }
    
    return instance;
}


-(void)fetchPhotoListsWithBusinesses:(NSArray *)businesses{
    for(Business *business in businesses){
        business.foods = [self foodsWithID:business page:0];
    }
}



-(NSArray *)foodsWithID:(Business *)business page:(NSInteger)page{
    NSString *urlString = [NSString stringWithFormat:@"%@%@?start=%lu", baseUrl, business.businessId, (long)page];
    NSURL *urlPhotoList = [NSURL URLWithString:urlString];
    
    NSData  * data      = [NSData dataWithContentsOfURL:urlPhotoList];
    
    TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:data];
    NSMutableArray *imageUrls = [NSMutableArray arrayWithArray:[doc searchWithXPathQuery:@"//img[@class='photo-box-img']"]];
    NSMutableArray *spans = [NSMutableArray arrayWithArray:[doc searchWithXPathQuery:@"//span[@class='offscreen']"]];
    [imageUrls removeObjectAtIndex:0];
    [spans removeObjectAtIndex:0];

    NSMutableArray *foods = [NSMutableArray arrayWithCapacity:imageUrls.count];
//    for (TFHppleElement *imageUrlElement in imageUrls) {
    
    for (NSInteger index =0;index<[imageUrls count];index++){
        TFHppleElement *imageUrlElement = [imageUrls objectAtIndex:index];
        NSString *imageUrlString = [imageUrlElement objectForKey:@"src"];
        imageUrlString = [NSString stringWithFormat:@"http:%@", imageUrlString];
        
        TFHppleElement *spanElement = [spans objectAtIndex:index];
        
        Food *food = [[Food alloc] initWithName:[spanElement text] imageUrl:[NSURL URLWithString:imageUrlString] business:business];
        [foods addObject:food];
    }
    
    
    return foods;
}

@end
