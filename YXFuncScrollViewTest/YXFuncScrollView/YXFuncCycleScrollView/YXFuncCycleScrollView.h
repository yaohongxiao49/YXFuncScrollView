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

typedef NS_ENUM(NSUInteger, YXFuncCycleScrollViewType) {
    /** 铺满 */
    YXFuncCycleScrollViewTypeFull,
    /** 有边距 */
    YXFuncCycleScrollViewTypeEdge,
    /** 卡片式 */
    YXFuncCycleScrollViewTypeCard,
};

/** 点击 */
typedef void(^YXFuncCycleScrollViewBlock)(YXFuncCycleScrollViewValueInfoModel *model);
/** 滚动 */
typedef void(^YXFuncCycleScrollViewMoveBlock)(NSInteger page);

@interface YXFuncCycleScrollView : UIView

/**
 * 显示边距（充满/卡片式效果时设置）
 * 如显示为卡片式效果，则需要优先设置（此时的宽度：屏幕宽度 - left，间距：right）
 */
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
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
/** 分页控制器当前页码（需要在设置了imgValueArr后，设置才可使用，起始值为0） */
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

/** 点击图片回调 */
@property (nonatomic, copy) YXFuncCycleScrollViewBlock yxFuncCycleScrollViewBlock;
/** 滚动视图回调 */
@property (nonatomic, copy) YXFuncCycleScrollViewMoveBlock yxFuncCycleScrollViewMoveBlock;

/** 圆角 */
@property (nonatomic, assign) CGFloat cornerRadius;

#pragma mark - 初始化视图
/**
 * 初始化视图
 * @param frame 显示尺寸
 * @param showType 显示类型
 */
- (instancetype)initWithFrame:(CGRect)frame
                     showType:(YXFuncCycleScrollViewType)showType;

@end

NS_ASSUME_NONNULL_END
