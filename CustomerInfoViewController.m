//
//  CustomerInfoViewController.m
//  Dome
//
//  Created by BTW on 14/12/24.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "CustomerInfoViewController.h"
#import "RushOrdersInfoTableViewCell.h"
#import "OrderInfoViewController.h"
#import "CustomTitleLabelTableView.h"
#import "DSOrder_ResultModel.h"
#import <MJRefresh.h>
@interface CustomerInfoViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
@property (weak, nonatomic) IBOutlet CustomTitleLabelTableView *MyTableView;
@property (weak, nonatomic) IBOutlet UIView *BGView1;
@property (weak, nonatomic) IBOutlet UILabel *BGView2;
@property (weak, nonatomic) IBOutlet UILabel *customerName;
@property (weak, nonatomic) IBOutlet UILabel *lastOrder;
@property (weak, nonatomic) IBOutlet UILabel *totalConsumption;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

static NSString *CellIdentifier = @"orderCell" ;

@implementation CustomerInfoViewController
{
    NSString * userid;
    NSMutableArray * _customerInfoArray;
    NSInteger _page;
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"客户管理";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.BGView1.layer.shadowColor = [UIColor blackColor].CGColor;
    self.BGView1.layer.shadowOffset = CGSizeMake(1, 1);
    self.BGView1.layer.shadowOpacity = 0.2;
    
    self.BGView2.layer.shadowColor = [UIColor blackColor].CGColor;
    self.BGView2.layer.shadowOffset = CGSizeMake(1, 1);
    self.BGView2.layer.shadowOpacity = 0.2;
    
    
    self.customerName.text = self.customerNameString;
    self.lastOrder.text = self.lastOrderString;
    self.totalConsumption.text = self.totlaConsumptionString;

    [[SDImageCache sharedImageCache]queryDiskCacheForKey:self.buyerid done:^(UIImage *image, SDImageCacheType cacheType) {
        self.avatarImageView.image = image;
        
    }];

    
    self.MyTableView.delegate = self;
    self.MyTableView.dataSource = self;
    [self.MyTableView registerNib:[UINib nibWithNibName:@"RushOrdersInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderCell"];
    [self.MyTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.MyTableView addFooterWithTarget:self action:@selector(footerRefresh)];

    _customerInfoArray = [[NSMutableArray alloc]init];
    userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    
    _page=1;
    
    [HTTPRequestManager getURL:[NSString stringWithFormat:GET_CUSTOMER_ORDER_API,userid,self.buyerid,_page] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        
        
        for (NSDictionary * modelDict in dict[@"result"])
        {
            DSOrder_ResultModel * model = [DSOrder_ResultModel init:modelDict];
            [_customerInfoArray addObject:model];
            
        }
        
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
    return _customerInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    
    RushOrdersInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(1, 1);
    cell.layer.shadowOpacity = 0.2;

    
    DSOrder_ResultModel * model  = _customerInfoArray[indexPath.row];

    
    [cell updateCellWithModelInCustomerManagement:model];
    
    
    
    
    
    return cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Touch %ld",(long)indexPath.row);
    OrderInfoViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderInfoViewController"];

    DSOrder_ResultModel * model = _customerInfoArray[indexPath.row];
    
    vc.orderModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark ----MJRefresh-----

-(void)headerRefresh
{
    _page=1;
    
    [HTTPRequestManager getURL:[NSString stringWithFormat:GET_CUSTOMER_ORDER_API,userid,self.buyerid,_page] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        
        [_customerInfoArray removeAllObjects];
        for (NSDictionary * modelDict in dict[@"result"])
        {
            DSOrder_ResultModel * model = [DSOrder_ResultModel init:modelDict];
            [_customerInfoArray addObject:model];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_MyTableView reloadData];
            [self.MyTableView headerEndRefreshing];
        });
    }];
}

-(void)footerRefresh
{
    _page++;
    
    [HTTPRequestManager getURL:[NSString stringWithFormat:GET_CUSTOMER_ORDER_API,userid,self.buyerid,_page] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        for (NSDictionary * modelDict in dict[@"result"])
        {
            DSOrder_ResultModel * model = [DSOrder_ResultModel init:modelDict];
            [_customerInfoArray addObject:model];
            
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [_MyTableView reloadData];
            [self.MyTableView footerEndRefreshing];
        });
    }];
    
    
    
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
