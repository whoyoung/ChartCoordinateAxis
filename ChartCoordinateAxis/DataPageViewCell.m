//
//  DataPageViewCell.m
//  ChartCoordinateAxis
//
//  Created by 杨虎 on 2018/1/18.
//  Copyright © 2018年 杨虎. All rights reserved.
//

#import "DataPageViewCell.h"

@interface DataPageViewCell()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *barView;
@end

@implementation DataPageViewCell
- (void)layoutSubviews {
    [super layoutSubviews];
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
    self.label.frame = CGRectMake(0, 1, self.bounds.size.width, 15);
    
    CGFloat barValue = [text floatValue];
    CGFloat y = self.bounds.size.height * self.zeroLineReferencePosition;
    if (barValue >= 0) {
        self.barView.frame = CGRectMake(0, y, self.bounds.size.width, height);
    } else {
        y += height;
        self.barView.frame = CGRectMake(0, y, self.bounds.size.width, height);
    }

}
@end
