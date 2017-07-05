//
//  RRZSetupSexController.m
//  Rrz
//
//  Created by 易超 on 16/3/21.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZSetupSexController.h"
#import "RRZUserInfoItem.h"
#import "RRZSetupSexTableViewCell.h"

static NSString *cellID = @"RRZSetupSexController";

@interface RRZSetupSexController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) RRZSetupSexTableViewCell *cell;

/** <#注释#>*/
@property (strong, nonatomic) UITableView *tableView;

/** <#注释#>*/
@property (strong, nonatomic) NSArray *sexArr;

@end

@implementation RRZSetupSexController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    [self setTitle:@"修改性别"];
    self.sexArr = @[@"女",@"男"];
    self.view.backgroundColor = RGB_COLOR(245, 245, 245);
    [self setupTableView];
}


-(void)setupTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44*2) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RRZSetupSexTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma mark - tableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sexArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RRZSetupSexTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.sex.text = self.sexArr[indexPath.row];
//    if (indexPath.row == 0) {
//        if (self.item.custSex.integerValue == 1) {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//            
//            
//        }else{
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
//    }else if (indexPath.row == 1){
//        if (self.item.custSex.integerValue == 0) {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        }else{
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
//    }
    
    if (indexPath.row==[[YRUserInfoManager manager].currentUser.custSex integerValue]) {
        
        cell.isYes.image = [UIImage imageNamed:@"yr_choose_yes"];
        _cell = cell;
    }else{
        cell.isYes.image = [UIImage imageNamed:@"yr_choose_no"];
    }
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    RRZSetupSexTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (indexPath.row == 0) {
//        self.item.custSex = @"1";
          _cell.isYes.image = [UIImage imageNamed:@"yr_choose_no"];
        cell.isYes.image = [UIImage imageNamed:@"yr_choose_yes"];
        _cell = cell;
        
//    }else if (indexPath.row == 1){
//        self.item.custSex = @"0";
//    }
//    [self.tableView reloadData];
//    [self registerData];
    
    UserModel *model = [[YRUserInfoManager manager] currentUser];
//    model.custNname = self.nameTextField.text;
    
    NSString *sex = indexPath.row==0?@"0":@"1";
    
    
    
    [YRHttpRequest ModifyPersonalInformationByChangeName:@"sex" value:sex success:^(NSDictionary *data) {
        [YRUserInfoManager manager].currentUser.custSex = sex;
        [self saveModelInfoToDisk];
        DLog(@"%@",data);
        model.custSex = sex;
        [self.navigationController popViewControllerAnimated:YES];
      //   [MBProgressHUD showSuccess:@"修改性别成功"];
        
    } failure:^(NSString *error) {
        [MBProgressHUD showError:error];
        
        
    }];
    
  
    
}



-(void)registerData{
//    
//    [[RRZNetworkController sharedController] editUserInfoByCustNname:self.item.custNname custSex:self.item.custSex custBirthday:self.item.custBirthday custAddr:self.item.custAddr custImgId:self.item.custImgId custIdentified:self.item.custIdentified signature:self.item.signature location:self.item.location success:^(id data) {
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:EditUserInfo_key object:nil];
//        [self.navigationController popViewControllerAnimated:YES];
//        
//    } failure:^(id data) {
//         [MBProgressHUD showError:NetworkError toView:self.view];
//    }];
}

@end
