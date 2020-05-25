//
//  YXFuncCycleScrollViewValueModel.m
//  YXFuncScrollViewTest
//
//  Created by ios on 2020/5/25.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXFuncCycleScrollViewValueModel.h"

@implementation YXFuncCycleScrollViewValueModel

+ (NSMutableArray *)arrayOfModelsFromDictionaries:(NSArray *)arr {
    
    NSMutableArray *dataAry = [NSMutableArray new];
    for (NSDictionary *dic in arr) {
        YXFuncCycleScrollViewValueInfoModel *model = [[YXFuncCycleScrollViewValueInfoModel alloc] initWithDic:dic];
        [dataAry addObject:model];
    }
    return dataAry;
}

@end

@implementation YXFuncCycleScrollViewValueInfoModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        _imgUrl = [dic objectForKey:@"imgUrl"];
    }
    return self;
}

@end
