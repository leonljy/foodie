//
//  ViewController.m
//  foodie
//
//  Created by Leonljy on 2015. 9. 19..
//  Copyright (c) 2015년 Favorie&John. All rights reserved.
//

#import "ViewController.h"
#import "YPAPISample.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>


@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *foods;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _foods = [[self defaultFood] mutableCopy];

    // Do any additional setup after loading the view, typically from a nib.
    NSString *defaultTerm = @"dinner";
    NSString *defaultLocation = @"San Francisco, CA";
    
    //Get the term and location from the command line if there were any, otherwise assign default values.
    NSString *term = [[NSUserDefaults standardUserDefaults] valueForKey:@"term"] ?: defaultTerm;
    NSString *location = [[NSUserDefaults standardUserDefaults] valueForKey:@"location"] ?: defaultLocation;
    
    YPAPISample *APISample = [[YPAPISample alloc] init];
    
    dispatch_group_t requestGroup = dispatch_group_create();
    
    dispatch_group_enter(requestGroup);

    [APISample queryTopBusinessInfoForTerm:term location:location completionHandler:^(NSDictionary *topBusinessJSON, NSError *error) {
        
        if (error) {
            NSLog(@"An error happened during the request: %@", error);
        } else if (topBusinessJSON) {
            NSLog(@"Top business info: \n %@", topBusinessJSON);
        } else {
            NSLog(@"No business was found");
        }
        
        dispatch_group_leave(requestGroup);
    }];
//    
    dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER); // This avoids the program exiting before all our asynchronous callbacks have been made.
    

    
    
    
    
    
    
    // You can customize MDCSwipeToChooseView using MDCSwipeToChooseViewOptions.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.likedText = @"Keep";
    options.likedColor = [UIColor blueColor];
    options.nopeText = @"Delete";
    options.onPan = ^(MDCPanState *state){
        if (state.thresholdRatio == 1.f && state.direction == MDCSwipeDirectionLeft) {
            NSLog(@"Let go now to delete the photo!");
        }
    };
    
    
    self.frontCardView = [self popFoodViewWithFrame:[self frontCardViewFrame]];
    [self.view addSubview:self.frontCardView];


    self.backCardView = [self popFoodViewWithFrame:[self backCardViewFrame]];
    [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
}


#pragma mark View Contruction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 60.f;
    CGFloat bottomPadding = 200.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y + 10.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}


#pragma mark - Internal Methods

- (void)setFrontCardView:(ChooseFoodView *)frontCardView {
    // Keep track of the person currently being chosen.
    // Quick and dirty, just for the purposes of this sample app.
    _frontCardView = frontCardView;
    self.currentFood = frontCardView.food;
}

- (NSArray *)defaultFood {
    return @[
             [[Food alloc] initWithName:@"1" imageUrl:[NSURL URLWithString:@"http://s3-media3.fl.yelpcdn.com/bphoto/Ih1vn0z3B03NpkuXGkDdtg/o.jpg"]],
             [[Food alloc] initWithName:@"2" imageUrl:[NSURL URLWithString:@"http://s3-media2.fl.yelpcdn.com/bphoto/Q4q8sF2eOJDmSqKyK0lXXg/o.jpg"]],
             [[Food alloc] initWithName:@"3" imageUrl:[NSURL URLWithString:@"http://s3-media2.fl.yelpcdn.com/bphoto/MuKf5RGUzueAuekyFz2o-w/o.jpg"]],
             [[Food alloc] initWithName:@"4" imageUrl:[NSURL URLWithString:@"http://s3-media3.fl.yelpcdn.com/bphoto/E8ndxmLzHPUWTk9r1nyFvw/o.jpg"]],
             [[Food alloc] initWithName:@"5" imageUrl:[NSURL URLWithString:@"http://s3-media2.fl.yelpcdn.com/bphoto/8Ks7jlhGnGGkBgaLTAzmVQ/o.jpg"]],
             [[Food alloc] initWithName:@"1" imageUrl:[NSURL URLWithString:@"http://s3-media3.fl.yelpcdn.com/bphoto/Ih1vn0z3B03NpkuXGkDdtg/o.jpg"]]
             ];
}



- (ChooseFoodView *)popFoodViewWithFrame:(CGRect)frame {
    if ([self.foods count] == 0) {
        return nil;
    }
    
    // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
    // Each take an "options" argument. Here, we specify the view controller as
    // a delegate, and provide a custom callback that moves the back card view
    // based on how far the user has panned the front card view.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 80.f;
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };
    
    // Create a personView with the top person in the people array, then pop
    // that person off the stack.
    ChooseFoodView *foodView = [[ChooseFoodView alloc] initWithFrame:frame
                                                                    food:self.foods[0]
                                                                   options:options];
    [self.foods removeObjectAtIndex:0];
    return foodView;
}


#pragma mark - MDCSwipeToChooseDelegate Callbacks

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"Couldn't decide, huh?");
}

// Sent before a choice is made. Cancel the choice by returning `NO`. Otherwise return `YES`.
//- (BOOL)view:(UIView *)view shouldBeChosenWithDirection:(MDCSwipeDirection)direction {
//    if (direction == MDCSwipeDirectionLeft) {
//        return YES;
//    } else {
//        // Snap the view back and cancel the choice.
//        [UIView animateWithDuration:0.16 animations:^{
//            view.transform = CGAffineTransformIdentity;
//            view.center = [view superview].center;
//        }];
//        return NO;
//    }
//}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
    // and "LIKED" on swipes to the right.
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"You noped %@.", self.currentFood.name);
    } else {
        NSLog(@"You liked %@.", self.currentFood.name);
    }
    
    // MDCSwipeToChooseView removes the view from the view hierarchy
    // after it is swiped (this behavior can be customized via the
    // MDCSwipeOptions class). Since the front card view is gone, we
    // move the back card to the front, and create a new back card.
    self.frontCardView = self.backCardView;
    if ((self.backCardView = [self popFoodViewWithFrame:[self backCardViewFrame]])) {
        // Fade the back card into view.
        self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         } completion:nil];
    }
}

#pragma mark Control Events

// Programmatically "nopes" the front card view.
- (void)nopeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
}

// Programmatically "likes" the front card view.
- (void)likeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
