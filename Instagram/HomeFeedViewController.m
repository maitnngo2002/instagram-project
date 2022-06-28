//
//  HomeFeedViewController.m
//  Instagram
//
//  Created by Mai Ngo on 6/27/22.
//

#import "HomeFeedViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ImagePickerViewController.h"
#import "PostTableViewCell.h"
#import "Post.h"
#import "DetailsViewController.h"
#import "MBProgressHUD/MBProgressHUD.h"

@interface HomeFeedViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ImagePickerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

@implementation HomeFeedViewController

-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
//    [self queryDatabase];
    [self queryDatabaseWithFilter:nil];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                         action:@selector(queryDatabase)
                         forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)queryDatabase {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    [query includeKey:@"author"];
    
//    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = (NSMutableArray *) posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        
        [self.refreshControl endRefreshing];
//        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}

- (void) queryDatabaseWithFilter:(NSDate *)lastDate {
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    if(lastDate) {
        [postQuery whereKey:@"createdAt" lessThan:lastDate];
    }
    postQuery.limit = 20;

    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if ([posts count] != 0) {
            if(lastDate){
                self.isMoreDataLoading = NO;
                [self.posts addObjectsFromArray:posts];
            }
            else {
                self.posts = (NSMutableArray *) posts;
            }
            [self.tableView reloadData];
            NSLog(@"😎😎😎 Successfully loaded home timeline");
        }
        else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"composePost"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ImagePickerViewController *imagePicker = (ImagePickerViewController *) navigationController.topViewController;
        imagePicker.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"detailsView"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *currentPost = self.posts[indexPath.row];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = currentPost;
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
    
- (IBAction)didTapLogout:(id)sender {

    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else {
            NSLog(@"Logout successful!");
        }
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        self.view.window.rootViewController = loginViewController;

    }];
}
- (IBAction)didTapCameraIcon:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ImagePickerViewController *imagePickerViewController = [storyboard instantiateViewControllerWithIdentifier:@"composePost"];
    [self presentViewController:imagePickerViewController animated:YES completion:nil];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostTableViewCell"];
    Post *post = self.posts[indexPath.row];
    cell.captionLabel.text = post.caption;
    [cell setPost:post];
    
    return cell;
}

-(void)didPost:(Post *)post {
    [self.posts insertObject:post atIndex:0];
    [self queryDatabase];
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            Post *lastPost = [self.posts lastObject];
            NSDate *lastDate = lastPost.createdAt;
            [self queryDatabaseWithFilter:lastDate];
        }
    }
}
@end
