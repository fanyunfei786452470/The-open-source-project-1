//
//  YRMobilePhoneContactController.m
//  YRYZ
//
//  Created by Sean on 16/8/19.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRMobilePhoneContactController.h"
#import "AddressBook.h"
//#import "User.h"
//#import "Person.h"
#import "YRPhoneContactCell.h"

#import "YRAddressListCell.h"

#import "YRNoPermissionsView.h"

#import "RRZGoodFriendItem.h"
#import "YRYYCache.h"
#import <MessageUI/MessageUI.h>
@interface YRMobilePhoneContactController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate,MFMessageComposeViewControllerDelegate>

// 搜索用的字符串
@property (nonatomic, copy) NSString *filterString;

/** 搜索*/
@property (strong, nonatomic) UISearchController        *searchC;

/** 搜索过滤item数组*/
@property (strong, nonatomic) NSMutableArray            *filterItems;

/**所有数据的数组   单条*/
@property (nonatomic,strong) NSMutableArray             *allFriendInfo;
/**所有数据模型*/
@property (nonatomic,strong) NSMutableArray             *friends;

@property (nonatomic,strong) NSMutableArray             *sectionTitlesArray;
//二维数组,装模型
@property (nonatomic,strong) NSMutableArray             *nFriends;

@property (nonatomic,strong) UITableView                *table;
//是否有权限
@property (nonatomic,assign) BOOL                       isPermissions;

@property (nonatomic,strong) NSMutableArray *focusArray;
@end

@implementation YRMobilePhoneContactController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"手机联系人";
    
    AddressBook *add = [[AddressBook alloc]init];
    
    @weakify(self);
    add.info = ^(BOOL isYes,NSArray *allInfo){
        
        @strongify(self);
        if (isYes&&allInfo.count>0) {
            //第一个是通讯录姓名,第二个是通讯录手机号
            NSArray *nameAry = allInfo[0];
            DLog(@"通讯录姓名：%@",nameAry);
          
           
            NSArray *phoneAry = allInfo[1];
            DLog(@"%@",phoneAry);
            for (int i = 0; i<nameAry.count; i++) {
                
                NSString *number = phoneAry[i];
                if ([number isEqualToString:[YRUserInfoManager manager].currentUser.custPhone]) {
                    continue;
                }
                if([number isMinePhoneNumber]){
                    RRZGoodFriendItem *per = [[RRZGoodFriendItem alloc]init];
                    per.custNname = nameAry[i];
                    per.custPhone = phoneAry[i];
                    [self.friends addObject:per];
                    NSString *friendInfo = [NSString stringWithFormat:@"%@ (%@)",per.custNname,per.custPhone];
                    [self.allFriendInfo addObject:friendInfo];
                }
            }
            self.isPermissions = YES;
            [self matchingFriend];
            [self loadData];
            [self configUI];
        }
        else{
            [self NoPermissionsToAddressBook];
            self.isPermissions = NO;
        }
    };
    
    [add readAllPeoplesNumAndName];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchC.active) {
        self.searchC.active = NO;
        [self.searchC.searchBar removeFromSuperview];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[YRYYCache share].yyCache removeObjectForKey:@"myFocusOnModel"];
    [[YRYYCache share].yyCache setObject:self.focusArray forKey:@"myFocusOnModel"];
}
- (void)matchingFriend{
    self.focusArray = [[NSMutableArray alloc]initWithArray:(NSArray *)[[YRYYCache share].yyCache objectForKey:@"myFocusOnModel"]];
    
    [self.friends enumerateObjectsUsingBlock:^(RRZGoodFriendItem *phone, NSUInteger idx1, BOOL * _Nonnull stop1) {
        phone.relation = @"100";
        [self.focusArray enumerateObjectsUsingBlock:^(RRZGoodFriendItem * focus, NSUInteger idx2, BOOL * _Nonnull stop2) {
           
            if ([phone.custPhone isEqualToString:focus.custPhone]) {
                NSString *name = focus.nameNotes.length>0?(focus.nameNotes):(focus.custNname);
                phone.custNname = [NSString stringWithFormat:@"%@(%@)",phone.custNname,name];
                phone.custImg = focus.custImg;
                phone.relation = focus.relation;
                phone.custSignature = focus.custSignature;
                phone.custId = focus.custId;
//                self.friends[idx1] = focus;
                *stop2 = YES;
            }
        }];
    }];
    
  /*  for (int i = 0; i <self.friends.count; i++) {
        RRZGoodFriendItem *phone = self.friends[i];
        phone.relation = @"100";
        for (int j = 0; j<focusArray.count; j++) {
            RRZGoodFriendItem * focus = focusArray[j];
            if ([phone.custPhone isEqualToString:focus.custPhone]) {
                NSString *name = focus.nameNotes.length>0?(focus.nameNotes):(focus.custNname);
                phone.custNname = [NSString stringWithFormat:@"%@(%@)",phone.custNname,name];
                phone.custImg = focus.custImg;
                phone.relation = focus.relation;
                phone.custSignature = focus.custSignature;
                DLog(@"%@",focus.custPhone);
                break;
            }
        }
    }*/
    
}

