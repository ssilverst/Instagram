//
//  HomeViewController.h
//  Instagram
//
//  Created by selinons on 7/7/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController <HomeCellDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIScrollViewDelegate>

@end

NS_ASSUME_NONNULL_END
