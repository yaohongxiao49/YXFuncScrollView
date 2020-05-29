//
//  YXEntertainingDiversionsView.h
//  YXFuncScrollViewTest
//
//  Created by ios on 2020/5/29.
//  Copyright © 2020 August. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 滚动文字视图蒙层位置类型 */
typedef NS_ENUM(NSUInteger, YXEntertainingDiversionsMaskType) {
    /** 没有 */
    YXEntertainingDiversionsMaskTypeNull,
    /** 右侧 */
    YXEntertainingDiversionsMaskTypeRight,
    /** 两头 */
    YXEntertainingDiversionsMaskTypeBoth,
};

/** 滚动文字视图对齐方式类型 */
typedef NS_ENUM(NSUInteger, YXEntertainingDiversionsViewScrollAlignment) {
    /** 左对齐 */
    YXEntertainingDiversionsViewScrollAlignmentLeft,
    /** 居中对齐 */
    YXEntertainingDiversionsViewScrollAlignmentCenter,
    /** 右对齐 */
    YXEntertainingDiversionsViewScrollAlignmentRight
};

@interface YXEntertainingDiversionsView : UIView

/** 字号 */
@property (nonatomic, strong) UIFont *font;
/** 字z色 */
@property (nonatomic, strong) UIColor *textColor;
/** 内容（最后设置） */
@property (nonatomic, strong) NSString *text;

/** 滚动总时长，默认为10秒 */
@property (nonatomic, assign) CGFloat scrollDuration;
/** 滚动速率，默认为20(pt/s)。赋值必须大于0，否则速率默认为20 */
@property (nonatomic, assign) CGFloat scrollVelocity;
/** 两个label之间的距离，默认为20 */
@property (nonatomic, assign) CGFloat paddingBetweenLabels;

/** 延迟开始第一次滚动(单位：秒)，默认为3秒 */
@property (nonatomic, assign) CGFloat delayInterval;
/** 循环滚动时，中间停止的时长(单位：秒)， 默认为3秒 */
@property (nonatomic, assign) CGFloat pauseInterval;

/** 是否自动开始滚动，默认为YES */
@property (nonatomic, assign) BOOL autoBeginScroll;
/** 是否在滚动 */
@property (nonatomic, assign, getter=isScrolling) BOOL scrolling;

/**
 * 初始化视图
 * @param frame 尺寸
 * @param maskType 蒙层类型
 * @param textAlignment 对齐方式
 */
- (instancetype)initWithFrame:(CGRect)frame
                     maskType:(YXEntertainingDiversionsMaskType)maskType
                textAlignment:(YXEntertainingDiversionsViewScrollAlignment)textAlignment;

/** 开始动画 */
- (void)startScrollAnimation;
/** 停止动画 */
- (void)stopScrollAnimation;

@end

NS_ASSUME_NONNULL_END
