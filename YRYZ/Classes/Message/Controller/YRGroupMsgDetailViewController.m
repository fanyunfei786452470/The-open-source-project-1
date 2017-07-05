//
//  YRGroupMsgDetailViewController.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/13.
//  Copyright © 2016年 yryz. All rights reserved.
//  消息-->群聊详情

#import "YRGroupMsgDetailViewController.h"
#import "YRGroupDetailFooterView.h"
#import "YRGroupDetailHeaderView.h"
#import "YRGroupMemberViewController.h"
#import "YRGroupChatNameViewController.h"
#import "YRMsgReportViewController.h"
#import "YRMinusGroupPeopleViewController.h"
#import "YRAdListUserInfoController.h"
#import "SPKitExample.h"
#import "SPUtil.h"
#define itemHeight (kScreenWidth-140)/4


static NSString *yrGroupMsgDetailCellIdentifier = @"yrGroupMsgDetailCellIdentifier";
@interface YRGroupMsgDetailViewController ()<UITableViewDelegate,UITableViewDataSource,YRGroupDetailHeaderViewDelegate,YRGroupDetailFooterViewDelegate,YRGroupChatNameViewControllerDelegate>

@property (nonatomic,weak) UITableView *tb_View;

@property (nonatomic,weak) YRGroupDetailHeaderView *headerView;

@property (nonatomic,strong) NSMutableArray *userArray;

@property (strong, nonatomic) YWTribeMember *myTribeMember;

@property (nonatomic,copy) NSString *changeGroupName;

@end

@implementation YRGroupMsgDetailViewController

- (NSMutableArray *)userArray{
    if (!_userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群聊详情";
    
    self.myTribeMember = [[self ywTribeService] fetchTribeMember:[[[self ywIMCore] getLoginService] currentLoginedUser]inTribe:self.tribe.tribeId];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 45.f;
    table.backgroundColor = RGB_COLOR(245, 245, 245);
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    self.tb_View = table;
    
    NSInteger count = self.dataArr.count >18?5:((self.dataArr.count+2 -1)/4 +1);
    YRGroupDetailHeaderView *headersView = [[YRGroupDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,(itemHeight+20)*count+100)];
    headersView.delegate = self;
    headersView.dataSource = (NSMutableArray*)self.dataArr;
    table.tableHeaderView = headersView;
    self.headerView = headersView;
    self.userArray = (NSMutableArray*)self.dataArr;

    YRGroupDetailFooterView *footerView = [[YRGroupDetailFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    footerView.delegate = self;
    table.tableFooterView = footerView;
    
}
- (void)requestData {
    if (!self.tribe) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.ywTribeService requestTribeMembersFromServer:self.tribe.tribeId completion:^(NSArray *members, NSString *tribeId, NSError *error) {
        if( error == nil ) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            weakSelf.userArray = [members mutableCopy];
                
            NSInteger count = weakSelf.userArray.count >18?5:((weakSelf.userArray.count+2 -1)/4 +1);
            YRGroupDetailHeaderView *headersView = [[YRGroupDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,(itemHeight+20)*count+100)];
            headersView.delegate = self;
            weakSelf.tb_View.tableHeaderView = headersView;
            headersView.dataSource = weakSelf.userArray;
            [self.headerView removeAllSubviews];
           [weakSelf.tb_View reloadData];
               
           });
            
     }else {
            [MBProgressHUD showError:@"更新群成员失败"];
        }
    }];
}

