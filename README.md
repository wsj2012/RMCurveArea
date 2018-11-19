# RMCurveArea

### 坐标系绘制贝塞尔曲线与x坐标形成封闭区域，区域内部背景实现颜色渐变。图标分析图。

效果图：

![ScreenShot](https://raw.githubusercontent.com/wsj2012/RMCurveArea/master/Screen%20Shot%20.png)

## Setup Instructions

To integrate RMCurveArea into your Xcode project using CocoaPods, specify it in your Podfile:
pod 'RMCurveArea', and in your code add #import "RMAreaView.h".

## Manually

Just add RMCurveArea folder to your project.

## Basic Examples

```
	RMAreaView *areaView = [[RMAreaView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, kScreenWidth, 360)];
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
```

注意：工程可扩展改变修改成自己想要的样式，若有疑问，可留言或微信:wsj_2012.