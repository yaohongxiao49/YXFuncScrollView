//
//  YXFuncScrollBaseTabView.m
//  YXFuncScrollViewTest
//
//  Created by ios on 2020/4/24.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXFuncScrollBaseTabView.h"
#import "YXFuncScrollBaseTabSecHeaderView.h"
#import "YXFuncScrollBaseTabSecFooterView.h"
#import "YXFuncScrollBaseTabCell.h"

@interface YXFuncScrollBaseTabView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) YXFuncScrollBaseTabVSuckType suckType; //吸顶类型
@property (nonatomic, assign) YXFuncScrollBaseTabVTextShowType textShowType; //cell宽度显示类型
@property (nonatomic, assign) YXFuncScrollBaseTabVSelType lineType; //cell选中line类型
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *selLineView; //选中下划线

@end

@implementation YXFuncScrollBaseTabView

- (instancetype)initWithFrame:(CGRect)frame suckType:(YXFuncScrollBaseTabVSuckType)suckType textShowType:(YXFuncScrollBaseTabVTextShowType)textShowType lineType:(YXFuncScrollBaseTabVSelType)lineType {
    self = [super initWithFrame:frame];
    
    if (self) {
        _suckType = suckType;
        _textShowType = textShowType;
        _lineType = lineType;
        [self initView];
    }
    return self;
}

#pragma mark - 计算字符串宽度
- (CGFloat)calculateTheStrWidth:(NSString *)str height:(CGFloat)height font:(UIFont *)font {
    
    CGSize newSize = [self calculateTheStrWithSize:str size:CGSizeMake(CGFLOAT_MAX, height) font:font];
    return newSize.width;
}
- (CGSize)calculateTheStrWithSize:(NSString *)str size:(CGSize)size font:(UIFont *)font {
    
    if (str.length == 0) {
        return CGSizeZero;
    }
    
    CGSize newSize = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil].size;
    
    return newSize;
}

#pragma mark - 滚动到指定视图
- (void)scrollToCurrentIndex:(NSInteger)currentIndex {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:currentIndex inSection:0];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [_collectionView reloadData];
    [_collectionView reloadData];
    [_collectionView layoutIfNeeded];
    
    YXFuncScrollBaseTabCell *cell = (YXFuncScrollBaseTabCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    self.selLineView.hidden = NO;
    self.selLineView.backgroundColor = self.selLineColor;
    [_collectionView sendSubviewToBack:self.selLineView];
    
    [self lineScrollingAnimation:self.boolLineAnimation view:cell];
}

#pragma mark - 滚动并回调
- (void)scrollToCurrentIndexBlock:(NSInteger)currentIndex {
    
    [self scrollToCurrentIndex:currentIndex];
    if (self.yxFuncScrollBaseTabVBlock) {
        self.yxFuncScrollBaseTabVBlock(currentIndex);
    }
}

