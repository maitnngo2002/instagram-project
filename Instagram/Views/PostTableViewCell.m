//
//  PostTableViewCell.m
//  Instagram
//
//  Created by Mai Ngo on 6/27/22.
//

#import "PostTableViewCell.h"

@implementation PostTableViewCell

-(void)setPost:(Post *)post {
    _post = post;
    self.postImage.file = post[@"image"];
    [self.postImage loadInBackground];
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

@end
