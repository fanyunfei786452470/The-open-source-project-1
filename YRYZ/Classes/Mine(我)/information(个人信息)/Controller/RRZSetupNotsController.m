//
//  RRZSetupNotsController.m
//  Rrz
//
//  Created by 易超 on 16/3/18.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZSetupNotsController.h"
#import "RRZUserInfoItem.h"
#import "NSString+EmojiAdditions.h"
#import "SPKitExample.h"
@interface RRZSetupNotsController ()<UITextFieldDelegate>
@property (nonatomic, weak) YWIMKit *imkit;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation RRZSetupNotsController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.title isEqualToString:@"修改昵称"]) {
        UserModel *model = [[YRUserInfoManager manager] currentUser];
        self.nameTextField.text = model.custNname;
    }else{
         self.nameTextField.text = self.model.nameNotes;
    }
    self.view.backgroundColor = RGB_COLOR(245, 245, 245);
    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameTextField.delegate = self;
    [self setRightNavButtonWithTitle:@"保存"];
}

- (void)rightNavAction:(UIButton *)button{
    [self.view endEditing:YES];
    UserModel *model = [[YRUserInfoManager manager] currentUser];
    if ([self.nameTextField.text isEqualToString:model.custNname]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if ([NSString stringContainsEmoji:self.nameTextField.text]) {
        [MBProgressHUD showSuccess:@"昵称不可以包含表情哦~😠"];
        return;
    }
    NSString *nameStr = self.nameTextField.text;
    nameStr = [nameStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (nameStr.length > 10) {
        [MBProgressHUD showSuccess:@"昵称设置不能大于10个字符"];
        return;
    }
    if (nameStr.length <= 0) {
        [MBProgressHUD showSuccess:@"昵称设置不能为空"];
        return;
    }
    if([self.title isEqualToString:@"修改昵称"]){
//        UserModel *model = [[YRUserInfoManager manager] currentUser];

        [MBProgressHUD showMessage:@""];

        [YRHttpRequest ModifyPersonalInformationByChangeName:@"nickName" value:self.nameTextField.text success:^(NSDictionary *data) {
             [YRUserInfoManager manager].currentUser.custNname = self.nameTextField.text;
             [MBProgressHUD hideHUD];
             [MBProgressHUD showSuccess:@"修改昵称成功"];
             [self saveModelInfoToDisk];

            YWPerson *person = [[YWPerson alloc] initWithPersonId:[YRUserInfoManager manager].currentUser.custId];
            [[SPKitExample sharedInstance].ywIMKit removeCachedProfileForPerson:person];
            [YRUserInfoManager manager].currentUser.custNname = self.nameTextField.text;
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSString *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:error];
        }];
    }else{
        if ([self.model.nameNotes isEqualToString: self.nameTextField.text]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
            [MBProgressHUD showMessage:@""];
        YWPerson *person = [[YWPerson alloc] initWithPersonId:self.model.custId];
         BOOL _isFriend = [[_imkit.IMCore getContactService] ifPersonIsFriend:person];
        
        DLog(@"是否为好友：%d",_isFriend);
        
//        YWPerson *person = [[YWPerson alloc] initWithPersonId:item.custId];
        [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService] responseToAddContact:YES fromPerson:person withMessage:@"" andResultBlock:^(NSError *error, YWPerson *person) {
            if (error == nil) {
                DLog(@"关注成功");
            } else {
                DLog(@"关注失败");
            }
        }];

        [[[self ywIMCore] getContactService] modifyContact:person WithNewNick:self.nameTextField.text andResultBlock:^(NSError *error, YWPerson *person) {
            [[SPKitExample sharedInstance].ywIMKit removeCachedProfileForPerson:person];

            if (error == nil) {
                 [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"修改成功"];
                DLog(@"修改成功");
                } else {
                     [MBProgressHUD hideHUD];
//                [MBProgressHUD showError:@"修改失败"];
                    DLog(@"修改失败");
                }
        }];
        

        [YRHttpRequest setUpFriendsRemarkByFriendID:self.model.custId meomo:self.nameTextField.text success:^(NSDictionary *data) {
            [MBProgressHUD hideHUD];
           self.model.nameNotes = self.nameTextField.text;
           [MBProgressHUD showSuccess:@"设置备注成功"];
           [self.navigationController popViewControllerAnimated:YES];

       } failure:^(NSString *error) {
           [MBProgressHUD hideHUD];
           [MBProgressHUD showError:error];
       }];
        
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - textFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.nameTextField) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 10) {
            return NO;
        }
    }
    return YES;
    
//    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    if ([toBeString length] > 10) {
//        
//        return NO;
//    }    return YES;
    
}
//- (void)dealloc{
//    
//}
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        if (textField.text.length > 10) {
            textField.text = [textField.text substringToIndex:10];
        }
    }
}

- (YWIMCore *)ywIMCore {
    return [SPKitExample sharedInstance].ywIMKit.IMCore;
}

- (id<IYWContactService>)ywContactService {
    return [[self ywIMCore] getContactService];
}
@end
