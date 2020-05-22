//
//  YXFuncScrollBaseView.h
//  YXFuncScrollViewTest
//
//  Created by ios on 2020/4/24.
//  Copyright © 2020 August. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "YXFuncScrollBaseTabView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YXFuncScrollBaseViewDelegate <NSObject>

/** 切换栏目 */
- (void)yxSwitchModuleByNowView:(UIView *)nowView index:(NSInteger)index;

@end

@interface YXFuncScrollBaseScrollView : UIScrollView

@end

@interface YXFuncScrollBaseView : UIView

/** 基础滚动视图 */
@property (nonatomic, strong) YXFuncScrollBaseScrollView *baseScrollView;
/** 主滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 顶部滚动视图 */
@property (nonatomic, strong) UIView *topView;
/** 标签视图 */
@property (nonatomic, strong) YXFuncScrollBaseTabView *tabView;

/** 显示标签数组 */
@property (nonatomic, strong) NSMutableArray *showTabArrs;
/** 显示视图数组 */
@property (nonatomic, strong) NSMutableArray *showViewArrs;
/** 当前滚动的视图 */
@property (nonatomic, strong) UIView *nowScrollView;

@property (nonatomic, assign) id <YXFuncScrollBaseViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
                       baseVC:(UIViewController *)baseVC
                  boolHasNavi:(BOOL)boolHasNavi
             boolContainFrash:(BOOL)boolContainFrash;

@end

NS_ASSUME_NONNULL_END
