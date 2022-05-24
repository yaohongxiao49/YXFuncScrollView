//
//  YXFuncCollectionViewVC.m
//  YXFuncScrollViewTest
//
//  Created by Augus on 2022/5/24.
//  Copyright © 2022 August. All rights reserved.
//

#import "YXFuncCollectionViewVC.h"
#import "YXFuncCollectionCardFlowLayout.h"
#import "YXFuncCollectionViewCell.h"

#define kYXScreenWidth [UIScreen mainScreen].bounds.size.width
#define kYXScreenHeight [UIScreen mainScreen].bounds.size.height

@interface YXFuncCollectionViewVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
/** 当前页数 */
@property (nonatomic, assign) NSInteger nowCurrent;
/** 当前组数 */
@property (nonatomic, assign) NSInteger nowSection;
/** 总组数 */
@property (nonatomic, assign) NSInteger maxSections;
/** 开始拖拽X */
@property (nonatomic, assign) CGFloat dragStartX;
/** 结束拖拽X */
@property (nonatomic, assign) CGFloat dragEndX;

@end

@implementation YXFuncCollectionViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 配置cell居中
- (void)fixCellToCenter {
    
    CGFloat width = 82.5;
    NSInteger maxIndex = [self.collectionView numberOfItemsInSection:_nowSection];
    //最小滚动距离
    float dragMiniDistance = self.view.bounds.size.width / 20.0f;
    if (_dragStartX - _dragEndX >= dragMiniDistance) {
        NSInteger count = ceil((_dragStartX - _dragEndX) / width);
        for (NSInteger i = 0; i < count; i ++) {
            _nowCurrent -= 1; //向右
            if (_nowCurrent < 0) {
                _nowSection--;
            }
            _nowCurrent = _nowCurrent < 0 ? maxIndex - 1 : _nowCurrent;
        }
    }
    else if (_dragEndX - _dragStartX >= dragMiniDistance) {
        NSInteger count = ceil((_dragEndX - _dragStartX) / width);
        for (NSInteger i = 0; i < count; i ++) {
            _nowCurrent += 1; //向左
            if (_nowCurrent == maxIndex) {
                _nowSection++;
            }
            _nowCurrent = _nowCurrent >= maxIndex ? 0 : _nowCurrent;
        }
    }
    
    if (_nowSection < 0 || _nowSection >= _maxSections) {
        _nowSection = _maxSections / 2;
    }
    [self scrollToCenter];
}

#pragma mark - 拖拽后滚动到中心
- (void)scrollToCenter {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_nowCurrent inSection:_nowSection];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self.collectionView reloadData];
    
    if (self.yxFuncCollectionViewVCBlock) {
        self.yxFuncCollectionViewVCBlock(_nowCurrent, _nowSection);
    }
}

#pragma mark - 指定页
- (void)pointToCollectionViewByRow:(NSInteger)row section:(NSInteger)section {
    
    _nowCurrent = row;
    _nowSection = section;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
    });
    [self.collectionView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [weakSelf.collectionView scrollRectToVisible:CGRectMake(weakSelf.collectionView.contentOffset.x + 3, 0, kYXScreenWidth, weakSelf.collectionView.frame.size.height) animated:YES];
    });
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return _maxSections;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSourceArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YXFuncCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YXFuncCollectionViewCell class]) forIndexPath:indexPath];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 
    _nowCurrent = indexPath.row;
    _nowSection = indexPath.section;
    [self scrollToCenter];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(110, 82);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

#pragma mark - <UIScrollViewDelegate>
#pragma mark - 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    _dragStartX = scrollView.contentOffset.x;
}
#pragma mark - 结束拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    _dragEndX = scrollView.contentOffset.x;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self fixCellToCenter];
    });
}
#pragma mark - didScorll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //坐标系转换获得collectionView上面的位于中心的cell
    CGPoint pointInView = [self.view convertPoint:self.collectionView.center toView:self.collectionView];
    //获取这一点的indexPath
    NSIndexPath *indexPathNow = [self.collectionView indexPathForItemAtPoint:pointInView];

    YXFuncCollectionViewCell *cell = (YXFuncCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPathNow];
    [self.collectionView bringSubviewToFront:cell];
}

#pragma mark - setting
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr {
    
    _dataSourceArr = dataSourceArr;
    
    [self.collectionView reloadData];
    
    _nowCurrent = 0;
    if (_dataSourceArr.count > 0) {
        _maxSections = 12;
        _nowSection = _maxSections / 2;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_nowCurrent inSection:_nowSection];
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        });
        
        if (self.yxFuncCollectionViewVCBlock) {
            self.yxFuncCollectionViewVCBlock(_nowCurrent, _nowSection);
        }
    }
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        YXFuncCollectionCardFlowLayout *layout = [[YXFuncCollectionCardFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_collectionView];
        
        [_collectionView registerClass:[YXFuncCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([YXFuncCollectionViewCell class])];
    }
    return _collectionView;
}


@end
