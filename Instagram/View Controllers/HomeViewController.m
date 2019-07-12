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
#import "DateTools.h"
#import "ProfileViewController.h"
#import "InfiniteScrollActivityView.h"

@interface HomeViewController () 
@property (strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (strong, nonatomic) InfiniteScrollActivityView *loadingMoreView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont fontWithName:@"No. Seven Regular" size:21]}];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Set up Infinite Scroll loading indicator
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    self.loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    self.loadingMoreView.hidden = true;
    [self.tableView addSubview:self.loadingMoreView];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tableView.contentInset = insets;
    
    [self fetchPosts : false];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
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
- (void)homeCell:(HomeCell *) homeCell didTap: (PFUser *)user
{
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    cell.delegate = self;

    cell.profileIcon.layer.cornerRadius = cell.profileIcon.frame.size.width/2;
    cell.post = self.posts[indexPath.row];

    cell.captionLabel.text = cell.post.caption;
    cell.usernameLabel.text = cell.post.author.username;
    cell.numberOfLikes.text = [NSString stringWithFormat:@"%@", cell.post.likeCount];
    UIImage *likedIcon = [UIImage imageNamed:@"noun_Love_1842236.png"];
    UIImage *unlikedIcon = [UIImage imageNamed:@"noun_Love_1938995.png"];
    if ([cell.post.usersWhoLike containsObject:cell.post.author.username])
    {
        [cell.likeButton setImage:likedIcon forState:UIControlStateNormal];
    }
    else
    {
        [cell.likeButton setImage:unlikedIcon forState:UIControlStateNormal];
    }
    NSDate *date = cell.post.createdAt;
    NSString *timeAgoString = [NSString stringWithFormat:@"%@", date.timeAgoSinceNow];
    cell.timestampLabel.text = timeAgoString;
    PFFileObject *userImageFile = cell.post.image;
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            cell.photo.image = [UIImage imageWithData:imageData];
        }
    }];
    userImageFile = cell.post.author[@"profileImage"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            cell.profileIcon.image = [UIImage imageWithData:imageData];
        }
    }];
    return cell;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if(!self.isMoreDataLoading){

        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            // Update position of loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            self.loadingMoreView.frame = frame;
            [self.loadingMoreView startAnimating];
            [self fetchPosts: true];
        }
    }}
- (void) fetchPosts : (BOOL) addToPrevious
{
    [SVProgressHUD show];

    // construct PFQuery
    PFQuery *postQuery;
    if (addToPrevious)
    {
        Post *lastPost = self.posts[self.posts.count -1];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createdAt < %@", lastPost.createdAt];
        // construct query
        postQuery = [PFQuery queryWithClassName:@"Post" predicate:predicate];
    }
    else
    {
        postQuery = [Post query];
    }
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts.count > 0) {
            if (addToPrevious)
            {
                self.posts = [self.posts arrayByAddingObjectsFromArray:posts];
                [self.loadingMoreView stopAnimating];
                self.isMoreDataLoading = false;

            }
            else
            {
                self.posts = posts;
            }
        
            [self.tableView reloadData];

        }
        else {
            NSLog(@"no posts to show!");
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
     else if ([[segue identifier] isEqualToString:@"profileSegue"]){
         ProfileViewController *profileController = [segue destinationViewController];
         profileController.me = sender;
     }
 }

@end
