//
//  RRZAdListBlackListController.m
//  Rrz
//
//  Created by 易超 on 16/6/24.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZAdListBlackListController.h"
#import "RRZGoodFriendItem.h"
#import "RRZAdListBlackListCell.h"

static NSString *cellID = @"BlackListCell";
@interface RRZAdListBlackListController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/** <#注释#>*/
@property (strong, nonatomic) UITableView *tableView;
/** <#注释#>*/
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSString *custId;

@end

@implementation RRZAdListBlackListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"黑名单";
    [self registerData];
    [self setupTableView];
    self.view.backgroundColor = RGB_COLOR(245, 245, 245);
}

-(void)setupTableView{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView setExtraCellLineHidden];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RRZAdListBlackListCell class]) bundle:nil] forCellReuseIdentifier:cellID];
}

#pragma mark - tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRZAdListBlackListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.item = self.items[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RRZGoodFriendItem *item = self.items[indexPath.row];
    self.custId = item.custId;
    [self setupAlertViewWithIndexpath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 66;
}


-(void)setupAlertViewWithIndexpath:(NSIndexPath *)index{
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"是否移出黑名单" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alertView show];
     YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"是否确认移出黑名单" cancelButtonText:@"取消" confirmButtonText:@"确定"];
    alertView.addConfirmAction = ^(){
         [self deleteBlackListWithIndexpath:index];
    };
    [alertView show];
}

#pragma mark - AlertView代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
//        [self deleteBlackList];
    }
}

#pragma mark - 网络请求
- (void)registerData{
//    [[RRZNetworkController sharedController] getBlackListSuccess:^(NSDictionary *info) {
//        
//        self.items = [RRZGoodFriendItem mj_objectArrayWithKeyValuesArray:info[@"data"]];
//        
//        [self.tableView reloadData];
//    } failure:^(NSDictionary *data) {
//         [MBProgressHUD showError:NetworkError toView:self.view];
//    }];
    
    
    [YRHttpRequest getFriendListSuccessWithType:kTheBlacklist success:^(NSDictionary *data) {
        
         self.items = [RRZGoodFriendItem mj_objectArrayWithKeyValuesArray:data];
         [self.tableView reloadData];
    } failure:^(NSString *error) {
        
        
    }];
}


// 移除黑名单的网络请求
-(void)deleteBlackListWithIndexpath:(NSIndexPath *)index{
    
//    [[RRZNetworkController sharedController] romoveBlackListBytoCustId:self.custId success:^(NSDictionary *data) {
//        
//        NSString *code = data[@"code"];
//        if ([code isEqualToString:@"success"]) {
//            [MBProgressHUD showError:@"移出成功"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:SetupAddressListNotification_key object:nil];
//            [self registerData];
//            [self.tableView reloadData];
//        }else{
//            [MBProgressHUD showError:data[@"message"]];
//        }
//        
//        
//    } failure:^(NSDictionary *data) {
//        [MBProgressHUD showError:NetworkError toView:self.view];
//    }];
   [YRHttpRequest AddOrRemoveAttentionToRemoveByType:@"2" friendID:self.custId actionType:@(1) success:^(NSDictionary *data)
    {
        [self.items removeObjectAtIndex:index.row];
        [MBProgressHUD showError:@"移出成功"];
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        
    }];
}


#pragma mark - lazy
-(NSMutableArray *)items{
    if (!_items) {
        _items = @[].mutableCopy;
    }
    return _items;
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
    NSString *text = @"点击屏幕继续加载";
    
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
//- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
//    return 10.0f;
//}






@end
