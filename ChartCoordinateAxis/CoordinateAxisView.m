//
//  CoordinateAxisView.m
//  ChartCoordinateAxis
//
//  Created by 杨虎 on 2018/1/15.
//  Copyright © 2018年 杨虎. All rights reserved.
//

#import "CoordinateAxisView.h"
#import "AxisModel.h"
@interface CoordinateAxisView ()
@property (nonatomic,strong) AxisModel *model;
@end

@implementation CoordinateAxisView

- (void)setDataDict:(NSDictionary *)dataDict {
    _dataDict = dataDict;
    _model = [[AxisModel alloc] initWithDataDict:dataDict];
}

- (void)layoutSubviews {
    
}
@end
