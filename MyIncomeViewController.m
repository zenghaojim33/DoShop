//
//  MyIncomeViewController.m
//  DoShop
//
//  Created by Anson on 15/2/13.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "MyIncomeViewController.h"
#import "MyIncomeTableViewCell.h"
#import "GetIncomeViewController.h"
#import "ChangeInfoViewController.h"
#import "UICountingLabel.h"
#import "CustomTitleLabelTableView.h"
#import <MJRefresh.h>
#import "DSIncome_IncomeModel.h"
#import "DSIncome_RecordModel.h"
typedef NS_ENUM(NSInteger, SelectedTable){
    
    MyIncomeSelected = 1,
    MyBalanceSelected,
    AllIncomeSelected
};

#define MyIncomeCacheKey @"MyIncome"
#define MyBalanceCacheKey @"MyBalance"
#define AllIncomeCacheKey @"AllIncome"

@interface MyIncomeViewController ()<UITableViewDataSource,UITableViewDelegate>




@property (weak, nonatomic) IBOutlet CustomTitleLabelTableView  *myIncomeTableview;
@property (weak, nonatomic) IBOutlet UIButton *myIncomeBtn;
@property (weak, nonatomic) IBOutlet UICountingLabel *myBalanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *myStoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *allIncomeBtn;
@property (nonatomic)NSInteger type;

@end

static  NSString * MyStoreIncome = @"StoreIncomeCell";
static  NSString * MyIncome = @"MyIncomeCell";

@implementation MyIncomeViewController{
    
    DSIncome_IncomeModel * _myIncomeModel;
    DSIncome_IncomeModel * _myBalanceModel;
    DSIncome_IncomeModel * _allIncomeModel;
    UIColor * _originalbtncolor;
    NSMutableArray * _myIncomeArray;
    NSMutableArray * _myBalanceArray;
    NSMutableArray * _allIncomeArray;
    NSMutableArray * _currentArray;
    NSInteger page;
    NSString * _userid;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的财富";
    self.myIncomeTableview.tableFooterView = [[UIView alloc]init];
    _originalbtncolor = self.myIncomeBtn.backgroundColor;
    [self.myIncomeTableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.myIncomeTableview addFooterWithTarget:self action:@selector(footerRefresh)];
    page=1;  //初始化第一页
    
    _userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    
    _myBalanceArray = [[NSMutableArray alloc]init];
    _myIncomeArray = [[NSMutableArray alloc]init];
    _allIncomeArray = [[NSMutableArray alloc]init];
    self.type = MyIncomeSelected;
    
    _myIncomeModel = [DSBaseModel cacheObjectByKey:MyIncomeCacheKey];
    _myBalanceModel = [DSBaseModel cacheObjectByKey:MyBalanceCacheKey];
    _allIncomeModel = [DSBaseModel cacheObjectByKey:AllIncomeCacheKey];

    if (_myIncomeModel)
    {
        [self updateCashBalance];

    
    }else{
    
        [HTTPRequestManager getURL:[NSString stringWithFormat:GET_INCOME_API,_userid,self.type,page] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        
        
        _myIncomeModel = [DSIncome_IncomeModel init:dict[@"result"]];
        [DSBaseModel saveObjectToCache:_myIncomeModel andKey:MyIncomeCacheKey];
    
        

        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self updateCashBalance];

   
            [self.myIncomeTableview reloadData];
            
            });
        
        }];
    }
    
}




#pragma mark ------申请提现---------

- (IBAction)applyForBalance:(id)sender {
    
    
    
    GetIncomeViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GetIncomeViewController"];
    [self.navigationController pushViewController:vc animated:YES];

}


#pragma mark --------我的收入---------

- (IBAction)myIncome:(id)sender {
    
    
    self.myIncomeBtn.backgroundColor = [UIColor colorWithRed:0.737 green:0.176 blue:0.196 alpha:1.000];
    
    self.myIncomeBtn.tintColor = [UIColor whiteColor];
    self.myStoreBtn.backgroundColor = [UIColor whiteColor];
    self.myStoreBtn.tintColor = [UIColor blackColor];
    self.allIncomeBtn.backgroundColor = [UIColor whiteColor];
    self.allIncomeBtn.tintColor = [UIColor blackColor];
    self.type = MyIncomeSelected;
    
    if(_myIncomeModel)
    {
        [_myIncomeTableview reloadData];
        return;
    }else{
    
        [HTTPRequestManager getURL:[NSString stringWithFormat:GET_INCOME_API,_userid,self.type,page]  andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        _myIncomeModel = [DSIncome_IncomeModel init:dict[@"result"]];
        
        [DSBaseModel saveObjectToCache:_myIncomeModel andKey:MyIncomeCacheKey];

            
        dispatch_async(dispatch_get_main_queue(), ^{
            [_myIncomeTableview reloadData];
            });
        
        }];
    
    
    
    }
    
    
}


#pragma mark --------提现详情---------


