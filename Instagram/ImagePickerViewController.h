//
//  ImagePickerViewController.h
//  Instagram
//
//  Created by Mai Ngo on 6/27/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ImagePickerViewControllerDelegate <NSObject>
-(void)didPost:(Post *)post;

@end
@interface ImagePickerViewController : UIViewController
@property (weak, nonatomic) id<ImagePickerViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
