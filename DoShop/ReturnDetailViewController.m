//
//  ReturnDetailViewController.m
//  DoShop
//
//  Created by Anson on 15/3/26.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "ReturnDetailViewController.h"
#import "ImgScrollView.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "TapImageView.h"
@interface ReturnDetailViewController ()<TapImageViewDelegate,UIScrollViewDelegate,ImgScrollViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *returnReason;
@property (weak, nonatomic) IBOutlet TapImageView *returnDetailImage;
@property (weak, nonatomic) IBOutlet UITextView *returnDetailTextView;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIButton *rejectButton;

@end


typedef NS_ENUM(NSInteger, ReturnReason){
    
    PersonalReason = 1,
    QualityReason = 2
    
};

@implementation ReturnDetailViewController{
    
    UIView *markView;
    UIView *scrollPanel;
    UIScrollView *myScrollView;

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.returnDetailTextView.text = self.reason;
//    [self.returnDetailImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,self.thimgUrl]] placeholderImage:nil ];
    [self.returnDetailImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,self.thimgUrl]] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    self.returnDetailImage.t_delegate = self;
    
    if (self.backType == PersonalReason)
    {
        self.returnReason.text = @"个人原因";
        
    }else{
        
        self.returnReason.text = @"质量原因";
        
    }
    
    
    if (self.backid != 4)
    {
        self.agreeButton.hidden = YES;
        self.rejectButton.hidden = YES;
    }
    
    
    scrollPanel = [[UIView alloc] initWithFrame:self.navigationController.view.bounds];
    scrollPanel.backgroundColor = [UIColor clearColor];
    scrollPanel.alpha = 0;
    [self.navigationController.view addSubview:scrollPanel];
    
    markView = [[UIView alloc] initWithFrame:scrollPanel.bounds];
    markView.backgroundColor = [UIColor blackColor];
    markView.alpha = 0.0;
    [scrollPanel addSubview:markView];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:self.navigationController.view.bounds];
    [scrollPanel addSubview:myScrollView];
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    CGSize contentSize = myScrollView.contentSize;
    contentSize.height = self.view.bounds.size.height;
    contentSize.width = self.view.bounds.size.width;
    myScrollView.contentSize = contentSize;
    

    
    
    
    
}
- (IBAction)agree:(id)sender {
    
    
    NSDictionary * postDict = @{@"detailId":@(self.detailId),
                                @"statu":@5};
    
    [HTTPRequestManager postURL:RETURN_CONFIRM_API andParameter:postDict onCompletion:^(NSDictionary *dict, NSError *error) {
        
        if ([dict[@"ret"] isEqualToNumber:@1])
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"TableViewReloadNotification" object:self];
            UIAlertView * view = [[UIAlertView alloc]init];
            view.message = @"已接受退货";
            [view addButtonWithTitle:@"确定"];
            [view show];

        }
        
    }];
    
    
    
}


- (IBAction)refuse:(id)sender {
    
    
    
    
    NSDictionary * postDict = @{@"detailId":@(self.detailId),
                                @"statu":@6};
    
    [HTTPRequestManager postURL:RETURN_CONFIRM_API andParameter:postDict onCompletion:^(NSDictionary *dict, NSError *error) {
        
        if ([dict[@"ret"] isEqualToNumber:@1])
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"TableViewReloadNotification" object:self];
            [SVProgressHUD showSuccessWithStatus:@"已拒绝退货"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"TableViewReloadNotification" object:nil];
            UIAlertView * view = [[UIAlertView alloc]init];
            view.message = @"已拒绝退货";
            [view addButtonWithTitle:@"确定"];
            [view show];


        }
        
    }];
    

    
}


-(void)tappedWithObject:(id)sender
{

    [self.view bringSubviewToFront:scrollPanel];
    scrollPanel.alpha = 1.0;
    
    TapImageView *tmpView = sender;
    
    
    //转换后的rect
    CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.navigationController.view];
    
    CGPoint contentOffset = myScrollView.contentOffset;
    contentOffset.x = 0;
    myScrollView.contentOffset = contentOffset;
    
    //添加
    [self addSubImgView];
    
    ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){contentOffset,myScrollView.bounds.size}];
    [tmpImgScrollView setContentWithFrame:convertRect];
    [tmpImgScrollView setImage:tmpView.image];
    [myScrollView addSubview:tmpImgScrollView];
    tmpImgScrollView.i_delegate = self;
    
    [self performSelector:@selector(setOriginFrame:) withObject:tmpImgScrollView afterDelay:0.1];
    

    
}


- (void)setOriginFrame:(ImgScrollView *) sender
{
    [UIView animateWithDuration:0.4 animations:^{
        [sender setAnimationRect];
        markView.alpha = 1.0;
        self.navigationController.navigationBar.hidden=YES;
    }];
}


-(void)addSubImgView
{
    for (UIView *tmpView in myScrollView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    CGRect convertRect = [[self.returnDetailImage superview] convertRect:self.returnDetailImage.frame toView:self.navigationController.view];
    
    ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){myScrollView.bounds.size.width,0,myScrollView.bounds.size}];
    [tmpImgScrollView setContentWithFrame:convertRect];
    [tmpImgScrollView setImage:self.returnDetailImage.image];
    [myScrollView addSubview:tmpImgScrollView];
    tmpImgScrollView.i_delegate = self;
    
    [tmpImgScrollView setAnimationRect];
}

- (void)tapImageViewTappedWithObject:(id)sender
{
    
    ImgScrollView *tmpImgView = sender;
    
    [UIView animateWithDuration:0.5 animations:^{
        markView.alpha = 0;
        self.navigationController.navigationBar.hidden=NO;
        [tmpImgView rechangeInitRdct];
    } completion:^(BOOL finished) {
        scrollPanel.alpha = 0;
    }];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Disable iOS 7 back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Enable iOS 7 back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
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
