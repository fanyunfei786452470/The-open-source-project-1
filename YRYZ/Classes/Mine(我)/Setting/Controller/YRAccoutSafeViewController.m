//
//  YRAccoutSafeViewController.m
//  YRYZ
//
//  Created by weishibo on 16/8/10.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRAccoutSafeViewController.h"
#import "YRAccoutSafeCell.h"
#import "YRPayPasswordViewController.h"
#import "YRLoginPasswordViewController.h"

#import "YRChangePayPassWordController.h"
#import "UMShareAndLogin.h"
#import "UMSocial.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
#import "YRRegisterController.h"
static NSString *YRAccoutSafeCellID = @"YRAccoutSafeCellID";


@interface YRAccoutSafeViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView       *tableView;


@property (nonatomic,assign) BOOL isHavePassword;

@property (nonatomic,assign) BOOL smallNopass;

@property (nonatomic,strong) NSMutableArray *infoLogin;

@property (nonatomic,strong) NSMutableArray *imageArray;

@property (nonatomic,weak) UserModel *model;

@property (nonatomic,strong) UISwitch *switc;

@property (nonatomic,copy) NSString *imageName;

@property (nonatomic,copy) NSString *loginType;

@property (nonatomic,strong) YRUserInfoLoginModel *logionModel;
@end

