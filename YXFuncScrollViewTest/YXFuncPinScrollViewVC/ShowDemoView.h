//
//  ShowDemoView.h
//  YXFuncScrollViewTest
//
//  Created by ios on 2020/4/24.
//  Copyright © 2020 August. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ShowDemoViewScrollViewBlock)(UIView *view);

@interface ShowDemoView : UIView

@property (nonatomic, copy) ShowDemoViewScrollViewBlock showDemoViewScrollViewBlock;

@end

NS_ASSUME_NONNULL_END
