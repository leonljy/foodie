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
@property (nonatomic, strong) UILabel *labelBusinessName;
@property (nonatomic, strong) UILabel *labelReviews;
@property (nonatomic, strong) UIImageView *imageViewRating;

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

        [self.imageView setFrame:CGRectMake(0, 0, self.imageView.bounds.size.width, self.imageView.bounds.size.width)];
        
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
    CGFloat bottomHeight = 70.f;
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
    
    [self constructBusinessNameLabel];
    [self constructNameLabel];
    [self constructBusinessRating];
    [self constructReviews];
//    [self constructCameraImageLabelView];
//    [self constructInterestsImageLabelView];
//    [self constructFriendsImageLabelView];
}



- (void)constructBusinessNameLabel {
    CGFloat leftPadding = 12.f;
    CGFloat topPadding = 13.f;
    CGRect frame = CGRectMake(leftPadding,
                              topPadding,
                              floorf(CGRectGetWidth(_informationView.frame) - 110.f),
                              20.f);
    self.labelBusinessName = [[UILabel alloc] initWithFrame:frame];
    self.labelBusinessName.text = self.food.business.name;
    [_informationView addSubview:self.labelBusinessName];
}

- (void)constructBusinessRating {
    CGFloat rightPadding = 10.f;
    CGFloat topPadding = 15.f;
    
    self.imageViewRating = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_informationView.bounds) - rightPadding - 83, topPadding, 83, 15)];
    
    [self.imageViewRating sd_setImageWithURL:self.food.business.ratingImage placeholderImage:nil];
                        
    [_informationView addSubview:self.imageViewRating];
}

- (void)constructNameLabel {
    CGFloat leftPadding = 12.f;
    CGFloat topPadding = 40.f;
    CGRect frame = CGRectMake(leftPadding,
                              topPadding,
                              floorf(CGRectGetWidth(_informationView.frame) - 110.f),
                              20.f);
    _nameLabel = [[UILabel alloc] initWithFrame:frame];
    _nameLabel.text = self.food.name;
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:13];
    _nameLabel.font = font;
    _nameLabel.textColor = [UIColor redColor];
    [_informationView addSubview:_nameLabel];
}


- (void)constructReviews{
    CGFloat rightPadding = 10.f;
    CGFloat topPadding = 40.f;
    
    
    
    CGRect frame = CGRectMake(CGRectGetWidth(_informationView.bounds) - rightPadding - 83,
                              topPadding,
                              83.f,
                              20.f);
    self.labelReviews = [[UILabel alloc] initWithFrame:frame];
    self.labelReviews.text = [NSString stringWithFormat:@"%ld Reviews", self.food.business.reviewCount];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:13];
    self.labelReviews.font = font;
    [self.labelReviews setTextAlignment:NSTextAlignmentRight];
    [_informationView addSubview:self.labelReviews];
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
