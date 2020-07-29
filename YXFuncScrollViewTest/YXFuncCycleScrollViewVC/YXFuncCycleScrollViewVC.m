//
//  YXFuncCycleScrollViewVC.m
//  YXFuncScrollViewTest
//
//  Created by ios on 2020/5/22.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXFuncCycleScrollViewVC.h"
#import "YXFuncCycleScrollView.h"
#import "YXEntertainingDiversionsView.h"

@interface YXFuncCycleScrollViewVC ()

@property (nonatomic, strong) YXEntertainingDiversionsView *entertainingDiversionsView;

@end

@implementation YXFuncCycleScrollViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initEntertainingView];
    [self initBannerView];
}

#pragma mark - 跑马灯
- (void)initEntertainingView {
    
    NSString *title = @"太阳上山，一哟儿喂！太阳下山，一喽儿喂！";
    _entertainingDiversionsView = [[YXEntertainingDiversionsView alloc] initWithFrame:CGRectMake(100, 120, self.view.bounds.size.width - 200, 30) maskType:YXEntertainingDiversionsMaskTypeRight textAlignment:YXEntertainingDiversionsViewScrollAlignmentCenter];
    _entertainingDiversionsView.textColor = [UIColor redColor];
    _entertainingDiversionsView.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:_entertainingDiversionsView];
    
    _entertainingDiversionsView.text = title;
}

#pragma mark - banner
- (void)initBannerView {
    
    YXFuncCycleScrollView *view = [[YXFuncCycleScrollView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 200) showType:YXFuncCycleScrollViewType3DCard directionType:YXFuncCycleScrollViewDirectionTypeHorizontal boolCycle:NO boolDynamic:YES zoomRadio:1.2];
    view.backgroundColor = [UIColor redColor];
    view.edgeInsets = UIEdgeInsetsMake(10, 200, 10, 40);
    view.cornerRadius = 10;
    view.boolContainTimer = NO;
    view.timeInterval = 3;
    view.yxFuncCycleScrollViewBlock = ^(YXFuncCycleScrollViewValueInfoModel * _Nonnull model) {
      
        NSLog(@"imgUrl == %@", model.imgUrl);
    };
    view.yxFuncCycleScrollViewMoveBlock = ^(NSInteger page) {
        
        NSLog(@"page == %@", @(page));
    };
    [self.view addSubview:view];
    
    NSArray *arr = [YXFuncCycleScrollViewValueModel arrayOfModelsFromDictionaries:@[@{@"imgUrl":@"1"}, @{@"imgUrl":@"2"}, @{@"imgUrl":@"3"}, @{@"imgUrl":@"4"}]];
    view.imgValueArr = [[NSMutableArray alloc] initWithArray:arr];
}

@end
