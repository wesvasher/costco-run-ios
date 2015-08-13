//
//  SCViewController.m
//  CostcoRun
//
//  Created by Wesley Vasher on 8/12/15.
//  Copyright (c) 2015 Stratos Technologies, Inc. All rights reserved.
//

#import "SCViewController.h"
#import <AFNetworking/AFNetworking.h>

@implementation SCViewController

- (IBAction)didTapStringCheeseButton:(id)sender {
    [self postItemWithNameToSlack:@"string cheese"];
}

- (IBAction)didTapPerrierButton:(id)sender {
    [self postItemWithNameToSlack:@"Perrier"];
}

- (IBAction)didTapWhiskeyButton:(id)sender {
    [self postItemWithNameToSlack:@"whiskey"];
}

- (void)postItemWithNameToSlack:(NSString *)itemName {
    NSString *slackPostURLString = [[NSUserDefaults standardUserDefaults] stringForKey:@"slackPostURLString"];
    
    if (!slackPostURLString) {
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:@"Error"
                                            message:@"Please enter a Slack Webhook URL in the Settings App."
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:NULL]];
        
        [self presentViewController:alertController animated:YES completion:NULL];
    }
    else {
        AFHTTPSessionManager *serializer = [AFHTTPSessionManager new];
        serializer.requestSerializer = [AFJSONRequestSerializer new];
        
        [serializer
         POST:slackPostURLString
         parameters:@{@"text": [NSString stringWithFormat:@"@ashleigh: we're out of %@", itemName]}
         success:^(NSURLSessionDataTask *task, id responseObject) {
             
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             if ([[NSString stringWithUTF8String:[error.userInfo[@"com.alamofire.serialization.response.error.data"] bytes]] isEqualToString:@"ok"]) {
                 UIAlertController *alertController =
                 [UIAlertController alertControllerWithTitle:@"Success"
                                                     message:@"We let her know!"
                                              preferredStyle:UIAlertControllerStyleAlert];
                 
                 [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:NULL]];
                 
                 [self presentViewController:alertController animated:YES completion:NULL];
             }
             // TODO: Handle failure
             else {
                 NSLog(@"Failure");
             }
         }];
    }
}

@end