- (void)configUI{
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [table registerNib:[UINib nibWithNibName:@"YRPhoneContactCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
    [table registerNib:[UINib nibWithNibName:NSStringFromClass([YRAddressListCell class]) bundle:nil] forCellReuseIdentifier:@"YRAddressListCellID"];
    
    _table = table;
    [self.view addSubview:table];
    
    [self tableConfigHeaderAndFooter:table];
}
- (void)tableConfigHeaderAndFooter:(UITableView *)table{
    
    self.searchC = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchC.searchResultsUpdater = self;
    self.searchC.dimsBackgroundDuringPresentation = NO;
    self.searchC.hidesNavigationBarDuringPresentation = YES;
//    self.searchC.searchBar.frame = CGRectMake(self.searchC.searchBar.frame.origin.x, self.searchC.searchBar.frame.origin.y, self.searchC.searchBar.frame.size.width, 44.0);
    
    self.searchC.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    self.searchC.searchBar.placeholder = @"搜索关键字";
    self.searchC.searchBar.barTintColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    self.searchC.searchBar.tintColor = Global_Color;
//    self.searchC.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchC.searchBar.layer.borderWidth = 1;
    self.searchC.searchBar.layer.borderColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1].CGColor;
    
//    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 44)];
//    headView.layer.borderColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1].CGColor;
//    headView.layer.borderWidth = 1;
//    headView.backgroundColor = RGB_COLOR(245, 245, 245);
//    [headView addSubview:self.searchC.searchBar];
    
    self.searchC.searchBar.delegate = self;
    self.searchC.delegate = self;
    
    table.tableHeaderView = self.searchC.searchBar;
    table.sectionIndexColor = [UIColor lightGrayColor];  //设置索引文字的颜色
    table.sectionIndexBackgroundColor = [UIColor clearColor];
    table.backgroundColor = RGB_COLOR(238, 238, 238);
    [self setupTableFootView];
    
}
- (void)setupTableFootView{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    label.text = [NSString stringWithFormat:@"共 %ld 位联系人",self.friends.count];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    self.table.tableFooterView = label;
    if (self.searchC.active) {
        label.hidden = YES;
    }else{
        label.hidden = NO;
    }
}

- (void)loadData{
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //create a temp sectionArray
    NSUInteger numberOfSections = [[collation sectionTitles] count];
    
    NSMutableArray *newSectionArray = [[NSMutableArray alloc]init];
    
    for (NSUInteger index = 0; index < numberOfSections; index++) {
        [newSectionArray addObject:[[NSMutableArray alloc]init]];
    }
    
    
    
    // insert Persons info into newSectionArray
    for (RRZGoodFriendItem *item in self.friends) {
        
        NSUInteger sectionIndex;
        if (item.nameNotes.length>1){
          sectionIndex = [collation sectionForObject:item collationStringSelector:@selector(nameNotes)];  //备注名
        }else{
           sectionIndex = [collation sectionForObject:item collationStringSelector:@selector(custNname)];  //备注名
        }
        [newSectionArray[sectionIndex] addObject:item];
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    self.sectionTitlesArray = [NSMutableArray new];
    
    //排序
    for (NSUInteger index=0; index < numberOfSections; index++) {
        NSMutableArray *personsForSection = newSectionArray[index];
        NSArray *sortedPersonsForSection = [collation sortedArrayFromArray:personsForSection collationStringSelector:@selector(custNname)];
        newSectionArray[index] = sortedPersonsForSection;
    }
    
    [newSectionArray enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
        if (arr.count == 0) {
            [temp addObject:arr];
        } else {
            [self.sectionTitlesArray addObject:[collation sectionTitles][idx]];
        }
    }];
    
    [newSectionArray removeObjectsInArray:temp];
    self.nFriends = newSectionArray;
    
}

#pragma mark --- 重写 filterString的set方法
//- (void)setFilterString:(NSString *)filterString
//{
//    if ([filterString isEqualToString:@" "]) {
//        [self.table reloadData];
//        return;
//    }
//    if (self.searchC.active) {
//         _filterString = filterString;
//        if ([filterString containsOnlyNumbers]) {
//            if (filterString.length<11) {
//                
//            }else{
//                NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"self contains %@", filterString];
//                
//                self.filterItems = (NSMutableArray *)[self.allFriendInfo filteredArrayUsingPredicate:filterPredicate];
//            }
//        }else{
//            // 如果搜索字符串为空 设置结果数组
//            if (!filterString || filterString.length <= 0) {
//                self.filterItems = [NSMutableArray array];
//            } else {
//                NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"self contains %@", filterString];
//                self.filterItems = (NSMutableArray *)[self.allFriendInfo filteredArrayUsingPredicate:filterPredicate];
//            }
//        }
//        [self.table reloadData];
//        [self setupTableFootView];
//    }
//}
#pragma mark ---- UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = [self.searchC.searchBar text];
    self.filterItems =[[NSMutableArray alloc]init];
    if ([searchString isEqualToString:@" "]||[searchString isEqualToString:@""]) {
        
    }else{
        for(RRZGoodFriendItem *item in self.friends)
        {
            NSString *name = item.custNname;
            if (!name) {
                name = @"";
            }
            NSString *notes = item.nameNotes;
            if (!notes) {
                notes = @"";
            }
            NSString *phone = item.custPhone;
            if (!phone) {
                phone = @"";
            }
            if([name rangeOfString:searchString].location != NSNotFound || [notes rangeOfString:searchString].location != NSNotFound || [phone isEqualToString:searchString])
            {
                [self.filterItems addObject:item];
            }
        }
    }
    [self.table reloadData];
    [self setupTableFootView];
}

