//
//  YXFuncCycleScrollView.h
//  YXFuncScrollViewTest
//
//  Created by ios on 2020/5/22.
//  Copyright © 2020 August. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXFuncCycleScrollViewValueModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^YXFuncCycleScrollViewBlock)(YXFuncCycleScrollViewValueInfoModel *model);

@interface YXFuncCycleScrollView : UIView

/** 图片信息数组 */
@property (nonatomic, strong) NSMutableArray *imgValueArr;

#pragma mark - 定时器
/** 是否含有定时器 */
@property (nonatomic, assign) BOOL boolContainTimer;
/** 时间间隔（需要先设置boolContainTimer） */
@property (nonatomic, assign) CGFloat timeInterval;

#pragma mark - 分页控制器
/** 是否显示分页控制器 */
@property (nonatomic, assign) BOOL boolShowPageControl;
/** 分页控制器坐标 */
@property (nonatomic, assign) CGRect pageframe;
/** 分页控制器当前页码（需要在设置了imgValueArr后，设置才有用） */
@property (nonatomic, assign) NSInteger currentPage;
/** 是否开启分页控制（默认关闭，此功能暂时不能使用） */
@property (nonatomic, assign) BOOL boolOpenPageControl;
/** 分页视图背景颜色 */
@property (nonatomic, strong) UIColor *pageBgColor;
/** 分页视图背景透明度 */
@property (nonatomic, assign) CGFloat pageBgAlpha;
/** 普通分页颜色 */
@property (nonatomic, strong) UIColor *norPageColor;
/** 选中分页颜色 */
@property (nonatomic, strong) UIColor *selPageColor;
/** 普通分页图片 */
@property (nonatomic, strong) UIImage *norPageImg;
/** 选中分页图片 */
@property (nonatomic, strong) UIImage *selPageImg;

#pragma mark - 点击图片回调
@property (nonatomic, copy) YXFuncCycleScrollViewBlock yxFuncCycleScrollViewBlock;

@end

NS_ASSUME_NONNULL_END
