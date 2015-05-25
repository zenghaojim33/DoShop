//
//  StartTimeViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-31.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "StartTimeViewController.h"
#import "EndTimeViewController.h"
#import "CalendarView.h"
@interface StartTimeViewController ()
<
    CalendarDelegate,
    EndTimeDelegate
>
@property (strong, nonatomic) CalendarView * sampleView;
@end

@implementation StartTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"请选择开始日期";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(1, 1);
    view.layer.shadowOpacity = 0.2;
    [self.view addSubview:view];
    UIImageView * imgeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,  view.frame.size.width, view.frame.size.height)];
    imgeView.image = [UIImage imageNamed:@"BGView.jpg"];
    [view addSubview:imgeView];

    
    _sampleView= [[CalendarView alloc]initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-80)];
    _sampleView.delegate = self;
    [_sampleView setBackgroundColor:[UIColor whiteColor]];
    _sampleView.calendarDate = [NSDate date];
    [self.view addSubview:_sampleView];
    
    self.navigationItem.backBarButtonItem = backItem;
    self.view.backgroundColor =[UIColor whiteColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tappedOnDate:(NSDate *)selectedDate
{
    
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString* dateString = [fmt stringFromDate:selectedDate];
    NSLog(@"selectedDate:%@", dateString);
    
    [self.delegate SetStartTimteStr:dateString];
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
