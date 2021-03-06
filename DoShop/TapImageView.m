//
//  TapImageView.m
//  TestLayerImage
//
//  Created by lcc on 14-8-1.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "TapImageView.h"

@implementation TapImageView

- (void)dealloc
{
    _t_delegate = nil;
}

-(void)awakeFromNib
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tapped:)];
    [self addGestureRecognizer:tap];
    
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.userInteractionEnabled = YES;
}



- (void) Tapped:(UIGestureRecognizer *) gesture
{
    
    if ([self.t_delegate respondsToSelector:@selector(tappedWithObject:)])
    {
        [self.t_delegate tappedWithObject:self];
    }
}


@end
