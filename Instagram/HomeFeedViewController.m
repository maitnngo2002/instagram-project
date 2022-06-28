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

@interface HomeFeedViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *posts;

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self queryDatabase];
}

- (void)queryDatabase {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"likesCount" greaterThan:@100];
    [query orderByDescending:@"createdAt"];
    
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = (NSMutableArray *) posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
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

@end
