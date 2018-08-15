//
//  RMAreaViewController.m
//  RelationDemo
//
//  Created by 王树军(金融壹账通客户端研发团队) on 2018/8/13.
//  Copyright © 2018 王树军(金融壹账通客户端研发团队). All rights reserved.
//

#import "RMAreaViewController.h"
#import "RMAreaView.h"

@interface RMAreaViewController ()

@end

@implementation RMAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:26/255.0 green:27/255.0 blue:29/255.0 alpha:1];
    RMAreaView *areaView = [[RMAreaView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, kScreenWidth, kScreenWidth)];
    [self.view addSubview:areaView];
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
