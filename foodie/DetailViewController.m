//
//  DetailViewController.m
//  foodie
//
//  Created by Kwanghwi Kim on 2015. 9. 20..
//  Copyright (c) 2015년 Favorie&John. All rights reserved.
//

#import "DetailViewController.h"
#import <MapKit/MapKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MMX/MMX.h>

#define METERS_PER_MILE 1609.344


@interface DetailViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewFood;
@property (weak, nonatomic) IBOutlet UILabel *labelBusinessName;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewRating;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelFoodName;
@property (weak, nonatomic) IBOutlet UILabel *labelDistance;
@property (weak, nonatomic) IBOutlet UILabel *labelReviews;
@property (weak, nonatomic) IBOutlet UILabel *labelFoodieLikes;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [_imageViewFood sd_setImageWithURL:_food.imageUrl placeholderImage:nil];
    [_labelBusinessName setText:_food.business.name];
    [_imageViewRating sd_setImageWithURL:_food.business.ratingImage placeholderImage:nil];
    NSArray *addresses = [_food.business.locationInfo objectForKey:@"display_address"];
    [_labelAddress setText:[NSString stringWithFormat:@"%@, %@", addresses[0], addresses[1]]];
    [_labelFoodName setText:_food.name];
    [_labelDistance setText:[NSString stringWithFormat:@"%.2lf mi",_food.business.distance]];
    [_labelReviews setText:[NSString stringWithFormat:@"%ld Reviews", _food.business.reviewCount]];
    
    [_labelFoodieLikes setText:_food.foodieLikes];
    
    
    
    
    NSDictionary *coordinate = self.food.business.locationInfo[@"coordinate"];
    double latitude = [coordinate[@"latitude"] doubleValue];
    double longitude = [coordinate[@"longitude"] doubleValue];
    

    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = latitude;
    zoomLocation.longitude= longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    [_mapView setRegion:viewRegion animated:YES];
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    [_mapView addAnnotation:point];

}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKAnnotationView *annView = [[MKAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    annView.image = [ UIImage imageNamed:@"imgMap" ];
    annView.canShowCallout = YES;
    return annView;
}


//// Add the following method
//- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
//    MyLocation *location = (MyLocation*)view.annotation;
//    
//    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
//    [location.mapItem openInMapsWithLaunchOptions:launchOptions];
//}

- (IBAction)handleBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)handleGoWithFriends:(id)sender {
    [MMXUser findByDisplayName:@"J" limit:20 offset:0 success:^(int totalCount, NSArray *users) {
        NSLog(@"%@", users);
        MMXMessage *message = [MMXMessage messageToRecipients:[NSSet setWithArray:users] messageContent:@{@"message": @"Invite"}];
        [message sendWithSuccess:^{
            NSLog(@"Success");
        } failure:^(NSError *error) {
            NSLog(@"Failure");
        }];
    } failure:^(NSError *error) {
        
    }];
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
