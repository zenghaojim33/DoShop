//
//  OrderViewController.m
//  Dome
//
//  Created by BTW on 14/12/23.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "OrderViewController.h"
#import "StartTimeViewController.h"
#import "EndTimeViewController.h"
#import "RushOrdersInfoTableViewCell.h"
#import "OrderInfoViewController.h"
#import "SendExpressViewController.h"
#import "ReturnOrderTableViewCell.h"
#import "CustomTitleLabelTableView.h"
#import <MJRefresh.h>
#import "ReturnInfoViewController.h"
#import "DSOrder_ResultModel.h"
#import "DSOrder_ProductsModel.h"
#import "DSReturn_ResultModel.h"
@interface OrderViewController ()
<
    StartimeDelegate,
    EndTimeDelegate,
    UITableViewDataSource,
    UITableViewDelegate,
    OrderTableViewCellDelegate,
    UITextFieldDelegate

>
{
    NSString * userid;
    NSString * selectStartTime;
    NSString * selectEndTime;
    NSString * type;
    BOOL _isReturnSelected;
    NSString * _currentAPI;

    NSMutableArray * _currentArray;
    NSInteger _page;
    NSString * _sortKeyword;
    
    
}
@property (strong, nonatomic) IBOutlet UITextField * searchTextField;
@property (strong, nonatomic) UIButton *DateEndBth;
@property (strong, nonatomic) UIButton *DateBth;
@property (weak, nonatomic) IBOutlet UIView *DateButtonBGView;

@property (weak, nonatomic) IBOutlet UIView *ButtonBGView;//scrollview下面的view
@property (weak, nonatomic) IBOutlet UIScrollView *buttonScrollView;


@property(nonatomic,strong)NSMutableArray *ButtonArray;
@property (weak, nonatomic) IBOutlet CustomTitleLabelTableView *MyTableView;
@end


static NSString *CellIdentifier = @"orderCell" ;
static NSString * ReturnCellIdentifier = @"return";

@implementation OrderViewController



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"订单查询";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
    

    [self.searchTextField resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveReloadTableViewDataOrder) name:@"TableViewReloadNotification" object:nil];
    
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



