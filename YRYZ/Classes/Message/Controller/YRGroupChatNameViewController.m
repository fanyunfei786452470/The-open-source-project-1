//
//  YRGroupChatNameViewController.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/14.
//  Copyright © 2016年 yryz. All rights reserved.
//  消息-->修改群聊名称

#import "YRGroupChatNameViewController.h"
#import "SPKitExample.h"

@interface YRGroupChatNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *chatNameTextField;
@property (weak, nonatomic) IBOutlet UIView *backGview;

@end

@implementation YRGroupChatNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改群聊名称";
    self.view.backgroundColor = RGB_COLOR(245, 245, 245);
    
    self.chatNameTextField.textColor = [UIColor wordColor];
    self.chatNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    self.chatNameTextField.text = self.name;
    
    self.backGview.layer.cornerRadius = 3.f;
    self.backGview.layer.borderColor = RGB_COLOR(229, 229, 229).CGColor;
    self.backGview.layer.borderWidth = 1.f;
    self.backGview.clipsToBounds = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    
}

/**
 *  @author ZX, 16-07-14 11:07:52
 *
 *  保存
 */
- (void)saveAction{
    
    
    if ([self.chatNameTextField.text isEqualToString:@""] || self.chatNameTextField.text == nil) {
        [MBProgressHUD showError:@"请填写群名"];
    }else if ([self.chatNameTextField.text isEqualToString:self.name]){
        [MBProgressHUD showError:@"请修改群名"];
    }else{
        @weakify(self);
        [self.ywTribeService modifyName:self.chatNameTextField.text notice:nil forTribe:self.tribeId completion:^(NSString *tribeId, NSError *error) {
            if (error == nil) {
                @strongify(self);
                
                if ([self.delegate respondsToSelector:@selector(ChangeGroupChatName:)]) {
                    [self.delegate ChangeGroupChatName:self.chatNameTextField.text];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }
        }];
    }
}


#pragma mark - Utility
- (YWIMCore *)ywIMCore {
    return [SPKitExample sharedInstance].ywIMKit.IMCore;
}

- (id<IYWTribeService>)ywTribeService {
    return [[self ywIMCore] getTribeService];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
