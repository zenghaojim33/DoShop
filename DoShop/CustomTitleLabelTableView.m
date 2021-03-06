//
//  CustomTitleLabelTableView.m
//  DoShop
//
//  Created by Anson on 15/3/31.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "CustomTitleLabelTableView.h"
#import <Masonry.h>


#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


@implementation CustomTitleLabelTableView{
    
    UILabel * _titleLabel;
    
}

- (bool) tableViewHasRows
{
    return [self numberOfRowsInSection:0] == 0;
}

-(void)awakeFromNib
{
    
    _titleLabel = [[UILabel alloc]init];

    
}




-(void)updateEmptyPage
{

    
    
    if ([self tableViewHasRows])
    {
        _titleLabel.hidden = NO;
    }else{
        _titleLabel.hidden = YES;
    }
    
    
}


//- (UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    const bool emptyViewShown = emptyView.superview != nil;
//    return emptyViewShown ? nil : [super hitTest:point withEvent:event];
//}

- (void)layoutSubviews
{
    [self updateEmptyPage];
    
    
    [self layoutIfNeeded];
    if (_titleLabel){
        
        _titleLabel.text = @"暂无数据";
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor colorWithWhite:0.520 alpha:1.000];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.frame = CGRectMake(0,0, 50, 50);
        _titleLabel.center = self.center;
        
        
        [self addSubview:_titleLabel];

    }
    
    [super layoutSubviews];
    
}




-(void)reloadData{
    [super reloadData];
    [self updateEmptyPage];

    
}

@end
