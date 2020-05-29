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

@property (nonatomic, assign) YXFuncCycleScrollViewType showType; //显示类型
@property (nonatomic, assign) BOOL boolHorizontal; //滚动方向是否为水平滚动
@property (nonatomic, strong) UIScrollView *scrollView; //滚动视图
@property (nonatomic, strong) NSMutableArray *imgViewsArr; //图片视图数组
@property (nonatomic, strong) NSTimer *timer; //时间控制器
@property (nonatomic, strong) UIView *pageBackView; //分页背景视图
@property (nonatomic, strong) YXPageControl *pageControl; //分页控制器
@property (nonatomic, strong) UIButton *pageBtn; //分页计算按钮
@property (nonatomic, assign) BOOL boolOpenTimer; //是否开启定时器
@property (nonatomic, assign) CGFloat imgVSize; //卡片式图片尺寸
@property (nonatomic, assign) CGFloat rollingDistance; //滚动距离

@end

@implementation YXFuncCycleScrollView

#pragma mark - 移除Timer
- (void)dealloc {
    
    if (_timer) {
        [self stopTimer];
    }
}

#pragma mark - 初始化视图
- (instancetype)initWithFrame:(CGRect)frame showType:(YXFuncCycleScrollViewType)showType directionType:(YXFuncCycleScrollViewDirectionType)directionType {
    self = [super initWithFrame:frame];
    
    if (self) {
        _showType = showType;
        _boolHorizontal = directionType == YXFuncCycleScrollViewDirectionTypeHorizontal ? YES : NO;
        
        [self initView];
        _rollingDistance = _boolHorizontal ? _scrollView.bounds.size.width : _scrollView.bounds.size.height;
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
    [_pageBtn setTitle:[NSString stringWithFormat:@" %@/%@ ", @(_pageControl.currentPage + 1), @(self.imgValueArr.count)] forState:UIControlStateNormal];
    
    [self scrollViewBlock];
}

#pragma mark - 根据显示类型更改图片显示位置
- (void)changeImgVShowFrame {
    
    __weak typeof(self) weakSelf = self;
    __block CGFloat scrollViewWidth = _scrollView.frame.size.width;
    __block CGFloat scrollViewHeight = _scrollView.frame.size.height;
    __block CGFloat top = self.edgeInsets.top;
    __block CGFloat left = self.edgeInsets.left;
    __block CGFloat bottom = self.edgeInsets.bottom;
    __block CGFloat right = self.edgeInsets.right;
    
    if (_boolHorizontal) {
        [_imgViewsArr enumerateObjectsUsingBlock:^(UIImageView *  _Nonnull imgV, NSUInteger idx, BOOL * _Nonnull stop) {
            
            switch (weakSelf.showType) {
                case YXFuncCycleScrollViewTypeFull: {
                    imgV.frame = CGRectMake(scrollViewWidth *idx, 0, scrollViewWidth, scrollViewHeight);
                    break;
                }
                case YXFuncCycleScrollViewTypeEdge: {
                    imgV.frame = CGRectMake(scrollViewWidth *idx + left, top, scrollViewWidth - (left + right), scrollViewHeight - (top + bottom));
                    imgV.clipsToBounds = YES;
                    break;
                }
                case YXFuncCycleScrollViewTypeCard: {
                    weakSelf.imgVSize = scrollViewWidth - left;
                    imgV.frame = CGRectMake((weakSelf.imgVSize + right) *idx, top, weakSelf.imgVSize, scrollViewHeight - (top + bottom));
                    imgV.clipsToBounds = YES;
                    break;
                }
                default:
                    break;
            }
        }];
        
        CGFloat imgCriticalValue = _imgVSize != 0 ? weakSelf.imgVSize : scrollViewWidth;
        _rollingDistance = _imgVSize != 0 ? (imgCriticalValue + right) : scrollViewWidth;
        if (_showType == YXFuncCycleScrollViewTypeCard) {
            _scrollView.clipsToBounds = NO;
            _scrollView.frame = CGRectMake(left /2, 0, _rollingDistance, scrollViewHeight);
            [_scrollView setContentSize:CGSizeMake((imgCriticalValue + right) *_imgViewsArr.count, scrollViewHeight)];
            [_scrollView setContentOffset:CGPointMake(_rollingDistance, 0)];
        }
    }
    else {
        [_imgViewsArr enumerateObjectsUsingBlock:^(UIImageView *  _Nonnull imgV, NSUInteger idx, BOOL * _Nonnull stop) {
            switch (weakSelf.showType) {
                case YXFuncCycleScrollViewTypeFull: {
                    imgV.frame = CGRectMake(0, scrollViewHeight *idx, scrollViewWidth, scrollViewHeight);
                    break;
                }
                case YXFuncCycleScrollViewTypeEdge: {
                    imgV.frame = CGRectMake(left, scrollViewHeight *idx + top, scrollViewWidth - (left + right), scrollViewHeight - (top + bottom));
                    imgV.clipsToBounds = YES;
                    break;
                }
                case YXFuncCycleScrollViewTypeCard: {
                    weakSelf.imgVSize = scrollViewHeight - top;
                    imgV.frame = CGRectMake(left, (weakSelf.imgVSize + bottom) *idx, scrollViewWidth - (left + right), weakSelf.imgVSize);
                    imgV.clipsToBounds = YES;
                    break;
                }
                default:
                    break;
            }
        }];
        
        CGFloat imgCriticalValue = _imgVSize != 0 ? weakSelf.imgVSize : scrollViewHeight;
        _rollingDistance = _imgVSize != 0 ? (imgCriticalValue + bottom) : scrollViewHeight;
        if (_showType == YXFuncCycleScrollViewTypeCard) {
            _scrollView.clipsToBounds = NO;
            _scrollView.frame = CGRectMake(0, top /2, scrollViewWidth, _rollingDistance);
            [_scrollView setContentSize:CGSizeMake(scrollViewWidth, (imgCriticalValue + bottom) *_imgViewsArr.count)];
            [_scrollView setContentOffset:CGPointMake(0, _rollingDistance)];
        }
    }
}

#pragma mark - 更改图片显示圆角
- (void)changeImgVShowCornerRadius {
    
    __weak typeof(self) weakSelf = self;
    [_imgViewsArr enumerateObjectsUsingBlock:^(UIImageView *  _Nonnull imgV, NSUInteger idx, BOOL * _Nonnull stop) {

        imgV.layer.cornerRadius = weakSelf.cornerRadius;
        imgV.layer.masksToBounds = YES;
    }];
}

#pragma mark - 设置滚动范围
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *view = [super hitTest:point withEvent:event];
    
    CGFloat scrollViewX = _scrollView.frame.origin.x;
    CGFloat scrollViewY = _scrollView.frame.origin.y;
    CGFloat scrollViewOffsetX = _scrollView.contentOffset.x;
    CGFloat scrollViewOffsetY = _scrollView.contentOffset.y;
    if ([view isEqual:self]) {
        for (UIView *subview in _scrollView.subviews) {
            CGPoint offset = CGPointMake(point.x - scrollViewX + scrollViewOffsetX - subview.frame.origin.x,
                                         point.y - scrollViewY + scrollViewOffsetY - subview.frame.origin.y);
            if ((view = [subview hitTest:offset withEvent:event])) {
                return view;
            }
        }
        return _scrollView;
    }
    
    return view;
}

