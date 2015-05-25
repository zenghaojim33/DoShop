//
//  UIScrollView+ScrollViewTouches.m
//  DoShop
//
//  Created by Anson on 15/3/16.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "UIScrollView+ScrollViewTouches.h"

@implementation UIScrollView (ScrollViewTouches)

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if ( !self.dragging )
    {
        [[self nextResponder] touchesBegan:touches withEvent:event];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if ( !self.dragging )
    {
        [[self nextResponder] touchesEnded:touches withEvent:event];
    }
}


@end
