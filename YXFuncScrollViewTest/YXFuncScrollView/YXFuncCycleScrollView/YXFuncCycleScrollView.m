//
//  YXFuncCycleScrollView.m
//  YXFuncScrollViewTest
//
//  Created by ios on 2020/5/22.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXFuncCycleScrollView.h"
#import "YXPageControl.h"

@interface YXFuncCycleScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *imgViewsArr; //图片视图数组
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIView *pageBackView;
@property (nonatomic, strong) YXPageControl *pageControl;

@end

@implementation YXFuncCycleScrollView

- (void)dealloc {
    
    if (_timer) [self stopTimer];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - 设置图片
- (void)setImageFromImageNames {
    
    NSInteger i = 0;
    for (UIImageView *imageView in _imgViewsArr) {
        if (self.imgValueArr.count < 3 && i > 1) { //只有两张图片时，将最后一张视图的图片，以第一张图片进行设置。
            YXFuncCycleScrollViewValueInfoModel *infoModel = self.imgValueArr.firstObject;
            [imageView setImage:[UIImage imageNamed:infoModel.imgUrl]];
        }
        else {
            YXFuncCycleScrollViewValueInfoModel *infoModel = self.imgValueArr[i];
            [imageView setImage:[UIImage imageNamed:infoModel.imgUrl]];
        }
        i++;
    }
}

#pragma mark - processTimer
- (void)processTimer {

    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width *2, 0) animated:YES];
}

#pragma mark - 点击分页控制器
- (void)changePageControl:(UIPageControl *)pageControl {
    
    self.currentPage = pageControl.currentPage;
}

#pragma mark - 单击
- (void)singleTapAction:(UITapGestureRecognizer *)gesture {
    
    if (self.yxFuncCycleScrollViewBlock) {
        YXFuncCycleScrollViewValueInfoModel *infoModel = [[YXFuncCycleScrollViewValueInfoModel alloc] init];
        if (self.imgValueArr.count > 1) {
            infoModel = self.imgValueArr[1];
        }
        else {
            infoModel = self.imgValueArr.firstObject;
        }
        self.yxFuncCycleScrollViewBlock(infoModel);
    }
}

#pragma mark - 更新第一条数据
- (void)updateFirstValue {
    
    YXFuncCycleScrollViewValueInfoModel *infoModel = self.imgValueArr.lastObject;
    [self.imgValueArr removeLastObject];
    [self.imgValueArr insertObject:infoModel atIndex:0];
}

#pragma mark - 更新最后一条数据
- (void)updateLastValue {
    
    YXFuncCycleScrollViewValueInfoModel *infoModel = self.imgValueArr.firstObject;
    [self.imgValueArr removeObjectAtIndex:0];
    [self.imgValueArr addObject:infoModel];
}

#pragma mark - 移除Timer
- (void)stopTimer {
    
    [_timer invalidate];
    _timer = nil;
}
#pragma mark - 关闭Timer
- (void)closeTimer {
    
    [_timer setFireDate:[NSDate distantFuture]];
}
#pragma mark - 开启Timer
- (void)openTimer {
    
    _timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.timeInterval];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_scrollView.contentOffset.x >= 2 *_scrollView.frame.size.width) { //滑动到右边视图
        [self updateLastValue];
        _pageControl.currentPage = _pageControl.currentPage == self.imgValueArr.count - 1 ? 0 : _pageControl.currentPage + 1;
    }
    else if (_scrollView.contentOffset.x <= 0) { //滑动到左边视图
        [self updateFirstValue];
        _pageControl.currentPage = _pageControl.currentPage == 0 ? self.imgValueArr.count - 1 : _pageControl.currentPage - 1;
    }
    else {
        return;
    }
    
    [self setImageFromImageNames];
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}
#pragma mark - 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self closeTimer];
}
#pragma mark - 结束拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self openTimer];
}

#pragma mark - setting
#pragma mark - 图片名数组
- (void)setImgValueArr:(NSMutableArray *)imgValueArr {
    
    _imgValueArr = imgValueArr;
    
    if (_imgValueArr.count == 0) {
        [self closeTimer];
        _pageBackView.hidden = YES;
        return;
    }
    else if (_imgValueArr.count == 1) {
        [_imgValueArr addObjectsFromArray:imgValueArr];
        [_imgValueArr addObjectsFromArray:imgValueArr];
        _pageBackView.hidden = YES;
        _scrollView.scrollEnabled = NO;
        [self closeTimer];
    }
    else {
        _pageBackView.hidden = NO;
        _scrollView.scrollEnabled = YES;
        [self updateFirstValue];
    }
    
    _pageControl.numberOfPages = _imgValueArr.count;
    [self setImageFromImageNames];
}

