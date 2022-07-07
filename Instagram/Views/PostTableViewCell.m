//
//  PostTableViewCell.m
//  Instagram
//
//  Created by Mai Ngo on 6/27/22.
//

#import "PostTableViewCell.h"

@implementation PostTableViewCell

NSString static *const likeArrayKey = @"likeArray";
NSString static *const imageKey = @"image";
NSString static *const usernameKey = @"username";

-(void)setPost:(Post *)post {
    _post = post;
    self.postImage.file = post[imageKey];
    [self.postImage loadInBackground];
}
- (IBAction)didTapLike:(id)sender {
    PFUser *user = [PFUser currentUser];
    NSArray *likeArray = [[NSArray alloc] init];
    likeArray = [self.post objectForKey:likeArrayKey];
    NSString *username = [user objectForKey:usernameKey];
    if(![likeArray containsObject:username]) {
        [self.favoriteButton setSelected:YES];
        [self.post addObject:username forKey:likeArrayKey];
        [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {}];
        likeArray = [self.post objectForKey:likeArrayKey];
        NSString *likeCount = [NSString stringWithFormat:@"%lu", (unsigned long)likeArray.count];
        self.likeCount.text = likeCount;
    }
    else {
        [self.favoriteButton setSelected:NO];
        [self.post removeObject:username forKey:likeArrayKey];
        [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {}];
        likeArray = [self.post objectForKey:likeArrayKey];
        NSString *likeCount = [NSString stringWithFormat:@"%lu", (unsigned long)likeArray.count];
        self.likeCount.text = likeCount;
    }
}

@end