#pragma mark -  UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yrGroupMsgDetailCellIdentifier];
    [self tableViewCell:cell cellForRowArIndexPath:indexPath];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case groupNameType:
        {
            YWTribeMember *tribeMember = [self myTribeMember];
            

            if (tribeMember.role == YWTribeMemberRoleOwner) {
                YRGroupChatNameViewController *groupChatNameVc = [[YRGroupChatNameViewController alloc] initWithNibName:@"YRGroupChatNameViewController" bundle:nil];
                
                NSString *name;
                if (self.changeGroupName == nil || [self.changeGroupName isEqualToString:@""]) {
                    name = self.tribe.tribeName;
                }else{
                    name = self.changeGroupName;
                }
                
                groupChatNameVc.name = name;
                groupChatNameVc.tribeId = self.tribe.tribeId;
                groupChatNameVc.delegate = self;

                [self.navigationController pushViewController:groupChatNameVc animated:YES];
                
            }else{
            
                [MBProgressHUD showError:@"您不是群主，不能修改群名"];
            }
        }
            break;
        case groupPeopleCountType:
        {
            
        }
            break;
        case msgNoNotificationType:
        {

        }
            break;
        case emptyChatKeepType:
        {

            @weakify(self);
            YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"确定清空聊天记录" cancelButtonText:@"取消" confirmButtonText:@"确定"];
            
            alertView.addCancelAction = ^{
                
            };
            alertView.addConfirmAction = ^{
                @strongify(self);
                
                YWConversation *conversation = (YWTribeConversation *)[[self.imKit.IMCore getConversationService] fetchConversationByConversationId:self.tribe.tribeId];
                [conversation removeAllLocalMessages];
                [self.navigationController popViewControllerAnimated:YES];
            };
            [alertView show];

        }
            break;
        case reportType:
        {
            YRMsgReportViewController *reportVc = [[YRMsgReportViewController alloc] init];
            reportVc.type = 1;
            reportVc.sourceId = self.tribe.tribeId;

            [self.navigationController pushViewController:reportVc animated:YES];
        }
            break;
        default:
            break;
    }
    
}
- (void)tableViewCell:(UITableViewCell *)cell cellForRowArIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case groupNameType:
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yr_msg_access"]];
            cell.accessoryView = imageView;
            [self tableViewCell:cell withText:@"群聊名称"];
            YWTribe *aTribe = self.tribe;
            
            NSString *atribeName;
            if ([self.changeGroupName isEqualToString:@""] || self.changeGroupName == nil) {
                atribeName = aTribe.tribeName;
            }else{
                atribeName = self.changeGroupName;
            }
            
            [self tableViewCell:cell WithDetailText:atribeName X:SCREEN_WIDTH-180.f];
        }
            break;
        case groupPeopleCountType:
        {
           NSInteger groupCount = [[self ywTribeService] fetchTribeMembers:self.tribe.tribeId].count;

            [self tableViewCell:cell withText:@"群组人数"];
            [self tableViewCell:cell WithDetailText:[NSString stringWithFormat:@"%ld人",groupCount] X:SCREEN_WIDTH-170.f];

        }
            break;
        case msgNoNotificationType:
        {
            YWMessageFlag messageFlag = [[[self ywIMCore] getSettingService] getMessageReceiveForTribe:_tribe];
            [self tableViewCell:cell withText:@"消息免打扰"];
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70.f, 10.0f, 45.0f, 25.0f)];
            switchView.onTintColor= [UIColor themeColor];
            
            if (messageFlag == YWMessageFlagReceive) {
                switchView.on = NO;//设置初始为ON的一边
            } else {
                switchView.on = YES;//设置初始为ON的一边
            }

            
            [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:switchView];
        }
            break;
        case emptyChatKeepType:
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yr_msg_access"]];
            cell.accessoryView = imageView;
            [self tableViewCell:cell withText:@"清空聊天记录"];
        }
            break;
        case reportType:
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yr_msg_access"]];
            cell.accessoryView = imageView;
            [self tableViewCell:cell withText:@"举报"];
        }
            break;
        default:
            break;
    }
}


- (void)switchAction:(UISwitch *)switchAction{
    
    if (switchAction.on) {
        [[[self ywIMCore] getSettingService] asyncSetMessageReceive:1 ForTribe:self.tribe completion:^(NSError *aError, NSDictionary *aResult) {
            
        }];
    }else{
        [[[self ywIMCore] getSettingService] asyncSetMessageReceive:2 ForTribe:self.tribe completion:^(NSError *aError, NSDictionary *aResult) {
            
        }];
    }

}

- (void)tableViewCell:(UITableViewCell *)cell withText:(NSString *)text{
    
    UILabel *label = [[UILabel alloc] init];
    label.mj_x    = 15.f;
    label.mj_y    = 10.f;
    label.mj_w    = 150.f;
    label.mj_h    = 25.f;
    [cell.contentView addSubview:label];
    
    label.text = text;
    label.textColor = [UIColor wordColor];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(15, 44, SCREEN_WIDTH-15, 1);
    layer.backgroundColor = RGB_COLOR(245, 245, 245).CGColor;
    [cell.contentView.layer addSublayer:layer];
}

