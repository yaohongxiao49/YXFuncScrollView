//
//  YXFuncCycleScrollViewVC.m
//  YXFuncScrollViewTest
//
//  Created by ios on 2020/5/22.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXFuncCycleScrollViewVC.h"
#import "YXFuncCycleScrollView.h"

@interface YXFuncCycleScrollViewVC ()

@end

@implementation YXFuncCycleScrollViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    YXFuncCycleScrollView *view = [[YXFuncCycleScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 200) showType:YXFuncCycleScrollViewTypeCard];
    view.backgroundColor = [UIColor redColor];
    view.edgeInsets = UIEdgeInsetsMake(10, 40, 10, 10);
    view.cornerRadius = 10;
    view.yxFuncCycleScrollViewBlock = ^(YXFuncCycleScrollViewValueInfoModel * _Nonnull model) {
      
        NSLog(@"imgUrl == %@", model.imgUrl);
    };
    [self.view addSubview:view];
    
    NSArray *arr = [YXFuncCycleScrollViewValueModel arrayOfModelsFromDictionaries:@[@{@"imgUrl":@"1"}, @{@"imgUrl":@"2"}, @{@"imgUrl":@"3"}, @{@"imgUrl":@"4"}]];
    view.imgValueArr = [[NSMutableArray alloc] initWithArray:arr];
}

@end
