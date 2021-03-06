//
//  SortGoodViewController.m
//  DoShop
//
//  Created by Anson on 15/2/15.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "SortGoodViewController.h"
#import "SupplierTableViewCell.h"
#import "SectionView.h"
#import "SectionInfoModel.h"
#import "STCollapseTableView.h"
@interface SortGoodViewController ()<UITableViewDelegate,UITableViewDataSource,UITableSectionHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet STCollapseTableView *supplierTableView;

@end
#define SECTION_HEIGHT 48
static NSString * cellIdentifier = @"suppliercell";
@implementation SortGoodViewController{
    
    NSMutableArray * _sectionInfoArray;
    NSMutableArray * _supplierArray;
    NSMutableArray * _categoryArray;
    NSMutableArray * _indexPathArray;
    NSMutableArray * _brandArray;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    [HTTPRequestManager getURL:[NSString stringWithFormat:GET_BRAND_API,userid] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
    
        
        
        _brandArray  = [dict[@"result"] objectForKey:@"brand"];
        _categoryArray = [dict[@"result"]  objectForKey:@"category"];
        _supplierArray = dict[@"result"][@"supplier"];
        [self.supplierTableView reloadData];
        
        
    }];
    
    
    
    
    
    
    
    
    
    UINib * sectionNib = [UINib nibWithNibName:@"SectionView" bundle:nil];
    [self.supplierTableView registerNib:sectionNib forHeaderFooterViewReuseIdentifier:@"SectionView"];
    
    self.supplierTableView.sectionFooterHeight = SECTION_HEIGHT;
    _sectionInfoArray = [[NSMutableArray alloc]init];
    
    NSArray * titleArray = @[@"类别",@"品牌",@"供应商"];
    for (NSInteger i=0;i<3;i++)
    {
        SectionInfoModel * model =[[SectionInfoModel alloc]init];
        model.sectiontitle = titleArray[i];
        model.fold=NO;
        [_sectionInfoArray addObject:model];
    }
    
    [self.supplierTableView reloadData];

    [self.supplierTableView openSection:0 animated:NO];
    [self.supplierTableView setExclusiveSections:NO];
    self.supplierTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _indexPathArray = [[NSMutableArray alloc]init];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -----UITableViewDelegate-----


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==0)
    {
        return _categoryArray.count;
    }else if (section==1){
        return _brandArray.count;
    }else{
        return _supplierArray.count;
    }
    

}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    SupplierTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section==0)
    {
        cell.supplierName.text = [_categoryArray[indexPath.row] objectForKey:@"categoryName"];
        cell.cellID = [_categoryArray[indexPath.row] objectForKey:@"categoryID"];
    }else if (indexPath.section==1){
        cell.supplierName.text = [_brandArray[indexPath.row] objectForKey:@"brandName"];
        cell.cellID = [_brandArray[indexPath.row] objectForKey:@"brandID"];
    }else{
        cell.supplierName.text = [_supplierArray[indexPath.row] objectForKey:@"supplierName"];
        cell.cellID = [_supplierArray[indexPath.row] objectForKey:@"brandID"];
    }
    
    
    
    if ([_indexPathArray containsObject:indexPath])
    {
        cell.checkButton.selected=YES;
    }else{
        cell.checkButton.selected=NO;
    }
    
    
    return cell;
    
    
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    SectionView * sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SectionView"];
    sectionView.delegate = self;
    sectionView.section = section;
    sectionView.sectionTitle.text =((SectionInfoModel*) _sectionInfoArray[section]).sectiontitle;
    
    return sectionView;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    
    return 48.0f;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    SupplierTableViewCell * cell = (SupplierTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.checkButton.selected = !cell.checkButton.selected;

    if (cell.checkButton.selected)
    {
        [_indexPathArray addObject:indexPath];
    }else if (!cell.checkButton.selected && [_indexPathArray containsObject:indexPath])
    {
        [_indexPathArray removeObject:indexPath];
    }
    
    
    
}


#pragma mark UITableSectionHeaderViewDelegate




- (IBAction)sortButtonClicked:(id)sender {
    
    NSMutableString * brandIDString = [NSMutableString stringWithString:@""];
    NSMutableString * categoryIDString = [NSMutableString stringWithString:@""];
    NSMutableString * supplierIDString = [NSMutableString stringWithString:@""];
    
    NSLog(@"%@",_indexPathArray);
    for (NSIndexPath * indexPath in _indexPathArray)
    {
        SupplierTableViewCell * cell = (SupplierTableViewCell*)[self.supplierTableView cellForRowAtIndexPath:indexPath];

        if (indexPath.section==0)
        {
            if (categoryIDString.length==0)
            {
                [categoryIDString appendFormat:@"%@",cell.cellID];
            }else{
                [categoryIDString appendFormat:@",%@",cell.cellID];

            }
            
        }else if (indexPath.section==1){
            //对应supplier
            if (brandIDString.length==0)
            {
                [brandIDString appendFormat:@"%@",cell.cellID];
            }else{
                [brandIDString appendFormat:@",%@",cell.cellID];
                
            }
            
        }else{
            if (supplierIDString.length==0)
            {
                [supplierIDString appendFormat:@"%@",cell.cellID];
            }else{
                [supplierIDString appendFormat:@",%@",cell.cellID];
                
            }
        }
        
        
        
    }
    
    
    [self.delegate sortGoodsWithCategory:categoryIDString andBrand:brandIDString andSupplier:supplierIDString];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
