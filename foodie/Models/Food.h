//
//  Food.h
//  foodie
//
//  Created by Kwanghwi Kim on 2015. 9. 19..
//  Copyright (c) 2015년 Favorie&John. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Business.h"

@interface Food : NSObject
@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) Business *business;
@property (strong, nonatomic) NSString *foodieLikes;

- (instancetype)initWithName:(NSString *)name imageUrl:(NSURL *)imageUrl business:(Business *)business;

@end
