//
//  YXFuncCollectionCardFlowLayout.m
//  YXFuncScrollViewTest
//
//  Created by Augus on 2022/5/24.
//  Copyright © 2022 August. All rights reserved.
//

#import "YXFuncCollectionCardFlowLayout.h"

@implementation YXFuncCollectionCardFlowLayout

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {

    NSArray *array = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    CGFloat centerX = self.collectionView.frame.size.width * 0.5 + self.collectionView.contentOffset.x;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        CGFloat deltaOriginalValue = attrs.center.x - centerX;
        CGFloat delta = fabs(deltaOriginalValue);

//        CGFloat scale = 1 - delta / (self.collectionView.frame.size.width);
//        CGFloat scale = 1 - delta / (self.collectionView.bounds.size.width * 0.5) * 0.25;
        CGFloat scale = 1 - delta / (self.collectionView.bounds.size.width) * 0.25;
        CGFloat heightScale = 1 - delta / (self.collectionView.frame.size.width) * 0.5;
        attrs.alpha = scale;
        attrs.size = CGSizeMake(scale * attrs.size.width, scale * attrs.size.height);
        attrs.center = CGPointMake(attrs.center.x, heightScale * attrs.center.y);
    }

    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {

    return YES;
}

@end
