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

#pragma mark - 点击图片回调
@property (nonatomic, copy) YXFuncCycleScrollViewBlock yxFuncCycleScrollViewBlock;

@end

NS_ASSUME_NONNULL_END
