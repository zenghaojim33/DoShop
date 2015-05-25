//
//  MessageViewController.m
//  Dome
//
//  Created by BTW on 14/12/22.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "MessageInfoViewController.h"
#import "DSMessage_MessageModel.h"
@interface MessageViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *MyTableView;

@end
static NSString *CellIdentifier = @"Cell" ;

@implementation MessageViewController
{
    
    DSMessage_MessageModel * _messageModel;
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"消息";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.MyTableView.delegate = self;
    self.MyTableView.dataSource = self;
    [self.MyTableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
//    [self.MyTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
//    [self.MyTableView addHeaderWithTarget:self action:@selector(footerRefresh)];

    
    
    [HTTPRequestManager getURL:GET_MESSAGE_API andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        
        _messageModel = [DSMessage_MessageModel init:dict];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.MyTableView reloadData];
        });
    }];
    
    
}
#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messageModel.result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    DSMessage_ResultModel * model = _messageModel.result[indexPath.row];
    [cell updateCellWithModel:model];
    

    return cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static dispatch_once_t onceToken;
    static  MessageTableViewCell * cell;
    dispatch_once(&onceToken, ^{
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    });
    DSMessage_ResultModel * model = _messageModel.result[indexPath.row];

    [cell updateCellWithModel:model];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1.0f;
    
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageInfoViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageInfoViewController"];
    DSMessage_ResultModel * model = _messageModel.result[indexPath.row];;
    vc.messageId = model.modelId;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-(void)headerRefresh
//{
//    [HTTPRequestManager getURL:GET_MESSAGE_API andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
//        
//        _messageModel = [DSMessage_MessageModel init:dict];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.MyTableView reloadData];
//        });
//    }];
//}
//
//
//
//
//-(void)footerRefresh{
//    
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
