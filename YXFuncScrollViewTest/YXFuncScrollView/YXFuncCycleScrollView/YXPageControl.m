//
//  YXPageControl.m
//  YXFuncScrollViewTest
//
//  Created by ios on 2020/5/25.
//  Copyright © 2020 August. All rights reserved.
//

#import "YXPageControl.h"

@implementation YXPageControl

- (void)setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    
    if (self.selImg != nil && self.norImg != nil) {
        for (NSUInteger i = 0; i < [self.subviews count]; i++) {
            UIView *bgView = [self.subviews objectAtIndex:i];
            [bgView setFrame:CGRectMake(bgView.frame.origin.x, bgView.frame.origin.y, 6, 6)];
            if ([bgView.subviews count] == 0) {
                UIImageView *view = [[UIImageView alloc] initWithFrame:bgView.bounds];
                [bgView addSubview:view];
            }
            
            UIImageView *img = bgView.subviews[0];
            img.contentMode = UIViewContentModeCenter;
            
            
            if (i == page) {
                img.image = self.selImg;
            }
            else {
                img.image = self.norImg;
            }
            
            bgView.backgroundColor = [UIColor clearColor];
        }
        
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    }
}

@end
