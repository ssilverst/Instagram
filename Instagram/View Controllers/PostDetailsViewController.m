//
//  PostDetailsViewController.m
//  Instagram
//
//  Created by selinons on 7/8/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import "PostDetailsViewController.h"

@interface PostDetailsViewController ()

@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.captionLabel.text = self.post.caption;
    self.usernameLabel.text = self.post.author.username;
    self.likeCount.text = [[NSString stringWithFormat:@"%@", self.post.likeCount] stringByAppendingString:@"likes"];
    self.dateLabel.text = [NSString stringWithFormat:@"%@", self.post.createdAt];
    PFFileObject *userImageFile = self.post.image;
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.photo.image = [UIImage imageWithData:imageData];
        }
    }];

}
- (IBAction)goToFeed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];

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
