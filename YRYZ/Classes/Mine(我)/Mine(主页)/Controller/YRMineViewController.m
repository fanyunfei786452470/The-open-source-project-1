//
//  YRMineViewController.m
//  YRYZ
//
//  Created by 易超 on 16/6/29.
//  Copyright © 2016年 yryz. All rights reserved.
//
#import "YRMineViewController.h"
#import "YRMineTopCell.h"
#import "YRMine_mineCell.h"
#import "YRMinePublicCell.h"
#import "YRLoginController.h"
#import "YRAddressListController.h"
#import "YRCollectController.h"
#import "YRMyWorksController.h"
#import "YRRingTranController.h"
#import "YRSettingController.h"
#import "YRAccountController.h"
#import "YRAfficheController.h"
#import "RRZMineMyInfoController.h"
#import "YRBaskViewController.h"

#import "YRRedAdsViewController.h"
#import "YRMyRedPackViewController.h"

#import "YRMineAddressListController.h"
#import "YRMineSunController.h"
#import "YRMainWorksController.h"
//#import "YRMineLoginController.h"
#import "YRLoginController.h"
#import "YRMineWebController.h"

#import "ZoomImage.h"
#import "LWImageBrowser.h"
#import "LWImageBrowserModel.h"

static NSString *mineTopCellID = @"YRMineTopCellID";
static NSString *mine_mineCellID = @"YRMine_mineCellID";
static NSString *minePublicCellID = @"YRMinePublicCellID";
@interface YRMineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView       *tableView;
@property (strong, nonatomic) NSArray           *images;
@property (strong, nonatomic) NSArray           *titles;

@property (nonatomic,strong) UILabel        *message;

@end

@implementation YRMineViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.message = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -40, 20, 10, 10)];
    self.message.backgroundColor = RGB_COLOR(250, 114, 111);
    self.message.layer.cornerRadius = 5;
    self.message.clipsToBounds = YES;
    [self setupTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMsgNotification:) name:@"sendMsgNotification" object:nil];
    [self setLeftNavButtonWithImage:[UIImage imageNamed:@""]];
    
}

-(void)setupTableView{
    self.images = @[@[],@[],@[@"yr_adList",@"yr_account",@"yr_mian_collect"],@[@"yr_setting",@"yr_online_message"],@[@"yr_helpOnline"]];
    self.titles = @[@[],@[],@[@"通讯录",@"我的账户",@"我的收藏"],@[@"设置",@"在线留言"],@[@"在线客服"]];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 150, 0);
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRMineTopCell class]) bundle:nil] forCellReuseIdentifier:mineTopCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRMine_mineCell class]) bundle:nil] forCellReuseIdentifier:mine_mineCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRMinePublicCell class]) bundle:nil] forCellReuseIdentifier:minePublicCellID];
}
- (void)sendMsgNotification:(NSNotification *)notification{
    [self.tableView reloadData];
}
#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 3;
    }else if (section == 3){
        return 2;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        YRMineTopCell *topCell = [tableView dequeueReusableCellWithIdentifier:mineTopCellID];
        [topCell.iconImageView setImageWithURL:[NSURL URLWithString:[YRUserInfoManager manager].currentUser.custImg] placeholder:[UIImage defaultHead]];
        
        topCell.nameLabel.text = [YRUserInfoManager manager].currentUser.custId ?[YRUserInfoManager manager].currentUser.custNname : @"点击登录";
        if ((kDevice_Is_iPhone5)&&topCell.nameLabel.text.length>8){
            topCell.nameLabel.font = [UIFont systemFontOfSize:15];
            topCell.nameLabel.font = [UIFont systemFontOfSize:15];
            topCell.nameLabel.font = [UIFont systemFontOfSize:15];
        }
        @weakify(topCell);
        topCell.chooseCell = ^(BOOL isChoose){
             @strongify(topCell);
            [self userImageClickWithImage:topCell];
        };
        return topCell;
    }else if (indexPath.section == 1){
        YRMine_mineCell *mineCell = [tableView dequeueReusableCellWithIdentifier:mine_mineCellID];
        mineCell.mineCellButtonClickBlock = ^(NSInteger tag){
            if ([YRUserInfoManager manager].currentUser) {
                if (tag == 11) {
                    YRMyWorksController *myWorksVC = [[YRMyWorksController alloc]init];
                    [self.navigationController pushViewController:myWorksVC animated:YES];
//                    YRMainWorksController *works = [[YRMainWorksController alloc]initWithMyFrame:CGRectMake(1, 1, 1, 1)];
//                     [self.navigationController pushViewController:works animated:YES];
                }else if (tag == 12){
                    YRRingTranController *ringTranVC = [[YRRingTranController alloc]init];
                    [self.navigationController pushViewController:ringTranVC animated:YES];
                }else if (tag == 13){
//                    YRBaskViewController *yrbaskVc = [[YRBaskViewController alloc] init];
//                    [self.navigationController pushViewController:yrbaskVc animated:YES];
                    YRMineSunController *mineSun = [[YRMineSunController alloc]init];
                    [self.navigationController pushViewController:mineSun animated:YES];
                    
                }else if(tag==14){
                    
                    YRMyRedPackViewController *RedbaskVc = [[YRMyRedPackViewController alloc] initWithMyFrame:CGRectMake(1, 1, 1, 1)];
                    [self.navigationController pushViewController:RedbaskVc animated:YES];
                }
            }else{
                if (![YRUserInfoManager manager].currentUser.custId) {
                    [self noLoginTip];
                    return;
                }
            }
        };
        return mineCell;
    }else{
        YRMinePublicCell *publicCell = [tableView dequeueReusableCellWithIdentifier:minePublicCellID];
        publicCell.iconImageView.image = [UIImage imageNamed:self.images[indexPath.section][indexPath.row]];
        publicCell.titleLabel.text = self.titles[indexPath.section][indexPath.row];
        publicCell.titleLabel.font = [UIFont titleFont17];
        publicCell.titleLabel.textColor = RGB_COLOR(51, 51, 51);
        if (indexPath.section == 2) {
            if (indexPath.row == 2) {
                publicCell.lineLabel.hidden = YES;
            }else{
                publicCell.lineLabel.hidden = NO;
            }
        }else if (indexPath.section == 3){
            if (indexPath.row == 1) {
                publicCell.lineLabel.hidden = YES;
            }else{
                publicCell.lineLabel.hidden = NO;
            }
        }else{
            publicCell.lineLabel.hidden = YES;
        }
        if ([publicCell.titleLabel.text isEqualToString:@"通讯录"]) {
            NSMutableArray *msgArr = [NSMutableArray array];
            msgArr = (NSMutableArray *)[[YRYYCache share].yyCache objectForKey:MsgFollow_Notification_Key]?(NSMutableArray *)[[YRYYCache share].yyCache objectForKey:MsgFollow_Notification_Key]:@[].mutableCopy;
            if (msgArr.count>0) {
                [publicCell.contentView addSubview:self.message];
                self.message.centerY = publicCell.contentView.centerY;
                self.message.hidden = NO;
            }else{
                self.message.hidden = YES;
            }
        }
        return publicCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 89;
    }else if (indexPath.section == 1){
        return 110;
    }else{
        return 44;
    }
}

