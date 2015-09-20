//
//  ImageUrlHelper.h
//  foodie
//
//  Created by Leonljy on 2015. 9. 19..
//  Copyright (c) 2015년 Favorie&John. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUrlHelper : NSObject
typedef void (^CompletionHandler)(NSDictionary *dicFoods);
+ (ImageUrlHelper *)sharedInstance;
-(void)fetchPhotoListsWithBusinesses:(NSArray *)businesses completionHandler:(CompletionHandler)completionHandler;
@end