#pragma mark - 下划线滚动动画
- (void)lineScrollingAnimation:(BOOL)isAnimation view:(UIView *)view {
    
    __weak typeof(self) weakSelf = self;
    if (isAnimation) {
        [UIView animateWithDuration:0.3 animations:^{
           
            switch (self.lineType) {
                case YXFuncScrollBaseTabVSelTypeCancel:
                    weakSelf.selLineView.hidden = YES;
                    break;
                case YXFuncScrollBaseTabVSelTypeSpecifiedLine: {
                    weakSelf.selLineView.frame = CGRectMake((view.frame.origin.x + view.frame.size.width - weakSelf.lineWidth) /2, view.frame.size.height - kScrollBaseTabCellLineHeight, weakSelf.lineWidth, kScrollBaseTabCellLineHeight);
                    break;
                }
                case YXFuncScrollBaseTabVSelTypeWidthLine: {
                    weakSelf.selLineView.frame = CGRectMake(view.frame.origin.x, view.frame.size.height - kScrollBaseTabCellLineHeight, view.frame.size.width, kScrollBaseTabCellLineHeight);
                    break;
                }
                case YXFuncScrollBaseTabVSelTypeTextLine: {
                    YXFuncScrollBaseTabCell *cell = (YXFuncScrollBaseTabCell *)view;
                    NSString *str = cell.titleLab.text;
                    CGFloat strWidth = [weakSelf calculateTheStrWidth:str height:weakSelf.cellHeight font:weakSelf.norTitleFont] + 10;
                    weakSelf.selLineView.frame = CGRectMake(cell.frame.origin.x + (cell.frame.size.width - strWidth) /2, cell.frame.size.height - kScrollBaseTabCellLineHeight, strWidth, kScrollBaseTabCellLineHeight);
                    break;
                }
                case YXFuncScrollBaseTabVSelTypeFull: {
                    weakSelf.selLineView.frame = view.frame;
                    break;
                }
                default:
                    break;
            }
        }];
    }
    else {
        switch (self.lineType) {
            case YXFuncScrollBaseTabVSelTypeCancel:
                self.selLineView.hidden = YES;
                break;
            case YXFuncScrollBaseTabVSelTypeSpecifiedLine: {
                self.selLineView.frame = CGRectMake((view.frame.origin.x + view.frame.size.width - self.lineWidth) /2, view.frame.size.height - kScrollBaseTabCellLineHeight, self.lineWidth, kScrollBaseTabCellLineHeight);
                break;
            }
            case YXFuncScrollBaseTabVSelTypeWidthLine: {
                self.selLineView.frame = CGRectMake(view.frame.origin.x, view.frame.size.height - kScrollBaseTabCellLineHeight, view.frame.size.width, kScrollBaseTabCellLineHeight);
                break;
            }
            case YXFuncScrollBaseTabVSelTypeTextLine: {
                YXFuncScrollBaseTabCell *cell = (YXFuncScrollBaseTabCell *)view;
                NSString *str = cell.titleLab.text;
                CGFloat strWidth = [self calculateTheStrWidth:str height:self.cellHeight font:self.norTitleFont] + 10;
                self.selLineView.frame = CGRectMake(cell.frame.origin.x + (cell.frame.size.width - strWidth) /2, cell.frame.size.height - kScrollBaseTabCellLineHeight, strWidth, kScrollBaseTabCellLineHeight);
                break;
            }
            case YXFuncScrollBaseTabVSelTypeFull: {
                self.selLineView.frame = view.frame;
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.tabArrs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YXFuncScrollBaseTabCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YXFuncScrollBaseTabCell class]) forIndexPath:indexPath];
    
    [cell reloadValueByCurrentIndex:self.currentIndex tagArrs:self.tabArrs indexPath:indexPath norTitleFont:self.norTitleFont norTextColor:self.norTextColor selTitleFont:self.selTitleFont selTextColor:self.selTextColor];
    
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        YXFuncScrollBaseTabSecHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([YXFuncScrollBaseTabSecHeaderView class]) forIndexPath:indexPath];
        
        return headerView;
    }
    else {
        YXFuncScrollBaseTabSecFooterView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([YXFuncScrollBaseTabSecFooterView class]) forIndexPath:indexPath];
        
        return headerView;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.currentIndex = indexPath.row;
    [self scrollToCurrentIndexBlock:self.currentIndex];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *str = self.tabArrs[indexPath.row];
    CGFloat strWidth = [self calculateTheStrWidth:str height:self.cellHeight font:self.norTitleFont] + 10;
    if (self.textShowType == YXFuncScrollBaseTabVTypeAuto) {
        self.cellWidth = strWidth + 20;
    }
    return CGSizeMake(self.cellWidth, self.cellHeight);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    CGSize size = CGSizeMake(60, self.bounds.size.height);
    if (self.secHeaderWidth <= 0.f) {
        return CGSizeZero;
    }
    return size;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    CGSize size = CGSizeMake(60, self.bounds.size.height);
    if (self.secFooterWidth <= 0.f) {
        return CGSizeZero;
    }
    return size;
}
- (CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return self.cellSpece;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return self.cellSpece;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    CGFloat bottom = self.edgeInsets.bottom;
    if (self.lineType == YXFuncScrollBaseTabVSelTypeSpecifiedLine || self.lineWidth == YXFuncScrollBaseTabVSelTypeWidthLine || self.lineWidth == YXFuncScrollBaseTabVSelTypeTextLine) {
        bottom = self.edgeInsets.bottom + kScrollBaseTabCellLineHeight;
    }
     
    self.edgeInsets = UIEdgeInsetsMake(self.edgeInsets.top, self.edgeInsets.left, self.edgeInsets.bottom, self.edgeInsets.right);
    return self.edgeInsets;
}

