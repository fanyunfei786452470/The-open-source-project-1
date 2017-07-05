//
//  RRZAdListRegardMeController.m
//  Rrz
//
//  Created by 易超 on 16/6/21.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZAdListRegardMeController.h"
#import "FriendsModel.h"
#import "RRZAddressListNewFriendCell.h"
//#import "RRZFriendInfoController.h"
#import "YRAdListUserInfoController.h"
#import "SPKitExample.h"
#import "UITabBar+badge.h"
#import "YRTabBarController.h"

static NSString *newFriendCell = @"RRZAddressListNewFriendCell";
@interface RRZAdListRegardMeController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate,RRZAddressListNewFriendCellAddButtonDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UITableView               *tableView;

@property (nonatomic, strong) UISearchController        *searchC;
/** 数据数组*/
@property (strong, nonatomic) NSMutableArray            *friends;
/** 过滤数组*/
@property (strong, nonatomic) NSMutableArray            *filterFriends;

@property (nonatomic,assign) NSInteger start;

@end

@implementation RRZAdListRegardMeController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.searchC.active = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关注我的";
    
    [self.navigationController.tabBarController.tabBar hideBadgeOnItemIndex:4];
    
    
//    [self registerData];
    [self setupTableView];
    [self setupSeach];
    self.view.backgroundColor = RGB_COLOR(245, 245, 245);
    id mes = [[YRYYCache share].yyCache objectForKey:MsgFollow_Notification_Key];
    if (mes) {
          [[YRYYCache share].yyCache removeObjectForKey:MsgFollow_Notification_Key];
    }
//    @weakify(self);
//    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:SetupAddressListNotification_key object:nil] subscribeNext:^(NSNotification *notification) {
//        @strongify(self);
//        [self registerData];
//    }];
}

-(void)setupTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44)];
    self.tableView.backgroundColor = RGB_COLOR(245, 245, 245);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 66;
    [self.view addSubview:self.tableView];
    [self.tableView setExtraCellLineHidden];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RRZAddressListNewFriendCell class]) bundle:nil] forCellReuseIdentifier:newFriendCell];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [self.tableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self.tableView jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    [self.tableView.header beginRefreshing];
}


- (void)headRefresh{
    self.start = 0;
    [self registerData];
}
- (void)footRefresh{
    self.start += kListPageSize;
    [self registerData];
}

- (void)setupSeach
{
    self.searchC = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchC.searchResultsUpdater = self;
    self.searchC.dimsBackgroundDuringPresentation = NO;
    self.searchC.hidesNavigationBarDuringPresentation = YES;
    self.searchC.searchBar.frame = CGRectMake(self.searchC.searchBar.frame.origin.x, self.searchC.searchBar.frame.origin.y, self.searchC.searchBar.frame.size.width, 44.0);
    self.searchC.searchBar.placeholder = @"搜索关键字";
    self.searchC.searchBar.barTintColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    self.searchC.searchBar.tintColor = Global_Color;
    UIImageView *view = [[[self.searchC.searchBar.subviews objectAtIndex:0] subviews] firstObject];
    view.layer.borderColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1].CGColor;
    view.layer.borderWidth = 1;
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 44)];
    [headView addSubview:self.searchC.searchBar];
    
    self.tableView.tableHeaderView = self.searchC.searchBar;
    self.searchC.searchBar.delegate = self;
    self.searchC.delegate = self;
}


