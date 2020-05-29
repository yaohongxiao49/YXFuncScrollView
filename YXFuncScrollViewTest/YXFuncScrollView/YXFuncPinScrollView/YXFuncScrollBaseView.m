//
//  YXFuncScrollBaseView.m
//  YXFuncScrollViewTest
//
//  Created by ios on 2020/4/24.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXFuncScrollBaseView.h"

@implementation YXFuncScrollBaseScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

@end

@interface YXFuncScrollBaseView () <UIScrollViewDelegate>
{
    BOOL _isMainScroll;  //是否滚动主视图
    BOOL _isCellScroll;  //是否滚动子视图
}

@property (nonatomic, weak) UIViewController *baseVC;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) BOOL boolHasNavi;
@property (nonatomic, assign) BOOL boolContainFrash;

@end

@implementation YXFuncScrollBaseView

- (instancetype)initWithFrame:(CGRect)frame baseVC:(UIViewController *)baseVC boolHasNavi:(BOOL)boolHasNavi boolContainFrash:(BOOL)boolContainFrash {
    self = [super initWithFrame:frame];
    if (self) {
        _baseVC = baseVC;
        _boolHasNavi = boolHasNavi;
        _boolContainFrash = boolContainFrash;
        [self initView];
    }
    return self;
}

#pragma mark - 更新滚动视图
- (void)updateScrollView {
    
    __weak typeof(self) weakSelf = self;
    [self.showViewArrs enumerateObjectsUsingBlock:^(UIView *  _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        
        view.frame = CGRectMake(weakSelf.baseScrollView.bounds.size.width *idx, 0, weakSelf.baseScrollView.bounds.size.width, weakSelf.scrollView.bounds.size.height);
        [weakSelf.scrollView addSubview:view];
    }];
    [self refreshrViewAtIndex:0];
}

#pragma mark - 更新栏目状态
- (void)refreshrViewAtIndex:(NSInteger)index {
    
    self.tabView.currentIndex = index;
    [self.scrollView setContentOffset:CGPointMake(self.baseScrollView.bounds.size.width *index, 0) animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(yxSwitchModuleByNowView:index:)]) {
        [self.delegate yxSwitchModuleByNowView:self.showTabArrs[index] index:index];
    }
}

#pragma mark - 初始化视图
- (void)initView {
    
    _isMainScroll = YES;
    _isCellScroll = NO;
    
    if (!_boolHasNavi) {
        self.baseScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

#pragma mark - setting
- (void)setTopView:(UIView *)topView {
    
    self.headerView = topView;
    [self updateScrollViewHeight];
}
- (void)setShowTabArrs:(NSMutableArray *)showTabArrs {
    
    _showTabArrs = showTabArrs;
    self.tabView.tabArrs = _showTabArrs;
}
- (void)setShowViewArrs:(NSMutableArray *)showViewArrs {
    
    _showViewArrs = showViewArrs;
    [self updateScrollView];
}
- (void)setNowScrollView:(UIView *)nowScrollView {
    
    _nowScrollView = nowScrollView;
    if ([_nowScrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)_nowScrollView;
        [self scrollViewDidScroll:tableView];
    }
    else if ([_nowScrollView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)_nowScrollView;
        [self scrollViewDidScroll:collectionView];
    }
    else if ([_nowScrollView isKindOfClass:[WKWebView class]]) {
        WKWebView *webview = (WKWebView *)_nowScrollView;
        [self scrollViewDidScroll:webview.scrollView];
    }
}

#pragma mark - 更新滚动视图高度
- (void)updateScrollViewHeight {
    
    self.tabView.frame = CGRectMake(0, CGRectGetMaxY([self.headerView frame]), self.baseScrollView.bounds.size.width, 50);
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY([self.tabView frame]), self.baseScrollView.bounds.size.width, self.baseScrollView.bounds.size.height - self.tabView.bounds.size.height);
    self.baseScrollView.contentSize = CGSizeMake(self.baseScrollView.bounds.size.width, self.baseScrollView.bounds.size.height + self.headerView.bounds.size.height);
}

#pragma mark - 还原滚动视图
- (void)reductionScrollView {
    
    [self.showViewArrs enumerateObjectsUsingBlock:^(UIView *  _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[UITableView class]]) {
                UITableView *tableView = (UITableView *)obj;
                tableView.contentOffset = CGPointZero;
            }
            else if ([obj isKindOfClass:[UICollectionView class]]) {
                UICollectionView *collectionView = (UICollectionView *)obj;
                collectionView.contentOffset = CGPointZero;
            }
            else if ([obj isKindOfClass:[WKWebView class]]) {
                WKWebView *webview = (WKWebView *)obj;
                webview.scrollView.contentOffset = CGPointZero;
            }
        }];
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == self.scrollView) {
        NSInteger page = scrollView.contentOffset.x /scrollView.bounds.size.width;
        if (self.tabView.currentIndex != page) {
            [self refreshrViewAtIndex:page];
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.scrollView) {
        return;
    }
    
    CGFloat offSetY = scrollView.contentOffset.y;
    CGFloat headerHeight = CGRectGetMaxY([self.headerView frame]);
    if (scrollView == self.baseScrollView) {
        if (_isMainScroll) {
            if (offSetY >= headerHeight) {
                scrollView.contentOffset = CGPointMake(0, headerHeight);
                _isMainScroll = NO;
                _isCellScroll = YES;
            }
            else {
                [self reductionScrollView];
            }
        }
        else {
            scrollView.contentOffset = CGPointMake(0, headerHeight);
        }
        scrollView.showsVerticalScrollIndicator = _isMainScroll;
    }
    else {
        if (_isCellScroll) {
            if (offSetY <= 0) {
                scrollView.contentOffset = CGPointZero;
                _isMainScroll = YES;
                _isCellScroll = NO;
            }
        }
        else {
            if (!_boolContainFrash) scrollView.contentOffset = CGPointZero;
        }
        scrollView.showsVerticalScrollIndicator = _isCellScroll;
    }
}

