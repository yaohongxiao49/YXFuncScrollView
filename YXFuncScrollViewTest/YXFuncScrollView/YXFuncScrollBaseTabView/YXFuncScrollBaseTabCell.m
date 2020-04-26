//
//  YXFuncScrollBaseTabCell.m
//  YXFuncScrollViewTest
//
//  Created by ios on 2020/4/24.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXFuncScrollBaseTabCell.h"

@implementation YXFuncScrollBaseTabCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLab.frame = CGRectMake(0, 0, (self.contentView.bounds.size.width - 10) /2, self.contentView.bounds.size.height);
    self.titleLab.center = self.contentView.center;
}

#pragma mark - 刷新数据
- (void)reloadValueByCurrentIndex:(NSInteger)currentIndex tagArrs:(NSMutableArray *)tagArrs indexPath:(NSIndexPath *)indexPath norTitleFont:(UIFont *)norTitleFont norTextColor:(UIColor *)norTextColor selTitleFont:(UIFont *)selTitleFont selTextColor:(UIColor *)selTextColor {
    
    BOOL isSelected = NO;
    self.titleLab.text = tagArrs[indexPath.row];
    
    if (currentIndex == indexPath.row) {
        isSelected = YES;
        self.titleLab.font = norTitleFont;
        self.titleLab.textColor = norTextColor;
    }
    else {
        isSelected = NO;
        self.titleLab.font = selTitleFont;
        self.titleLab.textColor = selTextColor;
        self.lineView.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark - 懒加载
- (UILabel *)titleLab {
    
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (self.contentView.bounds.size.width - 10) /2, self.contentView.bounds.size.height)];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.center = self.contentView.center;
        [self.contentView addSubview:_titleLab];
    }
    return _titleLab;
}

@end
