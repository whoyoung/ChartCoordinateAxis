//
//  DataVerticalPageViewCell.h
//  ChartCoordinateAxis
//
//  Created by 杨虎 on 2018/1/18.
//  Copyright © 2018年 杨虎. All rights reserved.
//

#import "KIPageViewCell.h"

@interface DataVerticalPageViewCell : KIPageViewCell
@property (nonatomic, assign) CGFloat zeroLineReferencePosition;

- (void)updateSubviews:(NSString *)text barWidth:(CGFloat)barWidth;
@end
