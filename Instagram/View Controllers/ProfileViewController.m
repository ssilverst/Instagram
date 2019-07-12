//
//  ProfileViewController.m
//  Instagram
//
//  Created by selinons on 7/9/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "PostCell.h"
#import "Post.h"
#import "SVProgressHUD.h"
#import "PostDetailsViewController.h"

@interface ProfileViewController ()
@property (strong, nonatomic) NSArray *posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UICollectionView *profilePostsView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.me == nil)
    {
        self.me = [PFUser currentUser];
    }
    else
    {
        self.editButton.hidden = YES;

    }

    self.profilePostsView.dataSource = self;
    self.profilePostsView.delegate = self;
    [self fetchPosts];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.profilePostsView insertSubview:self.refreshControl atIndex:0];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if (self.me == nil)
    {
        self.me = [PFUser currentUser];
    }
    // Do any additional setup after loading the view.
    self.profileName.text = self.me[@"profileName"];
    self.profileDescription.text = self.me[@"profileDescription"];
    self.profileUsername.text = self.me.username;
    PFFileObject *userImageFile = self.me[@"profileImage"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.profileImage.image = [UIImage imageWithData:imageData];
            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;

        }
    }];
    [self fetchPosts];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCell" forIndexPath:indexPath];
    Post *post = self.posts[indexPath.row];
    PFFileObject *userImageFile = post.image;
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            cell.postView.image = [UIImage imageWithData:imageData];
        }
    }];
    return cell;
}
- (void) fetchPosts
{
    [SVProgressHUD show];

    // construct PFQuery
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery whereKey:@"author" equalTo:self.me];

    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.posts = posts;
            [self.profilePostsView reloadData];
            
        }
        else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
        [SVProgressHUD dismiss];
    }];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;

}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([[segue identifier] isEqualToString:@"detailsSegue"]) {
         PostCell *tappedCell = sender;
         NSIndexPath *indexPath = [self.profilePostsView indexPathForCell:tappedCell];
         Post *post = self.posts[indexPath.row];
         UINavigationController *navigationController = [segue destinationViewController];
         PostDetailsViewController *deetController = (PostDetailsViewController *)navigationController.topViewController;
         deetController.post = post;
     }
 }



@end