#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchC.active){
        return self.filterFriends.count;
    }else{
        return self.friends.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchC.active) {
        FriendsModel *model = self.filterFriends[indexPath.row];
        RRZAddressListNewFriendCell *cell = [RRZAddressListNewFriendCell tableView:tableView items:model cellID:newFriendCell];
        cell.friendDelegate = self;
        NSString *name;
        if (model.nameNotes.length>0) {
            
            name = [NSString stringWithFormat:@"%@",model.nameNotes];
        }else{
            name = [NSString stringWithFormat:@"%@",model.custNname];
        }
        NSRange range = [name rangeOfString:self.searchC.searchBar.text];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:name];
        [attr addAttributes:@{NSForegroundColorAttributeName: Global_Color} range:range];
        cell.titleLabel.attributedText = attr;
        [cell.iconImageView setImageWithURL:[NSURL URLWithString:model.custImg] placeholder:[UIImage defaultHead]];
        return cell;
    }else{
        
        FriendsModel *model = self.friends[indexPath.row];
        RRZAddressListNewFriendCell *cell = [RRZAddressListNewFriendCell tableView:tableView items:model cellID:newFriendCell];
        cell.friendDelegate = self;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    FriendsModel *model = self.friends[indexPath.row];
//    RRZFriendInfoController *friendInfoVC = [[RRZFriendInfoController alloc]init];
//    friendInfoVC.custId = model.custId;
//    [self.navigationController pushViewController:friendInfoVC animated:YES];
    if (self.searchC.active) {
     FriendsModel *model = self.filterFriends[indexPath.row];
        DLog(@"%@",model.custNname);
        self.searchC.active = NO;
        YRAdListUserInfoController *userInfo = [[YRAdListUserInfoController alloc]init];
        [model.relation integerValue]==1?(userInfo.isFriend = YES) :(userInfo.isFriend = NO);
        userInfo.custId = model.custId;
        userInfo.foucnMyfriend = model;
        [self.navigationController pushViewController:userInfo animated:YES];
        
    }else{
        FriendsModel *model = self.friends[indexPath.row];
        YRAdListUserInfoController *userInfo = [[YRAdListUserInfoController alloc]init];
        [model.relation integerValue]==1?(userInfo.isFriend = YES) :(userInfo.isFriend = NO);
        userInfo.custId = model.custId;
         userInfo.foucnMyfriend = model;
        [self.navigationController pushViewController:userInfo animated:YES];
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.searchC.active) {
        if (section==0) {
            return 20;
        }
    }
    if (section==0) {
        return 0.1;
    }
    return 25;
}
#pragma mark - UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = [self.searchC.searchBar text];
    if ([searchString isEqualToString:@""]) {
        [self.filterFriends removeAllObjects];
    }else{
        self.filterFriends =[[NSMutableArray alloc]init];
        
        for(FriendsModel *item in self.friends)
        {
            NSString* name = item.custNname;
            if (!name) {
                name = @"";
            }
            NSString *phone = item.custPhone;
            if (!phone) {
                phone = @"";
            }
            if([name rangeOfString:searchString].location != NSNotFound || [phone isEqualToString:searchString])
            {
                [self.filterFriends addObject:item];
            }
        }
    }
    [self.tableView reloadData];
}
- (void)willPresentSearchController:(UISearchController *)searchController{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark DZNEmptyDataSetSource
- (UIImage*)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"r_cry"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂无相关信息";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    [self.tableView.header beginRefreshing];
}
#pragma mark - RRZAddressListNewFriendCellAddButtonDelegate
/**
 *  @author yichao, 16-04-05 18:04:50
 *
 *  1 加好友 2 加黑名单  3 相互关注
 *
 *  @param item
 */
-(void)listNewFriendCellAddFriend:(FriendsModel *)item cell:(RRZAddressListNewFriendCell *)cell{
    
    
    YWPerson *person = [[YWPerson alloc] initWithPersonId:item.custId];
    [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService] responseToAddContact:YES fromPerson:person withMessage:@"" andResultBlock:^(NSError *error, YWPerson *person) {
        if (error == nil) {
            DLog(@"关注成功");
        } else {
            DLog(@"关注失败");
        }
    }];
    
    [YRHttpRequest AddOrRemoveAttentionToRemoveByType:@"1" friendID:item.custId actionType:@(0) success:^(NSDictionary *data) {
        NSString *message;
        if([data[@"relation"] integerValue]==-1){
            message = @"用户不存在";
        }else if ([data[@"relation"] integerValue]==0){
            message = @"陌生人";
        }else if ([data[@"relation"] integerValue]==1){
            message = @"已关注";
        }else if ([data[@"relation"] integerValue]==2){
            message = @"用户不存在";
        }else if ([data[@"relation"] integerValue]==3){
            message = @"添加成功";
            item.relation = @"3";
            cell.rightButton.enabled = NO;
            cell.rightButton.backgroundColor = [UIColor clearColor];
        }
        [MBProgressHUD showError:message];
    } failure:^(NSString *error) {
        [MBProgressHUD showError:error];
    }];
}

//-(void)addFriendNotification{
//    [[NSNotificationCenter defaultCenter] postNotificationName:SetupAddressListNotification_key object:nil];
//}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self registerData];
//    self.start = 0;
    

    [self.tableView reloadData];
    
}
#pragma mark - 网络请求
-(void)registerData{
    
//    [MBProgressHUD showMessage:@"" toView:self.view];
    
    [YRHttpRequest getRegardMeListWithLimit:@(kListPageSize) start:@(self.start) Success:^(NSDictionary *data) {
        
        NSArray  *array =  [FriendsModel mj_objectArrayWithKeyValuesArray:data];

        if (self.start == 0) {
            [self.friends removeAllObjects];
        }
        [self.friends addObjectsFromArray:array];
        if ([array count] < kListPageSize) {
            self.start -= kListPageSize;
            [self.tableView.footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.footer endRefreshing];
        }
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
    } failure:^(NSString *data) {
        
        [MBProgressHUD showError:data toView:self.view];
    }];
    
//    @weakify(self);
//    [[RRZNetworkController sharedController]getRegardMeListSuccess:^(NSDictionary *data) {
//        @strongify(self);
//        [MBProgressHUD hideHUDForView:self.view];
//        self.friends = [FriendsModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
//        [self.tableView reloadData];
//    } failure:^(NSDictionary *data) {
//        [MBProgressHUD hideHUDForView:self.view];
//        [MBProgressHUD showError:NetworkError toView:self.view];
//    }];
}

#pragma mark - lazy
-(NSMutableArray *)friends{
    if (!_friends) {
        _friends = @[].mutableCopy;
    }
    return _friends;
}

@end