- (void)tableViewCell:(UITableViewCell *)cell WithDetailText:(NSString *)text X:(CGFloat)x{
    UILabel *label = [[UILabel alloc] init];
    label.mj_x    = x;
    label.mj_y    = 10.f;
    label.mj_w    = 150.f;
    label.mj_h    = 25.f;
    [cell.contentView addSubview:label];
    label.text = text;
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = RGB_COLOR(102, 102, 102);
}

#pragma mark - YRGroupDetailHeaderViewDelegate

/**
 *  @author ZX, 16-07-18 15:07:39
 *
 *  查看群成员
 */
- (void)didSeleteLookAllGroupPeople{
    
    YRMinusGroupPeopleViewController *groupMemberVc = [[YRMinusGroupPeopleViewController alloc] init];
    groupMemberVc.dataSource = self.userArray;
    groupMemberVc.tribe = self.tribe;
    [self.navigationController pushViewController:groupMemberVc animated:YES];
}

/**
 *  @author ZX, 16-07-18 15:07:19
 *
 *  添加群成员
 */
- (void)didSeleteAddGroupChat{
    YRGroupMemberViewController *groupMemberVc = [[YRGroupMemberViewController alloc] init];
    groupMemberVc.title = @"选择联系人";
    groupMemberVc.tribe = self.tribe;
    groupMemberVc.dataSource = self.userArray;
    groupMemberVc.isAddPerson = YES;
    [self.navigationController pushViewController:groupMemberVc animated:YES];
}

/**
 *  @author ZX, 16-07-18 15:07:26
 *
 *  删除群成员
 */
- (void)didSeleteMinusGroupChat{
    YWTribeMember *tribeMember = [self myTribeMember];
    
    if (tribeMember.role == YWTribeMemberRoleOwner) {
        
        YRGroupMemberViewController *groupMemberVc = [[YRGroupMemberViewController alloc] init];
        groupMemberVc.title = @"移除群成员";
        groupMemberVc.tribe = self.tribe;
        groupMemberVc.dataSource = self.userArray;
        groupMemberVc.isAddPerson = NO;
        [self.navigationController pushViewController:groupMemberVc animated:YES];
    }else{
        [MBProgressHUD showError:@"您不是群主，不能移除群成员！"];
    }
}

/**
 *  @author ZX, 16-09-10 09:09:21
 *
 *  点击群成员
 */
- (void)didSeleteLookPeopleDetailWithCustId:(NSString *)custId{

    YRAdListUserInfoController *userInfoVc = [[YRAdListUserInfoController alloc] init];
    userInfoVc.custId = custId;
    userInfoVc.isFriend = YES;
    [self.navigationController pushViewController:userInfoVc animated:YES];
}

#pragma mark - YRGroupDetailFooterViewDelegate

- (void)didClickDeleteGroupChat{
    YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"退出后不会通知群聊中其他成员，且不会再接受此群聊消息" cancelButtonText:@"取消" confirmButtonText:@"确定"];
    
    alertView.addCancelAction = ^{
        
    };
    alertView.addConfirmAction = ^{
        YWTribeMember *tribeMember = [self myTribeMember];
        
        if (tribeMember.role == YWTribeMemberRoleOwner && self.tribe.tribeType == YWTribeTypeNormal) {
//            __weak __typeof(self) weakSelf = self;
//            [[SPUtil sharedInstance] setWaitingIndicatorShown:YES withKey:self.description];
            [[self ywTribeService] disbandTribe:self.tribe.tribeId completion:^(NSString *tribeId, NSError *error) {
//                [[SPUtil sharedInstance] setWaitingIndicatorShown:NO withKey:weakSelf.description];
            }];
        }else {
//            __weak __typeof(self) weakSelf = self;
//            [[SPUtil sharedInstance] setWaitingIndicatorShown:YES withKey:self.description];
            [[self ywTribeService] exitFromTribe:self.tribe.tribeId completion:^(NSString *tribeId, NSError *error) {
//                [[SPUtil sharedInstance] setWaitingIndicatorShown:NO withKey:weakSelf.description];
                
            }];
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
    [alertView show];
}
/**改变群名*/
- (void)ChangeGroupChatName:(NSString *)name{
    self.changeGroupName = name;
    [self.tb_View reloadData];
}

- (YWIMCore *)ywIMCore {
    return [SPKitExample sharedInstance].ywIMKit.IMCore;
}

- (id<IYWTribeService>)ywTribeService {
    return [[self ywIMCore] getTribeService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
