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
    
    //创建areaView
    //注意： 高度必须大于（ChartHeight：200 + IntervalBottom：40 + yTitleLabelHeight：50 + titleHeight：50）= 默认这个最小值为340
    RMAreaView *areaView = [[RMAreaView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, [UIScreen mainScreen].bounds.size.width, 360)];
    [self.view addSubview:areaView];
    
    NSArray *xArr = @[@"2.1",@"2.2",@"2.3",@"2.4", @"2.5",@"2.6",@"2.7",@"2.8",@"2.9", @"2.10", @"2.11", @"2.12", @"2.13", @"2.14", @"2.15", @"2.16", @"2.17", @"2.18", @"2.19", @"2.20", @"2.21", @"2.22", @"2.23", @"2.24", @"2.25", @"2.26", @"2.27", @"2.28", @"3.1", @"3.2", @"3.3", @"3.4", @"3.5", @"3.6", @"3.7", @"3.8", @"3.9", @"3.10", @"3.11", @"3.12", @"3.13", @"3.14", @"3.15", @"3.16", @"3.17", @"3.18", @"3.19", @"3.20"];

    NSArray *yArr =  @[@11.73,@11.55,@11.55,@11.69,@11.78,@11.91,@11.77,@11.5,@11.53,@11.56,@11.71,@11.65,@11.62,@11.57,@11.62,@11.61,@11.71,@12.25,@12.29,@12.32,@12.31,@12.3,@12.39,@12.39,@12.49,@12.5,@12.48,@12.47,@12.49,@12.49,@12.42,@12.41,@12.47,@12.46,@12.69,@12.73,@12.72,@12.63,@12.46,@12.51,@12.49,@12.78,@13.1,@13.45,@13.48,@13.49,@13.14,@13.3];
    RMAreaModel *areaModel = [[RMAreaModel alloc] init];
    areaModel.xValueArr = xArr;
    areaModel.yValueArr = yArr;
    areaModel.title = @"浦发银行";
    areaModel.yTitle = @"PRICE(￥)";
    areaModel.startColor = RGB(89, 142, 163);
    areaModel.endColor = RGBA(89, 142, 163, 0.1);
    [areaView rm_drawWithAreaModel:areaModel];
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