- (IBAction)myStore:(id)sender {
    
    self.myStoreBtn.backgroundColor = [UIColor colorWithRed:0.737 green:0.176 blue:0.196 alpha:1.000];
    self.myStoreBtn.tintColor = [UIColor whiteColor];
    self.myIncomeBtn.backgroundColor = [UIColor whiteColor];
    self.myIncomeBtn.tintColor = [UIColor blackColor];
    self.allIncomeBtn.backgroundColor = [UIColor whiteColor];
    self.allIncomeBtn.tintColor = [UIColor blackColor];
    self.type = MyBalanceSelected;
    
    if(_myBalanceModel)
    {
        [_myIncomeTableview reloadData];
        return;
    
        }else{
            [HTTPRequestManager getURL:[NSString stringWithFormat:GET_INCOME_API,_userid,self.type,page] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        
                _myBalanceModel = [DSIncome_IncomeModel init:dict[@"result"]];
                [DSBaseModel saveObjectToCache:_myBalanceModel andKey:MyBalanceCacheKey];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [_myIncomeTableview reloadData];
                });
        
            }];
    
        }

}

- (IBAction)allIncome:(id)sender {
    
    
    self.allIncomeBtn.backgroundColor = [UIColor colorWithRed:0.737 green:0.176 blue:0.196 alpha:1.000];
    
    self.allIncomeBtn.tintColor = [UIColor whiteColor];
    self.myStoreBtn.backgroundColor = [UIColor whiteColor];
    self.myStoreBtn.tintColor = [UIColor blackColor];
    self.myIncomeBtn.backgroundColor = [UIColor whiteColor];
    self.myIncomeBtn.tintColor = [UIColor blackColor];
    self.type = AllIncomeSelected;
    
    if (_allIncomeModel)
    {
        [_myIncomeTableview reloadData];

    }else{
    [HTTPRequestManager getURL:[NSString stringWithFormat:GET_INCOME_API,_userid,self.type,page]  andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        
        _allIncomeModel = [DSIncome_IncomeModel init:dict[@"result"]];
        [DSBaseModel saveObjectToCache:_allIncomeModel andKey:AllIncomeCacheKey];

        dispatch_async(dispatch_get_main_queue(), ^{
            [_myIncomeTableview reloadData];
        });
        
    }];
    
    
    }
}


#pragma mark -------UITableViewDelegate-------



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyIncomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MyStoreIncome];
    
    DSIncome_RecordModel * recordModel;

    if (self.type==MyIncomeSelected)
    {
        recordModel = _myIncomeModel.records[indexPath.row];
    }else if (self.type == MyBalanceSelected){
        
        recordModel = _myBalanceModel.records[indexPath.row];
    }else if (self.type == AllIncomeSelected){
        recordModel = _allIncomeModel.records[indexPath.row];
    }
    
    
    
    
    [cell updateCellWithModel:recordModel];

    
    
    return cell;
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DSIncome_IncomeModel * currentModel;

    if (self.type==MyIncomeSelected)
    {
        currentModel = _myIncomeModel;
    }else if (self.type == MyBalanceSelected){
        
        currentModel = _myBalanceModel;
    }else if (self.type == AllIncomeSelected){
        currentModel = _allIncomeModel;
    }
    
    return currentModel.records.count;
}


#pragma mark ----MJRefresh------
-(void)headerRefresh
{
    
    page=1;
    

    [HTTPRequestManager getURL:[NSString stringWithFormat:GET_INCOME_API,_userid,self.type,page]  andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        DSIncome_IncomeModel * currentModel;
        NSString * key;
        switch (self.type) {
            case MyIncomeSelected:
                currentModel = _myIncomeModel;
                key = MyIncomeCacheKey;
                break;
            case MyBalanceSelected:
                currentModel = _myBalanceModel;
                key = MyBalanceCacheKey;
                break;
            case AllIncomeSelected:
                currentModel = _allIncomeModel;
                key = AllIncomeCacheKey;
                break;
            default:
                break;
        }
        currentModel = [DSIncome_IncomeModel init:dict[@"result"]];
        [DSBaseModel saveObjectToCache:currentModel andKey:key];

        dispatch_async(dispatch_get_main_queue(), ^{
            [_myIncomeTableview reloadData];
            [_myIncomeTableview headerEndRefreshing];
        });
        
    }];
    
    
}




-(void)footerRefresh
{
    
    
    page++;
    

    [HTTPRequestManager getURL:[NSString stringWithFormat:GET_INCOME_API,_userid,self.type,page]  andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        DSIncome_IncomeModel * currentModel;
        NSString * key;
        switch (self.type) {
            case MyIncomeSelected:
                currentModel = _myIncomeModel;
                key = MyIncomeCacheKey;
                break;
            case MyBalanceSelected:
                currentModel = _myBalanceModel;
                key = MyBalanceCacheKey;
            case AllIncomeSelected:
                currentModel = _allIncomeModel;
                key = AllIncomeCacheKey;
            default:
                break;
        }
        DSIncome_IncomeModel * newModel = [DSIncome_IncomeModel init:dict[@"result"]];
        
        if (currentModel.records.count>0)
        {
            [currentModel.records addObjectsFromArray:newModel.records];
        }
        [DSBaseModel saveObjectToCache:currentModel andKey:key];
        
        

        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_myIncomeTableview reloadData];
            [_myIncomeTableview footerEndRefreshing];
            if (![newModel.cashBalance isEqualToNumber:currentModel.cashBalance]){
                
                
                
                
            }
                 
            
        });
        
    }];
    

    
}

-(void)updateCashBalance
{
    
    
    
    NSNumber * myBalance = _myIncomeModel.cashBalance;
    _myBalanceLabel.method = UILabelCountingMethodEaseOut;
    _myBalanceLabel.format = @"%.2f";
    [_myBalanceLabel countFrom:0 to:myBalance.floatValue withDuration:1.5];
    [self.myIncomeTableview reloadData];
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
