//
//  EditProfileViewController.m
//  Instagram
//
//  Created by Mai Ngo on 6/28/22.
//

#import "EditProfileViewController.h"
#import "Parse/Parse.h"

@interface EditProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UITextField *bioField;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [PFUser currentUser];
    PFFileObject *image = [self.user objectForKey:@"image"];
    [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!data) {
            return NSLog(@"%@", error);
        }
        self.profileView.image = [UIImage imageWithData:data];
    }];
    self.profileView.layer.cornerRadius = self.profileView.frame.size.height/2;
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)didTapDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *bio = self.bioField.text;
    [self.user setObject:bio forKey:@"bio"];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
    }];
}
- (IBAction)didTapChange:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

@end