-(void)initDateButton
{
    self.DateBth = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2-1, 40)];
    [self.DateBth setTitle:@"请选择开始日期" forState:UIControlStateNormal];
    [self.DateBth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.DateBth setBackgroundColor:[UIColor whiteColor]];
    [self.DateBth addTarget:self action:@selector(TouchData:) forControlEvents:UIControlEventTouchUpInside];
     self.DateBth.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.DateButtonBGView addSubview:self.DateBth];
    
    self.DateEndBth = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 40)];
    [self.DateEndBth setTitle:@"请选择结束日期" forState:UIControlStateNormal];
    [self.DateEndBth setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
    [self.DateEndBth setBackgroundColor:[UIColor whiteColor]];
    [self.DateEndBth addTarget:self action:@selector(TouchEndData:) forControlEvents:UIControlEventTouchUpInside];
     self.DateEndBth.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.DateButtonBGView addSubview:self.DateEndBth];
    
}
-(void)initSelectButton
{
    float width = 375/5;
    
    self.buttonScrollView.contentSize = CGSizeMake(width*11+11, 33);
    
    NSArray * titles = @[@"已付款",@"未付款",@"已发货",@"已签收",@"已完成",@"已关闭",@"申请退货中",@"同意退货",@"不同意退货",@"待退款",@"退货成功"];
    self.ButtonArray = [NSMutableArray array];

    for (NSInteger i=0;i<6;i++)
    {
        UIButton * selectButton = [[UIButton alloc]initWithFrame:CGRectMake(width*i+i, 0, width, 33)];
        [selectButton setTitle:titles[i] forState:UIControlStateNormal];
        [selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        selectButton.titleLabel.font = [UIFont systemFontOfSize:15];
        selectButton.tag = i;
        [selectButton addTarget:self action:@selector(TouchSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [selectButton setBackgroundColor:[UIColor whiteColor]];
        [selectButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        if (i==0)
        {
            [selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [self.buttonScrollView addSubview:selectButton];
        [self.ButtonArray addObject:selectButton];
        
    }
    
    
    for (NSInteger i = 6;i<11;i++)
    {
        UIButton * selectButton = [[UIButton alloc]initWithFrame:CGRectMake(width*i+i, 0, width, 33)];
        [selectButton setTitle:titles[i] forState:UIControlStateNormal];
        [selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        selectButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [selectButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        selectButton.tag = i;
        [selectButton addTarget:self action:@selector(touchReturnListButtons:) forControlEvents:UIControlEventTouchUpInside];
        [selectButton setBackgroundColor:[UIColor whiteColor]];
        [self.buttonScrollView addSubview:selectButton];
        [self.ButtonArray addObject:selectButton];
    }
    
    
   

}
- (void)TouchSelectButton:(UIButton *)button
{
    if (button.center.x - self.view.frame.size.width/2 >= 0)
    {
        [_buttonScrollView setContentOffset:CGPointMake(button.center.x - self.view.frame.size.width/2, 0) animated:YES];
    }else{
        [_buttonScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }

    _isReturnSelected = NO;
    _currentAPI = GET_ORDER_API;
    _sortKeyword = @"";
    [self.DateEndBth setTitle:@"请选择结束日期" forState:UIControlStateNormal];
    [self.DateBth setTitle:@"请选择结束日期" forState:UIControlStateNormal];
    selectStartTime = selectEndTime = @"";

    
    for (int i = 0; i<self.ButtonArray.count; i++) {
    UIButton * SelectButton  = [self.ButtonArray objectAtIndex:i];
    [SelectButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    }
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    switch (button.tag) {
        case 0:
            //交易中
            type = @"1";
            break;
        case 1:
            //未发货
            type = @"0";
            break;
        case 2:
            //已完成
            type = @"2";
            break;
        case 3:
            //退货中
            type = @"3";
            break;
        case 4:
            //已关闭
            type = @"4";
            break;
        case 5:
            type = @"5";
            break;
        case 6:
            type = @"4";
            break;
        case 7 :
            type = @"5";
        case  8:
            type = @"6";
            break;
        case 9:
            type = @"7";
            break;
        default:
            type = @"8";
            break;
    }
    

    _page=1;
    
    
    [HTTPRequestManager getURL:[NSString stringWithFormat:_currentAPI,userid,(long)_page,type,_sortKeyword,selectStartTime,selectEndTime] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        

        [_currentArray removeAllObjects];
        for (NSDictionary * modelDict in dict[@"result"])
        {
            DSOrder_ResultModel * model = [DSOrder_ResultModel init:modelDict];
            [_currentArray addObject:model];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.MyTableView reloadData];
        });
        
    }];
    
    
}


-(void)touchReturnListButtons:(UIButton*)button
{
    if (button.center.x - self.view.frame.size.width/2 >= 0 && button.center.x <= _buttonScrollView.contentSize.width - self.view.frame.size.width/2)
    {
        [_buttonScrollView setContentOffset:CGPointMake(button.center.x - self.view.frame.size.width/2, 0) animated:YES];
    }else{
        [_buttonScrollView setContentOffset:CGPointMake(_buttonScrollView.contentSize.width-self.view.frame.size.width, 0) animated:YES];
    }
    _isReturnSelected = YES;
    _currentAPI = GET_BACKLIST_API;
    _sortKeyword = @"";
    [self.DateEndBth setTitle:@"请选择结束日期" forState:UIControlStateNormal];
    [self.DateBth setTitle:@"请选择结束日期" forState:UIControlStateNormal];
    selectEndTime = selectStartTime = @"";

    for (int i = 0; i<self.ButtonArray.count; i++) {
        UIButton * SelectButton  = [self.ButtonArray objectAtIndex:i];
        [SelectButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
    }
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    switch (button.tag) {
        case 0:
            //交易中
            type = @"1";
            break;
        case 1:
            //未发货
            type = @"0";
            break;
        case 2:
            //已完成
            type = @"2";
            break;
        case 3:
            //退货中
            type = @"3";
            break;
        case 4:
            //已关闭
            type = @"4";
            break;
            
        case 5:
            type = @"5";
            break;
        case 6:
            type = @"4";
            break;
        case 7 :
            type = @"5";
            break;
        case 8:
            type = @"6";
            break;
        case 9:
            type = @"7";
            break;
        default:
            type = @"8";
            break;
    }
    
    
    _page=1;
    
    
    [HTTPRequestManager getURL:[NSString stringWithFormat:_currentAPI,userid,(long)_page,type,_sortKeyword,selectStartTime,selectEndTime] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        
        [_currentArray removeAllObjects];
        for (NSDictionary * modelDict in dict[@"result"])
        {
            DSReturn_ResultModel * model = [DSReturn_ResultModel init:modelDict];
            [_currentArray addObject:model];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.MyTableView reloadData];
        });
        
    }];
    
}








-(void)SetStartTimteStr:(NSString *)startTimeStr
{
    
    selectStartTime = startTimeStr;
    
    [self.DateBth setTitle:[NSString stringWithFormat:@"%@",startTimeStr] forState:UIControlStateNormal];
}
- (void)TouchData:(UIButton *)sender {
    
    NSLog(@"TouchData");
    
    StartTimeViewController *vc = [[StartTimeViewController alloc]init];
    
    vc.delegate =self;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)TouchEndData:(id)sender
{
    
    
    if (selectStartTime.length ==0) {
        [self showAlertViewForTitle:@"请选择开始日期" AndMessage:nil];
    }else{
        
        EndTimeViewController * vc = [[EndTimeViewController alloc]init];
        vc.StartTimeStr = selectStartTime;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
}
-(void)SetEndTimeStr:(NSString *)endTimeStr
{
    [self.DateEndBth setTitle:[NSString stringWithFormat:@"%@",endTimeStr] forState:UIControlStateNormal];
    
    selectEndTime = endTimeStr;
    
    

    [self headerRefresh];
    
    
    NSLog(@"selectEndTime:%@",selectEndTime);

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDateButton];
    [self initSelectButton];

    _currentArray = [[NSMutableArray alloc]init];

    
    [self.searchTextField addTarget:self action:@selector(searchOrderWithKeywords) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.MyTableView.delegate = self;
    self.MyTableView.dataSource = self;
    [self.MyTableView registerNib:[UINib nibWithNibName:@"RushOrdersInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderCell"];
    [self.MyTableView registerNib:[UINib nibWithNibName:@"ReturnOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"return"];
    [self.MyTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.MyTableView addFooterWithTarget:self action:@selector(footerRefresh)];
    
    
    //初始化，一开始的type就是1,并且让currentArray指向第一个array
    type = @"1";
    _page=1;
    _sortKeyword = @"";
    selectStartTime = selectEndTime = @"";
    
    _currentAPI = GET_ORDER_API;
    userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    [HTTPRequestManager getURL:[NSString stringWithFormat:_currentAPI,userid,(long)_page,type,_sortKeyword,selectStartTime,selectEndTime] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        
        for (NSDictionary * modelDict in dict[@"result"])
        {
            DSOrder_ResultModel * model = [DSOrder_ResultModel init:modelDict];
            [_currentArray addObject:model];
            
        }
        

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.MyTableView reloadData];
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
    
    return _currentArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    

    if (_isReturnSelected == NO)
    {
        DSOrder_ResultModel * model = _currentArray[indexPath.row];
        RushOrdersInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell updateCelllWithModel:model andType:type];
        cell.delegate=self;
        return cell;

    
    }else{
        DSReturn_ResultModel * model = _currentArray[indexPath.row];

        ReturnOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ReturnCellIdentifier];
        [cell updateCellWithModel:model];
        return cell;
        
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}








#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[RushOrdersInfoTableViewCell class]])
    {
        
        OrderInfoViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderInfoViewController"];
        DSOrder_ResultModel * model = _currentArray[indexPath.row];
        vc.orderModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        ReturnInfoViewController * vc= [self.storyboard instantiateViewControllerWithIdentifier:@"ReturnInfoViewController"];
        DSReturn_ResultModel * model = _currentArray[indexPath.row];
        
        vc.returnModel = model;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark ---------MJRefresh-------
-(void)headerRefresh
{
    _page=1;
    
    
    

    [HTTPRequestManager getURL:[NSString stringWithFormat:_currentAPI,userid,(long)_page,type,_sortKeyword,selectStartTime,selectEndTime] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        [_currentArray removeAllObjects];
        if ([_currentAPI isEqualToString:GET_ORDER_API])
        {
            
            for (NSDictionary * modelDict in dict[@"result"])
            {
                DSOrder_ResultModel * model = [DSOrder_ResultModel init:modelDict];
                [_currentArray addObject:model];
                
            }
        }else{
            
            
            for (NSDictionary * modelDict in dict[@"result"])
            {
                DSReturn_ResultModel * model = [DSReturn_ResultModel init:modelDict];
                [_currentArray addObject:model];
                
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.MyTableView reloadData];
        });
    }];
    
    [self.MyTableView headerEndRefreshing];
}




-(void)footerRefresh
{
    _page++;
    [HTTPRequestManager getURL:[NSString stringWithFormat:_currentAPI,userid,(long)_page,type,_sortKeyword,selectStartTime,selectEndTime] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        
        if ([_currentAPI isEqualToString:GET_ORDER_API])
        {
        
            for (NSDictionary * modelDict in dict[@"result"])
            {
                DSOrder_ResultModel * model = [DSOrder_ResultModel init:modelDict];
                [_currentArray addObject:model];
            
            }
        }else{
            
            
            for (NSDictionary * modelDict in dict[@"result"])
            {
                DSReturn_ResultModel * model = [DSReturn_ResultModel init:modelDict];
                [_currentArray addObject:model];
                
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.MyTableView reloadData];
        });
        
    }];
    
    

    [self.MyTableView footerEndRefreshing];



}


#pragma mark ShowAlertView
-(void)showAlertViewForTitle:(NSString*)title AndMessage:(NSString*)message
{
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [av show];
}


#pragma mark -----OrderTableViewDelegate------


-(void)sendMyGoodWithOrderID:(NSInteger )orderid
{
    
    
    SendExpressViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SendExpressViewController"];
    vc.orderid = orderid;
    [self.navigationController pushViewController: vc animated:YES];
    
    
}

#pragma mark ------------收到通知中心回调刷新tableview-----------


-(void)didReceiveReloadTableViewDataOrder
{
    
    [self headerRefresh];
    
    
}



#pragma mark -------搜索商品--------

-(void)searchOrderWithKeywords
{
 
    _sortKeyword = [self.searchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self headerRefresh];
    
    
    
    
}


-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    
    _sortKeyword = @"";
    [self headerRefresh];
    return YES;
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
