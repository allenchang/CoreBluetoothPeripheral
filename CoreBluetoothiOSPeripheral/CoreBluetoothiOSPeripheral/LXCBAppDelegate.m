#import "LXCBAppDelegate.h"
#import "LXCBPeripheralServer.h"
#import "LXCBViewController.h"

@interface LXCBAppDelegate () <LXCBPeripheralServerDelegate>

@property (nonatomic, strong) LXCBPeripheralServer *peripheral;
@property (nonatomic, strong) LXCBViewController *viewController;

@end

@implementation LXCBAppDelegate

- (BOOL)application:(UIApplication *)application
        didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];

  self.viewController = [[LXCBViewController alloc] init];
  self.window.rootViewController = self.viewController;

  [self.window makeKeyAndVisible];

  self.peripheral = [[LXCBPeripheralServer alloc] initWithDelegate:self];
  self.peripheral.serviceName = @"Test";
  self.peripheral.serviceUUID = [CBUUID UUIDWithString:@"7e57"];
  self.peripheral.characteristicUUID = [CBUUID UUIDWithString:@"b71e"];
  [self.peripheral startAdvertising];

  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  [self.peripheral applicationDidEnterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  [self.peripheral applicationWillEnterForeground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
  NSLog(@"Application terminating");
  // Cry for help.
  UILocalNotification *notification = [[UILocalNotification alloc] init];
  notification.alertBody = @"I'm dying!";
  notification.alertAction = @"Rescue";
  notification.fireDate = [NSDate date];
  [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark - LXCBPeripheralServerDelegate

- (void)peripheralServer:(LXCBPeripheralServer *)peripheral centralDidSubscribe:(CBCentral *)central {
  [self.peripheral sendToSubscribers:[@"Hello" dataUsingEncoding:NSUTF8StringEncoding]];
  [self.viewController centralDidConnect];
}

- (void)peripheralServer:(LXCBPeripheralServer *)peripheral centralDidUnsubscribe:(CBCentral *)central {
  [self.viewController centralDidDisconnect];

}

@end
