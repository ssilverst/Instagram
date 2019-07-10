//
//  ProfileViewController.m
//  Instagram
//
//  Created by selinons on 7/9/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    PFUser *me = [PFUser currentUser];
    // Do any additional setup after loading the view.
    self.profileName.text = me[@"profileName"];
    self.profileDescription.text = me[@"profileDescription"];
    PFFileObject *userImageFile = me[@"profileImage"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.profileImage.image = [UIImage imageWithData:imageData];
        }
    }];
    
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
