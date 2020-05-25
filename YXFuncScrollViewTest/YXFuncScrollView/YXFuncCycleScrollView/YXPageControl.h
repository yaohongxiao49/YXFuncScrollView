//
//  YXPageControl.h
//  YXFuncScrollViewTest
//
//  Created by ios on 2020/5/25.
//  Copyright © 2020 August. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXPageControl : UIPageControl

/** 普通分页图片 */
@property (nonatomic, strong) UIImage *norImg;
/** 选中分页图片 */
@property (nonatomic, strong) UIImage *selImg;

#pragma mark - 设置当前页码
- (void)setCurrentPage:(NSInteger)page;

@end

NS_ASSUME_NONNULL_END
