//
//  ChooseFoodView.h
//  foodie
//
//  Created by Kwanghwi Kim on 2015. 9. 19..
//  Copyright (c) 2015년 Favorie&John. All rights reserved.
//

#import "MDCSwipeToChooseView.h"
#import "Food.h"

@interface ChooseFoodView : MDCSwipeToChooseView

@property (nonatomic, strong, readonly) Food *food;

- (instancetype)initWithFrame:(CGRect)frame
                       food:(Food *)food
                      options:(MDCSwipeToChooseViewOptions *)options;

@end
