//
//  PostTableViewCell.h
//  Instagram
//
//  Created by Mai Ngo on 6/27/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@property (strong, nonatomic) Post *post;
@end

NS_ASSUME_NONNULL_END
