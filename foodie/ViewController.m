//
//  ViewController.m
//  foodie
//
//  Created by Leonljy on 2015. 9. 19..
//  Copyright (c) 2015년 Favorie&John. All rights reserved.
//

#import "ViewController.h"
#import "YelpAPIHelper.h"
#import "TFHpple.h"
#import <CoreLocation/CoreLocation.h>
#import "Business.h"
#import "ImageUrlHelper.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

#define SEARCH_TERM @"Restaurants";

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *foods;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *businesses;
@property (strong, nonatomic) NSMutableArray *selectedFoods;
@property (weak, nonatomic) IBOutlet UILabel *labelBadge;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBadge;
@end

@implementation ViewController{
    BOOL isReceivedLocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    _foods = [[self defaultFood] mutableCopy];
    isReceivedLocation = NO;
    double latitude = 37.75855227;
    double longitude = -122.38431305;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    NSString *term = SEARCH_TERM;
    [self callYelpAPIWithCoreLocation:location term:term];
    
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
    
    
    self.selectedFoods = [NSMutableArray array];

    if (self.selectedFoods.count<1) {
        [self.imageViewBadge setAlpha:0.f];
        [self.labelBadge setAlpha:0.f];
    }
}

-(void)callYelpAPIWithCoreLocation:(CLLocation *)location term:(NSString *)term{
    
    YelpAPIHelper *APISample = [[YelpAPIHelper alloc] init];
    [APISample queryTopBusinessInfoForTerm:term coreLocation:location completionHandler:^(NSArray *businesses, NSError *error) {
        
        if (error) {
            NSLog(@"An error happened during the request: %@", error);
        } else if ([businesses count] > 0) {
            NSLog(@"Businesses: \n %@", businesses);
            self.businesses = [NSMutableArray arrayWithCapacity:[businesses count]];
            for(NSDictionary *dicBusiness in businesses){
                Business *business = [Business initWithDic:dicBusiness];
                [self.businesses addObject:business];
            }
            ImageUrlHelper *imageUrlHelper = [ImageUrlHelper sharedInstance];
            [imageUrlHelper fetchPhotoListsWithBusinesses:self.businesses];
            
            self.foods = [NSMutableArray array];
            for (Business *business in self.businesses) {
                [self.foods addObject:business.foods.firstObject];
            }

            
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.frontCardView = [self popFoodViewWithFrame:[self frontCardViewFrame]];
                [self.view addSubview:self.frontCardView];
                
                self.backCardView = [self popFoodViewWithFrame:[self backCardViewFrame]];
                [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
            });
            
            
            
        } else {
            NSLog(@"No business was found");
        }
        
        
    }];
}

#pragma mark View Contruction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 30.f;
    CGFloat bottomPadding = 200.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      350.f);
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
        [self.selectedFoods addObject:self.currentFood];
        self.labelBadge.text = [NSString stringWithFormat:@"%ld", self.selectedFoods.count];
        [self.imageViewBadge setAlpha:1.f];
        [self.labelBadge setAlpha:1.f];
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

#pragma mark - Control Events

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

#pragma mark - Handle Events
- (IBAction)handleLike:(id)sender {
    [self likeFrontCardView];
}
- (IBAction)handleNope:(id)sender {
    [self nopeFrontCardView];
}
- (IBAction)handleMyList:(id)sender {
    
}
- (IBAction)handleClearList:(id)sender {
    [self.selectedFoods removeAllObjects];
    [self.imageViewBadge setAlpha:0.f];
    [self.labelBadge setAlpha:0.f];
}

@end
