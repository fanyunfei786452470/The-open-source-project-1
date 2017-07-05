//
//  YRBuyAccountController.m
//  YRYZ
//
//  Created by 易超 on 16/7/21.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRBuyAccountController.h"
#import "RRZSaveMoneyController.h"
#import "YRStatementViewController.h"

@interface YRBuyAccountController ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (nonatomic,strong) YRAccountModel     *accountModel;

@property (nonatomic,assign) BOOL feachData;

@end

@implementation YRBuyAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightNavButtonWithTitle:@"消费明细"];
    
    self.title = @"消费账户";
    
   // [self getUserAccount];
    
//    if (self.accountModel) {
//        float sum = [self.accountModel.accountSum floatValue] * 0.01;
//        self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",sum];
//    }
    NSString *money = (NSString *)[[YRYYCache share].yyCache objectForKey:@"userMoney"];
    self.moneyLabel.text = money;
    [YRHttpRequest AccountBalanceQuerySuccess:^(NSDictionary *data) {
        
        self.accountModel = [YRAccountModel mj_objectWithKeyValues:data];
        CGFloat sum = [self.accountModel.accountSum integerValue] * 0.01;
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",sum];
        [[YRYYCache share].yyCache setObject:self.moneyLabel.text forKey:@"userMoney"];
        
    } failure:^(NSString *error) {
        
        [MBProgressHUD showError:error];
    }];
    
    
}

- (void)rightNavAction:(UIButton *)button{
    
    YRStatementViewController *Statement = [[YRStatementViewController alloc]init];
    [self.navigationController pushViewController:Statement animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.feachData) {
        [YRHttpRequest AccountBalanceQuerySuccess:^(NSDictionary *data) {
           
            self.accountModel = [YRAccountModel mj_objectWithKeyValues:data];
            CGFloat sum = [self.accountModel.accountSum integerValue] * 0.01;
            self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",sum];
            
        } failure:^(NSString *error) {
           
            [MBProgressHUD showError:error];
        }];
    }
   
}



- (IBAction)saveMoneyBtnClick {
    RRZSaveMoneyController *saveVc = [[RRZSaveMoneyController alloc] init];
    self.feachData = YES;
    [self.navigationController pushViewController:saveVc animated:YES];
}
-(void)dealloc{
    DLog(@"消费账户页面死掉了");
}

@end
