//
//  ChooseFoodView.m
//  foodie
//
//  Created by Kwanghwi Kim on 2015. 9. 19..
//  Copyright (c) 2015년 Favorie&John. All rights reserved.
//

#import "ChooseFoodView.h"
#import "ImageLabelView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ChooseFoodView()
@property (nonatomic, strong) UIView *informationView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) ImageLabelView *cameraImageLabelView;
@property (nonatomic, strong) ImageLabelView *interestsImageLabelView;
@property (nonatomic, strong) ImageLabelView *friendsImageLabelView;
@end

@implementation ChooseFoodView

#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
                       food:(id)food
                      options:(MDCSwipeToChooseViewOptions *)options {
    self = [super initWithFrame:frame options:options];
    if (self) {
        _food = food;
        NSLog(@"%@", _food.imageUrl);
        [self.imageView sd_setImageWithURL:_food.imageUrl placeholderImage:nil];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleBottomMargin;
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        self.imageView.autoresizingMask = self.autoresizingMask;
        
        [self constructInformationView];
    }
    return self;
}

#pragma mark - Internal Methods

- (void)constructInformationView {
    CGFloat bottomHeight = 60.f;
    CGRect bottomFrame = CGRectMake(0,
                                    CGRectGetHeight(self.bounds) - bottomHeight,
                                    CGRectGetWidth(self.bounds),
                                    bottomHeight);
    _informationView = [[UIView alloc] initWithFrame:bottomFrame];
    _informationView.backgroundColor = [UIColor whiteColor];
    _informationView.clipsToBounds = YES;
    _informationView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_informationView];
    
    [self constructNameLabel];
//    [self constructCameraImageLabelView];
//    [self constructInterestsImageLabelView];
//    [self constructFriendsImageLabelView];
}

- (void)constructNameLabel {
    CGFloat leftPadding = 12.f;
    CGFloat topPadding = 17.f;
    CGRect frame = CGRectMake(leftPadding,
                              topPadding,
                              floorf(CGRectGetWidth(_informationView.frame)/2),
                              CGRectGetHeight(_informationView.frame) - topPadding);
    _nameLabel = [[UILabel alloc] initWithFrame:frame];
//    _nameLabel.text = [NSString stringWithFormat:@"%@, %@", @"FoodName", @"FoodAge"];
    _nameLabel.text = self.food.name;
    [_informationView addSubview:_nameLabel];
}

//- (void)constructCameraImageLabelView {
//    CGFloat rightPadding = 10.f;
//    UIImage *image = [UIImage imageNamed:@"camera"];
//    _cameraImageLabelView = [self buildImageLabelViewLeftOf:CGRectGetWidth(_informationView.bounds) - rightPadding
//                                                      image:image
//                                                       text:[@(_person.numberOfPhotos) stringValue]];
//    [_informationView addSubview:_cameraImageLabelView];
//}
//
//- (void)constructInterestsImageLabelView {
//    UIImage *image = [UIImage imageNamed:@"book"];
//    _interestsImageLabelView = [self buildImageLabelViewLeftOf:CGRectGetMinX(_cameraImageLabelView.frame)
//                                                         image:image
//                                                          text:[@(_person.numberOfPhotos) stringValue]];
//    [_informationView addSubview:_interestsImageLabelView];
//}
//
//- (void)constructFriendsImageLabelView {
//    UIImage *image = [UIImage imageNamed:@"group"];
//    _friendsImageLabelView = [self buildImageLabelViewLeftOf:CGRectGetMinX(_interestsImageLabelView.frame)
//                                                       image:image
//                                                        text:[@(_person.numberOfSharedFriends) stringValue]];
//    [_informationView addSubview:_friendsImageLabelView];
//}

//- (ImageLabelView *)buildImageLabelViewLeftOf:(CGFloat)x image:(UIImage *)image text:(NSString *)text {
//    CGRect frame = CGRectMake(x - ChoosePersonViewImageLabelWidth,
//                              0,
//                              ChoosePersonViewImageLabelWidth,
//                              CGRectGetHeight(_informationView.bounds));
//    ImageLabelView *view = [[ImageLabelView alloc] initWithFrame:frame
//                                                           image:image
//                                                            text:text];
//    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//    return view;
//}


@end
