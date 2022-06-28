//
//  DetailsViewController.h
//  Instagram
//
//  Created by Mai Ngo on 6/27/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (strong, nonatomic) Post *post;

@end

NS_ASSUME_NONNULL_END
