//
//  RRZCitySeleteController.m
//  Rrz
//
//  Created by 易超 on 16/3/18.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZCitySeleteController.h"
#import "RRZUserInfoItem.h"
#import "RRZMineMyInfoController.h"


static NSString *citiesCellID = @"citiesCellID";

@interface RRZCitySeleteController ()<UITableViewDataSource,UITableViewDelegate>

/** tableView*/
@property (strong, nonatomic) UITableView *tableView;

/** 城市名数组*/
@property (strong, nonatomic) NSArray *cityArr;

/** 地区名*/
@property (strong, nonatomic) NSString *cityStr;

@end

@implementation RRZCitySeleteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.province;
    
    [self setupTableView];
}

-(void)setupTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT ) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.sectionHeaderHeight = 40;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 44, 0);
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:citiesCellID];
    
    NSMutableArray *cityArr = [NSMutableArray array];
    for (NSDictionary *dic in self.cities) {
        [cityArr addObject:dic[@"city"]];
    }
    self.cityArr = cityArr;
}

-(void)registerData{
    DLog(@"%@",self.cityStr);
    
    
    
    [YRHttpRequest ModifyPersonalInformationByChangeName:@"location" value:self.cityStr success:^(NSDictionary *data) {
        [YRUserInfoManager manager].currentUser.custLocation = self.cityStr;
        
        [self saveModelInfoToDisk];
        
    } failure:^(NSString *error) {
        [MBProgressHUD showError:error];
        
    }];
    
//    [[RRZNetworkController sharedController] editUserInfoByCustNname:self.item.custNname custSex:self.item.custSex custBirthday:self.item.custBirthday custAddr:self.item.custAddr custImgId:self.item.custImgId custIdentified:self.item.custIdentified signature:self.item.signature location:self.cityStr success:^(id data) {
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:EditUserInfo_key object:nil];
//        
        RRZMineMyInfoController *myInfoController = self.navigationController.childViewControllers[1];
        [self.navigationController popToViewController:myInfoController animated:YES];
//
//    } failure:^(id data) {
//         [MBProgressHUD showError:NetworkError toView:self.view];
//    }];
}


#pragma mark - tableView Delegate and DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cities.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:citiesCellID];
    cell.textLabel.text = self.cityArr[indexPath.row];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"全部";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.cityStr = [NSString stringWithFormat:@"%@-%@",self.province,self.cityArr[indexPath.row]];
    YRUserInfoManager *manager = [YRUserInfoManager manager];
    [manager.currentUser setCustLocation:self.cityStr];
    
    
    [self registerData];
}

@end
