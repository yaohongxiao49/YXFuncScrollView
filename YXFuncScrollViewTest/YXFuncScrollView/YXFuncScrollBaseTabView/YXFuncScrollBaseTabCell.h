//
//  YXFuncScrollBaseTabCell.h
//  YXFuncScrollViewTest
//
//  Created by ios on 2020/4/24.
//  Copyright © 2020 August. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXFuncScrollBaseTabCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *lineView;

/**
 * 刷新数据
 * @param currentIndex 当前下标
 * @param tagArrs 数据
 * @param indexPath indexPath
 * @param norTitleFont 普通字体
 * @param norTextColor 普通色值
 * @param selTitleFont 选中字体
 * @param selTextColor 选中色值
 */
- (void)reloadValueByCurrentIndex:(NSInteger)currentIndex
                          tagArrs:(NSMutableArray *)tagArrs
                        indexPath:(NSIndexPath *)indexPath
                     norTitleFont:(UIFont *)norTitleFont
                     norTextColor:(UIColor *)norTextColor
                     selTitleFont:(UIFont *)selTitleFont
                     selTextColor:(UIColor *)selTextColor;

@end

NS_ASSUME_NONNULL_END
