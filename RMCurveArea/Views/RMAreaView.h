//
//  RMAreaView.h
//  RelationDemo
//
//  Created by 王树军(金融壹账通客户端研发团队) on 2018/8/13.
//  Copyright © 2018 王树军(金融壹账通客户端研发团队). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMAreaModel.h"

@interface RMAreaView : UIView

@property (nonatomic, strong) NSArray *yValueArr;

- (void)rm_drawWithAreaModel:(RMAreaModel *)areaModel;

@end
