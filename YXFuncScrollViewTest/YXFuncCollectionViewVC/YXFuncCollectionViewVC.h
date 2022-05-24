//
//  YXFuncCollectionViewVC.h
//  YXFuncScrollViewTest
//
//  Created by Augus on 2022/5/24.
//  Copyright © 2022 August. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXFuncCollectionViewVC : UIViewController

/** 数据集合 */
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
/** 切换回调 */
@property (nonatomic, copy) void(^yxFuncCollectionViewVCBlock)(NSInteger row, NSInteger section);
/** 指定页 */
- (void)pointToCollectionViewByRow:(NSInteger)row section:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
