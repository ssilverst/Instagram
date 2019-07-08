//
//  HomeCell.h
//  Instagram
//
//  Created by selinons on 7/8/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Post.h"

@interface HomeCell : UITableViewCell

@property (strong, nonatomic) IBOutlet PFFileObject *photoImageView;
@property (strong, nonatomic) Post *post;

@end

