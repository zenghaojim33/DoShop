//
//  ProvinceLayout.m
//  DoShop
//
//  Created by Anson on 15/3/11.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "ProvinceLayout.h"

@implementation ProvinceLayout{
    
    NSInteger  _numberOfItemsForRows;
    
    
}




-(void)prepareLayout
{
    [super prepareLayout];
    _numberOfItemsForRows = 4;
    self.minimumInteritemSpacing = 5;
    self.minimumLineSpacing = 0;
    
    UICollectionView * collectionView = self.collectionView;
    
    CGSize newItemSize = self.itemSize;
    
    CGFloat itemsPerRow = MAX(_numberOfItemsForRows, 1);
    

    CGFloat totalSpacing = self.minimumInteritemSpacing * (itemsPerRow -1.0);
    
    newItemSize.width = (collectionView.bounds.size.width - totalSpacing) / itemsPerRow;
    
    if (self.itemSize.height>0)
    {
        CGFloat itemAspectRatio = self.itemSize.width / self.itemSize.height;
        newItemSize.height = newItemSize.width/ itemAspectRatio;
    }
    self.itemSize = newItemSize;
    
}




@end
