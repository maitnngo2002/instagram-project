//
//  SceneDelegate.m
//  Instagram
//
//  Created by Mai Ngo on 6/27/22.
//

#import "SceneDelegate.h"
#import "Parse/Parse.h"

@interface SceneDelegate ()

@end

NSString *const homeFeedViewController = @"HomeFeedViewController";

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    if (PFUser.currentUser) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

            self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:homeFeedViewController];
    }
}
@end
