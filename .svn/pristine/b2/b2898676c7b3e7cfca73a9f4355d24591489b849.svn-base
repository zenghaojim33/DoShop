//
//  CustomerViewController.m
//  Dome
//
//  Created by BTW on 14/12/23.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "CustomerViewController.h"
#import "CustomerTableViewCell.h"
#import "CustomerInfoViewController.h"
#import "CustomTitleLabelTableView.h"
#import "DSCustomer_CustomerModel.h"
#import <MJRefresh.h>
@interface CustomerViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate
>
#define CustomerCacheKey @"Customer"

@property (weak, nonatomic) IBOutlet CustomTitleLabelTableView *MyTableView;
@property (weak, nonatomic) IBOutlet UITextField *MyTextField;

@end

static NSString *CellIdentifier = @"customerCell";

@implementation CustomerViewController

{
    
    NSMutableArray * _customerArray;
    DSCustomer_CustomerModel * _customerModel;
    NSInteger _page;
    NSString * _key;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"客户管理";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
    // Do any additional setup after loading the view.
    _page=1;
    _key = @"";
    [self.MyTextField addTarget:self action:@selector(searchOrderWithKeywords) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    self.MyTableView.delegate = self;
    self.MyTableView.dataSource = self;
    [self.MyTableView registerNib:[UINib nibWithNibName:@"CustomerTableViewCell" bundle:nil] forCellReuseIdentifier:@"customerCell"];
    [self.MyTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.MyTableView addFooterWithTarget:self action:@selector(footerRefresh)];
    self.MyTableView.tableFooterView = [[UIView alloc]init];
    
    _customerArray = [[NSMutableArray alloc]init];
    NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    [HTTPRequestManager getURL:[NSString stringWithFormat:CUSTOMER_MANAGEMENT_API,userid,(long)_page,_key] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
       
        
        _customerModel = [DSCustomer_CustomerModel init:dict];
        [DSBaseModel saveObjectToCache:_customerModel andKey:CustomerCacheKey];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_MyTableView reloadData];
        });
        
    }];


}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _customerModel.result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    
    CustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    DSCustomer_ResultModel * result = _customerModel.result[indexPath.row];

    [cell updateCellWithModel:result];
    

    return cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    CustomerInfoViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomerInfoViewController"];
    CustomerTableViewCell * cell = (CustomerTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    vc.customerNameString = cell.customerName.text;
    vc.lastOrderString = cell.customerTime.text;
    vc.totlaConsumptionString = cell.totlaConsumption.text;
    vc.buyerid = cell.buyerid;
    [self.navigationController pushViewController:vc animated:YES];


}


#pragma mark --------MJRefresh----------



-(void)headerRefresh
{
    
    _page=1;
    NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    [HTTPRequestManager getURL:[NSString stringWithFormat:CUSTOMER_MANAGEMENT_API,userid,(long)_page,_key] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        
        
        _customerModel = [DSCustomer_CustomerModel init:dict];
        [DSBaseModel saveObjectToCache:_customerModel andKey:CustomerCacheKey];

        dispatch_async(dispatch_get_main_queue(), ^{
            [_MyTableView reloadData];
            [_MyTableView headerEndRefreshing];
        });
        
    }];
    
    
}





-(void)footerRefresh
{
    
    _page++;
    NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    [HTTPRequestManager getURL:[NSString stringWithFormat:CUSTOMER_MANAGEMENT_API,userid,(long)_page,_key] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        
        for (NSDictionary * modelDict in dict[@"result"])
        {
            DSCustomer_ResultModel * resultModel = [DSCustomer_ResultModel init:modelDict];
            [_customerModel.result addObject:resultModel];
        }
        
        [DSBaseModel saveObjectToCache:_customerModel andKey:CustomerCacheKey];

        dispatch_async(dispatch_get_main_queue(), ^{
            [_MyTableView reloadData];
            [_MyTableView footerEndRefreshing];

        });
        
    }];
    
    
    
}


#pragma mark ------搜索客户------

-(void)searchOrderWithKeywords
{
    _key = [self.MyTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [self headerRefresh];
    
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    
    _key = @"";
    [self headerRefresh];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