#pragma mark - 初始化
- (void)initView {
    
    UICollectionViewFlowLayout *flowL = [UICollectionViewFlowLayout new];
    [flowL setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    switch (_suckType) {
        case YXFuncScrollBaseTabVSuckTypeLeft:
            flowL.sectionHeadersPinToVisibleBounds = YES;
            flowL.sectionFootersPinToVisibleBounds = NO;
            break;
        case YXFuncScrollBaseTabVSuckTypeRight:
            flowL.sectionHeadersPinToVisibleBounds = NO;
            flowL.sectionFootersPinToVisibleBounds = YES;
            break;
        case YXFuncScrollBaseTabVSuckTypeFull:
            flowL.sectionHeadersPinToVisibleBounds = YES;
            flowL.sectionFootersPinToVisibleBounds = YES;
            break;
        default:
            flowL.sectionHeadersPinToVisibleBounds = NO;
            flowL.sectionFootersPinToVisibleBounds = NO;
            break;
    }
    
    self.cellWidth = 40.f;
    self.cellHeight = self.bounds.size.height;
    self.cellSpece = 0.f;
    self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.secHeaderWidth = 0.f;
    self.secFooterWidth = 0.f;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowL];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:NSClassFromString([YXFuncScrollBaseTabCell.class description]) forCellWithReuseIdentifier:NSStringFromClass([YXFuncScrollBaseTabCell class])];
    [_collectionView registerClass:NSClassFromString([YXFuncScrollBaseTabSecHeaderView.class description]) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([YXFuncScrollBaseTabSecHeaderView class])];
    [_collectionView registerClass:NSClassFromString([YXFuncScrollBaseTabSecFooterView.class description]) forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([YXFuncScrollBaseTabSecFooterView class])];
    [self addSubview:_collectionView];
    
    [self scrollToCurrentIndex:self.currentIndex];
}

#pragma mark - setting
- (void)setTabArrs:(NSMutableArray *)tabArrs {
    
    _tabArrs = tabArrs;
    [_collectionView reloadData];
}
- (void)setCurrentIndex:(NSInteger)currentIndex {
    
    _currentIndex = currentIndex;
    [self scrollToCurrentIndex:_currentIndex];
}
- (void)setSecHeaderWidth:(CGFloat)secHeaderWidth {
    
    _secHeaderWidth = secHeaderWidth;
    [_collectionView reloadData];
}
- (void)setSecFooterWidth:(CGFloat)secFooterWidth {
    
    _secFooterWidth = secFooterWidth;
    [_collectionView reloadData];
}
- (void)setCellHeight:(CGFloat)cellHeight {
    
    _cellHeight = cellHeight;
    [_collectionView reloadData];
}
- (void)setCellSpece:(CGFloat)cellSpece {
    
    _cellSpece = cellSpece;
    [_collectionView reloadData];
}
- (void)setCellWidth:(CGFloat)cellWidth {
    
    _cellWidth = cellWidth;
    [_collectionView reloadData];
}
- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
    
    _edgeInsets = edgeInsets;
    [_collectionView reloadData];
}
- (void)setNorTitleFont:(UIFont *)norTitleFont {
    
    _norTitleFont = norTitleFont;
    [_collectionView reloadData];
}
- (void)setNorTextColor:(UIColor *)norTextColor {
    
    _norTextColor = norTextColor;
    [_collectionView reloadData];
}
- (void)setSelTitleFont:(UIFont *)selTitleFont {
    
    _selTitleFont = selTitleFont;
    [_collectionView reloadData];
}
- (void)setSelTextColor:(UIColor *)selTextColor {
    
    _selTextColor = selTextColor;
    [_collectionView reloadData];
}
- (void)setSelLineColor:(UIColor *)selLineColor {
    
    _selLineColor = selLineColor;
    [_collectionView reloadData];
}
- (void)setLineWidth:(CGFloat)lineWidth {
    
    _lineWidth = lineWidth;
    [_collectionView reloadData];
}
- (void)setLineCorner:(CGFloat)lineCorner {
    
    _lineCorner = lineCorner;
    self.selLineView.layer.cornerRadius = _lineCorner;
    self.selLineView.layer.masksToBounds = YES;
}
- (void)setBoolLineAnimation:(BOOL)boolLineAnimation {
    
    _boolLineAnimation = boolLineAnimation;
    [_collectionView reloadData];
}

#pragma mark - 懒加载
- (UIView *)selLineView {
    
    if (!_selLineView) {
        _selLineView = [[UIView alloc] initWithFrame:CGRectMake(0, _collectionView.frame.size.height, 10, kScrollBaseTabCellLineHeight)];
        [_collectionView insertSubview:_selLineView atIndex:0];
    }
    return _selLineView;
}

@end
