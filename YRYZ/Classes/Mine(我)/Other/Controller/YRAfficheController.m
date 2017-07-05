//
//  YRAfficheController.m
//  YRYZ
//
//  Created by 易超 on 16/7/20.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRAfficheController.h"
#import "YRAccountCell.h"
#import "YRMineWebController.h"
static NSString *cellID = @"YRAfficheControllerID";
@interface YRAfficheController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView       *tableView;
@property (strong, nonatomic) NSArray           *titles;
@property (nonatomic,strong) NSArray *array;

@end


@implementation YRAfficheController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.array = @[@"关于我们",@"作者协议",SERVICEAGREEMENT,@"奖励规则",LEGALNOTICES];
    self.array = @[ABOUTUS,SERVICEAGREEMENT,RELEASERULES,DRAWRULES ,SUNUSERULES ,REDADSUSERULES ,BENEFITRULES ,REGISGUIDE,PAYMENTGUIDE,COMMONPROBLEMS,LEGALNOTICES,CONTACTUS];
    
    [self setTitle:@"用户帮助"];
    [self setupTableView];
    DLog(@"%@",NSHomeDirectory());
}

-(void)setupTableView{
//    self.titles = @[@"关于我们",@"作者协议",@"用户服务协议",@"奖励规则",@"法律声明",@"常见问题"];
    self.titles = @[@"关于我们",@"用户服务协议",@"作品发布规则",@"抽奖规则",@"“随手晒”使用规则",@"红包广告发布及使用规则",@"用户奖励规则",@"注册指南",@"付款指南",@"常见问题",@"法律声明",@"联系我们"];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGB_COLOR(245, 245, 245);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    [self.view addSubview:self.tableView];
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YRAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[YRAccountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
        cell.textLabel.font = [UIFont titleFont17];
      cell.textLabel.text = self.titles[indexPath.row];
    cell.textLabel.textColor = RGB_COLOR(51, 51, 51);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = RGB_COLOR(245, 245, 245);
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *url = self.array[indexPath.row];
    YRMineWebController *webController = [[YRMineWebController alloc]init];
    webController.titletext = self.titles[indexPath.row];
    webController.url = url;
    [self.navigationController pushViewController:webController animated:YES];
    
    
//    if (indexPath.row == 0) {
//        
//    }else if (indexPath.row == 1){
//        
//    }else if (indexPath.row == 2){
//        
//    }else if (indexPath.row == 3){
//        
//    }else if (indexPath.row == 4){
//        
//    }
}



@end
