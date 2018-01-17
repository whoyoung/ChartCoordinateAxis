//
//  XPageViewCell.m
//  ChartCoordinateAxis
//
//  Created by 杨虎 on 2018/1/17.
//  Copyright © 2018年 杨虎. All rights reserved.
//

#import "XPageViewCell.h"

@interface XPageViewCell()
@property (nonatomic, strong) UILabel *label;
@end

@implementation XPageViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = CGRectMake(0, 0, self.bounds.size.width, 15);
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

- (void)updateSubviews:(NSString *)text {
    self.label.text = text;
}
@end
