//
//  ImagePickerViewController.m
//  Instagram
//
//  Created by Mai Ngo on 6/27/22.
//

#import "ImagePickerViewController.h"
#import "Post.h"

@interface ImagePickerViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *captionField;

@end

@implementation ImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self pickImage];
}

-(void) viewWillAppear:(BOOL)animated {
    self.captionField.text = @"";
    self.navigationItem.rightBarButtonItem.enabled = [self equalsPlaceholder:self.imageView.image];
}

- (BOOL)equalsPlaceholder:(UIImage *)image2 {
    NSData *data1 = UIImagePNGRepresentation([UIImage imageNamed:@"image_placeholder"]);
    NSData *data2 = UIImagePNGRepresentation(image2);

    return !([data1 isEqual:data2]);
}

- (IBAction)onImageTap:(id)sender {
    [self pickImage];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    if (originalImage) {
        CGSize size = CGSizeMake(400, 400);
        self.imageView.image = [self resizeImage:originalImage withSize:size];
        self.navigationItem.rightBarButtonItem.enabled = [self equalsPlaceholder:originalImage];
    }
    else if (editedImage) {
        CGSize size = CGSizeMake(400, 400);
        self.imageView.image = [self resizeImage:originalImage withSize:size];
        self.navigationItem.rightBarButtonItem.enabled = [self equalsPlaceholder:editedImage];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pickImage {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)onShareTap:(id)sender {
    [Post postUserImage:self.imageView.image withCaption:self.captionField.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else {
            NSLog(@"Post successful!");
            Post *newPost = [Post createPost:self.imageView.image withCaption:self.captionField.text];
            [self.delegate didPost:newPost];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)onCancelTap:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
