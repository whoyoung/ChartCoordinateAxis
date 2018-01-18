//
//  ViewController.m
//  ChartCoordinateAxis
//
//  Created by 杨虎 on 2018/1/15.
//  Copyright © 2018年 杨虎. All rights reserved.
//
static const float lineWidth = 1.0;
#import "HorizontolViewController.h"
#import "KIPageView.h"
#import "XNamePageViewCell.h"
#import "YNumberPageViewCell.h"
#import "DataHorizontolPageViewCell.h"
@interface HorizontolViewController ()<KIPageViewDelegate>
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

@implementation HorizontolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self prepareData];
    [self findYMaxMinValue];
    [self calculateYScale];
    [self.view addSubview:self.yPageView];
    [self.view addSubview:self.xPageView];
    [self addSeparatorLine];
    [self.view addSubview:self.dataPageView];
}

- (void)prepareData {
    _xArray = @[@"a",@"bbbbbbb",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l"];
    _yArray = @[@"5",@"4",@"3",@"2",@"1",@"2",@"3",@"4",@"5",@"10",@"-10",@"-15"];
}
- (void)addSeparatorLine {
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.yPageView.frame), CGRectGetMinY(self.yPageView.frame), lineWidth, CGRectGetHeight(self.yPageView.frame))];
    rightLine.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightLine];
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.xPageView.frame), CGRectGetMaxY(self.yPageView.frame), CGRectGetWidth(self.xPageView.frame), lineWidth)];
    bottomLine.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottomLine];
}
#pragma mark *************************** KIPageViewDelegate
- (NSInteger)numberOfCellsInPageView:(KIPageView *)pageView {
    if (pageView == self.xPageView) {
        return self.xArray.count;
    } else if (pageView == self.yPageView) {
        return self.yPositiveScaleNum + self.yNegativeScaleNum;
    } else if (pageView == self.dataPageView) {
        return self.xArray.count;
    }
    return 0;
}
- (KIPageViewCell *)pageView:(KIPageView *)pageView cellAtIndex:(NSInteger)index {
    if (pageView == self.xPageView) {
        XNamePageViewCell *cell = (XNamePageViewCell *)[pageView dequeueReusableCellWithIdentifier:@"xCell"];
        if (!cell) {
            cell = [[XNamePageViewCell alloc] initWithIdentifier:@"xCell"];
            cell.frame = CGRectMake(0, 0, self.xScaleWidth, self.xPageView.frame.size.height);
        }
        NSString *text = index < self.xArray.count ? self.xArray[index] : @"--";;
        [cell updateSubviews:text];
        return cell;
    } else if (pageView == self.yPageView) {
        YNumberPageViewCell *cell = (YNumberPageViewCell *)[pageView dequeueReusableCellWithIdentifier:@"yCell"];
        if (!cell) {
            cell = [[YNumberPageViewCell alloc] initWithIdentifier:@"yCell"];
            cell.frame = CGRectMake(0, 0, self.yPageView.frame.size.width, self.yScaleHeight);
        }
        NSNumber *text = index < self.yScaleValues.count ? self.yScaleValues[self.yScaleValues.count -1-index] : @"--";;
        [cell updateSubviews:text.stringValue];
        return cell;
    } else if (pageView == self.dataPageView) {
        DataHorizontolPageViewCell *cell = (DataHorizontolPageViewCell *)[pageView dequeueReusableCellWithIdentifier:@"dataCell"];
        if (!cell) {
            cell = [[DataHorizontolPageViewCell alloc] initWithIdentifier:@"dataCell"];
            cell.frame = CGRectMake(0, 0, self.xScaleWidth, self.dataPageView.frame.size.height);
            cell.backgroundColor = [UIColor purpleColor];
            cell.zeroLineReferencePosition = 1.0*self.yPositiveScaleNum/(self.yNegativeScaleNum + self.yPositiveScaleNum);
        }
        NSString *text = index < self.yArray.count ? self.yArray[index] : @"--";
        CGFloat value = [text floatValue];
        CGFloat height = value/_yValuePerScale * _yScaleHeight;
        [cell updateSubviews:text height:height];
        return cell;
    }
    return nil;
}
- (CGFloat)pageView:(KIPageView *)pageView widthForCellAtIndex:(NSInteger)index {
    if (pageView == self.xPageView) {
        return self.xScaleWidth;
    } else if (pageView == self.yPageView) {
        return self.yPageView.frame.size.width;
    } else if (pageView == self.dataPageView) {
        return self.xScaleWidth;
    }
    return 0;
}
- (CGFloat)pageView:(KIPageView *)pageView heightForCellAtIndex:(NSInteger)index {
    if (pageView == self.xPageView) {
        return self.xPageView.frame.size.height;
    } else if (pageView == self.yPageView) {
        return self.yScaleHeight;
    } else if (pageView == self.dataPageView) {
        return self.dataPageView.frame.size.height;
    }
    return 0;
}

- (void)pageView:(KIPageView *)pageView didZoomingXRatio:(CGFloat)xRatio YRatio:(CGFloat)yRatio offset:(CGPoint)offset {
    if (pageView == self.dataPageView) {
//        [self.yPageView updateZoomXRatio:xRatio YRatio:yRatio contentOffset:offset];
        [self.xPageView updateZoomXRatio:xRatio YRatio:yRatio contentOffset:offset];
    }
    
}
- (void)pageView:(KIPageView *)pageView didScrollOffset:(CGPoint)offset {
    if (pageView == self.dataPageView) {
        [self.xPageView adjustScrollViewOffset:offset];
    }
}
#pragma mark ****************** YPageVeiw
- (KIPageView *)yPageView {
    if (!_yPageView) {
        _yPageView = [[KIPageView alloc] initWithOrientation:KIPageViewVertical];
        _yPageView.zoomDirection = YHPageViewZoomDirectionNone;
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
        _yNegativeScaleNum = 4;
        _yValuePerScale = ceil(fabs(_minYValue)/4.0);
        _yPositiveScaleNum = ceil(_maxYValue/_yValuePerScale);
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
        for (NSUInteger i=_yNegativeScaleNum; i>0; i--) {
            [_yScaleValues addObject:@(self.yValuePerScale * i * -1)];
        }
        for (NSUInteger i=0; i<_yPositiveScaleNum; i++) {
            [_yScaleValues addObject:@(self.yValuePerScale * i)];
        }
        
    }
    return _yScaleValues;
}

#pragma mark ****************** XPageVeiw
- (KIPageView *)xPageView {
    if (!_xPageView) {
        _xPageView = [[KIPageView alloc] initWithOrientation:KIPageViewHorizontal];
        _xPageView.zoomDirection = YHPageViewZoomDirectionNone;
        _xPageView.delegate = self;
        _xPageView.cellMargin = 6;
        _xPageView.frame = CGRectMake(CGRectGetMaxX(self.yPageView.frame)+lineWidth, CGRectGetMaxY(self.yPageView.frame)+lineWidth, self.view.frame.size.width-100, 15);
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

#pragma mark ****************** DataPageVeiw
- (KIPageView *)dataPageView {
    if (!_dataPageView) {
        _dataPageView = [[KIPageView alloc] initWithOrientation:KIPageViewHorizontal];
        _dataPageView.zoomDirection = YHPageViewZoomDirectionX;
        _dataPageView.delegate = self;
        _dataPageView.cellMargin = 6;
        _dataPageView.frame = CGRectMake(CGRectGetMinX(_xPageView.frame), CGRectGetMinY(_yPageView.frame), CGRectGetWidth(_xPageView.frame), CGRectGetHeight(_yPageView.frame));
    }
    return _dataPageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
