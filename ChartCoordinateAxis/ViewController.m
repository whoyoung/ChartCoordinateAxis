//
//  ViewController.m
//  ChartCoordinateAxis
//
//  Created by 杨虎 on 2018/1/15.
//  Copyright © 2018年 杨虎. All rights reserved.
//

#import "ViewController.h"
#import "KIPageView.h"
@interface ViewController ()<KIPageViewDelegate>
@property (nonatomic, strong) KIPageView *xPageView;
@property (nonatomic, strong) KIPageView *yPageView;
@property (nonatomic, strong) KIPageView *dataPageView;
@property (nonatomic, strong) NSArray *xArray;
@property (nonatomic, strong) NSArray *yArray;
@property (nonatomic, assign) CGFloat xScaleWidth;
@property (nonatomic, assign) CGFloat yScaleHeight;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    [self.view addSubview:self.xPageView];
}

- (void)prepareData {
    _xArray = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j"];
    _yArray = @[@"5",@"4",@"3",@"2",@"1",@"2",@"3",@"4",@"5",@"10"];
}

#pragma mark *************************** KIPageViewDelegate
- (NSInteger)numberOfCellsInPageView:(KIPageView *)pageView {
    return self.xArray.count;
}
- (KIPageViewCell *)pageView:(KIPageView *)pageView cellAtIndex:(NSInteger)index {
    if (pageView == self.xPageView) {
        KIPageViewCell *cell = [pageView dequeueReusableCellWithIdentifier:@"xCell"];
        UILabel *label = (UILabel *)[cell viewWithTag:1001];
        if (!cell) {
            cell = [[KIPageViewCell alloc] initWithIdentifier:@"xCell"];
            cell.frame = CGRectMake(0, 0, self.xScaleWidth, 15);
            label = [[UILabel alloc] initWithFrame:cell.bounds];
            label.textColor = [UIColor blackColor];
            label.adjustsFontSizeToFitWidth = YES;
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor orangeColor];
            label.tag = 1001;
            [cell addSubview:label];
        }
        NSString *text = index < self.xArray.count ? self.xArray[index] : @"--";;
        [label setText:text];
        return cell;
    }
    return nil;
}
- (CGFloat)pageView:(KIPageView *)pageView widthForCellAtIndex:(NSInteger)index {
    if (pageView == self.xPageView) {
        return self.xScaleWidth;
    }
    return 0;
}
- (CGFloat)pageView:(KIPageView *)pageView heightForCellAtIndex:(NSInteger)index {
    if (pageView == self.xPageView) {
        return self.xPageView.frame.size.height;
    }
    return 0;
}

- (KIPageView *)xPageView {
    if (!_xPageView) {
        _xPageView = [[KIPageView alloc] initWithOrientation:KIPageViewHorizontal];
        _xPageView.zoomDirection = YHPageViewZoomDirectionX;
        _xPageView.delegate = self;
        _xPageView.frame = CGRectMake(60, 400, self.view.frame.size.width-100, 40);
        _xPageView.cellMargin = 6;
    }
    return _xPageView;
}
- (CGFloat)xScaleWidth {
    if (_xScaleWidth == 0) {
        CGFloat xPageVeiwW = self.xPageView.frame.size.width;
        CGFloat perWidth = (xPageVeiwW-self.xArray.count*self.xPageView.cellMargin)/self.xArray.count;
        _xScaleWidth = perWidth > 40 ? perWidth: 40;
    }
    return _xScaleWidth;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
