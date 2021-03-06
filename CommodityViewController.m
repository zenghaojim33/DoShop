//
//  CommodityViewController.m
//  Dome
//
//  Created by BTW on 14/12/23.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "CommodityViewController.h"
#import "CommodityTableViewCell.h"
#import "CustomTitleLabelTableView.h"

#import "FSLineChart.h"
#import "UIColor+FSPalette.h"
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
@interface CommodityViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (weak, nonatomic) IBOutlet UIButton *Button1;
@property (weak, nonatomic) IBOutlet UIButton *Button2;
@property (weak, nonatomic) IBOutlet UIButton *Button3;
@property (weak, nonatomic) IBOutlet CustomTitleLabelTableView  *MyTableView;
@property (weak, nonatomic) IBOutlet UIView *LineView;
@property (strong,nonatomic)FSLineChart* lineChart;
@property(nonatomic,strong) NSMutableArray * currentArray;




@end

@implementation CommodityViewController
{
    NSInteger index;
    NSMutableArray * _everydayOrderArray;
    NSMutableArray * _everydaySalesArray;
    NSMutableArray * _everydayVisitorArray;
    NSString * _userid;
    NSInteger _page;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"销售管理";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
    
}
- (IBAction)TouchButton:(UIButton *)sender
{

    [self.Button1 setBackgroundColor:[UIColor whiteColor]];
    [self.Button1 setTitleColor:[UIColor scrollViewTexturedBackgroundColor] forState:UIControlStateNormal];
    
    [self.Button2 setBackgroundColor:[UIColor whiteColor]];
    [self.Button2 setTitleColor:[UIColor scrollViewTexturedBackgroundColor] forState:UIControlStateNormal];
    
    [self.Button3 setBackgroundColor:[UIColor whiteColor]];
    [self.Button3 setTitleColor:[UIColor scrollViewTexturedBackgroundColor] forState:UIControlStateNormal];
    
    [sender setBackgroundColor:[UIColor colorWithRed:227/255.0 green:116/255.0 blue:110/255.0 alpha:1]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    index =  sender.tag;

    
    
    [self changeTableViewData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    index = 1;
    _page = 1;
    _userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    _everydayOrderArray = [[NSMutableArray alloc]init];
    _everydaySalesArray = [[NSMutableArray alloc]init];
    _everydayVisitorArray = [[NSMutableArray alloc]init];
    [self.MyTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.MyTableView addFooterWithTarget:self action:@selector(footerRefresh)];

    
    [HTTPRequestManager getURL:[NSString stringWithFormat:GET_EVERYDAY_ORDER_NUM_API,_userid,_page] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        
        
        _everydayOrderArray = [dict[@"result"] mutableCopy];
        _currentArray = _everydayOrderArray;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_MyTableView reloadData];
            [self lineChartReloadData];
        });
        
        
        
    }];
    
    
    
    self.MyTableView.delegate = self;
    self.MyTableView.dataSource = self;
    [self.MyTableView registerNib:[UINib nibWithNibName:@"CommodityTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];

    

    

  

}



#pragma mark -------图标刷新数据
-(void)lineChartReloadData
{
    [self.lineChart removeFromSuperview];
    self.lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-32, self.LineView.frame.size.height)];

    self.lineChart.gridStep = 5;
    //因为日期是倒序的，所以将日期数组全部翻转

    NSMutableArray * originArray = self.currentArray;
    NSArray * reverseArray = [[originArray reverseObjectEnumerator]allObjects];
    self.lineChart.labelForIndex = ^(NSUInteger item){
        NSString * dateString = [reverseArray[item][@"date"] substringFromIndex:4];  //去掉年份
        return dateString;
    };
    
    self.lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%.1f",value];
    };
    
    NSMutableArray * chartDataArray = [[NSMutableArray alloc]init];
    for(NSInteger i = self.currentArray.count-1;i>=0;i--)
    {
        [chartDataArray addObject:_currentArray[i][@"sum"] ];
    }
    
    
    [self.lineChart setChartData:chartDataArray];
    [self.LineView addSubview:self.lineChart];

}

-(void)changeTableViewData
{
    _page = 1;
    
    if (index==1)
    {
        [HTTPRequestManager getURL:[NSString stringWithFormat:GET_EVERYDAY_ORDER_NUM_API,_userid,_page] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
            
            
            _everydayOrderArray = [dict[@"result"] mutableCopy];
            _currentArray = _everydayOrderArray;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_MyTableView reloadData];
                [self lineChartReloadData];
            });
            
            
            
        }];
    }else if (index==2)
    {
        
        
        [HTTPRequestManager getURL:[NSString stringWithFormat:GET_EVERYDAY_SALES_NUM_API,_userid,_page] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
            
            
            _everydayOrderArray = [dict[@"result"] mutableCopy];
            _currentArray = _everydayOrderArray;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_MyTableView reloadData];
                [self lineChartReloadData];
            });
            
            
            
        }];
    }else if (index==3)
    {
        
        
        [HTTPRequestManager getURL:[NSString stringWithFormat:GET_EVERYDAY_VISITOR_NUM_API,_userid,_page] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
            
            
            _everydayOrderArray = [dict[@"result"] mutableCopy];
            _currentArray = _everydayOrderArray;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_MyTableView reloadData];
                [self lineChartReloadData];
            });
            
            
            
        }];
        
        
    }
    
    
    
    
    
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
    
    
    
    static NSString *CellIdentifier = @"Cell" ;
    
    
    CommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary * infoDict = _currentArray[indexPath.row];
    cell.date.text = infoDict[@"date"];
    NSString * sum = ((NSNumber*)infoDict[@"sum"]).stringValue;
    cell.number.text = sum;
    if (index==1)
    {
        cell.unit.text = @"单";
    }else if (index==2)
    {
        cell.unit.text = @"元";
    }else{
        cell.unit.text = @"人";
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;

    
    return cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}



#pragma mark -----------MJRefresh------


-(void)headerRefresh
{
    _page = 1;
    NSString * API;
    switch (index) {
        case 1:
            API = GET_EVERYDAY_ORDER_NUM_API;
            break;
        case 2:
            API = GET_EVERYDAY_SALES_NUM_API;
        case 3:
            API = GET_EVERYDAY_VISITOR_NUM_API;
        default:
            break;
    }
    
    [HTTPRequestManager getURL:[NSString stringWithFormat:API,_userid,_page] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
       
        [_currentArray removeAllObjects];
        [_currentArray addObjectsFromArray:dict[@"result"]];
  
        dispatch_async(dispatch_get_main_queue(), ^{
            [_MyTableView reloadData];
            [self lineChartReloadData];
            [self.MyTableView headerEndRefreshing];
        });
    }];
    
    
    
}



-(void)footerRefresh
{
    
    _page ++;
    NSString * API;
    switch (index) {
        case 1:
            API = GET_EVERYDAY_ORDER_NUM_API;
            break;
        case 2:
            API = GET_EVERYDAY_SALES_NUM_API;
        case 3:
            API = GET_EVERYDAY_VISITOR_NUM_API;
        default:
            break;
    }
    
    [HTTPRequestManager getURL:[NSString stringWithFormat:API,_userid,_page] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        
        [_currentArray addObjectsFromArray:dict[@"result"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_MyTableView reloadData];
            [self lineChartReloadData];
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
