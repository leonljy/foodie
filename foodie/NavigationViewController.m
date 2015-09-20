//
//  NavigationViewController.m
//  foodie
//
//  Created by Kwanghwi Kim on 2015. 9. 20..
//  Copyright (c) 2015년 Favorie&John. All rights reserved.
//

#import "NavigationViewController.h"
#import "MessagesViewController.h"
#import <MMX.h>

@interface NavigationViewController () <UIAlertViewDelegate>

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated{
    // Indicate that you are ready to receive messages now!
    [MMX enableIncomingMessages];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMessage:)
                                                 name:MMXDidReceiveMessageNotification
                                               object:nil];
}

- (void)didReceiveMessage:(NSNotification *)notification {
    MMXMessage *message = notification.userInfo[MMXMessageKey];
    NSString *messageString = [message.messageContent objectForKey:@"message"];
    if ([messageString isEqualToString:@"Invite"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Invitation" message:@"Let's go together" delegate:self cancelButtonTitle:@"Nope" otherButtonTitles:@"OK", nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    } else {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        MessagesViewController *messagesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MESSAGES_VIEW_CONTROLLER"];
        [self pushViewController:messagesViewController animated:YES];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:(BOOL)animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
