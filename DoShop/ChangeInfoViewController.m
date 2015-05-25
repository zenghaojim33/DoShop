//
//  ChangeInfoViewController.m
//  DoShop
//
//  Created by Anson on 15/4/21.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "ChangeInfoViewController.h"
#import "DSUserInfoModel.h"
#import "BankViewController.h"
#import "CNCityPickerView.h"
#import "RegExpValidate.h"
#import "UIAlertView+Blocks.h"
@interface ChangeInfoViewController()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,BankDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *myAvatar;
@property (weak, nonatomic) IBOutlet UITextField *myNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *myPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *myAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *myEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *myAccountNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *myBankTextField;
@property (weak, nonatomic) IBOutlet UITextField *myBankNumTextField;
@property (weak, nonatomic) IBOutlet UIButton *selectBankBtn;
@property (weak, nonatomic) IBOutlet UITextField *myDetailAddressTextField;


@end

#define UserInfoCacheKey @"userinfo"

@implementation ChangeInfoViewController{
    
    
    DSUserInfoModel * _userInfoModel;
    NSString * _province;
    NSString * _city;
    NSString * _county;
    BOOL _Camera;
    UIImage * selectedImage;
}


-(void)viewDidLoad{


    CNCityPickerView * picker = [[CNCityPickerView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
    [picker setValueChangedCallback:^(NSString *province, NSString *city, NSString *area) {
        
        _province = province;
        _city = city;
        _county = area;
        self.myAddressTextField.text = [NSString stringWithFormat:@"%@ %@ %@",province,city,area];
        
    }];
    self.myAddressTextField.inputView = picker;
    picker.editingTextField = self.myAddressTextField;
    
    
    [self loadUserInfo];
    
    
}


#pragma mark ---load user info


-(void)loadUserInfo
{
    
    
    
    NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    
    
    _userInfoModel = [DSBaseModel cacheObjectByKey:UserInfoCacheKey];
    if (_userInfoModel){
        
        [self updateDataWithModel];

        
        
    }
    
    
    
    
    
    NSDictionary * postDict = @{@"userid":userid};
    [HTTPRequestManager postURL:GET_INFO_API andParameter:postDict onCompletion:^(NSDictionary *dict, NSError *error) {
        
        _userInfoModel = [DSUserInfoModel init:dict[@"result"]];

        [self updateDataWithModel];
        
        
        
        [DSBaseModel saveObjectToCache:_userInfoModel andKey:UserInfoCacheKey];
        
        

    }];
    
}



-(void)updateDataWithModel{
    _province = _userInfoModel.province;
    _county = _userInfoModel.county;
    _city = _userInfoModel.city;
    self.myAddressTextField.text = [NSString stringWithFormat:@"%@ %@ %@",_province,_city,_county];
    self.myDetailAddressTextField.text = _userInfoModel.area;
    self.myEmailTextField.text = _userInfoModel.email;
    self.myAccountNameTextField.text = _userInfoModel.bankUser;
    self.myBankTextField.text = _userInfoModel.bankName;
    self.myBankNumTextField.text = _userInfoModel.bankCode;
    self.myNameTextField.text = _userInfoModel.name;
    self.myPhoneTextField.text = _userInfoModel.phone;
    
    NSString * uimg = _userInfoModel.uimg;
    
    NSString * buttonImageUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,uimg];
    [self.myAvatar sd_setImageWithURL:[NSURL URLWithString:buttonImageUrl] placeholderImage:[UIImage imageNamed:@"测试头像"]];
}


#pragma mark --点击头像

- (IBAction)myAvatarClicked:(id)sender {
    
    
    
    UIActionSheet * actionSheet =
    [[UIActionSheet alloc]initWithTitle:@"选择照片"
                               delegate:nil
                      cancelButtonTitle:@"取消"
                 destructiveButtonTitle:@"拍照"
                      otherButtonTitles:@"选取现有的",nil];
    actionSheet.delegate=self;
    
    
    [actionSheet showInView:self.view];
    
    
}

- (IBAction)selectBank:(id)sender {
    
    BankViewController * bankVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BankViewController"];
    bankVC.delegate =self;
    [self.navigationController pushViewController:bankVC animated:YES];

    
    
}


//-(void)updateUserModel
//{
//    
//    NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
//    
//    NSDictionary * postDict = @{@"userid":userid};
//    [HTTPRequestManager postURL:GET_INFO_API andParameter:postDict onCompletion:^(NSDictionary *dict, NSError *error) {
//        
//        _userInfoModel = [DSUserInfoModel init:dict[@"result"]];
//        
//        
//        [DSBaseModel saveObjectToCache:_userInfoModel andKey:UserInfoCacheKey];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"AvatarUpdateNotification" object:self userInfo:nil];
//        
//        
//    }];
//    
//    
//}


#pragma mark --UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0) {
        
        NSLog(@"您选择了拍照");
        
        UIImagePickerController * ipc = [[UIImagePickerController alloc]init];
        
        [ipc setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        ipc.allowsEditing = YES;
        
        ipc.delegate = self;
        
        [self presentViewController:ipc animated:YES completion:nil];
        
        
        
    }else if (buttonIndex==1){
        
        NSLog(@"您选择了选取现有的");
        
        UIImagePickerController * ipc = [[UIImagePickerController alloc]init];
        
        [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        ipc.allowsEditing = YES;
        
        ipc.delegate = self;
        
        
        
        [self presentViewController:ipc animated:YES completion:nil];
        
    }else{
        
        NSLog(@"您选择了取消");
        
    }
};
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage* original_image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (_Camera ==YES) {
        UIImageWriteToSavedPhotosAlbum(original_image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }
    

    
    [self.myAvatar setImage:original_image];
    
    selectedImage = original_image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"图片保存成功");
}


