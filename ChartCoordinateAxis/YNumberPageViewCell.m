//
//  YNumberPageViewCell.m
//  ChartCoordinateAxis
//
//  Created by 杨虎 on 2018/1/17.
//  Copyright © 2018年 杨虎. All rights reserved.
//

#import "YNumberPageViewCell.h"

@interface YNumberPageViewCell()
@property (nonatomic, strong) CALayer *rightLineLayer;
@property (nonatomic, strong) UILabel *label;
@end


@implementation YNumberPageViewCell
- (void)layoutSubviews {
    [super layoutSubviews];
    self.rightLineLayer.frame = CGRectMake(self.bounds.size.width-1, 0, 1, self.bounds.size.height);
    self.label.frame = CGRectMake(0, self.bounds.size.height-15, self.bounds.size.width-1, 15);
}

- (CALayer *)rightLineLayer {
    if (!_rightLineLayer) {
        _rightLineLayer = [CALayer layer];
        _rightLineLayer.backgroundColor = [UIColor blackColor].CGColor;
        [self.contentView.layer addSublayer:_rightLineLayer];
    }
    return _rightLineLayer;
}
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.textColor = [UIColor blackColor];
        _label.adjustsFontSizeToFitWidth = YES;
        _label.font = [UIFont systemFontOfSize:12];
        _label.textAlignment = NSTextAlignmentRight;
        _label.backgroundColor = [UIColor orangeColor];
        [self addSubview:_label];
    }
    return _label;
}

- (void)updateSubviews:(NSString *)text {
    self.label.text = text;
}
@end
