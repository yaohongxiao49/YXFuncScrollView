//
//  ViewController.m
//  YXFuncScrollViewTest
//
//  Created by ios on 2020/4/24.
//  Copyright © 2020 August. All rights reserved.
//

#import "ViewController.h"
#import "YXFuncScrollBaseView.h"
#import "ShowDemoView.h"
#import "ShowHeaderView.h"

@interface ViewController () <YXFuncScrollBaseViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat naviHeight = 88;
    YXFuncScrollBaseView *baseView = [[YXFuncScrollBaseView alloc] initWithFrame:CGRectMake(0, naviHeight, self.view.bounds.size.width, self.view.bounds.size.height - naviHeight) baseVC:self boolHasNavi:YES boolContainFrash:NO];
    baseView.delegate = self;
    baseView.showTabArrs = (NSMutableArray *)@[@"1", @"2"];
    [self.view addSubview:baseView];
    
    ShowHeaderView *headerView = [[ShowHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    baseView.topView = headerView;
    
    ShowDemoView *fView = [[ShowDemoView alloc] init];
    fView.backgroundColor = [UIColor redColor];
    fView.showDemoViewScrollViewBlock = ^(UIView * _Nonnull view) {
      
        baseView.nowScrollView = view;
    };
    
    ShowDemoView *sView = [[ShowDemoView alloc] init];
    sView.backgroundColor = [UIColor greenColor];
    
    baseView.showViewArrs = (NSMutableArray *)@[fView, sView];
}

#pragma mark - <YXFuncScrollBaseViewDelegate>
- (void)yxSwitchModuleByNowView:(UIView *)nowView index:(NSInteger)index {
    
    
}

@end
