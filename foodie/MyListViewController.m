//
//  MyListViewController.m
//  foodie
//
//  Created by Kwanghwi Kim on 2015. 9. 19..
//  Copyright (c) 2015년 Favorie&John. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "MyListViewController.h"
#import "MyListTableViewCell.h"
#import "Food.h"
#import "DetailViewController.h"

@interface MyListViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation MyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.selectedFoods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MY_LIST_TABLE_VIEW_CELL"];
    
    Food *food = [self.selectedFoods objectAtIndex:indexPath.row];
    [cell.imageViewFood sd_setImageWithURL:food.imageUrl placeholderImage:nil];
    [cell.labelBusinessName setText:food.business.name];
    [cell.labelBusinessDistance setText:[NSString stringWithFormat:@"%.2lf mi",food.business.distance]];
    [cell.imageViewRating sd_setImageWithURL:food.business.ratingImage placeholderImage:nil];
    [cell.labelBusinessReviews setText:[NSString stringWithFormat:@"%ld Reviews", food.business.reviewCount]];
    NSArray *addresses = [food.business.locationInfo objectForKey:@"display_address"];
    [cell.labelBusinessAddress setText:[NSString stringWithFormat:@"%@, %@", addresses[0], addresses[1]]];
    
    food.foodieLikes = [NSString stringWithFormat:@"%d likes",arc4random_uniform(500)];
    [cell.labelFoodieLike setText:food.foodieLikes];
    
    
    [cell.labelName setText:food.name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Food *food = [self.selectedFoods objectAtIndex:indexPath.row];
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DETAIL_VIEW_CONTROLLER"];
    detailViewController.food = food;
    [self.navigationController pushViewController:detailViewController animated:YES];
}


- (IBAction)handleBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