#pragma mark - 是否含有定时器
- (void)setBoolContainTimer:(BOOL)boolContainTimer {
    
    _boolContainTimer = boolContainTimer;
}
#pragma mark - 间隔时间
- (void)setTimeInterval:(CGFloat)timeInterval {
    
    _timeInterval = timeInterval;
    if (self.boolContainTimer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(processTimer) userInfo:nil repeats:YES];
    }
}

#pragma mark - 是否显示分页控制器
- (void)setBoolShowPageControl:(BOOL)boolShowPageControl {
    
    _boolShowPageControl = boolShowPageControl;
    _pageBackView.hidden =! _boolShowPageControl;
}
#pragma mark - 分页控制器坐标
- (void)setPageframe:(CGRect)pageframe {
    
    _pageframe = pageframe;
    _pageBackView.frame = _pageframe;
}
#pragma mark - 当前页码
- (void)setCurrentPage:(NSInteger)currentPage {
    
    _currentPage = currentPage;
    
    for (NSInteger i = 0; i < _currentPage; i ++) {
        if (i <= _pageControl.currentPage) {
            [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width *2, 0)];
        }
        else {
            [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
        }
    }
}
#pragma mark - 是否开启分页控制
- (void)setBoolOpenPageControl:(BOOL)boolOpenPageControl {
    
    _boolOpenPageControl = boolOpenPageControl;
    _pageControl.userInteractionEnabled = _boolOpenPageControl;
}
#pragma mark - 分页视图背景颜色
- (void)setPageBgColor:(UIColor *)pageBgColor {
    
    _pageBgColor = pageBgColor;
    _pageBackView.backgroundColor = _pageBgColor;
}
#pragma mark - 分页视图背景透明度
- (void)setPageBgAlpha:(CGFloat)pageBgAlpha {
    
    _pageBgAlpha = pageBgAlpha;
    _pageBackView.backgroundColor = [self.pageBgColor colorWithAlphaComponent:_pageBgAlpha];
}
#pragma mark - 普通分页颜色
- (void)setNorPageColor:(UIColor *)norPageColor {
    
    _norPageColor = norPageColor;
    _pageControl.pageIndicatorTintColor = _norPageColor;
}
#pragma mark - 选中分页颜色
- (void)setSelPageColor:(UIColor *)selPageColor {
    
    _selPageColor = selPageColor;
    _pageControl.currentPageIndicatorTintColor = _selPageColor;
}
#pragma mark - 普通分页图片
- (void)setNorPageImg:(UIImage *)norPageImg {
    
    _norPageImg = norPageImg;
    _pageControl.norImg = _norPageImg;
}
#pragma mark - 选中分页图片
- (void)setSelPageImg:(UIImage *)selPageImg {
    
    _selPageImg = selPageImg;
    _pageControl.selImg = _selPageImg;
}

#pragma mark - 初始化视图
- (void)initView {
    
    _imgViewsArr = [[NSMutableArray alloc] init];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width *3, _scrollView.frame.size.height)];
    _scrollView.backgroundColor = [UIColor clearColor];
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = YES;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    for (int i = 0; i < 3; i ++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width *i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.userInteractionEnabled = NO;
        [_scrollView addSubview:img];
        [_imgViewsArr addObject:img];
    }
    
    _pageBackView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bounds) - 20, CGRectGetWidth(self.bounds), 20)];
    _pageBackView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.6];
    [self addSubview:_pageBackView];
    
    _pageControl = [[YXPageControl alloc] initWithFrame:_pageBackView.bounds];
    _pageControl.center = CGPointMake(CGRectGetMidX(_pageBackView.bounds), CGRectGetMidY(_pageBackView.bounds));
    _pageControl.numberOfPages = _imgViewsArr.count;
    _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPage = 0;
    _pageControl.userInteractionEnabled = self.boolOpenPageControl;
    [_pageControl addTarget:self action:@selector(changePageControl:) forControlEvents:UIControlEventTouchUpInside];
    [_pageBackView addSubview:_pageControl];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    [self.scrollView addGestureRecognizer:singleTap];
}

@end
