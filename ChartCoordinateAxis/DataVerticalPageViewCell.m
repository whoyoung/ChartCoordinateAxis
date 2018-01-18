//
//  DataVerticalPageViewCell.m
//  ChartCoordinateAxis
//
//  Created by 杨虎 on 2018/1/18.
//  Copyright © 2018年 杨虎. All rights reserved.
//

#import "DataVerticalPageViewCell.h"

@interface DataVerticalPageViewCell()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *barView;
@property (nonatomic, assign) CGFloat barWidth;
@end

@implementation DataVerticalPageViewCell
- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = CGRectMake(self.bounds.size.width - 20, 0, 20, self.bounds.size.height);
    if (self.barWidth >= 0) {
        CGFloat x = self.bounds.size.width * self.zeroLineReferencePosition;
        self.barView.frame = CGRectMake(x, 0, self.barWidth, self.bounds.size.height);
    } else {
        CGFloat x = self.bounds.size.width * self.zeroLineReferencePosition + self.barWidth;
        self.barView.frame = CGRectMake(x, 0, fabs(self.barWidth), self.bounds.size.height);
    }
}

- (UIView *)barView {
    if (!_barView) {
        _barView = [[UIView alloc] init];
        _barView.backgroundColor = [UIColor redColor];
        [self addSubview:_barView];
    }
    return _barView;
}
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.textColor = [UIColor blackColor];
        _label.adjustsFontSizeToFitWidth = YES;
        _label.font = [UIFont systemFontOfSize:12];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor orangeColor];
        _label.numberOfLines = 0;
        [self addSubview:_label];
    }
    return _label;
}

- (void)updateSubviews:(NSString *)text barWidth:(CGFloat)barWidth {
    self.label.text = text;
    self.barWidth = barWidth;
    [self setNeedsLayout];
}
@end

