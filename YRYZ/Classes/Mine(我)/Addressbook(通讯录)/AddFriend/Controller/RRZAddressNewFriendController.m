//
//  RRZAddressNewFriendController.m
//  Rrz
//
//  Created by 易超 on 16/3/4.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZAddressNewFriendController.h"
#import "RRZAddressListNewFriendCell.h"
#import  "AddressBook.h"
#import  "FriendsModel.h"
static NSString *addressListNewFriendCellID = @"RRZAddressListNewFriendCell";
@interface RRZAddressNewFriendController ()
<RRZAddressListNewFriendCellAddButtonDelegate>
@property (strong, nonatomic) NSString        *phoneStr;
@property (strong, nonatomic) NSMutableArray  *friendsList;

@end

@implementation RRZAddressNewFriendController


- (NSString*)phoneStr{
    if (!_phoneStr) {
        _phoneStr = @"";
    }
    return _phoneStr;
}

- (NSMutableArray*)friendsList{
    if (!_friendsList) {
        _friendsList = @[].mutableCopy;
    }
    return _friendsList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"手机联系人";
    
    [self getPhoneNum];
    
    [self initTableView];
    
    [self relationshipListByPhones];
    
}

- (void)initTableView{
    [self.tableView setExtraCellLineHidden];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RRZAddressListNewFriendCell class]) bundle:nil] forCellReuseIdentifier:addressListNewFriendCellID];
}


- (void)getPhoneNum{
    NSArray *arr =  [AddressBook readAllPeoplesHeader];
    
    [arr enumerateObjectsUsingBlock:^(AddressBook *book , NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *str = [book.tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
        self.phoneStr = [self.phoneStr stringByAppendingFormat:@"%@",str];
        if (![book isEqual:arr.lastObject]) {
             self.phoneStr = [self.phoneStr stringByAppendingString:@","];
        }
    }];
    
}
/**
 *  @author weishibo, 16-03-07 18:03:49
 *
 *  上传本地通讯录 得到匹配的待添加好友
 */

- (void)relationshipListByPhones{
    
//    [[RRZNetworkController sharedController] relationshipListByPhones:self.phoneStr success:^(NSDictionary *info) {
//
//        self.friendsList = [FriendsModel mj_objectArrayWithKeyValuesArray:info[@"data"]];
//        [self.tableView reloadData];
//
//    } failure:^(id data) {
//         [MBProgressHUD showError:NetworkError toView:self.view];
//    }];
    
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendsModel *item = [self.friendsList objectAtIndex:indexPath.row];
    RRZAddressListNewFriendCell *cell = [RRZAddressListNewFriendCell tableView:tableView  items:item cellID:addressListNewFriendCellID];
    cell.friendDelegate = self;
    return cell;
}
/**
 *  @author weishibo, 16-03-08 11:03:20
 *
 *  添加还有 1表示添加好友
 *
 *  @param item <#item description#>
 */
- (void)listNewFriendCellAddFriend:(FriendsModel *)item{
//    [MBProgressHUD showMessage:@"" toView:self.view];
//    [[RRZNetworkController sharedController] friendsRelationShipByToCustId:item.custId type:1 success:^(NSDictionary *info) {
//        [MBProgressHUD showError:@"添加成功"];
//        [self.tableView reloadData];
//    } failure:^(id data) {
//         [MBProgressHUD showError:NetworkError toView:self.view];
//    }];
    [YRHttpRequest AddOrRemoveAttentionToRemoveByType:@"1" friendID:item.custId actionType:@(0) success:^(NSDictionary *data) {
        [MBProgressHUD showError:@"添加成功"];
    } failure:^(NSString *error) {
         [MBProgressHUD showError:error];
    }];
    
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 刚选中又马上取消选中，格子不变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
