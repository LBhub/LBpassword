//
//  AppDelegate.h
//  LBpassword
//
//  Created by lb on 15/10/8.
//  Copyright © 2015年 李波. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AppWillExitDelegate <NSObject>

- (void)appWillExit;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) id <AppWillExitDelegate> exitDelegate;

@end

