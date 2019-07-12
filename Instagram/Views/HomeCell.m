//
//  HomeCell.m
//  Instagram
//
//  Created by selinons on 7/8/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import "HomeCell.h"
#import "Parse/Parse.h"

@implementation HomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profileIcon addGestureRecognizer:profileTapGestureRecognizer];
    [self.profileIcon setUserInteractionEnabled:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    [self.delegate homeCell:self didTap:self.post.author];
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
    self.numberOfLikes.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
    UIImage *chosenImage = liked ? unlikedIcon:likedIcon;
    [self.likeButton setImage:chosenImage forState:UIControlStateNormal];
}

@end