#pragma mark - 获取安全区域
- (UIEdgeInsets)yxsafeAreaInsets {
    
    if (@available(iOS 11.0, *)) {
        return [[UIApplication sharedApplication] keyWindow].safeAreaInsets;
    }
    else {
        return UIEdgeInsetsZero;
    }
}
#pragma mark - 是否是全面屏
- (BOOL)isFullIphone {
    
    if (self.yxsafeAreaInsets.bottom > 0.0) {
        return YES;
    }
    else {
        return NO;
    }
}
#pragma mark - 状态栏高度
- (CGFloat)sbHeight {
    
    if (self.isFullIphone) {
        return self.yxsafeAreaInsets.top;
    }
    else {
        return 20;
    }
}
#pragma mark - 导航栏高度
- (CGFloat)naviHeight {
    
    return 44 + self.sbHeight;
}

#pragma mark - 懒加载
- (YXFuncScrollBaseScrollView *)baseScrollView {
    
    if (!_baseScrollView) {
        _baseScrollView = [YXFuncScrollBaseScrollView new];
        _baseScrollView.frame = self.bounds;
        _baseScrollView.delegate = self;
        _baseScrollView.bounces = NO;
        _baseScrollView.scrollEnabled = YES;
        _baseScrollView.showsVerticalScrollIndicator = NO;
        _baseScrollView.showsHorizontalScrollIndicator = NO;
        _baseScrollView.contentSize = CGSizeMake(self.baseScrollView.bounds.size.width, self.baseScrollView.bounds.size.height);
        [self addSubview:self.baseScrollView];
    }
    return _baseScrollView;
}
- (UIView *)headerView {
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.baseScrollView.bounds.size.width, 0)];
        [self.baseScrollView addSubview:_headerView];
    }
    return _headerView;
}
- (YXFuncScrollBaseTabView *)tabView {
    
    if (!_tabView) {
        _tabView = [[YXFuncScrollBaseTabView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY([self.headerView frame]), self.baseScrollView.bounds.size.width, 50) suckType:YXFuncScrollBaseTabVSuckTypeFull textShowType:YXFuncScrollBaseTabVTypeAuto lineType:YXFuncScrollBaseTabVSelTypeTextLine];
        _tabView.backgroundColor = [UIColor whiteColor];
        _tabView.secHeaderWidth = 60;
        _tabView.secFooterWidth = 60;
        _tabView.cellSpece = 10;
        _tabView.norTitleFont = [UIFont systemFontOfSize:14];
        _tabView.norTextColor = [UIColor blackColor];
        _tabView.selTitleFont = [UIFont systemFontOfSize:14];
        _tabView.selTextColor = [UIColor redColor];
        _tabView.selLineColor = [UIColor blueColor];
//        _tabView.lineWidth = 10;
        _tabView.boolLineAnimation = YES;
        [self.baseScrollView addSubview:_tabView];
        __weak typeof(self) weakSelf = self;
        _tabView.yxFuncScrollBaseTabVBlock = ^(NSInteger current) {
            
            [weakSelf refreshrViewAtIndex:current];
        };
    }
    return _tabView;
}
- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.frame = CGRectMake(0, CGRectGetMaxY([self.tabView frame]), self.baseScrollView.bounds.size.width, self.baseScrollView.bounds.size.height - CGRectGetMaxY([self.tabView frame]));
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.baseScrollView.bounds.size.width *self.tabView.tabArrs.count, _scrollView.bounds.size.height);
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        [self.baseScrollView addSubview:_scrollView];
    }
    return _scrollView;
}

@end
