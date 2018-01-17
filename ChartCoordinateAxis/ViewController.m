//
//  ViewController.m
//  ChartCoordinateAxis
//
//  Created by 杨虎 on 2018/1/15.
//  Copyright © 2018年 杨虎. All rights reserved.
//

#import "ViewController.h"
#import "KIPageView.h"
#import "XPageViewCell.h"
#import "YPageViewCell.h"
@interface ViewController ()<KIPageViewDelegate>
@property (nonatomic, strong) KIPageView *xPageView;
@property (nonatomic, strong) KIPageView *yPageView;
@property (nonatomic, strong) KIPageView *dataPageView;
@property (nonatomic, strong) NSArray *xArray;
@property (nonatomic, strong) NSArray *yArray;
@property (nonatomic, assign) CGFloat xScaleWidth;
@property (nonatomic, assign) CGFloat yScaleHeight;
@property (nonatomic, assign) CGFloat yValuePerScale;
@property (nonatomic, assign) NSInteger yPositiveScaleNum;
@property (nonatomic, assign) NSInteger yNegativeScaleNum;

@property (nonatomic, strong) NSMutableArray *yScaleValues;
@property (nonatomic, assign) CGFloat minYValue;
@property (nonatomic, assign) CGFloat maxYValue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    [self findYMaxMinValue];
    [self calculateYScale];
    [self.view addSubview:self.xPageView];
    [self.view addSubview:self.yPageView];
}

