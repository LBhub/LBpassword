//
//  AppDelegate.m
//  LBpassword
//
//  Created by lb on 15/10/8.
//  Copyright © 2015年 李波. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface AppDelegate ()
{
    BOOL isLogin;
}

@property (nonatomic,strong) UIView *bgView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    isLogin = NO;
     NSLog(@"....%s...",__func__);
    

    self.bgView = [[UIView alloc] initWithFrame:self.window.frame];
    self.bgView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.window addSubview:self.bgView];
    
    MainViewController *mainVC = [MainViewController new];
    self.exitDelegate = mainVC;
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    isLogin = NO;
    [self.window bringSubviewToFront:self.bgView];
    
    __weak typeof(self) weakSelf = self;
    [weakSelf.exitDelegate appWillExit];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (!isLogin) {
        [self.window bringSubviewToFront:self.bgView];
        [self authenticateUser];
    }
}


- (void)authenticateUser{
    //初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    //错误对象
    NSError* error = nil;
    NSString* result = @"Authentication is needed to access your notes.";
    
    //首先使用canEvaluatePolicy 支持指纹验证
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error){
            if (success) {
                NSLog(@"验证成功");
                __weak typeof(self) weakSelf = self;
                isLogin = YES;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [weakSelf.window sendSubviewToBack:self.bgView];
                });
                
            }
        }];
        
    }else{
        [[[UIAlertView alloc] initWithTitle:@"不支持指纹" message:@"确定" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil] show];
    }
}

@end
