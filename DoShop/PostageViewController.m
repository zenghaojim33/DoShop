//
//  PostageViewController.m
//  DoShop
//
//  Created by Anson on 15/3/10.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "PostageViewController.h"
#import "PostageTableViewCell.h"
#import "ProvinceViewController.h"
#import "ProvinceViewController.h"
#import "RegExpValidateFormat.h"
#import "DSPostage_PostageModel.h"
@interface PostageViewController ()<UITableViewDataSource,UITableViewDelegate,PostageDelegate,UIAlertViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *postageTableView;
@property (weak, nonatomic) IBOutlet UITextField *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *allInclusionBtn;
@property (weak, nonatomic) IBOutlet UIButton *limitedinclusionBtn;
@property (weak, nonatomic) IBOutlet UIButton *noInclusionBtn;
@property(nonatomic)NSInteger expressionType;

@property(nonatomic)NSNumber * postageid;  //每个用户对应一个postageid
@property(nonatomic,strong)PostageTableViewCell * deleteCell;
@end

#define PostageCacheKey @"postage"
static NSString * cellIdentifier = @"Postage";
@implementation PostageViewController
{
    NSArray * _provinceNameArray;
    DSPostage_PostageModel * _postageModel;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //获得编号对应的省份


    [self.priceLabel addTarget:self action:@selector(TextfieldDidChange:) forControlEvents:UIControlEventAllEditingEvents];
    
    [self reloadPostageTableView];

    
}





#pragma mark -------UITableViewDelegate------


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PostageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    DSPostage_ProvincesModel * provinceModel = _postageModel.result.provinces[indexPath.row];
    [cell updateCellWithModel:provinceModel];
    cell.tag = 500+indexPath.row;
    
    return cell;
    
   
    
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    

    return _postageModel.result.provinces.count;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static PostageTableViewCell * cell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
    });
    DSPostage_ProvincesModel * provinceModel = _postageModel.result.provinces[indexPath.row];
    [cell updateCellWithModel:provinceModel];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    return height+1.0f;
    
    
}


#pragma mark ------------UI

- (IBAction)selectExpressType:(id)sender {
    
    
    UIButton * btn = sender;
    if (btn.tag==999)
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"checked_button"] forState:UIControlStateNormal];
        [self.limitedinclusionBtn setBackgroundImage:[UIImage imageNamed:@"uncheck_button"] forState:UIControlStateNormal];
        [self.noInclusionBtn setBackgroundImage:[UIImage imageNamed:@"uncheck_button"] forState:UIControlStateNormal];

        self.expressionType = 1;
        
    }else if (btn.tag==1000)
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"checked_button"] forState:UIControlStateNormal];
        [self.allInclusionBtn setBackgroundImage:[UIImage imageNamed:@"uncheck_button"] forState:UIControlStateNormal];
        [self.noInclusionBtn setBackgroundImage:[UIImage imageNamed:@"uncheck_button"] forState:UIControlStateNormal];

        self.expressionType = 2;
    }else if (btn.tag==1001)
    {
        
        [btn setBackgroundImage:[UIImage imageNamed:@"checked_button"] forState:UIControlStateNormal];
        [self.allInclusionBtn setBackgroundImage:[UIImage imageNamed:@"uncheck_button"] forState:UIControlStateNormal];
        [self.limitedinclusionBtn setBackgroundImage:[UIImage imageNamed:@"uncheck_button"] forState:UIControlStateNormal];
        
        self.expressionType = 3;
        
    }
    
    
}


-(void)initiateExpressType
{
    
    if (self.expressionType ==1)
    {
        [self.allInclusionBtn setBackgroundImage:[UIImage imageNamed:@"checked_button"] forState:UIControlStateNormal];
        [self.limitedinclusionBtn setBackgroundImage:[UIImage imageNamed:@"uncheck_button"] forState:UIControlStateNormal];
        [self.noInclusionBtn setBackgroundImage:[UIImage imageNamed:@"uncheck_button"] forState:UIControlStateNormal];
        
        self.expressionType = 1;
        
    }else if (self.expressionType==2)
    {
        [self.self.limitedinclusionBtn setBackgroundImage:[UIImage imageNamed:@"checked_button"] forState:UIControlStateNormal];
        [self.allInclusionBtn setBackgroundImage:[UIImage imageNamed:@"uncheck_button"] forState:UIControlStateNormal];
        [self.noInclusionBtn setBackgroundImage:[UIImage imageNamed:@"uncheck_button"] forState:UIControlStateNormal];
        
        self.expressionType = 2;
    }else if (self.expressionType ==3)
    {
        
        [self.noInclusionBtn setBackgroundImage:[UIImage imageNamed:@"checked_button"] forState:UIControlStateNormal];
        [self.allInclusionBtn setBackgroundImage:[UIImage imageNamed:@"uncheck_button"] forState:UIControlStateNormal];
        [self.limitedinclusionBtn setBackgroundImage:[UIImage imageNamed:@"uncheck_button"] forState:UIControlStateNormal];
        self.expressionType = 3;

        
        
    }
}


