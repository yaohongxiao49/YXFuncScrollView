//
//  YXEntertainingDiversionsView.m
//  YXFuncScrollViewTest
//
//  Created by ios on 2020/5/29.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXEntertainingDiversionsView.h"

#define kDefaultScrollDuration 10 //动画时间
#define kDefaultSrollVelocity 20 //默认滚动速度
#define kDefaultPauseTime 3.0 //间隔时间
#define kDefaultPadding 20.0 //间隔距离
#define kDefaultDelay 1.0 //延迟

@interface YXEntertainingDiversionsView ()

@property (nonatomic, assign) YXEntertainingDiversionsMaskType maskType; //蒙层类型
@property (nonatomic, assign) YXEntertainingDiversionsViewScrollAlignment textAlignment; //文字对齐方式
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *labelCopy;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL manualStop;

@end

@implementation YXEntertainingDiversionsView

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame maskType:(YXEntertainingDiversionsMaskType)maskType textAlignment:(YXEntertainingDiversionsViewScrollAlignment)textAlignment {
    self = [super initWithFrame:frame];
    
    if (self) {
        _maskType = maskType;
        _textAlignment = textAlignment;
        [self initView];
    }
    return self;
}

#pragma mark - 设置label的Frame
- (void)setLabelsFrame {
    
    if (self.font) _label.font = self.font;
    if (self.font) _labelCopy.font = self.font;
    if (self.textColor) _label.textColor = self.textColor;
    if (self.textColor) _labelCopy.textColor = self.textColor;
    
    [_label sizeToFit];
    [_labelCopy sizeToFit];
    
    //label
    CGPoint center = CGPointMake(_label.center.x, self.center.y - self.frame.origin.y);
    _label.center = center;
    if (_label.frame.size.width > self.frame.size.width) {
        CGRect labelFrame = _label.frame;
        labelFrame.origin.x = 0;
        _label.frame = labelFrame;
    }
    
    //labelCopy
    CGPoint copyCenter = CGPointMake(_labelCopy.center.x, self.center.y - self.frame.origin.y);
    _labelCopy.center = copyCenter;
    CGRect frame = _labelCopy.frame;
    frame.origin.x = CGRectGetMaxX(_label.frame) + self.paddingBetweenLabels;
    _labelCopy.frame = frame;
    
    CGSize size;
    if (_label.frame.size.width > self.frame.size.width) {
        size.width = CGRectGetWidth(_label.frame) + CGRectGetWidth(self.frame) + self.paddingBetweenLabels;
    }
    else {
        size.width = CGRectGetWidth(self.frame);
    }
    size.height = self.frame.size.height;
    self.contentView.frame = CGRectMake(0, 0, size.width, size.height);
    
    if (_label.frame.size.width > self.frame.size.width) {
        self.scrollDuration = _label.frame.size.width /self.scrollVelocity;
        _label.hidden = NO;
        _labelCopy.hidden = NO;
        if (self.autoBeginScroll) {
            [self startScrollAnimation];
        }
    }
    else {
        self.scrolling = NO;
        _labelCopy.hidden = YES;
        CGPoint center = _label.center;
        if (_textAlignment == YXEntertainingDiversionsViewScrollAlignmentLeft) {
            center.x = _label.frame.size.width /2.0;
        }
        else if (_textAlignment == YXEntertainingDiversionsViewScrollAlignmentCenter) {
            center.x = self.center.x - self.frame.origin.x;
        }
        else {
            center.x = self.frame.size.width - _label.frame.size.width /2.0;
        }
        _label.center = center;
    }
}

#pragma mark - 设置动画
- (void)shouldAutoScollLabel {
    
    if (self.scrolling) {
        return;
    }
    self.scrolling = YES;
    
    CGSize size;
    size.height = self.frame.size.height;
    if (_label.frame.size.width > self.frame.size.width) {
        size.width = CGRectGetWidth(_label.frame) + CGRectGetWidth(self.frame) + self.paddingBetweenLabels;
    }
    else {
        size.width = CGRectGetWidth(self.frame);
    }
    self.contentView.frame = CGRectMake(0, 0, size.width, size.height);
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:self.scrollDuration animations:^{
        
        if (weakSelf.label.frame.size.width > weakSelf.frame.size.width) {
            weakSelf.contentView.frame = CGRectMake(-(weakSelf.label.frame.size.width + weakSelf.paddingBetweenLabels), 0, size.width, size.height);
        }
        else {
            weakSelf.contentView.frame = CGRectMake(0, 0, size.width, size.height);
        }
    } completion:^(BOOL finished) {
       
        [weakSelf endAnimationg];
    }];
}

