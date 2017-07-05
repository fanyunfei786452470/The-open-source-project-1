//
//  YRFriendSetMoreController.m
//  YRYZ
//
//  Created by Sean on 16/9/1.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRFriendSetMoreController.h"
#import "YRMsgReportViewController.h"
@interface YRFriendSetMoreController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UISwitch *mySwitch;

@property (nonatomic,strong) UIButton   *canBtn;

@end

@implementation YRFriendSetMoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"更多设置";
    [self configUI];
}
- (void)configUI{
    self.mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 0 , 40, 40)];
    [self.mySwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    self.mySwitch.onTintColor= [UIColor themeColor];
    self.mySwitch.layer.borderColor = RGB_COLOR(220, 220, 220).CGColor;
    
    self.canBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.canBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    [self.canBtn addTarget:self action:@selector(canBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.canBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    [self.canBtn setTintColor:RGB_COLOR(252, 92, 95)];
    self.canBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    UITableView *table =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:table];
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    table.backgroundColor = RGB_COLOR(245, 245, 245);
  
}
- (void)switchChange:(UISwitch *)mySwitch{
    if (mySwitch.on) {
        DLog(@"加入黑名单");
        [YRHttpRequest AddOrRemoveAttentionToRemoveByType:@"2" friendID:self.custId actionType:@(0) success:^(NSDictionary *data) {
            if ([data[@"relation"] intValue]==0) {
                  [MBProgressHUD showSuccess:@"加入黑名单成功"];
                NSInteger count = self.navigationController.childViewControllers.count-1;
                [self.navigationController popToViewController:self.navigationController.childViewControllers[count-2] animated:YES];
            }
            DLog(@"加入黑名单成功");
            
        } failure:^(NSString *error) {
             [MBProgressHUD showSuccess:error];
            
        }];
    }else{
        [YRHttpRequest AddOrRemoveAttentionToRemoveByType:@"2" friendID:self.custId actionType:@(1) success:^(NSDictionary *data) {
            if ([data[@"relation"] intValue]==0) {
                [MBProgressHUD showSuccess:@"取消黑名单成功"];
            }
        } failure:^(NSString *error) {
            [MBProgressHUD showSuccess:error];
        }];
    }
}
- (void)canBtnClick:(UIButton *)sender{
    
    DLog(@"点击了取消关注按钮");
    
    YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"是否确认取消关注" cancelButtonText:@"取消" confirmButtonText:@"确定"];
    alertView.addConfirmAction = ^{
        [YRHttpRequest AddOrRemoveAttentionToRemoveByType:@"1" friendID:self.custId actionType:@(1) success:^(NSDictionary *data) {

        if ([data[@"relation"] intValue]==2) {
            [MBProgressHUD showSuccess:@"取消关注成功"];
            self.foucnMyfriend.relation = @"0";
        }
            self.searchModel.relation = @"0";
            NSInteger count = self.navigationController.childViewControllers.count-1;
            [self.navigationController popToViewController:self.navigationController.childViewControllers[count-2] animated:YES];
                   } failure:^(NSString *error) {
           [MBProgressHUD showSuccess:error];
            
        }];
    };
    [alertView show];
    
}

#pragma mark ---tableDele
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.isFriend?2:1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.01;
    }else{
        return 10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.section==0) {
        if (indexPath.row==0) {
          cell.textLabel.text = @"举报";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.textLabel.text = @"加入黑名单";
            self.mySwitch.centerY = cell.contentView.centerY;
            [cell.contentView addSubview:self.mySwitch];
        }
    }else{
        self.canBtn.center = cell.center;
        self.canBtn.centerX = self.view.centerX;
        [cell.contentView addSubview:self.canBtn];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0&&indexPath.row==0) {
        YRMsgReportViewController *report = [[YRMsgReportViewController alloc]init];
        report.sourceId = self.custId;
        report.type = 1;
        report.isPop = YES;
        [self.navigationController pushViewController:report animated:YES];
    }
    
    
}

@end





























