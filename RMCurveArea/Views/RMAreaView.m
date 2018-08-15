//
//  RMAreaView.m
//  RelationDemo
//
//  Created by 王树军(金融壹账通客户端研发团队) on 2018/8/13.
//  Copyright © 2018 王树军(金融壹账通客户端研发团队). All rights reserved.
//

#import "RMAreaView.h"
#import "RMArrowView.h"

#define IntervalBottom 100 //坐标系距离当前view底部距离
#define IntervalLeft 50 //坐标系距离左边距
#define IntervalRight 20 //坐标系距离右边距
#define ChartWidth (kScreenWidth - IntervalLeft - 10 - IntervalRight)//坐标系（绘制图形）宽度
#define ChartHeight 200 //坐标系高度
#define YIntervalCount  3 //Y轴刻度数

@interface RMAreaView()

@property (nonatomic, strong) NSMutableArray *pointArray;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) NSInteger yMax;
@property (nonatomic, strong) NSArray *xArr;
@property (nonatomic, strong) NSMutableArray *circleArr;//点击显示的标记圈
@property (nonatomic, strong) NSMutableArray *clickBgViewArr;
@property (nonatomic, strong) NSMutableArray *tipsArr;
@property (nonatomic, strong) NSMutableArray *arrowArr;
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UILabel *yTitleLabel;//标题

@end

@implementation RMAreaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithRed:26/255.0 green:27/255.0 blue:29/255.0 alpha:1];
        [self addSubview:self.titleLabel];
        self.titleLabel.text = @"中国平安";
        [self addSubview:self.yTitleLabel];
        self.yTitleLabel.text = @"PRICE(￥)";
        [self processingData];
    }
    
    return self;
}

- (void)rm_drawWithAreaModel:(RMAreaModel *)areaModel
{
    self.titleLabel.text = areaModel.title;
    self.xArr = areaModel.xValueArr;
    self.yValueArr = areaModel.yValueArr;
    [self setNeedsDisplay];
}

- (void)processingData {
    self.yValueArr = @[@11.73,@11.55,@11.55,@11.69,@11.78,@11.91,@11.77,@11.5,@11.53,@11.56,@11.71,@11.65,@11.62,@11.57,@11.62,@11.61,@11.71,@12.25,@12.29,@12.32,@12.31,@12.3,@12.39,@12.39,@12.49,@12.5,@12.48,@12.47,@12.49,@12.49,@12.42,@12.41,@12.47,@12.46,@12.69,@12.73,@12.72,@12.63,@12.46,@12.51,@12.49,@12.78,@13.1,@13.45,@13.48,@13.49,@13.14,@13.3];
    NSString *maxValue = self.yValueArr[0];
    self.distance = (ChartWidth) / (self.yValueArr.count - 1);
    for (int i = 0; i < self.yValueArr.count; i++) {
        if ([self.yValueArr[i] floatValue] > [maxValue floatValue]) {
            maxValue = self.yValueArr[i];
        }
    }
    
    self.xArr = @[@"2.1",@"2.2",@"2.3",@"2.4", @"2.5",@"2.6",@"2.7",@"2.8",@"2.9", @"2.10", @"2.11", @"2.12", @"2.13", @"2.14", @"2.15", @"2.16", @"2.17", @"2.18", @"2.19", @"2.20", @"2.21", @"2.22", @"2.23", @"2.24", @"2.25", @"2.26", @"2.27", @"2.28", @"3.1", @"3.2", @"3.3", @"3.4", @"3.5", @"3.6", @"3.7", @"3.8", @"3.9", @"3.10", @"3.11", @"3.12", @"3.13", @"3.14", @"3.15", @"3.16", @"3.17", @"3.18", @"3.19", @"3.20"];
    self.yMax = (([maxValue integerValue] / 5) + 1) * 5;
    
    for (int i = 0; i < self.yValueArr.count; i++) {
        [self.pointArray addObject:NSStringFromCGPoint(CGPointMake(IntervalLeft + 5 + self.distance * i,  CGRectGetHeight(self.frame) - IntervalBottom - [self.yValueArr[i] floatValue] / _yMax * ChartHeight))];
        
    }
}

