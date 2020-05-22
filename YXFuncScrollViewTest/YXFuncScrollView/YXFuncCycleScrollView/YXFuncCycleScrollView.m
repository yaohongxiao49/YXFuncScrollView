//
//  YXFuncCycleScrollView.m
//  YXFuncScrollViewTest
//
//  Created by ios on 2020/5/22.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXFuncCycleScrollView.h"

@interface YXFuncCycleScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *imgViewsArr; //图片视图数组
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation YXFuncCycleScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - 初始化视图
- (void)initView {
    
    _imgViewsArr = [[NSMutableArray alloc] init];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(processTimer) userInfo:nil repeats:YES];
//    _timer.fireDate = [NSDate distantFuture];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width *3, _scrollView.frame.size.height)];
    _scrollView.backgroundColor = [UIColor clearColor];
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    _scrollView.showsHorizontalScrollIndicator = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = YES;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    for (int i = 0; i < 3; i ++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width *i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        img.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:img];
        [_imgViewsArr addObject:img];
    }
    
    UIView *pageBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 224, CGRectGetWidth(self.bounds), 20)];
    pageBackView.alpha = 0.6;
    pageBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
    [self addSubview:pageBackView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    _pageControl.center = CGPointMake(CGRectGetMidX(pageBackView.bounds), CGRectGetMidY(pageBackView.bounds));
    _pageControl.numberOfPages = _imgViewsArr.count;
    _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPage = 0;
    _pageControl.userInteractionEnabled = NO;
    [pageBackView addSubview:_pageControl];
}

#pragma mark - 设置图片
- (void)setImageFromImageNames {
    
    int i = 0;
    for (UIImageView *imageView in _imgViewsArr) {
        [imageView setImage:[UIImage imageNamed:_imageNamesArr[i]]];
        i++;
    }
}

#pragma mark - processTimer（时间控制器）
- (void)processTimer {

    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width *2, 0) animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_scrollView.contentOffset.x >= 2 *_scrollView.frame.size.width) { //滑动到右边视图
        NSString *firstImageName = [[NSString alloc] initWithString:_imageNamesArr.firstObject];
        [_imageNamesArr removeObjectAtIndex:0];
        [_imageNamesArr addObject:firstImageName];
        _pageControl.currentPage = _pageControl.currentPage == _imageNamesArr.count - 1 ? 0 : _pageControl.currentPage + 1;
    }
    else if (_scrollView.contentOffset.x <= 0) { //滑动到左边视图
        NSString *lastImageName = [[NSString alloc] initWithString: _imageNamesArr.lastObject];
        [_imageNamesArr removeLastObject];
        [_imageNamesArr insertObject:lastImageName atIndex:0];
        _pageControl.currentPage = _pageControl.currentPage == 0 ? _imageNamesArr.count - 1 : _pageControl.currentPage - 1;
    }
    else {
        return;
    }
    
    [self setImageFromImageNames];
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

#pragma mark - 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    _timer.fireDate = [NSDate distantFuture];
}

#pragma mark - 结束拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    _timer.fireDate = _timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
}

@end
