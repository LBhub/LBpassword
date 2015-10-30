//
//  EditViewController.h
//  LBpassword
//
//  Created by lb on 15/10/9.
//  Copyright © 2015年 李波. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditEndDelegate <NSObject>

-(void)getTextArray:(NSArray *)textArray WithIndex:(int)index;

@end

@interface EditViewController : UIViewController

@property (nonatomic,assign) int index;
@property (nonatomic,strong) NSMutableArray *data;
@property id <EditEndDelegate>editDelegate;


@end
