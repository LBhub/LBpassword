//
//  EditViewController.m
//  LBpassword
//
//  Created by lb on 15/10/9.
//  Copyright © 2015年 李波. All rights reserved.
//

#import "EditViewController.h"
#import "MainViewController.h"

#define  MAINSIZE [UIScreen mainScreen].bounds.size
#define TFTAG 500

@interface EditViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *autoBtn;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    [self addSubView];
}

- (void)addSubView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
    [self.view addSubview:self.tableView];
    
    self.autoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    self.autoBtn.backgroundColor = [UIColor clearColor];
    [self.autoBtn setTitle:@"+" forState:(UIControlStateNormal)];
    [self.autoBtn.titleLabel setFont:[UIFont fontWithName:self.autoBtn.titleLabel.font.fontName size:30]];
    [self.autoBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [self.autoBtn addTarget:self action:@selector(autoSetName) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController class] ==  [MainViewController class]) {
        [self back];
    }
}

- (void)autoSetName{
    UITextField *tf = (UITextField *)[self.view viewWithTag:TFTAG + 1];
    tf.text = @"717071242@qq.com";
    [self.data replaceObjectAtIndex:1 withObject:tf.text];
}

- (void)back{
    __weak  typeof(self) weakSelf = self;
    [weakSelf.editDelegate getTextArray:weakSelf.data WithIndex:self.index];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *arr = @[@"账号描述",@"账号名",@"密码"];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:nil];
    if (indexPath.section == 1 && indexPath.row == 0) {
         cell.accessoryView = self.autoBtn;
    }
   
    if (indexPath.row == 0) {
        cell.textLabel.text = arr[indexPath.section];
        cell.textLabel.textColor = [UIColor grayColor];
    }else{
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(13, 0, MAINSIZE.width, 44)];
        tf.tag = TFTAG + indexPath.section;
        tf.text = self.data[indexPath.section];
        tf.delegate = self;
        [cell.contentView addSubview:tf];
    }
    return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    int index = (int)textField.tag - TFTAG;
    
    if (index >= 1) {
         [self.tableView setContentOffset:CGPointMake(0, 50 * index) animated:YES];
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    int index = (int)textField.tag - TFTAG;
    [self.tableView setContentOffset:CGPointMake(0, 10) animated:YES];
    
    if (self.data == nil) {
        self.data = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    }

    [self.data replaceObjectAtIndex:index withObject:textField.text];
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
