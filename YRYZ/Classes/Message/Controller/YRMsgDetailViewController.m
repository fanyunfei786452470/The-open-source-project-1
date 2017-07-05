//
//  YRMsgDetailViewController.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/13.
//  Copyright © 2016年 yryz. All rights reserved.
//  消息-- >聊天详情

#import "YRMsgDetailViewController.h"
#import "YRMsgDetailHeaderView.h"
#import "YRMsgReportViewController.h"
#import "YRAdListUserInfoController.h"
#import "SPKitExample.h"
#import "SPUtil.h"
static NSString *yrMsgDetailCellIdentifier = @"yrMsgDetailCellIdentifier";
@interface YRMsgDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) UITableView *tb_View;

@end

@implementation YRMsgDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天详情";
    
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 50.f;
    table.backgroundColor = RGB_COLOR(245, 245, 245);
    table.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:table];
    self.tb_View = table;
    
    YWProfileItem *item = [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService] getProfileForPerson:self.person withTribe:nil];
    NSString *displayName = item.displayName;
    UIImage *avatar = item.avatar;
    
    YRMsgDetailHeaderView *headerView = [[YRMsgDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 135) Image:avatar Name:displayName];
    headerView.didHeadImg = ^{
        
        YRAdListUserInfoController *userInfoVc = [[YRAdListUserInfoController alloc] init];
        userInfoVc.custId = self.person.personId;
        userInfoVc.isFriend = YES;
        [self.navigationController pushViewController:userInfoVc animated:YES];
    
    };
    table.tableHeaderView = headerView;
  
    [self setExtraCellLineHidden:table];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yrMsgDetailCellIdentifier];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yr_msg_access"]];
    cell.accessoryView = imageView;
    [self tableViewCell:cell cellForRowArIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            @weakify(self);
            YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"确定清空聊天记录" cancelButtonText:@"取消" confirmButtonText:@"确定"];
            
            alertView.addCancelAction = ^{
                
            };
            alertView.addConfirmAction = ^{
                @strongify(self);
                YWConversation *conversation = (YWP2PConversation *)[[self.imKit.IMCore getConversationService] fetchConversationByConversationId:self.person.personLongId];
                [conversation removeAllLocalMessages];
                [self.navigationController popViewControllerAnimated:YES];
            };
            [alertView show];
        }
            break;
        case 1:
        {
            YRMsgReportViewController *reportVc = [[YRMsgReportViewController alloc] init];
            reportVc.type = 1;
            reportVc.sourceId = self.person.personId;
            [self.navigationController pushViewController:reportVc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)tableViewCell:(UITableViewCell *)cell cellForRowArIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0:
        {
            [self tableViewCell:cell withText:@"清空聊天记录"];
        }
            break;
        case 1:
        {
            [self tableViewCell:cell withText:@"举报"];
        }
            break;
        default:
            break;
    }
}
/**
 *  @author ZX, 16-07-13 13:07:57
 *
 *  去除底部线条
 *
 *  @param tableView tableView
 */
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)tableViewCell:(UITableViewCell *)cell withText:(NSString *)text{
    
    UILabel *label = [[UILabel alloc] init];
    label.mj_x    = 15.f;
    label.mj_y    = 10.f;
    label.mj_w    = 150.f;
    label.mj_h    = 30.f;
    [cell.contentView addSubview:label];
    
    label.text = text;
    label.textColor = [UIColor wordColor];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(15, 49, SCREEN_WIDTH-15, 1);
    layer.backgroundColor = RGB_COLOR(245, 245, 245).CGColor;
    [cell.contentView.layer addSublayer:layer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