#pragma mark - 开启动画
- (void)startScrollAnimation {
    
    self.manualStop = NO;
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (weakSelf) {
            [weakSelf shouldAutoScollLabel];
        }
    });
}

#pragma mark - 结束动画
- (void)endAnimationg {
    
    self.scrolling = NO;
    if (_label.frame.size.width > self.frame.size.width) {
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.pauseInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (weakSelf && !weakSelf.manualStop) {
                [weakSelf shouldAutoScollLabel];
            }
        });
    }
    else {
        [self setLabelsFrame];
    }
}

#pragma mark - 移除动画
- (void)stopScrollAnimation {
    
    [self.contentView.layer removeAllAnimations];
    self.scrolling = NO;
    self.manualStop = YES;
}

#pragma mark - setter
- (void)setText:(NSString *)text {
    
    _text = text;
    _label.text = text;
    _labelCopy.text = text;
    [self stopScrollAnimation];
    [self setLabelsFrame];
}
- (void)setTextColor:(UIColor *)textColor {
    
    _textColor = textColor;
    _label.textColor = textColor;
    _labelCopy.textColor = textColor;
}
- (void)setFont:(UIFont *)font {
    
    _font = font;
    _label.font = font;
    _labelCopy.font = font;
}
- (void)setScrollVelocity:(CGFloat)scrollVelocity {
    
    _scrollVelocity = scrollVelocity;
}
- (void)setPaddingBetweenLabels:(CGFloat)paddingBetweenLabels {
    
    _paddingBetweenLabels = paddingBetweenLabels;
}
- (void)setScrollDuration:(CGFloat)scrollDuration {
    
    _scrollDuration = scrollDuration;
}
- (void)setPauseInterval:(CGFloat)pauseInterval {
    
    _pauseInterval = pauseInterval;
}
- (void)setDelayInterval:(CGFloat)delayInterval {
    
    _delayInterval = delayInterval;
}
- (void)setAutoBeginScroll:(BOOL)autoBeginScroll {
    
    _autoBeginScroll = autoBeginScroll;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.mask.frame = self.bounds;
}

#pragma mark - 初始化视图
- (void)initView {
    
    self.layer.masksToBounds = YES;
    _label = [self customLabel];
    _labelCopy = [self customLabel];
    [self.contentView addSubview:_label];
    [self.contentView addSubview:_labelCopy];
    [self addSubview:self.contentView];
    
    _scrollDuration = kDefaultScrollDuration;
    _scrollVelocity = kDefaultSrollVelocity;
    _pauseInterval = kDefaultPauseTime;
    _delayInterval = kDefaultDelay;
    _paddingBetweenLabels = kDefaultPadding;
    _autoBeginScroll = YES;
    _manualStop = NO;
    self.userInteractionEnabled = NO;
    
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    switch (_maskType) {
        case YXEntertainingDiversionsMaskTypeRight: {
            layer.colors = @[(__bridge id)[UIColor colorWithWhite:0 alpha:0.05f].CGColor, (__bridge id)[UIColor colorWithWhite:0 alpha:1.0f].CGColor];
            layer.locations = @[@0, @0.4]; //设置颜色的范围
            layer.startPoint = CGPointMake(1, 0); //设置颜色渐变的起点
            layer.endPoint = CGPointMake(0.5, 0); //设置颜色渐变的终点，与 startPoint 形成一个颜色渐变方向
            break;
        }
        case YXEntertainingDiversionsMaskTypeBoth: {
            layer.colors = @[(__bridge id)[UIColor colorWithWhite:0 alpha:0.05f].CGColor, (__bridge id)[UIColor colorWithWhite:0 alpha:1.0f].CGColor, (__bridge id)[UIColor colorWithWhite:0 alpha:1.0f].CGColor, (__bridge id)[UIColor colorWithWhite:0 alpha:0.05f].CGColor];
            layer.locations = @[@(0.0f), @(0.3f), @(0.7f), @(1.0)]; //设置颜色的范围
            layer.startPoint = CGPointMake(0, 0); //设置颜色渐变的起点
            layer.endPoint = CGPointMake(1, 0); //设置颜色渐变的终点，与 startPoint 形成一个颜色渐变方向
            break;
        }
        default:
            break;
    }
    layer.frame = self.bounds;
    self.layer.mask = layer;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldAutoScollLabel) name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - 懒加载
#pragma mark - 内容背景视图
- (UIView *)contentView {
    
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}
#pragma mark - 显示内容
- (UILabel *)customLabel {
    
    UILabel *commenLabel = [[UILabel alloc] init];
    commenLabel.backgroundColor = [UIColor clearColor];
    commenLabel.textColor = [UIColor blackColor];
    commenLabel.font = [UIFont systemFontOfSize:14];
    [commenLabel sizeToFit];
    return commenLabel;
}

@end
