//
//  SectionView.h
//  DoShop
//
//  Created by Anson on 15/2/16.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UITableSectionHeaderViewDelegate;

@interface SectionView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *sectionTitle;
@property (weak, nonatomic) IBOutlet UIImageView *sectionFoldIndicator;
@property (nonatomic,weak)id <UITableSectionHeaderViewDelegate> delegate;
@property (nonatomic)NSInteger section;
@property (nonatomic)BOOL fold;
@end


@protocol UITableSectionHeaderViewDelegate <NSObject>
@optional
-(void)sectionHeaderView:(SectionView*)sectionView sectionOpened:(NSInteger)section;
-(void)sectionHeaderView:(SectionView*)sectionView sectionClosed:(NSInteger)section;


@end