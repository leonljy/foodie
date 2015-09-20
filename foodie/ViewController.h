//
//  ViewController.h
//  foodie
//
//  Created by Leonljy on 2015. 9. 19..
//  Copyright (c) 2015년 Favorie&John. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MDCSwipeToChooseDelegate.h>
#import "ChooseFoodView.h"
#import "Food.h"

@interface ViewController : UIViewController <MDCSwipeToChooseDelegate>

@property (nonatomic, strong) Food *currentFood;
@property (nonatomic, strong) ChooseFoodView *frontCardView;
@property (nonatomic, strong) ChooseFoodView *backCardView;
@end

