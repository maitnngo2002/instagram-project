//
//  AppDelegate.m
//  Instagram
//
//  Created by Mai Ngo on 6/27/22.
//

#import "AppDelegate.h"
#import "Parse/Parse.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {

            configuration.applicationId = @"5kacCYAUB3bct8qhxZwmQ9QVn8derr8OJI5UiAjH";
            configuration.clientKey = @"wPVxVUseDeQGRHGl2NT64uSlPv5iGgrxdGqpwjXN";
            configuration.server = @"https://parseapi.back4app.com";
        }];

    [Parse initializeWithConfiguration:config];
    return YES;
}

@end
