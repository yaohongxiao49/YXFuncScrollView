//
//  YXFuncCycleScrollViewValueModel.h
//  YXFuncScrollViewTest
//
//  Created by ios on 2020/5/25.
//  Copyright © 2020 August. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXFuncCycleScrollViewValueModel : NSObject

+ (NSMutableArray *)arrayOfModelsFromDictionaries:(NSArray *)arr;

@end

@interface YXFuncCycleScrollViewValueInfoModel : NSObject

@property (nonatomic, copy) NSString *imgUrl;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
