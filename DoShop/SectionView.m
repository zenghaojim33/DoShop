//
//  SectionView.m
//  DoShop
//
//  Created by Anson on 15/2/16.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "SectionView.h"
@implementation SectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSectionView)];
//    
//    
//    [self addGestureRecognizer:tap];
    self.fold = YES;
    
    
}


-(void)tapSectionView
{
    
    if (self.fold){
        [self.sectionFoldIndicator setImage:[UIImage imageNamed:@"carat-open"]];
        
    }else{
        [self.sectionFoldIndicator setImage:[UIImage imageNamed:@"carat"]];
    }
    
    
    if (self.fold)
    {
        if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]){
            [self.delegate sectionHeaderView:self sectionOpened:self.section];
        }
    
    }else{
        if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]){
            [self.delegate sectionHeaderView:self sectionClosed:self.section];
        }
        
    }
    self.fold = !self.fold;
    NSLog(@"%d",self.fold);

}



@end
