//
//  DataPageViewCell.m
//  ChartCoordinateAxis
//
//  Created by 杨虎 on 2018/1/18.
//  Copyright © 2018年 杨虎. All rights reserved.
//

#import "DataHorizontolPageViewCell.h"

@interface DataHorizontolPageViewCell()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *barView;
@property (nonatomic, assign) CGFloat barHeight;
@end

@implementation DataHorizontolPageViewCell
- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = CGRectMake(0, 1, self.bounds.size.width, 15);
    if (self.barHeight >= 0) {
        CGFloat y = self.bounds.size.height * self.zeroLineReferencePosition - self.barHeight;
        self.barView.frame = CGRectMake(0, y, self.bounds.size.width, self.barHeight);
    } else {
        CGFloat y = self.bounds.size.height * self.zeroLineReferencePosition;
        self.barView.frame = CGRectMake(0, y, self.bounds.size.width, fabs(self.barHeight));
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
        [self addSubview:_label];
    }
    return _label;
}

- (void)updateSubviews:(NSString *)text height:(CGFloat)height {
    self.label.text = text;
    self.barHeight = height;
    [self setNeedsLayout];
}
@end
