//
//  EditViewController.h
//  Instagram
//
//  Created by selinons on 7/9/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextView *bioView;
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (strong, nonatomic) UIImage *selectedPhoto;

@end

NS_ASSUME_NONNULL_END
