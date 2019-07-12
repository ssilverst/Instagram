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
    self.likeCount.text = [[NSString stringWithFormat:@"%@", self.post.likeCount] stringByAppendingString:@" likes"];
    UIImage *likedIcon = [UIImage imageNamed:@"noun_Love_1842236.png"];
    UIImage *unlikedIcon = [UIImage imageNamed:@"noun_Love_1938995.png"];
    PFFileObject *userImageFile = self.post.author[@"profileImage"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.profileIcon.image = [UIImage imageWithData:imageData];
            self.profileIcon.layer.cornerRadius = self.profileIcon.frame.size.width/2;
            
        }
    }];
    if ([self.post.usersWhoLike containsObject:self.post.author.username])
    {
        [self.likeButton setImage:likedIcon forState:UIControlStateNormal];
    }
    else
    {
        [self.likeButton setImage:unlikedIcon forState:UIControlStateNormal];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Configure output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    self.dateLabel.text = [formatter stringFromDate:self.post.createdAt];
    userImageFile = self.post.image;
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.photo.image = [UIImage imageWithData:imageData];
        }
    }];

}
- (IBAction)goToFeed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];

}
- (IBAction)didTapFavorite:(id)sender
{
    Boolean liked = false;
    // Update the local post model
    // setting the post to unfavorited
    PFUser *currDude = [PFUser currentUser];
    if (![self.post.usersWhoLike containsObject:currDude.username])
    {
        //update set
        [self.post addObject:currDude.username forKey:@"usersWhoLike"];
    }
    
    else
    {
        liked = true;
        //update set
        [self.post removeObject:currDude.username forKey:@"usersWhoLike"];
    }
    //update likecount
    self.post.likeCount = [NSNumber numberWithInteger:self.post.usersWhoLike.count];
    //update ui
    [self refreshData: liked];
    [self.post saveInBackground];
}

- (void) refreshData: (Boolean)liked
{
    UIImage *likedIcon = [UIImage imageNamed:@"noun_Love_1842236.png"];
    UIImage *unlikedIcon = [UIImage imageNamed:@"noun_Love_1938995.png"];
    self.likeCount.text = [[NSString stringWithFormat:@"%@", self.post.likeCount] stringByAppendingString:@" likes"];
    UIImage *chosenImage = liked ? unlikedIcon:likedIcon;
    [self.likeButton setImage:chosenImage forState:UIControlStateNormal];
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
