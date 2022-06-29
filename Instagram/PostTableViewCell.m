//
//  PostTableViewCell.m
//  Instagram
//
//  Created by Mai Ngo on 6/27/22.
//

#import "PostTableViewCell.h"
#import "Parse/Parse.h"
@import Parse;

@implementation PostTableViewCell

-(void)setPost:(Post *)post {
    _post = post;
    self.postImage.file = post[@"image"];
    [self.postImage loadInBackground];
    
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profileView addGestureRecognizer:profileTapGestureRecognizer];
    [self.profileView setUserInteractionEnabled:YES];
}
- (IBAction)didTapLike:(id)sender {
    PFUser *user = [PFUser currentUser];
    NSArray *likeArray = [[NSArray alloc] init];
    likeArray = [self.post objectForKey:@"likeArray"];
    NSString *username = [user objectForKey:@"username"];
    if(![likeArray containsObject:username]) {
        [self.favoriteButton setSelected:YES];
        [self.post addObject:username forKey:@"likeArray"];
        [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        }];
        likeArray = [self.post objectForKey:@"likeArray"];
        NSString *likeCount = [NSString stringWithFormat:@"%lu", (unsigned long)likeArray.count];
        self.likeCount.text = likeCount;
    }
    else {
        [self.favoriteButton setSelected:NO];
        [self.post removeObject:username forKey:@"likeArray"];
        [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        }];
        likeArray = [self.post objectForKey:@"likeArray"];
        NSString *likeCount = [NSString stringWithFormat:@"%lu", (unsigned long)likeArray.count];
        self.likeCount.text = likeCount;
    }

}

//- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
//    [self.delegate postCell:self didTap:self.post.author];
//}
@end
