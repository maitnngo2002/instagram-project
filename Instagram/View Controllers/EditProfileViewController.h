//
//  EditProfileViewController.h
//  Instagram
//
//  Created by Mai Ngo on 6/28/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditProfileViewController : UIViewController
@property (strong, nonatomic) PFUser *user;

@end

NS_ASSUME_NONNULL_END
