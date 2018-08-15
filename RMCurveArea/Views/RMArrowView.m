//
//  RMArrowView.m
//  RelationDemo
//
//  Created by 王树军(金融壹账通客户端研发团队) on 2018/8/14.
//  Copyright © 2018 王树军(金融壹账通客户端研发团队). All rights reserved.
//

#import "RMArrowView.h"

@implementation RMArrowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat startX = 5;
    CGFloat startY =  6;
    CGContextMoveToPoint(context, startX, startY);//设置起点
    CGContextAddLineToPoint(context, startX - 5, startY -6);
    CGContextAddLineToPoint(context, startX + 5, startY-6);
    CGContextClosePath(context);
    [[UIColor colorWithWhite:0.8 alpha:1] setFill];
    [[UIColor colorWithWhite:0.8 alpha:1] setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);}


@end
