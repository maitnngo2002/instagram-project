//
//  DetailsViewController.m
//  Instagram
//
//  Created by Mai Ngo on 6/27/22.
//

#import "DetailsViewController.h"
#import "Post.h"
#import "NSDate+DateTools.h"
@import Parse;

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.postImageView.file = self.post.image;
    [self.postImageView loadInBackground];
    self.captionLabel.text = self.post.caption;
    self.usernameLabel.text = self.post.author.username;
    self.dateLabel.text = [self.post.createdAt shortTimeAgoSinceNow];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
