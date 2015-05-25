//
//  ProductDetailViewController.h
//  DoShop
//
//  Created by Anson on 15/4/1.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailViewController : UIViewController

@property(nonatomic,strong)NSNumber * productId;
@property (weak, nonatomic) IBOutlet UIWebView *ProductDetailWebView;



@end
