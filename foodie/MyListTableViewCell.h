//
//  MyListTableViewCell.h
//  foodie
//
//  Created by Kwanghwi Kim on 2015. 9. 19..
//  Copyright (c) 2015년 Favorie&John. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewFood;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewRating;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelBusinessName;
@property (weak, nonatomic) IBOutlet UILabel *labelBusinessAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelBusinessDistance;
@property (weak, nonatomic) IBOutlet UILabel *labelBusinessReviews;

@end