- (void)willPresentSearchController:(UISearchController *)searchController{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark --- tableViewDelegate
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.searchC.active) {
        return  1;
    }
    
    return self.sectionTitlesArray.count;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchC.active) {
        return self.filterItems.count;
    }
    return [self.nFriends[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.searchC.active) {
//        YRAddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YRAddressListCellID"];
//        NSString *item = self.filterItems[indexPath.row];
//        NSRange range = [item rangeOfString:self.searchC.searchBar.text];
//        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:item];
//        [attr addAttributes:@{NSForegroundColorAttributeName: Global_Color} range:range];
//        cell.nameLabel.attributedText = attr;
//        [cell.iconImage setImageWithURL:[NSURL URLWithString:[NSString headImageUrl:item]] placeholder:[UIImage defaultHead]];
//        return cell;
        
        YRPhoneContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
        RRZGoodFriendItem *per = self.filterItems[indexPath.row];
        cell.isFocus.userInteractionEnabled = YES;
        cell.addLabel.hidden = YES;
        
        if ([per.relation integerValue]==1) {
            cell.isFocus.backgroundColor = [UIColor clearColor];
            [cell.isFocus setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.isFocus setTitle:@"已是好友" forState:UIControlStateNormal];
            cell.isFocus.userInteractionEnabled = NO;
        }else if ([per.relation integerValue]==0){
            cell.isFocus.backgroundColor = [UIColor clearColor];
            [cell.isFocus setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.isFocus setTitle:@" " forState:UIControlStateNormal];
            cell.addLabel.text = @"等待对方同意";
            cell.addLabel.hidden = NO;
            cell.isFocus.userInteractionEnabled = NO;
        }else{
            cell.isFocus.backgroundColor = [UIColor themeColor];
            [cell.isFocus setTitle:@"加关注" forState:UIControlStateNormal];
            [cell.isFocus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            @weakify(self);
            cell.choose = ^(BOOL icClick){
                @strongify(self);
                if (icClick) {
                    [self.searchC.view endEditing:YES];
                    [self cellBtnClick:per];
                }
            };
        }
        NSRange range = [per.custNname rangeOfString:self.searchC.searchBar.text];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:per.custNname];
        [attr addAttributes:@{NSForegroundColorAttributeName: Global_Color} range:range];
        cell.userName.attributedText = attr;
        [cell.userImage setImageWithURL:[NSURL URLWithString:per.custImg] placeholder:[UIImage defaultHead]];
        cell.userName.text = per.custNname;
        cell.subTitle.text = per.custSignature;
         return cell;

    }else{
        YRPhoneContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
        RRZGoodFriendItem *per = self.nFriends[indexPath.section][indexPath.row];
        cell.addLabel.hidden = YES;
        cell.isFocus.userInteractionEnabled = YES;
        
        if ([per.relation integerValue]==1) {
            cell.isFocus.backgroundColor = [UIColor clearColor];
             [cell.isFocus setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.isFocus setTitle:@"已是好友" forState:UIControlStateNormal];
             cell.isFocus.userInteractionEnabled = NO;
        }else if ([per.relation integerValue]==0){
            cell.isFocus.backgroundColor = [UIColor clearColor];
             [cell.isFocus setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.isFocus setTitle:@" " forState:UIControlStateNormal];
            cell.addLabel.text = @"等待对方同意";
            cell.addLabel.hidden = NO;
            cell.isFocus.userInteractionEnabled = NO;
        }else{
            cell.isFocus.backgroundColor = [UIColor themeColor];
            [cell.isFocus setTitle:@"加关注" forState:UIControlStateNormal];
            [cell.isFocus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            @weakify(self);
            cell.choose = ^(BOOL icClick){
                 @strongify(self);
                if (icClick) {
                   [self.searchC.view endEditing:YES];
                    [self cellBtnClick:per];
                }
            };
        }
        [cell.userImage setImageWithURL:[NSURL URLWithString:per.custImg] placeholder:[UIImage defaultHead]];
        cell.userName.text = per.custNname;
        cell.subTitle.text = per.custSignature;
        return cell;
    }
}

- (void)cellBtnClick:(RRZGoodFriendItem *)model{
    [MBProgressHUD showMessage:@""];
    self.table.userInteractionEnabled = NO;
    [YRHttpRequest addFriendFromPhoneNumber:model.custPhone success:^(NSDictionary *data) {
        [model setValuesForKeysWithDictionary:data];
        NSString *error;
        [MBProgressHUD hideHUD];
        DLog(@"%@",data);
        if ([data[@"relation"] integerValue]==-1) {
            [self noRegisWithModle:model];
        }
        else if ([data[@"relation"] integerValue]==1){
            error = @"关注成功";
            model.relation = @"0";
            [self fouceModel:model];
            [self.table reloadData];
            self.table.userInteractionEnabled = YES;
            [MBProgressHUD showError:error toView:self.view];
        }
        else if ([data[@"relation"] integerValue]==3){
            error = @"关注成功";
             [self fouceModel:model];
            [self.table reloadData];
            model.relation=@"1";
            [MBProgressHUD showError:error toView:self.view];
            self.table.userInteractionEnabled = YES;
        }
        
    } failure:^(NSString *error) {
         [MBProgressHUD hideHUD];
        [MBProgressHUD showError:error toView:self.view];
    }];
}

- (void)noRegisWithModle:(RRZGoodFriendItem *)model{
    YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"该用户还不是悠然一指用户" cancelButtonText:@"取消" confirmButtonText:@"邀请注册"];
    
    alertView.addCancelAction = ^{
        self.table.userInteractionEnabled = YES;
    };
    alertView.addConfirmAction = ^{
        
        MFMessageComposeViewController *vc =[[MFMessageComposeViewController alloc] init];
        vc.messageComposeDelegate = self;
        vc.recipients = @[model.custPhone];
        [vc.navigationBar setTranslucent:YES];
        
        vc.body = [NSString stringWithFormat:@"【我在使用好看、好玩又能的奖励的“悠然一指”APP，现介绍给你并邀请你加入“悠然一指”，大家一起看，一起玩，一起赚。悠然一指APP下载地址：%@   记得加我为好友哦！】",APPDOWNLOAD];
        
        [self presentViewController:vc animated:YES completion:^{
            self.table.userInteractionEnabled = YES;
        }];
        
    };
    [alertView show];

}
#pragma ---mark  messageComposeDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)fouceModel:(RRZGoodFriendItem *)model{

    [self.focusArray addObject:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (self.searchC.active) {
    //        return 44;
    //    }
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.searchC.active) {
//        RRZGoodFriendItem *per = self.filterItems[indexPath.row];
//        self.searchC.active = NO;
//        if (per.custId) {
//            [self pushUserInfoViewController:per.custId withIsFriend:YES];
//        }
    }else{
//        RRZGoodFriendItem *per = self.nFriends[indexPath.section][indexPath.row];
//        if (per.custId) {
//            [self pushUserInfoViewController:per.custId withIsFriend:YES];
//        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.searchC.active&&section==0) {
        return 15;
    }else{
        return 25;
    }
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (self.searchC.active) {
        return nil;
    }
    return self.sectionTitlesArray;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.searchC.active) {
        return nil;
    }
    return [self.sectionTitlesArray objectAtIndex:section];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.isPermissions) {
        self.searchC.active = NO;
    }else{
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            
            NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
//通讯录没有权限
- (void)NoPermissionsToAddressBook{
    
    YRNoPermissionsView *view = [[[NSBundle mainBundle]loadNibNamed:@"YRNoPermissionsView" owner:nil options:nil] lastObject];
//    view.backgroundColor = [UIColor redColor];
    view.frame = self.view.bounds;
//    view.backgroundColor = [UIColor whiteColor];
    DLog(@"没有权限");
    [self.view addSubview:view];
}
- (NSMutableArray *)friends{
    if (!_friends) {
        _friends = [[NSMutableArray alloc]init];
    }
    return _friends;
}
- (NSMutableArray *)sectionTitlesArray{
    if (!_sectionTitlesArray) {
        _sectionTitlesArray = [[NSMutableArray alloc]init];
    }
    return _sectionTitlesArray;
}
- (NSMutableArray *)allFriendInfo
{
    if (!_allFriendInfo) {
        _allFriendInfo = [[NSMutableArray alloc]init];
    }
    return _allFriendInfo;
}
-(void)dealloc{
    
    DLog(@"手机联系人页面死掉了");
//    
//    [self.searchC.searchBar removeFromSuperview];
//    [self.table.tableHeaderView removeAllSubviews];
//    [self.table removeAllSubviews];
//    self.searchC = nil;
    
}
@end








































