//
//  ExpressSelectViewController.m
//  DoShop
//
//  Created by Anson on 15/3/17.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "ExpressSelectViewController.h"
#import "AlphabetCollectionViewCell.h"
#import "ExpressNameTableViewCell.h"
#import "CommonExpressCollectionReusableView.h"
@interface ExpressSelectViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *alphabetCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *expressTableView;



@end


static NSString * tableViewCellIdentifier = @"express";
static NSString  * collectionViewCellIdentifier = @"alphabet";


@implementation ExpressSelectViewController{
    
    NSDictionary * _expressDict;
    NSArray * _letterArray;
    NSArray * _expressNameArray;
    CommonExpressCollectionReusableView * _headerView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"ExpressList" ofType:@"plist"];
    
    _expressDict = [[NSDictionary alloc]initWithContentsOfFile:path];
    _letterArray = _expressDict[@"alphabet"];
    //初始化为A
    _expressNameArray = _expressDict[@"express"][@"A"];
    _expressTableView.tableFooterView = [[UIView alloc]init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --------UITbleViewDelegate---------



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return _expressNameArray.count;
    
    
}





-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpressNameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    cell.expressName.text = _expressNameArray[indexPath.row];
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpressNameTableViewCell * cell = (ExpressNameTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    self.expressName = cell.expressName.text;
    [self performSegueWithIdentifier:@"unwindFromExpress" sender:cell];
}




#pragma mark ------UICollectionView---------


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _letterArray.count;
    
    
    
}





-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    AlphabetCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellIdentifier forIndexPath:indexPath];
    cell.letter.text = _letterArray[indexPath.row];
    return cell;
    
    
}




- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    

    _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    return _headerView;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    AlphabetCollectionViewCell * cell =(AlphabetCollectionViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
    NSString * letter = cell.letter.text;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.letter.textColor = [UIColor colorWithRed:0.651 green:0.104 blue:0.149 alpha:1.000];
    
    
    _headerView.commonExpressLabel.textColor = [UIColor whiteColor];
    _headerView.backgroundColor = [UIColor colorWithRed:0.651 green:0.104 blue:0.149 alpha:1.000];
    
    
    _expressNameArray = _expressDict[@"express"][letter];
    [self.expressTableView reloadData];
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    AlphabetCollectionViewCell * cell =(AlphabetCollectionViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
    NSString * letter = cell.letter.text;
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:0.651 green:0.104 blue:0.149 alpha:1.000];
    cell.letter.textColor = [UIColor whiteColor];
    _expressNameArray = _expressDict[@"express"][letter];
    
    
    
    
}

#pragma mark -------点击常用快递
- (IBAction)commonExpress:(id)sender {
    
    
    _expressNameArray = _expressDict[@"express"][@"common"];
    _headerView.backgroundColor = [UIColor whiteColor];
    _headerView.commonExpressLabel.textColor = [UIColor colorWithRed:0.651 green:0.104 blue:0.149 alpha:1.000];
    
    NSIndexPath * selectedCellIndexPath = [self.alphabetCollectionView indexPathsForSelectedItems].firstObject;
    AlphabetCollectionViewCell * cell =(AlphabetCollectionViewCell*) [self.alphabetCollectionView cellForItemAtIndexPath:selectedCellIndexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:0.651 green:0.104 blue:0.149 alpha:1.000];
    cell.letter.textColor = [UIColor whiteColor];
    
    [self.expressTableView reloadData];
    

}






/*
#pragma mark - Navigation

 In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     Get the new view controller using [segue destinationViewController].
     Pass the selected object to the new view controller.
}
*/

@end
