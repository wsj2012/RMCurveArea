//
//  RMAreaModel.h
//  RMCurveArea
//
//  Created by 王树军(金融壹账通客户端研发团队) on 2018/8/15.
//  Copyright © 2018 王树军(金融壹账通客户端研发团队). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMAreaModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *xValueArr;//x坐标刻度值
@property (nonatomic, strong) NSArray *yValueArr;//y坐标刻度值
@property (nonatomic, copy) NSString *yTitle;
@property (nonatomic, copy) NSString *tipValueSuffix;//单位

@end
