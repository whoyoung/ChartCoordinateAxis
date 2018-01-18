//
//  VerticalViewContoller.m
//  ChartCoordinateAxis
//
//  Created by 杨虎 on 2018/1/18.
//  Copyright © 2018年 杨虎. All rights reserved.
//

#import "VerticalViewContoller.h"
#import "KIPageView.h"
#import "XNumberPageVeiwCell.h"
#import "YNamePageViewCell.h"
#import "DataVerticalPageViewCell.h"

@interface VerticalViewContoller ()<KIPageViewDelegate>
@property (nonatomic, strong) KIPageView *xPageView;
@property (nonatomic, strong) KIPageView *yPageView;
@property (nonatomic, strong) KIPageView *dataPageView;
@property (nonatomic, strong) NSArray *xArray;
@property (nonatomic, strong) NSArray *yArray;
@property (nonatomic, assign) CGFloat xScaleWidth;
@property (nonatomic, assign) CGFloat yScaleHeight;
@property (nonatomic, assign) CGFloat xValuePerScale;
@property (nonatomic, assign) NSInteger xPositiveScaleNum;
@property (nonatomic, assign) NSInteger xNegativeScaleNum;

@property (nonatomic, strong) NSMutableArray *xScaleValues;
@property (nonatomic, assign) CGFloat minXValue;
@property (nonatomic, assign) CGFloat maxXValue;
@end

@implementation VerticalViewContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self prepareData];
    [self findXMaxMinValue];
    [self calculateXScale];
    [self.view addSubview:self.yPageView];
    [self.view addSubview:self.xPageView];
    [self.view addSubview:self.dataPageView];
}

