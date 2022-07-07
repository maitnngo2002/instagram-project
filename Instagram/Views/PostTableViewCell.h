//
//  PostTableViewCell.h
//  Instagram
//
//  Created by Mai Ngo on 6/27/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "PostTableViewCell.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@protocol PostTableViewCellDelegate;

@interface PostTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel1;
@property (weak, nonatomic) IBOutlet UILabel *userLabel2;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) Post *post;
@property (nonatomic, weak) id<PostTableViewCellDelegate> delegate;

@end

@protocol PostTableViewCellDelegate

- (void)postTableViewCell:(PostTableViewCell *)postTableViewCell didTap: (PFUser *)user;

@end

NS_ASSUME_NONNULL_END