- (void)drawRect:(CGRect)rect {
    
    
    //1、获取图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // x轴线条绘制
    //2、描述路径
    for(int i = 0; i < YIntervalCount + 1; i++)
    {
        //创建路径
        CGMutablePathRef path =  CGPathCreateMutable();
        //设置起点
        CGPathMoveToPoint(path, NULL, IntervalLeft - 5, CGRectGetHeight(self.frame) - IntervalBottom - ChartHeight / YIntervalCount * i);
        //设置终点
        CGPathAddLineToPoint(path, NULL, kScreenWidth - IntervalRight, CGRectGetHeight(self.frame) - IntervalBottom - ChartHeight / YIntervalCount * i);
        //颜色
        [i == 0 ? [UIColor whiteColor]: [UIColor colorWithWhite:0.5 alpha:0.5] setStroke];
        //线宽
        CGContextSetLineWidth(ctx, 1);
        //设置连接样式
        CGContextSetLineJoin(ctx, kCGLineJoinBevel);
        //设置顶角样式
        CGContextSetLineCap(ctx, kCGLineCapButt);
        //3、把路径添加到上下文
        CGContextAddPath(ctx, path);
        //4、渲染上下文到View的layer
        CGContextStrokePath(ctx);
    }
    
    // y轴线条绘制
    {
        CGMutablePathRef path =  CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, IntervalLeft - 5, CGRectGetHeight(self.frame) - IntervalBottom);
        CGPathAddLineToPoint(path, NULL, IntervalLeft - 5, CGRectGetHeight(self.frame) - IntervalBottom - ChartHeight);
        [[UIColor colorWithWhite:1 alpha:1] setStroke];
        CGContextSetLineWidth(ctx, 1);
        CGContextSetLineJoin(ctx, kCGLineJoinBevel);
        CGContextSetLineCap(ctx, kCGLineCapButt);
        CGContextAddPath(ctx, path);
        CGContextStrokePath(ctx);
    }
    
    // y轴刻度label
    for(int i = 0; i < YIntervalCount + 1; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - IntervalBottom - 10 - ChartHeight/YIntervalCount*i, IntervalLeft - 15, 20)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        label.textAlignment = NSTextAlignmentRight;
        label.text = [NSString stringWithFormat:@"%ld",_yMax/YIntervalCount*i];
        [self addSubview:label];
    }
    
    // x轴刻度
    
    {
        NSInteger pCount = 1;
        if (self.pointArray.count > 12) {
            pCount = self.pointArray.count / 12;
        }
        for (int i =0; i < self.pointArray.count; i+=pCount) {
            CGMutablePathRef path =  CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, IntervalLeft + 5 + ChartWidth/self.pointArray.count*i, CGRectGetHeight(self.frame) - IntervalBottom);
            CGPathAddLineToPoint(path, NULL, IntervalLeft + 5 + ChartWidth/self.pointArray.count*i, CGRectGetHeight(self.frame) - IntervalBottom + 5);
            [[UIColor whiteColor] setStroke];
            CGContextSetLineWidth(ctx, 1);
            CGContextSetLineJoin(ctx, kCGLineJoinBevel);
            CGContextSetLineCap(ctx, kCGLineCapButt);
            CGContextAddPath(ctx, path);
            CGContextStrokePath(ctx);
            
            
            UILabel *xLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 14)];
            xLabel.font = [UIFont systemFontOfSize:12];
            xLabel.textAlignment = NSTextAlignmentCenter;
            xLabel.center = CGPointMake(IntervalLeft + 5 + ChartWidth/self.pointArray.count*i, CGRectGetHeight(self.frame) - IntervalBottom + 5 + 14);
            xLabel.transform = CGAffineTransformMakeRotation(-M_PI_4);
            xLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
            xLabel.backgroundColor = [UIColor clearColor];
            xLabel.text = _xArr[i];
            [self addSubview:xLabel];

        }
        
    }
    
    [self drawCurveChartWithPoints:self.pointArray];
}

