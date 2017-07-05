//
//  RRZSetupSignatureViewController.m
//  Rrz
//
//  Created by 易超 on 16/3/18.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZSetupSignatureViewController.h"
#import "RRZUserInfoItem.h"

@interface RRZSetupSignatureViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;


@end

@implementation RRZSetupSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UserModel *model = [[YRUserInfoManager manager] currentUser];
    if ([self.title isEqualToString:@"个人签名"]) {
        self.textView.placeholder = @"请输入个性签名";
        self.textView.text = model.custSignature;
        
    }else{
        self.textView.placeholder = @"请输入个人简介";
        self.textView.text = model.custDesc;
    }
    self.view.backgroundColor = RGB_COLOR(245, 245, 245);
//    self.textView.text = self.item.signature;
    self.textView.delegate = self;
    
//    [self.textView addTarget:self action:@selector(textViewDidChange:) forControlEvents:UIControlEventEditingChanged];
     
    [self setRightNavButtonWithTitle:@"保存"];
}

-(void)rightNavAction:(UIButton *)button{
    [self.view endEditing:YES];
    NSString *textStr = self.textView.text;
    textStr = [textStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSInteger length = [self.title isEqualToString:@"个人签名"]?30:20;
    
    
    if (textStr.length > length) {
        NSString *moreLength = [NSString stringWithFormat:@"%@设置不能大于%ld个字符",self.title,length];
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:moreLength delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//        [alertView show];
         [MBProgressHUD showSuccess:moreLength];
        return;
    }


    UserModel *model = [[YRUserInfoManager manager] currentUser];
    //model.custSignature = self.textView.text;
    
     [MBProgressHUD showMessage:@""];
    NSString *interfaceName = [self.title isEqualToString:@"个人签名"]?@"signature":@"desc";
    
    [YRHttpRequest ModifyPersonalInformationByChangeName:interfaceName value:self.textView.text success:^(NSDictionary *data) {
        DLog(@"%@",data);
        
         [self.title isEqualToString:@"个人签名"]?(model.custSignature=self.textView.text):(model.custDesc=self.textView.text);
        
        [self saveModelInfoToDisk];
        [MBProgressHUD hideHUD];
         [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:error];
    }];
   

}

#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    NSInteger length = [self.title isEqualToString:@"个人签名"]?30:20;
//    if (textView == self.textView) {
//        if (text.length == 0) return YES;
//        
//        NSInteger existedLength = textView.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = text.length;
//        if (existedLength - selectedLength + replaceLength > length) {
//            return NO;
//        }
//    }
//    
//    return YES;
    NSInteger length = [self.title isEqualToString:@"个人签名"]?30:20;
    if (textView == self.textView) {
        if (text.length == 0) return YES;
        
        NSInteger existedLength = textView.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = text.length;
        if (existedLength - selectedLength + replaceLength > length) {
            return NO;
        }
    }
    return YES;
    
    
    
}

-(void)textViewDidChange:(UITextView *)textView{
    NSInteger length = [self.title isEqualToString:@"个人签名"]?30:20;
    //该判断用于联想输入
    if (textView.text.length > length)
    {
        textView.text = [textView.text substringToIndex:length];
    }
}

@end
