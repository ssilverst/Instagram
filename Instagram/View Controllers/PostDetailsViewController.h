//
//  PostDetailsViewController.h
//  Instagram
//
//  Created by selinons on 7/8/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UIImageView *profileIcon;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) Post *post;
@end

NS_ASSUME_NONNULL_END
