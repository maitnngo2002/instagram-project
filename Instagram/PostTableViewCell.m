//
//  PostTableViewCell.m
//  Instagram
//
//  Created by Mai Ngo on 6/27/22.
//

#import "PostTableViewCell.h"
#import "Parse/Parse.h"

@implementation PostTableViewCell

-(void)setPost:(Post *)post {
    _post = post;
    self.postImage.image = post[@"image"];
    [self.postImage loadInBackground];
}

@end
