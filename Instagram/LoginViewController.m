//
//  LoginViewController.m
//  Instagram
//
//  Created by Mai Ngo on 6/27/22.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)onTapRegister:(id)sender {
    [self registerUser];
}
- (IBAction)onTapLogin:(id)sender {
    [self loginUser];
}
- (void)registerUser {
    PFUser *newUser = [PFUser user];
    
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");

            // manually segue to logged in view
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            self.usernameField.text = @"";
            self.passwordField.text = @"";
        }
    }];
}
- (void)loginUser {
    if ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""] ) {
        [self showAlert:@""];
        return;
    }
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [self showAlert:error.localizedDescription];
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

-(void)showAlert:(NSString *) errorString {
    UIAlertController *alert;
   
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    if ([errorString isEqual:@""]) {
        alert = [UIAlertController alertControllerWithTitle:@"Missing Fields"
                                                    message:@"Username or/and password field empty, try again."
                                             preferredStyle:(UIAlertControllerStyleAlert)];
        [alert addAction:cancelAction];
    }
    else {
        alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                    message:errorString
                                             preferredStyle:(UIAlertControllerStyleAlert)];
        [alert addAction:okAction];
    }
    
    [self presentViewController:alert animated:YES completion:^{
        NSLog(@"Finished presenting alert");
    }];
}

@end
