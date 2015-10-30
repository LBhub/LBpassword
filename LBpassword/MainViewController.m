//
//  MainViewController.m
//  LBpassword
//
//  Created by lb on 15/10/8.
//  Copyright © 2015年 李波. All rights reserved.
//

#import "MainViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "EditViewController.h"


#define CELLTAG 200
#define  MAINSIZE [UIScreen mainScreen].bounds.size

@interface FirstCell : UITableViewCell

@property (nonatomic,strong) UIImageView *accessoryImageView;

@end

@implementation FirstCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ){
        CGFloat edge = 8;
        CGFloat imgW = 44 - 2 * edge;
        
        self.accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MAINSIZE.width - edge - imgW, edge, imgW, imgW)];
        self.accessoryView = self.accessoryImageView;
    }
    
    return self;
}

@end

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate,EditEndDelegate>
{
    CGSize mainSize;
    NSMutableArray *list;
    NSMutableArray *showArr;
    CGPoint showPoint;
    CGPoint hidePoint;
    CGFloat lastContentOffsetY;
}

@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *addBtn;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    mainSize = [UIScreen mainScreen].bounds.size;
    self.title = @"密码助手";
    lastContentOffsetY = 0.0;
    
    [self addDate];
    [self addSubView];
}

- (void)addDate{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dourDocumentPath = [paths objectAtIndex:0];
    
    NSString *filePath=[dourDocumentPath stringByAppendingPathComponent:@"myDate"];
    list = [NSMutableArray arrayWithContentsOfFile:filePath];
    if (!list) {
        list = [NSMutableArray array];
    }
    showArr = [NSMutableArray array];
    for (int i = 0; i < list.count; i ++) {
        [showArr addObject:@NO];
    }
}

- (void)addSubView{
    CGFloat edge = 8;
    CGFloat btnW = 60;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, mainSize.width, 44)];
    self.searchBar.placeholder = @"输入名称";
    self.searchBar.translucent = YES;
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame) + edge, mainSize.width, mainSize.height - CGRectGetMaxY(self.searchBar.frame) - edge) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollsToTop = YES;
    [self.view addSubview:self.tableView];
    
    showPoint = CGPointMake(mainSize.width / 2, mainSize.height - edge - btnW);
    hidePoint = CGPointMake(mainSize.width / 2,  mainSize.height + edge + btnW);
    
    self.addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, btnW, btnW)];
    self.addBtn.center = showPoint;
    [self.addBtn setTitle:@"+" forState:(UIControlStateNormal)];
    self.addBtn.titleLabel.font = [UIFont fontWithName:self.addBtn.titleLabel.font.fontName size:50];
    [self.addBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.addBtn.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    self.addBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.addBtn.layer.masksToBounds = YES;
    self.addBtn.layer.cornerRadius = btnW / 2;
    
    [self.addBtn addTarget:self action:@selector(addInfo) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:self.addBtn];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([showArr[section] boolValue]) {
        return [list[section] count];
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = list[indexPath.section];
    
    static NSString *identifier1 = @"Firstcell";
    if (indexPath.row == 0) {
        FirstCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell == nil) {
            cell = [[FirstCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier1];
        }
         NSString *imgName = ([showArr[indexPath.section] boolValue]) ? @"up.png" : @"down.png";
        cell.accessoryImageView.image = [UIImage imageNamed:imgName];
        cell.accessoryImageView.tag = CELLTAG + indexPath.section;
        cell.textLabel.text = arr[indexPath.row];
        cell.textLabel.textColor = [UIColor grayColor];
        return cell;
        
    }
    
    static NSString *identifier = @"cell";
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = arr[indexPath.row];
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}


- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return YES;
    }
    return NO;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [list removeObjectAtIndex:indexPath.section];
        [tableView deleteSections:[[NSIndexSet alloc] initWithIndex:indexPath.section] withRowAnimation:(UITableViewRowAnimationTop)];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self onTapWithIndex:(int)indexPath.section];
    }else{
        EditViewController *editVC = [EditViewController new];
        editVC.data = list[indexPath.section];
        editVC.index = (int)indexPath.section;
        editVC.editDelegate = self;
        [self.navigationController pushViewController:editVC animated:YES];
    }
}

- (void)onTapWithIndex:(int)index{
    BOOL status = [showArr[index] boolValue];
    
    showArr[index] = [NSNumber numberWithBool:!status];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)addInfo{
    NSLog(@"添加信息");
    EditViewController *editVC = [EditViewController new];
    editVC.index = -1;
    editVC.editDelegate = self;
    [self.navigationController pushViewController:editVC animated:YES];
}

//编辑代理
- (void)getTextArray:(NSArray *)textArray WithIndex:(int)index{
    if (!(textArray[1] && textArray[2])) {
        return;
    }
    
    if (index == -1) {
        [list addObject:textArray.mutableCopy];
        [showArr addObject:@NO];
        [self.tableView reloadData];
    }else{
        [list replaceObjectAtIndex:index withObject:textArray.mutableCopy];
        [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:index] withRowAnimation:(UITableViewRowAnimationFade)];
    }
}


- (void)appWillExit{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dourDocumentPath = [paths objectAtIndex:0];
    
    NSString *filePath=[dourDocumentPath stringByAppendingPathComponent:@"myDate"];
    [list writeToFile:filePath atomically:YES];
}

#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    int i = 0;
    for (NSArray *arr in list) {
        if ([[arr firstObject]  containsString:searchText]){
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionTop animated:YES];;
        }
        i ++;
    }
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView*)scrollView{
    lastContentOffsetY = scrollView.contentOffset.y;
}

-( void )scrollViewDidScroll:( UIScrollView *)scrollView {
    if (scrollView.contentOffset.y< lastContentOffsetY ){
        //向上
        [UIView animateWithDuration:0.3 animations:^{
            self.addBtn.center = showPoint;
        }];
    } else if(scrollView.contentOffset.y >lastContentOffsetY){
        //向下
        [UIView animateWithDuration:0.3 animations:^{
            self.addBtn.center = hidePoint;
        }];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