#pragma mark -- 确定
- (IBAction)confirmBtnClicked:(id)sender {
    if (![RegExpValidate validateBankAccountNumber:self.myBankNumTextField.text])
    {
        [UIAlertView showWithTitle:@"请输入正确的银行卡号"];
        return;
    }else if (![self noEmptyTextField]){
        [UIAlertView showWithTitle:@"请输入完整的个人信息"];
        return ;
    }
    
    
    NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    NSString * phone = [[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
    
    //将图片压缩并转成NSData
    NSData *imageData = UIImageJPEGRepresentation(self.myAvatar.image, 0.5);
    
    NSDictionary * postDict = @{@"userid":userid,
                                @"province":_province,
                                @"county":_county,
                                @"city":_city,
                                @"area":self.myDetailAddressTextField.text,
                                @"email":self.myEmailTextField.text,
                                @"bankUser":self.myAccountNameTextField.text,
                                @"bankName":self.myBankTextField.text,
                                @"bankCode":self.myBankNumTextField.text,
                                @"phone":phone,
                                @"name":self.myNameTextField.text
                                };
    
    [HTTPRequestManager postURLWithData:imageData andURL:CHANGE_INFO_API andParameter:postDict onCompletion:^(NSInteger statusCode, NSError *error) {
        
            [[SDImageCache sharedImageCache]clearDisk];

            [[NSNotificationCenter defaultCenter]postNotificationName:@"AvatarUpdateNotification" object:self.myAvatar.image userInfo:nil];

            [self.navigationController popViewControllerAnimated:YES];
        
    }];
    


    
}


-(BOOL)noEmptyTextField
{
    return self.myDetailAddressTextField.text.length>0 && self.myEmailTextField.text.length>0 && self.myAccountNameTextField.text.length > 0 && self.myBankNumTextField.text.length > 0 && self.myNameTextField.text.length > 0 && self.myBankTextField.text.length > 0;
}



-(void)setBankName:(NSString *)bankName
{
    self.myBankTextField.text = bankName;
}

@end
