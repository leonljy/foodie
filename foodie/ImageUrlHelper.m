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
        business.foods = [self foodsWithID:business.businessId page:0];
    }
}



-(NSArray *)foodsWithID:(NSString *)businessId page:(NSInteger)page{
    NSString *urlString = [NSString stringWithFormat:@"%@%@?start=%lu", baseUrl, businessId, (long)page];
    NSURL *urlPhotoList = [NSURL URLWithString:urlString];
    NSData  * data      = [NSData dataWithContentsOfURL:urlPhotoList];
    
    TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:data];
    NSMutableArray *imageUrls = [NSMutableArray arrayWithArray:[doc searchWithXPathQuery:@"//img[@class='photo-box-img']"]];
//    NSMutableArray *names = [NSMutableArray arrayWithArray:[doc searchWithXPathQuery:@"//div[@class='photo-box-overlay_caption']"]];
    [imageUrls removeObjectAtIndex:0];

    
    NSMutableArray *foods = [NSMutableArray arrayWithCapacity:imageUrls.count];
    for (TFHppleElement *imageUrlElement in imageUrls) {
        NSString *imageUrlString = [imageUrlElement objectForKey:@"src"];
        imageUrlString = [NSString stringWithFormat:@"http:%@", imageUrlString];
        Food *food = [[Food alloc] initWithName:@"" imageUrl:[NSURL URLWithString:imageUrlString]];
        [foods addObject:food];
    }
    
    
    return foods;
//    TFHppleElement * element = [elements objectAtIndex:1];
//    
//    NSLog(@"%@", [element objectForKey:@"src"]);       // Easy access to single attribute)
}

@end
