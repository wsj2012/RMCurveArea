//
//  ViewController.m
//  RMCurveArea
//
//  Created by 王树军(金融壹账通客户端研发团队) on 2018/8/14.
//  Copyright © 2018 王树军(金融壹账通客户端研发团队). All rights reserved.
//

#import "ViewController.h"
#import "RMAreaViewController.h"

@interface ViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Main";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:26/255.0 green:27/255.0 blue:29/255.0 alpha:1];
    [self setBarButtonItem];
    
}

- (void)setBarButtonItem
{
    //隐藏导航栏上的返回按钮
    [self.navigationItem setHidesBackButton:YES];
    //用来放searchBar的View
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight + 7, self.view.frame.size.width, 54)];
    [self.view addSubview:titleView];
    //    titleView.backgroundColor = [UIColor colorWithRed:234/255.0 green:235/255.0 blue:237/255.0 alpha:1];
    //创建searchBar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(5, 7, CGRectGetWidth(titleView.frame) - 15, 40)];
    //默认提示文字
    searchBar.placeholder = @"搜索内容";
    //背景图片
    searchBar.backgroundImage = [[UIImage alloc] init];
    searchBar.barStyle = UISearchBarStyleDefault;
    searchBar.barTintColor = [UIColor whiteColor];
    //代理
    searchBar.delegate = self;
    //显示右侧取消按钮
    searchBar.showsCancelButton = YES;
    //光标颜色
    searchBar.tintColor =[UIColor grayColor];
    //拿到searchBar的输入框
    UITextField *searchTextField = [searchBar valueForKey:@"_searchField"];
    //字体大小
    searchTextField.font = [UIFont systemFontOfSize:15];
    //输入框背景颜色
    searchTextField.backgroundColor = [UIColor colorWithRed:234/255.0 green:235/255.0 blue:237/255.0 alpha:1];
    //拿到取消按钮
    UIButton *cancleBtn = [searchBar valueForKey:@"cancelButton"];
    //设置按钮上的文字
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    //设置按钮上文字的颜色
    [cancleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [titleView addSubview:searchBar];
    self.searchBar = searchBar;
    
    
    
    //    self.navigationItem.titleView = titleView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_searchBar.isFirstResponder) {
        [self.searchBar becomeFirstResponder];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - other delegate

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"SearchButton");
    [self.navigationController pushViewController:[RMAreaViewController new] animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}


@end