#pragma mark -------改变邮费设定------
- (IBAction)changeExpressionSetting:(id)sender {
    
    PostageTableViewCell * cell;
    if ([UIDevice currentDevice].systemVersion.floatValue<8.0){
        cell = (PostageTableViewCell*)[sender superview].superview.superview;
    }else{
        cell = (PostageTableViewCell*)[sender superview].superview;
    }
        
    NSIndexPath * indexPathOfCell = [self.postageTableView indexPathForCell:cell];
    DSPostage_ProvincesModel * provinceModel = _postageModel.result.provinces[indexPathOfCell.row];
    
    
    NSMutableString * chosenProvince = [[NSMutableString alloc]init];
    
    [_postageModel.result.provinces enumerateObjectsUsingBlock:^(DSPostage_ProvincesModel * model, NSUInteger idx, BOOL *stop) {
        if (idx != cell.tag-500)
        {
            [chosenProvince appendString:[NSString stringWithFormat:@",%@",model.province]];
        }
    }];
    
    
    
    ProvinceViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Province"];
    vc.province = cell.province;
    vc.provinceid = cell.provinceid;
    vc.changeInfo = YES;
    vc.chosenProvince = chosenProvince;
    vc.postageid = self.postageid;
    vc.expressPrice = cell.price.text;
    vc.expressName= provinceModel.postagename;
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
}




#pragma mark -----增加邮费设定------
- (IBAction)addExpressType:(id)sender {
    
    NSMutableString * chosenProvince = [[NSMutableString alloc]init];

    [_postageModel.result.provinces enumerateObjectsUsingBlock:^(DSPostage_ProvincesModel * model, NSUInteger idx, BOOL *stop) {

            [chosenProvince appendString:[NSString stringWithFormat:@",%@",model.province]];
    }];
    ProvinceViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Province"];
    vc.postageid = self.postageid;
    vc.chosenProvince = chosenProvince;
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
    

    
}


#pragma mark --------删除邮费设定--------


- (IBAction)deleteExpressType:(id)sender {
    
    
    UIAlertView * alertview = [[UIAlertView alloc]initWithTitle:@"确认" message:@"确认删除此邮费设定" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertview show];
    
    

    if ([UIDevice currentDevice].systemVersion.floatValue<8.0){
         self.deleteCell = (PostageTableViewCell*)[sender superview].superview.superview;
    }else{
        self.deleteCell = (PostageTableViewCell*)[sender superview].superview;
    }
    
    
    
    
    
    
}






#pragma mark ------确认--------
- (IBAction)confirm:(id)sender {

    if (self.priceLabel.text.length==0)
    {
        UIAlertView * alertview = [[UIAlertView alloc]init];
        alertview.message = @"请输入包邮金额";
        [alertview addButtonWithTitle:@"确认"];
        [alertview show];
        return;
        
    }
    
    NSDictionary * postDict = @{@"postageid":self.postageid,
                                @"statu":[NSNumber numberWithInteger:self.expressionType],
                                @"prices":self.priceLabel.text
                            
                                };
    [HTTPRequestManager postURL:UPDATE_POSTAGE_API andParameter:postDict onCompletion:^(NSDictionary *dict, NSError *error) {
       
        [self reloadPostageTableView];
        
    }];
    
    
    
    
    
}


#pragma mark ----------选择完成后回调刷新tableview----------


-(void)reloadPostageTableView
{
    
    self.expressionType = 1;
    

    
    
    NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    [HTTPRequestManager getURL:[NSString stringWithFormat:GET_POSTAGE_API,userid] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        _postageModel = [DSPostage_PostageModel init:dict];
        [DSBaseModel saveObjectToCache:_postageModel andKey:PostageCacheKey];

        NSNumber * expressionType = _postageModel.result.statu;
        NSNumber * prices = _postageModel.result.prices;
        self.postageid = _postageModel.result.postageid;
        self.expressionType = expressionType.integerValue;
        self.priceLabel.text = prices.stringValue;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.postageTableView reloadData];
            [self initiateExpressType];
        });

        
        
        
    }];
    
    
    
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
    
    [self.view endEditing:YES];
}




-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1)
    {
        NSNumber * provinceid = self.deleteCell.provinceid;
        NSDictionary * postDict = @{@"provinceid":provinceid};
        [HTTPRequestManager postURL:DELETE_PROVINCE_API andParameter:postDict onCompletion:^(NSDictionary *dict, NSError *error) {
           
            [self reloadPostageTableView];
        }];
    }
    
    
}


-(void)TextfieldDidChange:(UITextField*)textfield
{
    [RegExpValidateFormat formatToPriceStringWithTextField:textfield];
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
