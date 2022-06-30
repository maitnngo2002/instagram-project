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
#import "PostTableViewCell.h"
#import "ProfileViewController.h"

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
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = (NSMutableArray *) posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        
        [self.refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
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
        }
        else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"detailsView"]) {
        PostTableViewCell *tappedCell = sender;
        DetailsViewController *detailsViewController =  [segue destinationViewController];
        detailsViewController.post = tappedCell.post;
        detailsViewController.user = self.user;
    }
    else if([segue.identifier isEqualToString:@"profileSegue"]) {
        ProfileViewController *profileViewController =  [segue destinationViewController];
        profileViewController.user = sender;
    }
}
    
- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
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
    self.user = [PFUser currentUser];

    PFFileObject *image = [post.author objectForKey:@"image"];
    
    cell.userLabel1.text = post.author.username;
    cell.userLabel2.text = post.author.username;

    [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!data) {
            return NSLog(@"%@", error);
        }
        cell.profileView.image = [UIImage imageWithData:data];
    }];
    cell.profileView.layer.cornerRadius = cell.profileView.frame.size.height/2;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateFormat:@"E MMM d HH:mm:ss Z y"];
    NSDate *createdAt = [post createdAt];
    NSDate *todayDate = [NSDate date];
    double ti = [createdAt timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if (ti < 60) {
        cell.dateLabel.text = @"less than a min ago";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        cell.dateLabel.text = [NSString stringWithFormat:@"%d min ago", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        cell.dateLabel.text = [NSString stringWithFormat:@"%d hr ago", diff];
    } else {
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        cell.dateLabel.text = [formatter stringFromDate:createdAt];
    }
    return cell;
}

-(void)didPost:(Post *)post {
    [self.posts insertObject:post atIndex:0];
    [self queryDatabase];
    [self.tableView reloadData];
}

- (void)postCell:(PostTableViewCell *)postCell didTap:(PFUser *)user{
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}

@end
