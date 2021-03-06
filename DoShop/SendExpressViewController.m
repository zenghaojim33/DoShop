//
//  SendExpressViewController.m
//  DoShop
//
//  Created by Anson on 15/2/15.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "SendExpressViewController.h"
#import "ExpressSelectViewController.h"
#import "UIAlertView+Blocks.h"
@interface SendExpressViewController ()
@property (weak, nonatomic) IBOutlet UILabel *expressSelection;
@property (weak, nonatomic) IBOutlet UITextField *expressNumber;


@end

@implementation SendExpressViewController{
    

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
}


#pragma mark ------确认发货-------

- (IBAction)confirm:(id)sender {
    
    
    NSDictionary * postDict = @{@"orderid":@(self.orderid),
                                @"courier":self.expressSelection.text,
                                @"courierCode":self.expressNumber.text
                                };
    
    [HTTPRequestManager postURL:SEND_ORDER_API andParameter:postDict onCompletion:^(NSDictionary *dict, NSError *error) {
       
        
        if ([dict[@"ret"] isEqualToNumber:@1])
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"TableViewReloadNotification" object:self];
            [UIAlertView showWithTitle:@"已经成功发货"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    
}

-(IBAction)unwindSegue:(UIStoryboardSegue *)segue
{
    
    ExpressSelectViewController * vc = segue.sourceViewController;
    self.expressSelection.text = vc.expressName;
    
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
