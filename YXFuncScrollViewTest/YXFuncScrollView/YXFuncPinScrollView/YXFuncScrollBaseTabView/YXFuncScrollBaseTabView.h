//
//  YXFuncScrollBaseTabView.h
//  YXFuncScrollViewTest
//
//  Created by ios on 2020/4/24.
//  Copyright © 2020 August. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScrollBaseTabCellLineHeight 3

NS_ASSUME_NONNULL_BEGIN

/** 吸顶类型 */
typedef NS_ENUM(NSUInteger, YXFuncScrollBaseTabVSuckType) {
    /** 不吸顶 */
    YXFuncScrollBaseTabVSuckTypeNull,
    /** 左侧吸顶 */
    YXFuncScrollBaseTabVSuckTypeLeft,
    /** 右侧吸顶 */
    YXFuncScrollBaseTabVSuckTypeRight,
    /** 全吸顶 */
    YXFuncScrollBaseTabVSuckTypeFull,
};
/** 滚动cell宽度显示类型 */
typedef NS_ENUM(NSUInteger, YXFuncScrollBaseTabVTextShowType) {
    /** 指定显示宽度 */
    YXFuncScrollBaseTabVTypeSpecified,
    /** 文字自适应 */
    YXFuncScrollBaseTabVTypeAuto,
};
/** 滚动cell选中类型 */
typedef NS_ENUM(NSUInteger, YXFuncScrollBaseTabVSelType) {
    /** 不显示 */
    YXFuncScrollBaseTabVSelTypeCancel,
    /** 指定宽度 */
    YXFuncScrollBaseTabVSelTypeSpecifiedLine,
    /** 宽度线型 */
    YXFuncScrollBaseTabVSelTypeWidthLine,
    /** 适应文字 */
    YXFuncScrollBaseTabVSelTypeTextLine,
    /** 覆盖 */
    YXFuncScrollBaseTabVSelTypeFull,
};

typedef void(^YXFuncScrollBaseTabVBlock)(NSInteger current);

@interface YXFuncScrollBaseTabView : UIView

/**
 * 初始化视图
 * @param frame frame
 * @param suckType 吸顶类型
 * @param textShowType 文字显示类型
 * @param lineType 下划线显示类型
 */
- (instancetype)initWithFrame:(CGRect)frame
                     suckType:(YXFuncScrollBaseTabVSuckType)suckType
                 textShowType:(YXFuncScrollBaseTabVTextShowType)textShowType
                     lineType:(YXFuncScrollBaseTabVSelType)lineType;

/** 显示数据数组 */
@property (nonatomic, strong) NSMutableArray *tabArrs;
/** 当前所在下标 */
@property (nonatomic, assign) NSInteger currentIndex;
/** secHeader宽度（非必传）*/
@property (nonatomic, assign) CGFloat secHeaderWidth;
/** secFooter宽度 （非必传）*/
@property (nonatomic, assign) CGFloat secFooterWidth;
/** cell高度（非必传） */
@property (nonatomic, assign) CGFloat cellHeight;
/** cell间距（非必传） */
@property (nonatomic, assign) CGFloat cellSpece;
/** cell宽度（非必传） */
@property (nonatomic, assign) CGFloat cellWidth;
/** 边距（非必传） */
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
/** 普通字体 */
@property (nonatomic, strong) UIFont *norTitleFont;
/** 普通文字颜色 */
@property (nonatomic, strong) UIColor *norTextColor;
/** 选中字体 */
@property (nonatomic, strong) UIFont *selTitleFont;
/** 选中文字颜色 */
@property (nonatomic, strong) UIColor *selTextColor;
/** 选中线颜色 */
@property (nonatomic, strong) UIColor *selLineColor;
/** 下划线宽度 */
@property (nonatomic, assign) CGFloat lineWidth;
/** 下划线圆角 */
@property (nonatomic, assign) CGFloat lineCorner;
/** 是否显示下划线动画 */
@property (nonatomic, assign) BOOL boolLineAnimation;

@property (nonatomic, copy) YXFuncScrollBaseTabVBlock yxFuncScrollBaseTabVBlock;

@end

NS_ASSUME_NONNULL_END
