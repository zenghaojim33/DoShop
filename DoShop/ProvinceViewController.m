//
//  ProvinceViewController.m
//  DoShop
//
//  Created by Anson on 15/3/10.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "ProvinceViewController.h"
#import "ProvinceCollectionViewCell.h"
#import "NSString+MyContainsString.h"
#import "UIScrollView+ScrollViewTouches.h"
#import "RegExpValidateFormat.h"
@interface ProvinceViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *provinceCollectionView;
@property (weak, nonatomic) IBOutlet UITextField *postageName;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForCollectionView;

@end
static NSString * cellIdentifier = @"Province";
@implementation ProvinceViewController{
    
    
    NSArray * _provinceArray;
    NSArray * _chosenArray;  //用于保存已经选中的cell
    NSMutableArray * _invalidatedArray; //用于保存无法选中的cellas
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.price.text = [self.expressPrice substringFromIndex:1];  //预设邮费
    self.postageName.text = self.expressName;
    [self.price addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventAllEditingEvents];
    
    if (self.changeInfo)
    {
        [self setPreChosenCells];
    }
    [self invalidateCells];
    self.provinceCollectionView.allowsMultipleSelection=YES;
    NSString * path = [[NSBundle mainBundle]pathForResource:@"ProvinceList" ofType:@"plist"];
    _provinceArray = [[NSArray alloc]initWithContentsOfFile:path];
    
    self.heightForCollectionView.constant = [self preferredContentSize].height;
    

}

#pragma mark ------------预选当前已经选中的cell------------
-(void)setPreChosenCells
{
    
    if ([self.province myContainsString:@","])
    {
        _chosenArray = [self.province componentsSeparatedByString:@","];
    }else{
        _chosenArray = @[self.province];
        
    }
    

    
}

#pragma mark ----------无效化其他选中的cell----------
-(void)invalidateCells
{
    NSLog(@"%@",self.chosenProvince);
    _invalidatedArray =  [self.chosenProvince componentsSeparatedByString:@","].mutableCopy;
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _provinceArray.count;
    
    
}



-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProvinceCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    

    cell.provinceLabel.text = _provinceArray[indexPath.row];
    NSString * indexPathString = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    
    if (self.changeInfo)
    {
        BOOL foundChosen = CFArrayContainsValue ( (__bridge CFArrayRef)_chosenArray,
                                                 CFRangeMake(0, _chosenArray.count),
                                                 (CFStringRef)indexPathString ) ;

        if (foundChosen)
        {
            
            //indexpath存在于数组里就要将它选中
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.provinceCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];

                
            });
        }

    }
    BOOL foundInvalidated = CFArrayContainsValue ( (__bridge CFArrayRef)_invalidatedArray,
                                                  CFRangeMake(0, _invalidatedArray.count),
                                                  (CFStringRef)indexPathString ) ;
    
    if (foundInvalidated)
    {
        [cell setCollectionViewCellUserInteractionUnable];
    }
    return cell;
    
    
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -------确认修改-------
- (IBAction)confirm:(id)sender {

        if (self.price.text.length==0 || self.postageName.text == 0)
        {
            UIAlertView * alert = [[UIAlertView alloc]init];
            alert.message = @"请输入完整的邮费和邮费设定名";
            [alert addButtonWithTitle:@"确定"];
            [alert show];
            
            
            
            return;
        }
    
        
    
        
        NSArray * selectedIndexPath = [self.provinceCollectionView indexPathsForSelectedItems];
    
        if (selectedIndexPath.count==0)
        {
            UIAlertView * alert = [[UIAlertView alloc]init];
            alert.message = @"请至少选择一个地区";
            [alert addButtonWithTitle:@"确定"];
            [alert show];
            return;
        }
    
    
        NSMutableString * selectedProvinces = [[NSMutableString alloc]init];

        
        for (NSIndexPath * indexPath in selectedIndexPath)
        {
            
            NSString * provinceid = [NSString stringWithFormat:@"%ld",indexPath.row+1];
            
            if (selectedProvinces.length != 0)
            {
                [selectedProvinces appendString:[NSString stringWithFormat:@",%@",provinceid]];
            }else{
                [selectedProvinces appendString:[NSString stringWithFormat:@"%@",provinceid]];
            }
            
        }
        
        
        if (self.changeInfo)
        {
        
            NSDictionary * postDict = @{@"province":selectedProvinces,
                                        @"postagename":self.postageName.text,
                                    @"provinceid":self.provinceid,
                                    @"price":self.price.text
                                    };
            [HTTPRequestManager postURL:UPDATE_PROVINCE_API andParameter:postDict onCompletion:^(NSDictionary *dict, NSError *error) {
            
                [self.navigationController popViewControllerAnimated:YES];
                [self.delegate reloadPostageTableView];
            
            }];
        }else{
            
            NSDictionary * postDict =@{@"province":selectedProvinces,
                                       @"postagename":self.postageName.text,
                                       @"postageid":self.postageid,
                                       @"price":self.price.text
                                       };
            
            [HTTPRequestManager postURL:ADD_PROVINCE_API andParameter:postDict onCompletion:^(NSDictionary *dict, NSError *error) {
                
                [self. navigationController popViewControllerAnimated:YES];
                [self.delegate reloadPostageTableView];

                
            }];
            
        }
    
        
    
    
    
    
    
}



-(void)textFieldDidChange:(UITextField *)textField{
    [RegExpValidateFormat formatToPriceStringWithTextField:textField];

}



- (CGSize)preferredContentSize
{
    // Force the table view to calculate its height
    [self.provinceCollectionView layoutIfNeeded];
    return self.provinceCollectionView.contentSize;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    
    [self.view endEditing:YES];
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
