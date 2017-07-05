//
//  YRSearchFriendController.m
//  YRYZ
//
//  Created by Sean on 16/9/21.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSearchFriendController.h"
#import "RRZAddressCommendFriendCell.h"
#import "RRZCommendFriend.h"
#import "RRZNavSearchView.h"
#import "YRAdListUserInfoController.h"
#import "SPKitExample.h"
static NSString *addressFriendCell = @"RRZAddressSearchFriendCell";
@interface YRSearchFriendController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,RRZAddressListNewFriendCellAddButtonDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) UITextField *seachTextField;

/** 数据数组*/
@property (strong, nonatomic) NSMutableArray *friends;
/** <#注释#>*/
@property (assign, nonatomic) NSInteger start;


@end

@implementation YRSearchFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 66;
    [self.tableView setExtraCellLineHidden];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;

    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RRZAddressCommendFriendCell class]) bundle:nil] forCellReuseIdentifier:addressFriendCell];
    
    [self.tableView jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    [self.tableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
        [self setupNavTitleView];
 
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.seachTextField endEditing:YES];
}
-(void)setupNavTitleView{
    RRZNavSearchView *searchView = [[RRZNavSearchView alloc]init];
    searchView.frame = CGRectMake(0, 6, SCREEN_WIDTH - 95, 32);
    //    searchView.backgroundColor = [UIColor clearColor];
    self.seachTextField = searchView.seachTextField;
    self.seachTextField.delegate = self;
    if (self.searchText) {
        self.seachTextField.text = self.searchText;
        [self.tableView.header beginRefreshing];
    }else{
         [self.seachTextField becomeFirstResponder];
    }
   
    self.navigationItem.titleView = searchView;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"搜索" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(searchItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)headRefresh
{
    self.start = 0;
    [self registerData];
}
- (void)footRefresh
{
    self.start += kListPageSize;
    [self registerData];
    
}

-(void)searchItemClick{
    
    [self.view endEditing:YES];
    [self.seachTextField resignFirstResponder];
    
    self.start = 0;
    [self registerData];
}


- (void)registerData{
    
    //    [self.view endEditing:YES];
    
    if ([[self.seachTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        [MBProgressHUD showError:@"输入用户昵称或手机号码"];
        [self.tableView.footer endRefreshing];
        return;
    }
    
    
    [YRHttpRequest searchFriendByString:self.seachTextField.text limit:@(kListPageSize) start:@(self.start) success:^(NSDictionary *data) {
        if (data.count==0) {
            [MBProgressHUD showError:@"没有更多的搜索结果"];
        }
        NSArray  *array =  [RRZCommendFriend mj_objectArrayWithKeyValuesArray:data];
        
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
    } failure:^(NSString *error) {
        
    }];
 
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    self.start = 0;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.seachTextField endEditing:YES];
    [self registerData];
    
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RRZAddressCommendFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:addressFriendCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RRZCommendFriend *item = self.friends[indexPath.row];
    cell.items = item;
    cell.friendDelegate = self;
    
    NSString *name = [NSString stringWithFormat:@"%@",item.custNname];
      NSRange range = [name rangeOfString:self.seachTextField.text options:NSCaseInsensitiveSearch];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:name];
    [attr addAttributes:@{NSForegroundColorAttributeName: Global_Color} range:range];
    cell.titleLabel.attributedText = attr;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    RRZCommendFriend *model = self.friends[indexPath.row];
    YRAdListUserInfoController *userInfo = [[YRAdListUserInfoController alloc]init];
    userInfo.searchModel = model;
    userInfo.custId = model.custId;
    [self.navigationController pushViewController:userInfo animated:YES];

}

-(void)listNewFriendCellAddFriend:(RRZCommendFriend *)item{
    
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
            item.relation = @"1";
        }else if ([data[@"relation"] integerValue]==2){
            message = @"用户不存在";
        }else if ([data[@"relation"] integerValue]==3){
            message = @"添加好友成功";
            item.relation = @"1";
        }
         [self.tableView reloadData];
        [MBProgressHUD showError:message];
    } failure:^(NSString *error) {
        [MBProgressHUD showError:error];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSMutableArray *)friends
{
    if (!_friends) {
        _friends = [[NSMutableArray alloc]init];
    }
    return _friends;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
