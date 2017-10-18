//
//  AppDelegate.m
//  onesignalpoc
//

#import "AppDelegate.h"
#import <OneSignal/OneSignal.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Plot initializeWithLaunchOptions:launchOptions delegate:self];
    [OneSignal initWithLaunchOptions:launchOptions
                               appId:@"YOUR_ID"
            handleNotificationAction:nil
                            settings:@{kOSSettingsKeyAutoPrompt: @false}];
    OneSignal.inFocusDisplayType = OSNotificationDisplayTypeNotification;

    [OneSignal promptForPushNotificationsWithUserResponse:^(BOOL accepted) {
        NSLog(@"User accepted notifications: %d", accepted);
    }];
    return YES;
}
    
- (void)plotHandleGeotriggers:(PlotHandleGeotriggers*)geotriggerHandler {
        for (PlotGeotrigger* geotrigger in geotriggerHandler.geotriggers) {
            NSString* jsonString = [geotrigger.userInfo objectForKey:PlotGeotriggerDataKey];
            NSData *dataJson = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary * data = [NSJSONSerialization JSONObjectWithData:dataJson options:0 error:NULL];
            NSString *now = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]];
            NSString* key = [data objectForKey:@"key"];
            if (key){
                [OneSignal sendTag:key value:now];
                NSLog(@"Sending tag pair:(%@,%@)",key,now);
            }
        }
        [geotriggerHandler markGeotriggersHandled:geotriggerHandler.geotriggers];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
