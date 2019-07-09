//
//  HomeViewController.m
//  Instagram
//
//  Created by selinons on 7/7/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import "Post.h"
#import "HomeCell.h"
#import "SVProgressHUD.h"
#import "PostDetailsViewController.h"

@interface HomeViewController () 
@property (strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self fetchPosts];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    // Do any additional setup after loading the view.
}

- (IBAction)logout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    Post *post = self.posts[indexPath.row];
    

    cell.captionLabel.text = post.caption;
    cell.usernameLabel.text = post.author.username;
    cell.numberOfLikes.text = [NSString stringWithFormat:@"%@", post.likeCount];
    PFFileObject *userImageFile = post.image;
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            cell.photo.image = [UIImage imageWithData:imageData];
        }
    }];
    return cell;
    
}

- (void) fetchPosts
{
    // construct PFQuery
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.posts = posts;
            [self.tableView reloadData];

        }
        else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
        [SVProgressHUD dismiss];
    }];
}



 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([[segue identifier] isEqualToString:@"detailsSegue"]) {
         HomeCell *tappedCell = sender;
         NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
         Post *post = self.posts[indexPath.row];
         UINavigationController *navigationController = [segue destinationViewController];
         PostDetailsViewController *deetController = (PostDetailsViewController *)navigationController.topViewController;
         deetController.post = post;
     }
 }

@end
