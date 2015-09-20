//
//  Food.h
//  foodie
//
//  Created by Kwanghwi Kim on 2015. 9. 19..
//  Copyright (c) 2015년 Favorie&John. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Food : NSObject
@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) NSString *name;

- (instancetype)initWithName:(NSString *)name imageUrl:(NSURL *)imageUrl;

@end