@implementation YRAccoutSafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [YRUserInfoManager manager].currentUser;
    self.switc = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70.f, 10.0f, 45.0f, 25.0f)];
    [self setTitle:@"账户与安全"];
   
    [self loadData];
    [self setupTableView];
}
- (void)loadData{
    

        [YRHttpRequest AccountInformationByInformationName:kLoginMethod success:^(NSDictionary *data) {
            
        self.infoLogin = [YRUserInfoLoginModel mj_objectArrayWithKeyValuesArray:data];
        [self processingImages];
            [self.tableView reloadData];
    } failure:^(NSString *error) {
        
         DLog(@"%@",error);
    }];
    
}
- (void)processingImages{
     self.imageArray = [[NSMutableArray alloc]initWithArray:@[@"weChat",@"sina",@"QQ",@"yr_phone_num"]];
    self.imageName = self.imageArray[[self.model.loginType integerValue]-1];
    self.logionModel =self.infoLogin[[self.model.loginType integerValue]-1];
    [self.imageArray removeObjectAtIndex:[self.model.loginType integerValue]-1];
    [self.infoLogin removeObjectAtIndex:[self.model.loginType integerValue]-1];
    

    if ([self.imageName isEqualToString:@"weChat"]) {
        self.loginType = @"微信";
    }else if ([self.imageName isEqualToString:@"sina"]){
        self.loginType = @"新浪微博";
    }else if ([self.imageName isEqualToString:@"QQ"]){
        self.loginType = @"QQ";
    }else if ([self.imageName isEqualToString:@"yr_phone_num"]){
        self.loginType = @"手机号";
    }
    
  /*  YRUserInfoLoginModel *model = self.infoLogin.lastObject;
    if ([model.type integerValue]==1) {
        [self.imageArray removeObject:@"weChat"];
    }else if ([model.type integerValue]==2){
       [self.imageArray removeObject:@"sina"];
    }else if ([model.type integerValue]==3){
        [self.imageArray removeObject:@"QQ"];
    }else if ([model.type integerValue]==4){
        [self.imageArray removeObject:@"yr_phone_num"];
    }*/
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YRHttpRequest QueryThePaymentPasswordSuccess:^(NSDictionary *data) {
        DLog(@"%@",data);
        BOOL havePassword = [data[@"isPayPassword"] boolValue];
        havePassword?(self.isHavePassword=YES):(self.isHavePassword = NO);
        self.smallNopass = [data[@"smallNopass"] boolValue];
        
    } failure:^(NSString *error) {
        
    }];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadData];
}
-(void)setupTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = RGB_COLOR(245, 245, 245);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    [self.view addSubview:self.tableView];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YRAccoutSafeCell" bundle:nil] forCellReuseIdentifier:YRAccoutSafeCellID];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section== 1) {
        if (section==0) {
            return 30;
        }else{
          return 60;
        }
      
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return 20;
    }else{
        return 10;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 3) {
        UIView *view = [[UIView alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,2, SCREEN_WIDTH, 20)];
        label.text = @"开启后进行50元以下的支付行为,无需输入支付密码\t";
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = RGB_COLOR(161, 161, 161);
        [view addSubview:label];
        return view;

    }else{
        return nil;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0 || section== 1) {
        UIView *view = [[UIView alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,0, SCREEN_WIDTH, 30)];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        view.backgroundColor = [UIColor whiteColor];
        if (section == 0) {
            label.text = @"注册账户";
            label.textColor = [UIColor themeColor];
        }else if (section == 1){
            label.text = @"其他登录方式";
            label.textColor = [UIColor grayColorOne];
            label.font = [UIFont systemFontOfSize:15];
            label.frame = CGRectMake(10,30, SCREEN_WIDTH, 30);
            UILabel *rightLable = [[UILabel alloc] init];
            rightLable.frame = CGRectMake(SCREEN_WIDTH - 200,35, 190, 22);
            rightLable.textAlignment = NSTextAlignmentRight;
            rightLable.text = @"更换绑定手机请联系客服";
            rightLable.font = [UIFont systemFontOfSize:12];
            rightLable.textColor = [UIColor grayColorOne];
            [view addSubview:rightLable];
        }
        [view addSubview:label];
        return view;
    }else{
        return nil;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }else if (section == 2){
        return 2;
    }else if (section == 3){
        return 1;
    }
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 || indexPath.section == 1 ) {
      
        YRAccoutSafeCell *accoutcell = [tableView dequeueReusableCellWithIdentifier:YRAccoutSafeCellID forIndexPath:indexPath];
        if (indexPath.section==0) {
                  accoutcell.subTitleLable.text = self.logionModel.nickName;
             accoutcell.backgroundColor = RGB_COLOR(246, 246, 246);
            accoutcell.bageBtn.hidden = YES;
            [accoutcell.headImageView setImageWithURL:[NSURL URLWithString:self.model.custImg] placeholder:[UIImage defaultImage]];
            accoutcell.headImageView.image = [UIImage imageNamed:self.imageName];
            accoutcell.titleLabel.text = self.loginType;
            if ([self.model.loginType integerValue]==4&&self.infoLogin) {
                NSMutableString *openId = [[NSMutableString alloc]initWithString:self.logionModel.openId];
                [openId replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                accoutcell.subTitleLable.text = openId;
            }
//            accoutcell.subTitleLable.text = 
            
//            accoutcell.titleLabel.text = self.model.custNname;
//            accoutcell.subTitleLable.text = self.model.custSignature;
        }
        if (indexPath.section==1) {
//            if (indexPath.row==0) {
//                accoutcell.headImageView.image = [UIImage imageNamed:self.imageArray.firstObject];
//                 accoutcell.titleLabel.text = @"手机号";
//                accoutcell.subTitleLable.text = @"138*******9876";
//                accoutcell.bageBtn.tag = 1001;
//            }else if (indexPath.row==1){
//                accoutcell.titleLabel.text = @"QQ";
//                  accoutcell.headImageView.image = [UIImage imageNamed:@"QQ"];
//                 accoutcell.subTitleLable.text = @"ID:PIG";
//                 accoutcell.bageBtn.tag = 1002;
//            }else if (indexPath.row==2){
//                 accoutcell.titleLabel.text = @"新浪微博";
//                 accoutcell.headImageView.image = [UIImage imageNamed:@"sina"];
//                 accoutcell.subTitleLable.hidden = YES;
//                 accoutcell.bageBtn.tag = 1003;
//            }
            [self setCellUIWithIndexPath:indexPath tableCell:accoutcell];
            
          [accoutcell.bageBtn addTarget:self action:@selector(bageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }

        return accoutcell;
    }else if(indexPath.section == 2) {
        
        static NSString *cellID = @"UITableViewCell2ID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"登录密码";
            cell.detailTextLabel.text = @"更改";
            
        }else{
            cell.textLabel.text = @"支付密码";
            if (self.isHavePassword) {
                cell.detailTextLabel.text = @"更改";
                 cell.detailTextLabel.textColor = RGB_COLOR(158, 158, 158);
            }else{
                cell.detailTextLabel.text = @"设置";
                cell.detailTextLabel.textColor = [UIColor redColor];
            }
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }else{
        static NSString *cellID = @"UITableViewCell3ID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        cell.textLabel.text = @"小额免密";
        self.switc.onTintColor= [UIColor themeColor];
        self.switc.on = self.smallNopass;//设置初始为ON的一边
        [self.switc addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:self.switc];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        self.switc.layer.borderColor = RGB_COLOR(220, 220, 220).CGColor;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 60;
    }else{
        return 44;
    }
}
- (void)setCellUIWithIndexPath:(NSIndexPath *)indexPath tableCell:(YRAccoutSafeCell *)cell{
    YRUserInfoLoginModel *model = self.infoLogin[indexPath.row];
     cell.bageBtn.hidden = NO;
    if (model.openId){
         [cell.bageBtn setTitle:@"解绑" forState:UIControlStateNormal];
          cell.bageBtn.userInteractionEnabled = YES;
        cell.bageBtn.backgroundColor = RGB_COLOR(245, 245, 245);
        [cell.bageBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        if ([model.type integerValue]==4) {
            [cell.bageBtn setTitle:@"已绑定" forState:UIControlStateNormal];
            cell.bageBtn.backgroundColor = [UIColor clearColor];
            cell.bageBtn.userInteractionEnabled = NO;
            [cell.bageBtn setTitleColor:RGB_COLOR(117, 117, 117) forState:UIControlStateNormal];
        }
        
    }else{
        [cell.bageBtn setTitle:@"绑定" forState:UIControlStateNormal];
        [cell.bageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.bageBtn.backgroundColor = [UIColor themeColor];
         cell.bageBtn.userInteractionEnabled = YES;
    }
   
    cell.subTitleLable.text = model.nickName;
    
    if ([model.type integerValue]==1) {
        cell.headImageView.image = [UIImage imageNamed:@"weChat"];
         cell.titleLabel.text = @"微信";
        cell.bageBtn.tag = 1001;
    }else if ([model.type integerValue]==2){
        cell.headImageView.image = [UIImage imageNamed:@"sina"];
        cell.titleLabel.text = @"新浪微博";
        cell.bageBtn.tag = 1002;
        
    }else if ([model.type integerValue]==3){
        cell.headImageView.image = [UIImage imageNamed:@"QQ"];
        cell.titleLabel.text = @"QQ";
        cell.bageBtn.tag = 1003;
    }else if ([model.type integerValue]==4){
        cell.headImageView.image = [UIImage imageNamed:@"yr_phone_num"];
        cell.titleLabel.text = @"手机号";
        cell.bageBtn.tag = 1004;
        if (self.infoLogin) {
            NSMutableString *openId = [[NSMutableString alloc]initWithString:model.openId];
            [openId replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            cell.subTitleLable.text = openId;
        }
    }
//    if (![WeiboSDK isWeiboAppInstalled]){
//        self.sinaButton.hidden = YES;
//    }
//    
//    if (![QQApiInterface isQQInstalled]){
//        self.QQButton.hidden = YES;
//    }
//    if (![WXApi isWXAppInstalled]&&![WeiboSDK isWeiboAppInstalled]&&![QQApiInterface isQQInstalled]) {
//        self.thirdView.hidden = YES;
//    }
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([YRUserInfoManager manager].currentUser){
            if (indexPath.section == 2) {
                if (indexPath.row == 1) {
        //            YRPayPasswordViewController *payVc = [[YRPayPasswordViewController alloc] init];
        //            [self.navigationController pushViewController:payVc animated:YES];
                    
                    YRChangePayPassWordController *payVc = [[YRChangePayPassWordController alloc]init];
                    if (self.isHavePassword) {
                        payVc.title = @"修改支付密码";
                    }else{
                        payVc.title = @"设置支付密码";
                    }
                    [self.navigationController pushViewController:payVc animated:YES];
            
                }else if (indexPath.row == 0){
                    YRLoginPasswordViewController *payVc = [[YRLoginPasswordViewController alloc] init];
                    payVc.delegate = self.delegate;
                    [self.navigationController pushViewController:payVc animated:YES];
                }
            }
    }else{
        if (indexPath.section!=3) {
              [self notLoggedIn];
        }
    }
}

//绑定账户
- (void)bageBtnClick:(UIButton *)sender{
    //sender的tag值  1001 微信  1002 微博  1003 QQ 1004 手机
    
    if ([YRUserInfoManager manager].currentUser){
                if([sender.currentTitle isEqualToString:@"绑定"]){
                //绑定微信
                if (sender.tag==1001) {
                    [WXApi isWXAppInstalled]?[self bodingWechat]:[self noInstallWithString:@"微信"];
                }//绑定QQ
                else if (sender.tag==1003){
                    [QQApiInterface isQQInstalled]?[self bodingQQ]:[self noInstallWithString:@"QQ"];
                }//绑定新浪微博
                else if (sender.tag==1002){
                    [WeiboSDK isWeiboAppInstalled]?[self bodingSina]:[self noInstallWithString:@"微博"];
                }else if (sender.tag==1004){
                    [self bodingPhone];
                }
        }
        else{
              NSString *type = [NSString stringWithFormat:@"%ld",(NSInteger)sender.tag-1000];
            NSArray *array = @[@"微信",@"微博",@"QQ",@"手机"];
            NSString *name = [NSString stringWithFormat:@"是否确认解绑%@",array[[type intValue]-1]];
            YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:name cancelButtonText:@"取消" confirmButtonText:@"确认"];
            alertView.addConfirmAction = ^(){
                YRUserInfoLoginModel *model = self.infoLogin[[type intValue]-1];
                [self unBodingWhat:type openId:model.openId];
            };
            [alertView show];
        }
    }
    else{
        [self notLoggedIn];
    }
}
- (void)unBodingWhat:(NSString *)name openId:(NSString *)openId{
    
    [YRHttpRequest bindOtherAccountByTheName:name accessToken:@""  openId:openId   action:@"1" success:^(NSDictionary *data) {
        [MBProgressHUD showSuccess:@"解绑成功"];
        [self loadData];
    } failure:^(NSString *error) {
        [MBProgressHUD showSuccess:error];
    }];
}
- (void)bodingWechat{
    [UMShareAndLogin UMLoginWithWeChatDataSourseWithController:self SuccessHandler:^(BOOL isSuccess, id result) {
        
        UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatSession];
        NSString *openId = snsAccount.openId;
        NSString *action = @"0";
        NSString *accessToken = snsAccount.accessToken;
        [YRHttpRequest bindOtherAccountByTheName:@"1" accessToken:accessToken  openId:(NSString *)openId   action:(NSString *)action success:^(NSDictionary *data) {
             [self loadData];
        } failure:^(NSString *error) {
           [MBProgressHUD showError:error];
        }];
        
    }];
}
- (void)bodingQQ{
    [UMShareAndLogin UMLoginWithQQDataSourseWithController:self SuccessHandler:^(BOOL isSuccess, id result) {
        
        UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
        NSString *openId = snsAccount.openId;
        NSString *action = @"0";
        NSString *accessToken = snsAccount.accessToken;
        [YRHttpRequest bindOtherAccountByTheName:@"3" accessToken:accessToken  openId:(NSString *)openId   action:(NSString *)action success:^(NSDictionary *data) {
              [self loadData];
        } failure:^(NSString *error) {
            [MBProgressHUD showError:error];
        }];
    }];
    
}
- (void)bodingSina{
    [UMShareAndLogin UMLoginWithWebDataSourseWithController:self SuccessHandler:^(BOOL isSuccess, id result) {
        
        UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
        NSString *openId = snsAccount.usid;
        NSString *action = @"0";
        NSString *accessToken = snsAccount.accessToken;
        [YRHttpRequest bindOtherAccountByTheName:@"2" accessToken:accessToken openId:(NSString *)openId   action:(NSString *)action success:^(NSDictionary *data) {
            [self loadData];
            
        } failure:^(NSString *error) {
            
            [MBProgressHUD showError:error];
        }];
        
    }];
    
}
- (void)bodingPhone{
    YRRegisterController *reigs = [[YRRegisterController alloc]init];
    reigs.title = @"绑定手机号";
    [self.navigationController pushViewController:reigs animated:YES];
    
    
    
}
- (void)noInstallWithString:(NSString *)string{
    
    NSString *str = [NSString stringWithFormat:@"您还没有安装%@客户端",string];
    
    YRAlertView *alertView = [[YRAlertView alloc]initWithTitle:str cancelButtonText:@"确认"];
     [alertView show];
}
- (void)notLoggedIn{
    
    YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"请登录进行后续操作" cancelButtonText:@"再看看" confirmButtonText:@"去登录"];
    [alertView show];
}



#pragma mark
- (void)switchAction:(UISwitch*)s{
    
    if (self.isHavePassword){
        BOOL isSecret = self.smallNopass;
        if (!isSecret) {
            [YRHttpRequest setSmallFreeByType:YES success:^(NSDictionary *data) {
                self.smallNopass = YES;
                    DLog(@"设置小额免密成功,%@",data);
                
            } failure:^(NSString *error) {
                
            }];
        }else{
            [YRHttpRequest setSmallFreeByType:NO success:^(NSDictionary *data) {
                self.smallNopass = NO;
                DLog(@"设置小额有密成功,%@",data);
            } failure:^(NSString *error) {
                
            }];
        }

    }else{
        if ([YRUserInfoManager manager].currentUser) {
            YRAlertView *alertView = [[YRAlertView alloc]initWithTitle:@"为了您的账户安全,请先设置支付密码" cancelButtonText:@"设置"];
            alertView.addCancelAction = ^{
                YRChangePayPassWordController *payVc = [[YRChangePayPassWordController alloc]init];
                payVc.title = @"设置支付密码";
                [self.navigationController pushViewController:payVc animated:YES];
            };
            [alertView show];
        }else{
            [self notLoggedIn];
        }
        s.on = !s.on;
    }
    
    
}
@end
















