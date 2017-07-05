//
//  RRZAddressSearchFriendController.m
//  Rrz
//
//  Created by 易超 on 16/3/12.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZAddressSearchFriendController.h"
#import "RRZAddressCommendFriendCell.h"
#import "RRZCommendFriend.h"
#import "RRZNavSearchView.h"
//#import "RRZFriendInfoController.h"

static NSString *addressFriendCell = @"RRZAddressSearchFriendCell";

@interface RRZAddressSearchFriendController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,RRZAddressListNewFriendCellAddButtonDelegate>

@property (weak, nonatomic) UITextField *seachTextField;

/** 数据数组*/
@property (strong, nonatomic) NSMutableArray *friends;
/** <#注释#>*/
@property (assign, nonatomic) NSInteger pageNow;

@end

@implementation RRZAddressSearchFriendController

-(NSMutableArray *)friends{
    if (!_friends) {
        _friends = @[].mutableCopy;
    }
    return _friends;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 66;
    [self.tableView setExtraCellLineHidden];
    
    [self setupNavTitleView];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RRZAddressCommendFriendCell class]) bundle:nil] forCellReuseIdentifier:addressFriendCell];
    
//    [self.tableView jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    [self.tableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
//    [self.tableView.header beginRefreshing];
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:SetupAddressListNotification_key object:nil] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        [self registerData];
    }];
}

-(void)setupNavTitleView{
    RRZNavSearchView *searchView = [[RRZNavSearchView alloc]init];
    searchView.frame = CGRectMake(0, 6, SCREEN_WIDTH - 95, 32);
//    searchView.backgroundColor = [UIColor clearColor];
    self.seachTextField = searchView.seachTextField;
    self.seachTextField.delegate = self;
    [self.seachTextField becomeFirstResponder];
    self.navigationItem.titleView = searchView;
    
//    UIBarButtonItem *item = [UIBarButtonItem titleItemWithImage:nil highImage:nil target:self action:@selector(registerData) norColor:NavItemColor highColor:nil title:@"搜索"];
//    self.navigationItem.rightBarButtonItem = item;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"搜索" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(searchItemClick) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

//- (void)headRefresh
//{
//    self.pageNow = 0;
//    [self registerData];
//    
//}

- (void)footRefresh
{
    self.pageNow += kListPageSize;
    [self registerData];
    
}

-(void)searchItemClick{
    
    [self.view endEditing:YES];
    [self.seachTextField resignFirstResponder];
    
    self.pageNow = 0;
    [self registerData];
}


- (void)registerData{
    
//    [self.view endEditing:YES];
    
    if (self.seachTextField.text.length <= 0) {
        [MBProgressHUD showError:@"请输入关键字"];
        return;
    }
    
    
    [YRHttpRequest searchFriendByKeyWord:self.seachTextField.text page:0 pageSize:0 success:^(NSDictionary *data) {
        
        DLog(@"%@",data);
        
    } failure:^(NSString *error) {
        
        DLog(@"%@",error);
        
    }];
    
    
    
////     [MBProgressHUD showMessage:@"" toView:self.view];
//    [[RRZNetworkController sharedController] getCommendFriendWithPageNow:self.pageNow pageSize:kListPageSize phone:self.seachTextField.text success:^(NSDictionary *data) {
//      //        DLog(@"%@",data);
//        NSString *code = data[@"code"];
//        if (![code isEqualToString:@"success"]) {
//            [MBProgressHUD showError:data[@"message"]];
//            return ;
//        }
//        
//        
//        NSArray *datas = [RRZCommendFriend mj_objectArrayWithKeyValuesArray:data[@"data"]];
//        if (datas.count == 0) {
//            [MBProgressHUD showError:@"未找到相关信息"];
//        }else{
//            [MBProgressHUD hideHUDForView:self.view];
//        }
//        if (self.pageNow == 0) {
//            [self.friends removeAllObjects];
//            [self.tableView reloadData];
//        }
//        [self.friends addObjectsFromArray:datas];
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
    return self.friends.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RRZAddressCommendFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:addressFriendCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.items = self.friends[indexPath.row];
    cell.friendDelegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    RRZCommendFriend *model = self.friends[indexPath.row];
    
//    RRZFriendInfoController *friendInfoVC = [[RRZFriendInfoController alloc]init];
//    friendInfoVC.custId = model.custId;
//    friendInfoVC.addRegardBlock = ^{
//        model.isSel = YES;
//        [self.tableView reloadData];
//    };
//    [self.navigationController pushViewController:friendInfoVC animated:YES];
}

-(void)listNewFriendCellAddFriend:(RRZCommendFriend *)item{
//    [MBProgressHUD showMessage:@"" toView:self.view];
//    [[RRZNetworkController sharedController] friendsRelationShipByToCustId:item.custId type:kGoodFriend success:^(NSDictionary *data) {
//        NSString *code = data[@"code"];
//        if ([code isEqualToString:@"success"]) {
//            [MBProgressHUD showError:@"已发送"];
//            item.isSel = YES;
//        }else{
//            [MBProgressHUD showError:data[@"message"]];
//        }
//    } failure:^(NSDictionary *data) {
//         [MBProgressHUD showError:NetworkError toView:self.view];
//    }];
//    
//    [[RRZNetworkController sharedController]addRelationshipByToCustId:item.custId type:@"1" success:^(NSDictionary *data) {
//        NSString *code = data[@"code"];
//        if ([code isEqualToString:@"success"]) {
//            [MBProgressHUD showError:@"已发送"];
//            item.isSel = YES;
//        }else{
//            [MBProgressHUD showError:data[@"message"]];
//        }
//    } failure:^(NSDictionary *data) {
//        [MBProgressHUD showError:NetworkError toView:self.view];
//    }];
}

@end
