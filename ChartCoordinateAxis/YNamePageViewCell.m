//
//  YNamePageViewCell.m
//  ChartCoordinateAxis
//
//  Created by 杨虎 on 2018/1/18.
//  Copyright © 2018年 杨虎. All rights reserved.
//

#import "YNamePageViewCell.h"

@interface YNamePageViewCell()
@property (nonatomic, strong) UILabel *label;
@end

@implementation YNamePageViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = CGRectMake(0, (self.bounds.size.height-15)/2.0, self.bounds.size.width, 15);
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
