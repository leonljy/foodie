//
//  Food.m
//  foodie
//
//  Created by Kwanghwi Kim on 2015. 9. 19..
//  Copyright (c) 2015년 Favorie&John. All rights reserved.
//

#import "Food.h"

@implementation Food

- (instancetype)initWithName:(NSString *)name imageUrl:(NSURL *)imageUrl{
    self = [super init];
    if (self) {
        self.name = name;
        self.imageUrl = imageUrl;
    }
    return self;
}

@end
