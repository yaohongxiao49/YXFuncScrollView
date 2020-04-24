//
//  YXFuncScrollBaseTabView.m
//  YXFuncScrollViewTest
//
//  Created by ios on 2020/4/24.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXFuncScrollBaseTabView.h"
#import "YXFuncScrollBaseTabCell.h"
#import "YXFuncScrollBaseTabSecHeaderView.h"
#import "YXFuncScrollBaseTabSecFooterView.h"

@interface YXFuncScrollBaseTabView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation YXFuncScrollBaseTabView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initView];
    }
    return self;
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(30, 20);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    CGSize size = CGSizeMake(20, 20);
    return size;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    CGSize size = CGSizeMake(20, 40);
    return size;
}
- (CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - 初始化
- (void)initView {
    
    UICollectionViewFlowLayout *flowL = [UICollectionViewFlowLayout new];
    [flowL setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowL.sectionHeadersPinToVisibleBounds = YES;
    flowL.sectionFootersPinToVisibleBounds = YES;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowL];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:NSClassFromString([YXFuncScrollBaseTabCell.class description]) forCellWithReuseIdentifier:NSStringFromClass([YXFuncScrollBaseTabCell class])];
    [_collectionView registerClass:NSClassFromString([YXFuncScrollBaseTabSecHeaderView.class description]) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([YXFuncScrollBaseTabSecHeaderView class])];
    [_collectionView registerClass:NSClassFromString([YXFuncScrollBaseTabSecFooterView.class description]) forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([YXFuncScrollBaseTabSecFooterView class])];
    [self addSubview:_collectionView];
}

#pragma mark - setting
- (void)setTabArrs:(NSMutableArray *)tabArrs {
    
    _tabArrs = tabArrs;
    [_collectionView reloadData];
}

@end