//根据points中的点画出曲线
- (void)drawCurveChartWithPoints:(NSMutableArray *)points
{
    UIBezierPath* path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointFromString([points objectAtIndex:0])];//这一步很重要
    //遍历各个点，画曲线
    for(int i=0; i<[points count]-1; i++){
        CGPoint startPoint = CGPointFromString([points objectAtIndex:i]);
        CGPoint endPoint = CGPointFromString([points objectAtIndex:i+1]);
        [UIView animateWithDuration:.1 animations:^(){
            [path1 addCurveToPoint:endPoint controlPoint1:CGPointMake((endPoint.x-startPoint.x)/2+startPoint.x, startPoint.y) controlPoint2:CGPointMake((endPoint.x-startPoint.x)/2+startPoint.x, endPoint.y)];
        }];
        
    }
    
    for(int i=0; i<[points count]; i++){
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(CGPointFromString(points[i]).x - ChartWidth / self.pointArray.count/2, CGRectGetHeight(self.frame) - IntervalBottom - (CGRectGetHeight(self.frame) - IntervalBottom- CGPointFromString(points[i]).y), ChartWidth / self.pointArray.count, CGRectGetHeight(self.frame) - IntervalBottom- CGPointFromString(points[i]).y)];
        bgView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
        bgView.hidden = YES;
        [self addSubview:bgView];
        [self.clickBgViewArr addObject:bgView];
        
        NSString *value = [NSString stringWithFormat:@"  Date:%@\n  Price:%@", self.xArr[i], [self.yValueArr[i] stringValue]];
        CGSize textSize1 = [value sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize1.width + 5, textSize1.height + 10)];
        label.center = CGPointMake(CGPointFromString(points[i]).x, CGPointFromString(points[i]).y - 20 - textSize1.height/2);
        label.layer.cornerRadius = 4;
        label.clipsToBounds = YES;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:12];
        label.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        label.textColor = [UIColor blackColor];
        label.text = value;
        label.hidden = true;
        [self addSubview:label];
        [self.tipsArr addObject:label];
        
        
        RMArrowView *arrowView = [[RMArrowView alloc] initWithFrame:CGRectMake(label.center.x - 5, CGRectGetMaxY(label.frame)-1, 10, 6)];
        arrowView.hidden = YES;
        [self addSubview:arrowView];
        [self.arrowArr addObject:arrowView];
        
        
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, 14, 14);
        view.center = CGPointFromString(points[i]);
        view.layer.cornerRadius = 7;
        view.backgroundColor = RGB(94, 142, 164);
        view.clipsToBounds = YES;
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        view.hidden = true;
        [self addSubview:view];
        [self.circleArr addObject:view];
    }
    
    [RGB(94, 142, 164) set];       //设置画笔颜色
    [path1 setLineWidth:2];     //设置画笔宽度
    path1.lineCapStyle = kCGLineCapRound;
    [path1 strokeWithBlendMode:kCGBlendModeNormal alpha:1];
    
    CGPoint firstPoint = CGPointFromString([points firstObject]);
    CGPoint lastPoint = CGPointFromString([points lastObject]);
    CGPoint secondPoint = CGPointMake(lastPoint.x+2, lastPoint.y);
    CGPoint thirdPoint = CGPointMake(secondPoint.x, CGRectGetHeight(self.frame) - IntervalBottom);
    CGPoint forthPoint = CGPointMake(firstPoint.x-1, thirdPoint.y);
    CGPoint fifthPoint = CGPointMake(forthPoint.x, firstPoint.y);
    
    //把曲线封闭起来
    [path1 addLineToPoint:secondPoint];
    [path1 addLineToPoint:thirdPoint];
    [path1 addLineToPoint:forthPoint];
    [path1 addLineToPoint:fifthPoint];
    [path1 addLineToPoint:firstPoint];

    [path1 closePath];
    
//    [[UIColor colorWithRed:.0/255.0 green:187.0/255.0 blue:255/255.0 alpha:0.5] setFill];
//    [path1 fill];
    
    //绘制渐变图层
    CAShapeLayer *shapLayer = [CAShapeLayer layer];
    shapLayer.path = path1.CGPath;
    shapLayer.frame = self.bounds;
