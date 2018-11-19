//
//  RMAreaView.m
//  RelationDemo
//
//  Created by 王树军(金融壹账通客户端研发团队) on 2018/8/13.
//  Copyright © 2018 王树军(金融壹账通客户端研发团队). All rights reserved.
//

#import "RMAreaView.h"
#import "RMArrowView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define IntervalBottom 40 //坐标系距离当前view底部距离
#define IntervalLeft 50 //坐标系距离左边距
#define IntervalRight 20 //坐标系距离右边距
#define ChartWidth (kScreenWidth - IntervalLeft - 10 - IntervalRight)//坐标系（绘制图形）宽度
#define ChartHeight 200 //坐标系高度
#define YIntervalCount  3 //Y轴刻度数

@interface RMAreaView()

@property (nonatomic, strong) NSMutableArray *pointArray;//根据传入的yVAlueArr计算出的坐标点
@property (nonatomic, assign) CGFloat distance;//x轴刻度值间距
@property (nonatomic, assign) NSInteger yMax;//确定y轴最大显示刻度值（可根据需要进行改变）
@property (nonatomic, strong) NSMutableArray *circleArr;//点击显示的标记圈
@property (nonatomic, strong) NSMutableArray *clickBgViewArr;//点击区域显示的白色背景条
@property (nonatomic, strong) NSMutableArray *tipsArr;//点击曲线显示的提示框
@property (nonatomic, strong) NSMutableArray *arrowArr;
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UILabel *yTitleLabel;//y标题

@property (nonatomic, strong) RMAreaModel *areaModel;

@end

@implementation RMAreaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithRed:26/255.0 green:27/255.0 blue:29/255.0 alpha:1];
        [self addSubview:self.titleLabel];
        [self addSubview:self.yTitleLabel];
//        [self processingData];
    }
    
    return self;
}

- (void)rm_drawWithAreaModel:(RMAreaModel *)areaModel
{
    self.areaModel = areaModel;
    self.titleLabel.text = areaModel.title;
    self.titleLabel.text = areaModel.title;
    self.yTitleLabel.text = areaModel.yTitle;
    [self processingData];
    [self setNeedsDisplay];
}

- (void)processingData {
    NSString *maxValue = self.areaModel.yValueArr[0];
    self.distance = (ChartWidth) / (self.areaModel.yValueArr.count - 1);
    for (int i = 0; i < self.areaModel.yValueArr.count; i++) {
        if ([self.areaModel.yValueArr[i] floatValue] > [maxValue floatValue]) {
            maxValue = self.areaModel.yValueArr[i];
        }
    }
    self.yMax = (([maxValue integerValue] / 5) + 1) * 5;
    for (int i = 0; i < self.areaModel.yValueArr.count; i++) {
        [self.pointArray addObject:NSStringFromCGPoint(CGPointMake(IntervalLeft + 5 + self.distance * i,  CGRectGetHeight(self.frame) - IntervalBottom - [self.areaModel.yValueArr[i] floatValue] / self.yMax * ChartHeight))];
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
        //x刻度最多绘制12个刻度，可根据需要调整刻度数量
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
            xLabel.text = self.areaModel.xValueArr[i];
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
        
        NSString *value = [NSString stringWithFormat:@"  Date:%@\n  Price:%@", self.areaModel.xValueArr[i], [self.areaModel.yValueArr[i] stringValue]];
        CGSize textSize1 = [value sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize1.width + 5, textSize1.height + 10)];
        label.center = CGPointMake((CGPointFromString(points[i]).x - (textSize1.width + 5)/2 <= (kScreenWidth - (textSize1.width + 5))) ? CGPointFromString(points[i]).x : (kScreenWidth - (textSize1.width + 5)/2), CGPointFromString(points[i]).y - 20 - textSize1.height/2);
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
        
        
        RMArrowView *arrowView = [[RMArrowView alloc] initWithFrame:CGRectMake(CGPointFromString(points[i]).x - 5, CGRectGetMaxY(label.frame)-1, 10, 6)];
        arrowView.hidden = YES;
        [self addSubview:arrowView];
        [self.arrowArr addObject:arrowView];
        
        
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, 14, 14);
        view.center = CGPointFromString(points[i]);
        view.layer.cornerRadius = 7;
        view.backgroundColor = [UIColor colorWithRed:94/255.0 green:142/255.0 blue:164/255.0 alpha:1]; 
        view.clipsToBounds = YES;
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        view.hidden = true;
        [self addSubview:view];
        [self.circleArr addObject:view];
    }
    
    
    [[UIColor colorWithRed:94/255.0 green:142/255.0 blue:164/255.0 alpha:1] set];       //设置画笔颜色
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
    gradientLayer.colors = @[(__bridge id)self.areaModel.startColor.CGColor, (__bridge id)self.areaModel.endColor.CGColor];
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
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - IntervalBottom - ChartHeight - 50 - 50, kScreenWidth, 50)];
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

- (RMAreaModel *)areaModel {
    if (!_areaModel) {
        _areaModel = [RMAreaModel new];
    }
    return _areaModel;
}

@end