- (void)prepareData {
    _yArray = @[@"a",@"bbbbbbb",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l"];
    _xArray = @[@"5",@"4",@"3",@"2",@"1",@"2",@"3",@"4",@"5",@"10",@"-10",@"-15"];
}

#pragma mark *************************** KIPageViewDelegate
- (NSInteger)numberOfCellsInPageView:(KIPageView *)pageView {
    if (pageView == self.xPageView) {
        return self.xPositiveScaleNum + self.xNegativeScaleNum;
    } else if (pageView == self.yPageView) {
        return self.yArray.count;
    } else if (pageView == self.dataPageView) {
        return self.yArray.count;
    }
    return 0;
}
- (KIPageViewCell *)pageView:(KIPageView *)pageView cellAtIndex:(NSInteger)index {
    if (pageView == self.xPageView) {
        XNumberPageVeiwCell *cell = (XNumberPageVeiwCell *)[pageView dequeueReusableCellWithIdentifier:@"xCell"];
        if (!cell) {
            cell = [[XNumberPageVeiwCell alloc] initWithIdentifier:@"xCell"];
            cell.frame = CGRectMake(0, 0, self.xScaleWidth, self.xPageView.frame.size.height);
        }
        NSNumber *text = index < self.xScaleValues.count ? self.xScaleValues[index] : @"--";
        [cell updateSubviews:text.stringValue];
        return cell;
    } else if (pageView == self.yPageView) {
        YNamePageViewCell *cell = (YNamePageViewCell *)[pageView dequeueReusableCellWithIdentifier:@"yCell"];
        if (!cell) {
            cell = [[YNamePageViewCell alloc] initWithIdentifier:@"yCell"];
            cell.frame = CGRectMake(0, 0, self.yPageView.frame.size.width, self.yScaleHeight);
        }
        NSString *text = index < self.yArray.count ? self.yArray[self.yArray.count-1-index] : @"--";;
        [cell updateSubviews:text];
        return cell;
    } else if (pageView == self.dataPageView) {
        DataVerticalPageViewCell *cell = (DataVerticalPageViewCell *)[pageView dequeueReusableCellWithIdentifier:@"dataCell"];
        if (!cell) {
            cell = [[DataVerticalPageViewCell alloc] initWithIdentifier:@"dataCell"];
            cell.frame = CGRectMake(0, 0, self.dataPageView.frame.size.width, self.yScaleHeight);
            cell.backgroundColor = [UIColor purpleColor];
            cell.zeroLineReferencePosition = 1.0*self.xNegativeScaleNum/(self.xNegativeScaleNum + self.xPositiveScaleNum);
        }
        NSString *text = index < self.xArray.count ? self.xArray[index] : @"--";
        CGFloat value = [text floatValue];
        CGFloat width = value/self.xValuePerScale * self.xScaleWidth;
        [cell updateSubviews:text barWidth:width];
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
        return self.xPageView.frame.size.width;
    }
    return 0;
}
- (CGFloat)pageView:(KIPageView *)pageView heightForCellAtIndex:(NSInteger)index {
    if (pageView == self.xPageView) {
        return self.xPageView.frame.size.height;
    } else if (pageView == self.yPageView) {
        return self.yScaleHeight;
    } else if (pageView == self.dataPageView) {
        return self.yScaleHeight;
    }
    return 0;
}

- (void)pageView:(KIPageView *)pageView didZoomingXRatio:(CGFloat)xRatio YRatio:(CGFloat)yRatio offset:(CGPoint)offset {
    if (pageView == self.dataPageView) {
        //        [self.yPageView updateZoomXRatio:xRatio YRatio:yRatio contentOffset:offset];
        [self.yPageView updateZoomXRatio:xRatio YRatio:yRatio contentOffset:offset];
    }
    
}
- (void)pageView:(KIPageView *)pageView didScrollOffset:(CGPoint)offset {
    if (pageView == self.dataPageView) {
        [self.yPageView adjustScrollViewOffset:offset];
    }
}
#pragma mark ****************** YPageVeiw
- (KIPageView *)xPageView {
    if (!_xPageView) {
        _xPageView = [[KIPageView alloc] initWithOrientation:KIPageViewHorizontal];
        _xPageView.zoomDirection = YHPageViewZoomDirectionX;
        _xPageView.delegate = self;
        _xPageView.frame = CGRectMake(CGRectGetMaxX(self.yPageView.frame), CGRectGetMaxY(self.yPageView.frame), self.view.frame.size.width-100, 15);
    }
    return _xPageView;
}
- (CGFloat)xScaleWidth {
    if (_xScaleWidth == 0) {
        CGFloat xPageVeiwW = self.xPageView.frame.size.width;
        CGFloat perWidth = (xPageVeiwW-self.xScaleValues.count*self.xPageView.cellMargin)/self.xScaleValues.count;
        _xScaleWidth = perWidth > 40 ? perWidth: 40;
    }
    return _xScaleWidth;
}
- (void)findXMaxMinValue {
    _minXValue = [self.xArray[0] floatValue];
    _maxXValue = [self.xArray[0] floatValue];
    [self findMaxAndMinValue:0 rightIndex:self.xArray.count-1];
}
- (void)calculateXScale {
    if (_minXValue >= 0) {
        _xPositiveScaleNum = 4;
        _xNegativeScaleNum = 0;
        _xValuePerScale = ceil(_maxXValue/4.0);
    } else if (_maxXValue <= 0) {
        _xPositiveScaleNum = 4;
        _xNegativeScaleNum = 0;
        _xValuePerScale = ceil(fabs(_minXValue)/4.0);
    } else if (_maxXValue >= fabs(_minXValue)) {
        _xPositiveScaleNum = 4;
        _xValuePerScale = ceil(_maxXValue/4.0);
        _xNegativeScaleNum = ceil(fabs(_minXValue)/_xValuePerScale);
    } else {
        _xNegativeScaleNum = 4;
        _xValuePerScale = ceil(fabs(_minXValue)/4.0);
        _xPositiveScaleNum = ceil(_maxXValue/_xValuePerScale);
    }
}

- (void)findMaxAndMinValue:(NSUInteger)leftIndex rightIndex:(NSUInteger)rightIndex {
    if (leftIndex == rightIndex) {
        self.minXValue = MIN([self.xArray[leftIndex] floatValue], self.minXValue);
        self.maxXValue = MAX([self.xArray[leftIndex] floatValue], self.maxXValue);
        return;
    } else if(leftIndex == rightIndex-1) {
        if ([self.xArray[leftIndex] floatValue] < [self.xArray[rightIndex] floatValue]) {
            self.minXValue = MIN([self.xArray[leftIndex] floatValue], self.minXValue);
            self.maxXValue = MAX([self.xArray[rightIndex] floatValue], self.maxXValue);
            return;
        } else {
            self.minXValue = MIN([self.xArray[rightIndex] floatValue], self.minXValue);
            self.maxXValue = MAX([self.xArray[leftIndex] floatValue], self.maxXValue);
            return;
        }
    }
    NSUInteger mid = (leftIndex + rightIndex)/2;
    [self findMaxAndMinValue:leftIndex rightIndex:mid];
    [self findMaxAndMinValue:mid + 1 rightIndex:rightIndex];
}

- (NSArray *)xScaleValues {
    if (!_xScaleValues) {
        _xScaleValues = [NSMutableArray arrayWithCapacity:(_xPositiveScaleNum+_xNegativeScaleNum)];
        for (NSUInteger i=_xNegativeScaleNum; i>0; i--) {
            [_xScaleValues addObject:@(self.xValuePerScale * i * -1)];
        }
        for (NSUInteger i=0; i<_xPositiveScaleNum; i++) {
            [_xScaleValues addObject:@(self.xValuePerScale * i)];
        }
        
    }
    return _xScaleValues;
}

#pragma mark ****************** YPageVeiw
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
        CGFloat yPageHeight = self.yPageView.frame.size.height;
        CGFloat perHeight = (yPageHeight-self.yArray.count*self.yPageView.cellMargin)/self.yArray.count;
        _yScaleHeight = perHeight > 40 ? perHeight: 40;
    }
    return _yScaleHeight;
}

#pragma mark ****************** DataPageVeiw
- (KIPageView *)dataPageView {
    if (!_dataPageView) {
        _dataPageView = [[KIPageView alloc] initWithOrientation:KIPageViewVertical];
        _dataPageView.zoomDirection = YHPageViewZoomDirectionY;
        _dataPageView.delegate = self;
        _dataPageView.frame = CGRectMake(CGRectGetMaxX(_yPageView.frame), CGRectGetMinY(_yPageView.frame), CGRectGetWidth(_xPageView.frame), CGRectGetHeight(_yPageView.frame));
    }
    return _dataPageView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
