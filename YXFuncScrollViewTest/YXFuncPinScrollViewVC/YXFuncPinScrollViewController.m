//
//  YXFuncPinScrollViewController.m
//  YXFuncScrollViewTest
//
//  Created by ios on 2020/5/22.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXFuncPinScrollViewController.h"
#import "YXFuncScrollBaseView.h"
#import "ShowDemoView.h"
#import "ShowHeaderView.h"

@interface YXFuncPinScrollViewController () <YXFuncScrollBaseViewDelegate>

@property (nonatomic, strong) YXFuncScrollBaseView *baseView;

@end

@implementation YXFuncPinScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof(self) weakSelf = self;
    CGFloat naviHeight = 88;
    _baseView = [[YXFuncScrollBaseView alloc] initWithFrame:CGRectMake(0, naviHeight, self.view.bounds.size.width, self.view.bounds.size.height - naviHeight) baseVC:self boolHasNavi:YES boolContainFrash:NO];
    _baseView.delegate = self;
    _baseView.showTabArrs = (NSMutableArray *)@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11"];
    [self.view addSubview:_baseView];
    
    ShowHeaderView *headerView = [[ShowHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    _baseView.topView = headerView;
    
    ShowDemoView *fView = [[ShowDemoView alloc] init];
    fView.backgroundColor = [UIColor redColor];
    fView.showDemoViewScrollViewBlock = ^(UIView * _Nonnull view) {
      
        weakSelf.baseView.nowScrollView = view;
    };
    
    ShowDemoView *sView = [[ShowDemoView alloc] init];
    sView.backgroundColor = [UIColor greenColor];
    sView.showDemoViewScrollViewBlock = ^(UIView * _Nonnull view) {
      
        weakSelf.baseView.nowScrollView = view;
    };
    
    _baseView.showViewArrs = (NSMutableArray *)@[fView, sView];
}

#pragma mark - <YXFuncScrollBaseViewDelegate>
- (void)yxSwitchModuleByNowView:(UIView *)nowView index:(NSInteger)index {
    
}

@end
