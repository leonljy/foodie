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
        [self photoListWithID:business.businessId page:0];
    }
}



-(NSArray *)photoListWithID:(NSString *)businessId page:(NSInteger)page{
    NSString *urlString = [NSString stringWithFormat:@"%@%@?start=%lu", baseUrl, businessId, (long)page];
    NSURL *urlPhotoList = [NSURL URLWithString:urlString];
    NSData  * data      = [NSData dataWithContentsOfURL:urlPhotoList];
    
    TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:data];
    NSMutableArray *elements = [NSMutableArray arrayWithArray:[doc searchWithXPathQuery:@"//img[@class='photo-box-img']"]];
    [elements removeObjectAtIndex:0];
    
    return elements;
//    TFHppleElement * element = [elements objectAtIndex:1];
//    
//    NSLog(@"%@", [element objectForKey:@"src"]);       // Easy access to single attribute)
}

@end
