//
//  ViewController.m
//  YXFuncScrollViewTest
//
//  Created by ios on 2020/4/24.
//  Copyright © 2020 August. All rights reserved.
//

#import "ViewController.h"
#import "YXFuncPinScrollViewController.h"
#import "YXFuncCycleScrollViewVC.h"
 
@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataSourceArr = [[NSMutableArray alloc] initWithObjects:@"吸顶的滚动视图", @"无限循环的滚动视图", @"other", nil];
    
    self.navigationController.title = @"主页";
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSourceArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"123yd";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = _dataSourceArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        YXFuncPinScrollViewController *vc = [[YXFuncPinScrollViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 1) {
        YXFuncCycleScrollViewVC *vc = [[YXFuncCycleScrollViewVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        
    }
}

@end