- (void)prepareData {
    _xArray = @[@"a",@"bbbbbbb",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j"];
    _yArray = @[@"5",@"4",@"3",@"2",@"1",@"2",@"3",@"4",@"5",@"10"];
}

#pragma mark *************************** KIPageViewDelegate
- (NSInteger)numberOfCellsInPageView:(KIPageView *)pageView {
    if (pageView == self.xPageView) {
        return self.xArray.count;
    } else if (pageView == self.yPageView) {
        return self.yPositiveScaleNum + self.yNegativeScaleNum;
    }
    return 0;
}
- (KIPageViewCell *)pageView:(KIPageView *)pageView cellAtIndex:(NSInteger)index {
    if (pageView == self.xPageView) {
        XPageViewCell *cell = (XPageViewCell *)[pageView dequeueReusableCellWithIdentifier:@"xCell"];
        if (!cell) {
            cell = [[XPageViewCell alloc] initWithIdentifier:@"xCell"];
            cell.frame = CGRectMake(0, 0, self.xScaleWidth, self.xPageView.frame.size.height);
        }
        NSString *text = index < self.xArray.count ? self.xArray[index] : @"--";;
        [cell updateSubviews:text];
        return cell;
    } else if (pageView == self.yPageView) {
        YPageViewCell *cell = (YPageViewCell *)[pageView dequeueReusableCellWithIdentifier:@"yCell"];
        if (!cell) {
            cell = [[YPageViewCell alloc] initWithIdentifier:@"yCell"];
            cell.frame = CGRectMake(0, 0, self.yPageView.frame.size.width, self.yScaleHeight);
        }
        NSNumber *text = index < self.yScaleValues.count ? self.yScaleValues[self.yScaleValues.count -1-index] : @"--";;
        [cell updateSubviews:text.stringValue];
        return cell;
    }
    return nil;
}
- (CGFloat)pageView:(KIPageView *)pageView widthForCellAtIndex:(NSInteger)index {
    if (pageView == self.xPageView) {
        return self.xScaleWidth;
    } else if (pageView == self.yPageView) {
        return self.yPageView.frame.size.width;
    }
    return 0;
}
- (CGFloat)pageView:(KIPageView *)pageView heightForCellAtIndex:(NSInteger)index {
    if (pageView == self.xPageView) {
        return self.xPageView.frame.size.height;
    } else if (pageView == self.yPageView) {
        return self.yScaleHeight;
    }
    return 0;
}
- (void)updateZoomXRatio:(CGFloat)xRatio YRatio:(CGFloat)yRatio contentOffset:(CGPoint)offset {
    
}

- (KIPageView *)xPageView {
    if (!_xPageView) {
        _xPageView = [[KIPageView alloc] initWithOrientation:KIPageViewHorizontal];
        _xPageView.zoomDirection = YHPageViewZoomDirectionX;
        _xPageView.delegate = self;
        _xPageView.frame = CGRectMake(60, 464, self.view.frame.size.width-100, 40);
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

- (KIPageView *)yPageView {
    if (!_yPageView) {
        _yPageView = [[KIPageView alloc] initWithOrientation:KIPageViewVertical];
        _yPageView.zoomDirection = YHPageViewZoomDirectionY;
        _yPageView.delegate = self;
        _yPageView.frame = CGRectMake(0, 64, 60, 400);
    }
    return _yPageView;
}
- (CGFloat)yScaleHeight {
    if (_yScaleHeight == 0) {
        CGFloat yPageVeiwH = self.yPageView.frame.size.height;
        CGFloat perHeight = (yPageVeiwH-self.yScaleValues.count*self.yPageView.cellMargin)/self.yScaleValues.count;
        _yScaleHeight = perHeight > 40 ? perHeight: 40;
    }
    return _yScaleHeight;
}
- (void)findYMaxMinValue {
    _minYValue = [self.yArray[0] floatValue];
    _maxYValue = [self.yArray[0] floatValue];
    [self findMaxAndMinValue:0 rightIndex:self.yArray.count-1];
}
- (void)calculateYScale {
    if (_minYValue >= 0) {
        _yPositiveScaleNum = 4;
        _yNegativeScaleNum = 0;
        _yValuePerScale = ceil(_maxYValue/4.0);
    } else if (_maxYValue <= 0) {
        _yPositiveScaleNum = 4;
        _yNegativeScaleNum = 0;
        _yValuePerScale = ceil(fabs(_minYValue)/4.0);
    } else if (_maxYValue >= fabs(_minYValue)) {
        _yPositiveScaleNum = 4;
        _yValuePerScale = ceil(_maxYValue/4.0);
        _yNegativeScaleNum = ceil(fabs(_minYValue)/_yValuePerScale);
    } else {
        _yPositiveScaleNum = ceil(_maxYValue/_yValuePerScale);
        _yValuePerScale = ceil(fabs(_minYValue)/4.0);
        _yNegativeScaleNum = 4;
    }
}

- (void)findMaxAndMinValue:(NSUInteger)leftIndex rightIndex:(NSUInteger)rightIndex {
    if (leftIndex == rightIndex) {
        self.minYValue = MIN([self.yArray[leftIndex] floatValue], self.minYValue);
        self.maxYValue = MAX([self.yArray[leftIndex] floatValue], self.maxYValue);
        return;
    } else if(leftIndex == rightIndex-1) {
        if ([self.yArray[leftIndex] floatValue] < [self.yArray[rightIndex] floatValue]) {
            self.minYValue = MIN([self.yArray[leftIndex] floatValue], self.minYValue);
            self.maxYValue = MAX([self.yArray[rightIndex] floatValue], self.maxYValue);
            return;
        } else {
            self.minYValue = MIN([self.yArray[rightIndex] floatValue], self.minYValue);
            self.maxYValue = MAX([self.yArray[leftIndex] floatValue], self.maxYValue);
            return;
        }
    }
    NSUInteger mid = (leftIndex + rightIndex)/2;
    [self findMaxAndMinValue:leftIndex rightIndex:mid];
    [self findMaxAndMinValue:mid + 1 rightIndex:rightIndex];
}

- (NSArray *)yScaleValues {
    if (!_yScaleValues) {
        _yScaleValues = [NSMutableArray arrayWithCapacity:(_yPositiveScaleNum+_yNegativeScaleNum)];
        for (NSUInteger i=_yNegativeScaleNum; i>0; i++) {
            [_yScaleValues addObject:@(self.yValuePerScale * i * -1)];
        }
        for (NSUInteger i=0; i<_yPositiveScaleNum; i++) {
            [_yScaleValues addObject:@(self.yValuePerScale * i)];
        }
        
    }
    return _yScaleValues;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