- (void)userImageClickWithImage:(YRMineTopCell *)cell{
//    UserModel *model = [YRUserInfoManager manager].currentUser;
//    [ZoomImage showImage:icon];
    if ([YRUserInfoManager manager].currentUser&&cell) {
        LWImageBrowserModel *models = [[LWImageBrowserModel alloc]initWithLocalImage:cell.iconImageView.image imageViewSuperView:cell positionAtSuperView:cell.iconImageView.frame index:0];
        LWImageBrowser *useImage = [[LWImageBrowser alloc]initWithParentViewController:self imageModels:@[models] currentIndex:0];
        useImage.pageControl.hidden = YES;
        [useImage show];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if ([YRUserInfoManager manager].currentUser.custId) {
            RRZMineMyInfoController *myInfoVC = [[RRZMineMyInfoController alloc]init];
            [self.navigationController pushViewController:myInfoVC animated:YES];
        }else{
            YRLoginController *loginVC = [[YRLoginController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }else if (indexPath.section == 2){
      
        if ([YRUserInfoManager manager].currentUser) {
            if (indexPath.row == 0) {
                YRMineAddressListController *adListVC = [[YRMineAddressListController alloc]init];
//                YRAddressListController *adListVC = [[YRAddressListController alloc]init];
                [self.navigationController pushViewController:adListVC animated:YES];
            }else if (indexPath.row == 1){
                YRAccountController *accountVC = [[YRAccountController alloc]init];
                [self.navigationController pushViewController:accountVC animated:YES];
            }else if (indexPath.row == 2){
                YRCollectController *collectVC = [[YRCollectController alloc]init];
                [self.navigationController pushViewController:collectVC animated:YES];
            }
        }else{
            if (![YRUserInfoManager manager].currentUser.custId) {
                [self noLoginTip];
                return;
            }
        }
    }
    else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            YRSettingController *settingVC = [[YRSettingController alloc]init];
            settingVC.delegate = self;
            [self.navigationController pushViewController:settingVC animated:YES];
        }else{
//            YRAfficheController *afficheVC = [[YRAfficheController alloc]init];
//            [self.navigationController pushViewController:afficheVC animated:YES];
            YRMineWebController *heleMeWbe = [[YRMineWebController alloc]init];
            heleMeWbe.titletext = @"在线留言";
            heleMeWbe.url = @"http://form.mikecrm.com/blRghq";
            [self.navigationController pushViewController:heleMeWbe animated:YES];
        }
    }else if (indexPath.section == 4){
        
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