#pragma mark - processTimer
- (void)processTimer {

    if (_boolHorizontal) {
        [_scrollView setContentOffset:CGPointMake(_rollingDistance *2, 0) animated:YES];
    }
    else {
        [_scrollView setContentOffset:CGPointMake(0, _rollingDistance *2) animated:YES];
    }
}

#pragma mark - 点击分页控制器
- (void)changePageControl:(UIPageControl *)pageControl {
    
    self.currentPage = pageControl.currentPage;
}

#pragma mark - 单击图片
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

#pragma mark - 滚动视图block
- (void)scrollViewBlock {
    
    if (self.yxFuncCycleScrollViewMoveBlock) {
        self.yxFuncCycleScrollViewMoveBlock(_pageControl.currentPage);
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
    
    CGFloat offsetOrigin = 0.f;
    if (_boolHorizontal) {
        offsetOrigin = scrollView.contentOffset.x;
    }
    else {
        offsetOrigin = scrollView.contentOffset.y;
    }
    
    if (offsetOrigin >= 2 *_rollingDistance) { //滑动到右边视图
        [self updateLastValue];
        _pageControl.currentPage = _pageControl.currentPage == self.imgValueArr.count - 1 ? 0 : _pageControl.currentPage + 1;
    }
    else if (offsetOrigin <= 0) { //滑动到左边视图
        [self updateFirstValue];
        _pageControl.currentPage = _pageControl.currentPage == 0 ? self.imgValueArr.count - 1 : _pageControl.currentPage - 1;
    }
    else {
        return;
    }
    
    [self setImageFromImageNames];
    if (_boolHorizontal) {
        [scrollView setContentOffset:CGPointMake(_rollingDistance, 0)];
    }
    else {
        [scrollView setContentOffset:CGPointMake(0, _rollingDistance)];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (_boolOpenTimer) {
        [self closeTimer];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (_boolOpenTimer) {
        [self openTimer];
    }
}

#pragma mark - setting
#pragma mark - 图片名数组
- (void)setImgValueArr:(NSMutableArray *)imgValueArr {
    
    _imgValueArr = imgValueArr;
    
    if (_imgValueArr.count == 0) {
        [self closeTimer];
        _pageBackView.hidden = YES;
        _boolOpenTimer = NO;
        return;
    }
    else if (_imgValueArr.count == 1) {
        [_imgValueArr addObjectsFromArray:imgValueArr];
        [_imgValueArr addObjectsFromArray:imgValueArr];
        _pageBackView.hidden = YES;
        _scrollView.scrollEnabled = NO;
        [self closeTimer];
        _boolOpenTimer = NO;
    }
    else {
        _pageBackView.hidden = NO;
        _scrollView.scrollEnabled = YES;
        [self updateFirstValue];
        _boolOpenTimer = YES;
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
        _boolOpenTimer = YES;
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
        if (_boolHorizontal) {
            if (i <= _pageControl.currentPage) {
                [_scrollView setContentOffset:CGPointMake(_rollingDistance *2, 0)];
            }
            else {
                [_scrollView setContentOffset:CGPointMake(_rollingDistance, 0)];
            }
        }
        else {
            if (i <= _pageControl.currentPage) {
                [_scrollView setContentOffset:CGPointMake(0, _rollingDistance *2)];
            }
            else {
                [_scrollView setContentOffset:CGPointMake(0, _rollingDistance)];
            }
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

#pragma mark - 显示边距
- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
    
    _edgeInsets = edgeInsets;
    [self changeImgVShowFrame];
}

#pragma mark - 显示圆角
- (void)setCornerRadius:(CGFloat)cornerRadius {
    
    _cornerRadius = cornerRadius;
    [self changeImgVShowCornerRadius];
}

#pragma mark - 初始化视图
- (void)initView {
    
    self.clipsToBounds = YES;
    _imgViewsArr = [[NSMutableArray alloc] init];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    if (_boolHorizontal) {
        [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width *3, _scrollView.frame.size.height)];
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    }
    else {
        [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height *3)];
        [_scrollView setContentOffset:CGPointMake(0, _scrollView.frame.size.height)];
    }
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = YES;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    for (int i = 0; i < 3; i ++) {
        UIImageView *imgV = [[UIImageView alloc] init];
        if (_boolHorizontal) {
            imgV.frame = CGRectMake(_scrollView.frame.size.width *i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
        }
        else {
            imgV.frame = CGRectMake(0, _scrollView.frame.size.height *i, _scrollView.frame.size.width, _scrollView.frame.size.height);
        }
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        imgV.userInteractionEnabled = NO;
        [_scrollView addSubview:imgV];
        [_imgViewsArr addObject:imgV];
    }
    
    _pageBackView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bounds) - 20, CGRectGetWidth(self.bounds), 20)];
    _pageBackView.backgroundColor = [UIColor clearColor];
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
    
    _pageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _pageBtn.frame = CGRectMake(self.bounds.size.width - 40, 20, 30, 22);
    [_pageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_pageBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    _pageBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    _pageBtn.layer.cornerRadius = 11;
    _pageBtn.layer.masksToBounds = YES;
    [self addSubview:_pageBtn];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    [_scrollView addGestureRecognizer:singleTap];
}

@end