//    shapLayer.fillColor =  [UIColor colorWithRed:.0/255.0 green:187.0/255.0 blue:255/255.0 alpha:0.7].CGColor;
    [self.layer addSublayer:shapLayer];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(shapLayer.frame), CGRectGetHeight(shapLayer.frame));
    gradientLayer.colors = @[(__bridge id)RGB(89, 142, 163).CGColor, (__bridge id)RGBA(89, 142, 163, 0.1).CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    [gradientLayer setMask:shapLayer];

    [self.layer addSublayer:gradientLayer];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    
    if (touchPoint.x < IntervalLeft || touchPoint.x > kScreenWidth - IntervalRight ||
        touchPoint.y > (CGRectGetHeight(self.frame) - IntervalBottom) ||
        touchPoint.y < (CGRectGetHeight(self.frame) - IntervalBottom - ChartHeight)) {
        return;
    }
    
    NSInteger index = (touchPoint.x - IntervalLeft - (ChartWidth / self.pointArray.count / 2))/ (ChartWidth / self.pointArray.count);
    if (index == self.pointArray.count) {
        return;
    }
    
    UIView *circle = self.circleArr[index];
    circle.alpha = 1;
    circle.hidden = NO;
    UIView *bgView = self.clickBgViewArr[index];
    bgView.hidden = NO;
    UILabel *label = self.tipsArr[index];
    label.hidden = NO;
    UIView *arrow = self.arrowArr[index];
    arrow.hidden = NO;
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if (touchPoint.x < IntervalLeft || touchPoint.x > kScreenWidth - IntervalRight ||
        touchPoint.y > (CGRectGetHeight(self.frame) - IntervalBottom) ||
        touchPoint.y < (CGRectGetHeight(self.frame) - IntervalBottom - ChartHeight)) {
        return;
    }
    
//    NSInteger index = (touchPoint.x - IntervalLeft - (ChartWidth / self.array.count / 2))/ (ChartWidth / self.array.count);
//    UIView *circle = self.circleArr[index];
    for(UIView *view in self.circleArr) {
        [UIView animateWithDuration:0.25 animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            view.hidden = true;
        }];
    }
    
    for (UIView *view in self.clickBgViewArr) {
        view.hidden = true;
    }
    
    for (UILabel *label in self.tipsArr) {
        label.hidden = true;
    }
    
    for (UIView *view in self.arrowArr) {
        view.hidden = true;
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    NSInteger index = (touchPoint.x - IntervalLeft - (ChartWidth / self.pointArray.count / 2))/ (ChartWidth / self.pointArray.count);
    if (touchPoint.x < IntervalLeft) {
        index = 0;
    }
    if (touchPoint.x > kScreenWidth - IntervalRight) {
        index = self.pointArray.count - 1;
    }
    
    if (touchPoint.x < IntervalLeft || touchPoint.x > kScreenWidth - IntervalRight ||
        touchPoint.y > (CGRectGetHeight(self.frame) - IntervalBottom) ||
        touchPoint.y < (CGRectGetHeight(self.frame) - IntervalBottom - ChartHeight)) {
        UIView *view = self.circleArr[index];
        [UIView animateWithDuration:0.25 animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            view.hidden = true;
        }];
        
        UIView *bgView = self.clickBgViewArr[index];
        bgView.hidden = true;
        
        UILabel *label = self.tipsArr[index];
        label.hidden = true;
        
        UIView *arrow = self.arrowArr[index];
        arrow.hidden = true;
        return;
    }
    
    if (index == self.pointArray.count) {
        return;
    }
    
    for (UIView *view in self.circleArr) {
        view.alpha = 1;
        if (view != self.circleArr[index]) {
            view.hidden = true;
        }else {
            view.hidden = false;
        }
    }
    
    for (UIView *view in self.clickBgViewArr) {
        if (view != self.clickBgViewArr[index]) {
            view.hidden = true;
        }else {
            view.hidden = false;
        }
    }
    
    for (UILabel *label in self.tipsArr) {
        if (label != self.tipsArr[index]) {
            label.hidden = true;
        }else {
            label.hidden = false;
        }
    }
    
    for (UIView *view in self.arrowArr) {
        if (view != self.arrowArr[index]) {
            view.hidden = true;
        }else {
            view.hidden = false;
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

#pragma mark - getter and setter

- (NSMutableArray *)pointArray {
    if (!_pointArray) {
        _pointArray = [NSMutableArray array];
    }
    return _pointArray;
}

- (NSMutableArray *)circleArr {
    if (!_circleArr) {
        _circleArr = [NSMutableArray array];
    }
    return _circleArr;
}

- (NSMutableArray *)clickBgViewArr {
    if (!_clickBgViewArr) {
        _clickBgViewArr = [NSMutableArray array];
    }
    return _clickBgViewArr;
}

- (NSMutableArray *)tipsArr {
    if (!_tipsArr) {
        _tipsArr = [NSMutableArray array];
    }
    return _tipsArr;
}

- (NSMutableArray *)arrowArr {
    if (!_arrowArr) {
        _arrowArr = [NSMutableArray array];
    }
    return _arrowArr;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 50)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)yTitleLabel {
    if (!_yTitleLabel) {
        _yTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetHeight(self.frame) - IntervalBottom - ChartHeight - 50, kScreenWidth, 50)];
        _yTitleLabel.font = [UIFont systemFontOfSize:12];
        _yTitleLabel.textAlignment = NSTextAlignmentLeft;
        _yTitleLabel.textColor = [UIColor whiteColor];
    }
    return _yTitleLabel;
}

@end
