//
//  AxisModel.h
//  ChartCoordinateAxis
//
//  Created by 杨虎 on 2018/1/15.
//  Copyright © 2018年 杨虎. All rights reserved.
//



#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,AxisDirection) {
    AxisDirectionVertical = 0,
    AxisDirectionHorizontal
};

@interface AxisModel : NSObject
@property (nonatomic,assign,readonly) AxisDirection direction;
@property (nonatomic,assign,readonly) BOOL hideYAxisLine;
@property (nonatomic,assign,readonly) BOOL hideYReferenceLine;
@property (nonatomic,assign,readonly) BOOL hideXReferenceLine;
@property (nonatomic,assign,readonly) BOOL isDottedLineReference;
@property (nonatomic,assign,readonly) float itemDefaultMinSpaceX;
@property (nonatomic,assign,readonly) float itemDefaultMinSpaceY;

- (id)initWithDataDict:(NSDictionary *)dataDict;
@end
