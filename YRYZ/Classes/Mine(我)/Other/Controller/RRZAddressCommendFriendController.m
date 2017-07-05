//
//  RRZAddressAddFriendController.m
//  Rrz
//
//  Created by 易超 on 16/3/4.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZAddressCommendFriendController.h"
#import "RRZAddressCommendFriendCell.h"
#import "RRZCommendFriend.h"
//#import "RRZFriendInfoController.h"

static NSString *addressCommendFriendCell = @"RRZAddressCommendFriendCell";
@interface RRZAddressCommendFriendController ()<RRZAddressListNewFriendCellAddButtonDelegate>

/** 数据数组*/
@property (strong, nonatomic) NSMutableArray *friends;

@property (nonatomic, assign)NSInteger    pageNow;

@end

@implementation RRZAddressCommendFriendController

-(NSMutableArray *)friends{
    if (!_friends) {
        _friends = @[].mutableCopy;
    }
    return _friends;
}

//- (void)setPageNow:(NSInteger)pageNow
//{
//    if (pageNow < 0) {
//        _pageNow = 0;
//        return;
//    }
//    _pageNow = pageNow;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNow = 0;
    self.navigationItem.title = @"推荐好友";
    [self.tableView setExtraCellLineHidden];
    self.tableView.rowHeight = 66;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RRZAddressCommendFriendCell class]) bundle:nil] forCellReuseIdentifier:addressCommendFriendCell];
    
    
    [self.tableView jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    [self.tableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self.tableView.header beginRefreshing];
    
}

- (void)headRefresh
{
    self.pageNow = 0;
    [self registerData];
}

- (void)footRefresh
{
    self.pageNow += kListPageSize;
    [self registerData];
    
}


-(void)registerData{
//    @weakify(self);
//    [[RRZNetworkController sharedController] getCommendFriendWithPageNow:self.pageNow pageSize:kListPageSize phone:@"" success:^(NSDictionary *data) {
//        @strongify(self);
////        DLog(@"%@",data);
//        
//        NSArray *datas = [RRZCommendFriend mj_objectArrayWithKeyValuesArray:data[@"data"]];
//        
//        if (self.pageNow == 0) {
//            [self.friends removeAllObjects];
//            [self.tableView reloadData];
//        }
//        [self.friends addObjectsFromArray:datas];
//        
//        
//        if (datas.count < kListPageSize) {
//            self.pageNow -= kListPageSize;
//            [self.tableView.footer endRefreshingWithNoMoreData];
//        }else{
//            [self.tableView.footer endRefreshing];
//        }
//        
//        [self.tableView.header endRefreshing];
//        [self.tableView reloadData];
//        
//    } failure:^(id data) {
//         [MBProgressHUD showError:NetworkError toView:self.view];
//        [self.tableView.header endRefreshing];
//        [self.tableView.footer endRefreshing];
//    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    DLog(@"%ld",self.friends.count);
    return self.friends.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RRZAddressCommendFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCommendFriendCell];
    cell.items = self.friends[indexPath.row];
    cell.friendDelegate = self;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 刚选中又马上取消选中，格子不变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    RRZCommendFriend *model = self.friends[indexPath.row];
    
//    RRZFriendInfoController *friendInfoVC = [[RRZFriendInfoController alloc]init];
//    friendInfoVC.custId = model.custId;
////    friendInfoVC.isMyFriend = NO;
//    [self.navigationController pushViewController:friendInfoVC animated:YES];
}

-(void)listNewFriendCellAddFriend:(RRZCommendFriend *)item{
//    [MBProgressHUD showProgressLabel:@""];
//    [MBProgressHUD showMessage:@"" toView:self.view];
//    [[RRZNetworkController sharedController] friendsRelationShipByToCustId:item.custId type:1 success:^(NSDictionary *info) {
//        
//        NSString *code = info[@"code"];
//        if ([code isEqualToString:@"success"]) {
////            [MBProgressHUD showError:@"已发送"];
//            [MBProgressHUD hideHUDForView:self.view];
//            item.isSel = YES;
//        }else{
//            [MBProgressHUD showError:info[@"message"]];
//        }
//        
////        [self.tableView reloadData];
//    } failure:^(id data) {
//         [MBProgressHUD showError:NetworkError toView:self.view];
//    }];
    
    
    [YRHttpRequest AddOrRemoveAttentionToRemoveByType:@"1" friendID:item.custId actionType:@(0) success:^(NSDictionary *data) {
        [MBProgressHUD showError:@"添加成功"];
    } failure:^(NSString *error) {
        [MBProgressHUD showError:error];
    }];

}

@end
