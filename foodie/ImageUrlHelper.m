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

@interface ImageUrlHelper()
@property (strong, nonatomic) NSMutableDictionary *dicFoods;

@end
static ImageUrlHelper *instance;
static NSString *baseUrl = @"http://www.yelp.com/biz_photos/";
@implementation ImageUrlHelper{
    NSInteger businessCount;
    NSInteger indexBusiness;
}
+ (ImageUrlHelper *)sharedInstance{
    if(nil==instance){
        instance = [[ImageUrlHelper alloc] init];
    }
    
    return instance;
}


-(void)fetchPhotoListsWithBusinesses:(NSArray *)businesses completionHandler:(CompletionHandler)completionHandler{
    businessCount = [businesses count];
    indexBusiness=0;
    self.dicFoods = [NSMutableDictionary dictionary];
    
    dispatch_queue_t queue = dispatch_queue_create("com.foodie", DISPATCH_QUEUE_CONCURRENT);
    
    for(Business *business in businesses){
        dispatch_async(queue, ^{
            NSString *urlString = [NSString stringWithFormat:@"%@%@?start=%d", baseUrl, business.businessId, 0];
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
            [self.dicFoods setObject:foods forKey:business.businessId];
            
            indexBusiness++;
            if(indexBusiness==businessCount){
//                dispatch_release(queue);
                completionHandler(self.dicFoods);
            }
        });
    }
}



-(void)foodsWithID:(Business *)business page:(NSInteger)page{
    //    return foods;
}

@end
