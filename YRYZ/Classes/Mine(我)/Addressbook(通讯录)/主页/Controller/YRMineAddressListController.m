//
//  YRMineAddressListController.m
//  YRYZ
//
//  Created by Sean on 16/8/31.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRMineAddressListController.h"
#import "YRAddressListCell.h"
#import "SDContactsSearchResultController.h"
#import "YRAdListItem.h"
#import "RRZAdListRegardMeController.h"
#import "RRZAdListMyRegardViewController.h"
#import "YRAdListUserInfoController.h"
#import "RRZAddressAddFriendController.h"
#import "RRZAdListBlackListController.h"
#import "RRZGoodFriendItem.h"
#import "YRMineFriendCell.h"
#import "YRGroupListViewController.h"

#import "SPKitExample.h"
static NSString *cellID = @"YRAddressListCellID";
@interface YRMineAddressListController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate>
/** 搜索*/
@property (strong, nonatomic) UISearchController        *searchC;
/** tableView*/
@property (strong, nonatomic) UITableView               *tableView;
@property (nonatomic, strong) NSMutableArray            *sectionTitlesArray;
@property (strong, nonatomic) NSArray                   *nFriends;
/** 搜索过滤item数组*/
@property (strong, nonatomic) NSMutableArray            *filterItems;
/** 原始好友列表*/
@property (strong, nonatomic) NSMutableArray            *friends;
@property (strong, nonatomic) UILabel                   *footLabel;
//我的关注,相互关注的label
@property (nonatomic,strong) UILabel *myFriendFocus;

//我关注的model数组
@property (nonatomic,strong) NSMutableArray *myFocusonArray;

@property (nonatomic,strong) UILabel        *meagess;

@end

@implementation YRMineAddressListController

#pragma mark - init
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(self.searchC.active){
        self.searchC.active = NO;
        [self.searchC.searchBar removeFromSuperview];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.newMessage = 5;
//    self.newCount = 3;
    _myFriendFocus = [[UILabel alloc]init];
    _myFriendFocus.text = @"  我的好友";
    _myFriendFocus.font = [UIFont systemFontOfSize:15];
    _myFriendFocus.textColor = RGB_COLOR(114, 114, 144);
    
    [self setTitle:@"通讯录"];
     [self setRightNavButtonWithTitle:@"添加好友"];
    [self setupSearchController];
    NSMutableArray *model = (NSMutableArray *)[[YRYYCache share].yyCache objectForKey:@"myFriendModel"];
    self.friends = model;
    
    self.myFocusonArray = (NSMutableArray *)[[YRYYCache share].yyCache objectForKey:@"myFocusOnModel"];
    
    NSMutableArray *msgArr = [NSMutableArray array];
    msgArr = (NSMutableArray *)[[YRYYCache share].yyCache objectForKey:MsgFollow_Notification_Key]?(NSMutableArray *)[[YRYYCache share].yyCache objectForKey:MsgFollow_Notification_Key]:@[].mutableCopy;
    self.newCount = msgArr.count;
    
    
    [self setUpTableSection];
    [self setupTableFootView];
    [self.tableView reloadData];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMsgNotification:) name:@"sendMsgNotification" object:nil];
    //    @weakify(self);
    //    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:SetupAddressListNotification_key object:nil] subscribeNext:^(NSNotification *notification) {
    //        @strongify(self);
    //        [self registerData];
    //    }];
//    
//    [self setUpTableSection];
//    [self setupTableFootView];
}

- (void)rightNavAction:(UIButton *)button{
    
    RRZAddressAddFriendController *addFriendController = [[RRZAddressAddFriendController alloc]init];
    [self.navigationController pushViewController:addFriendController animated:YES];
}
- (void)sendMsgNotification:(NSNotification *)notification{
    
    NSMutableArray *msgArr = [NSMutableArray array];
    msgArr = (NSMutableArray *)[[YRYYCache share].yyCache objectForKey:MsgFollow_Notification_Key]?(NSMutableArray *)[[YRYYCache share].yyCache objectForKey:MsgFollow_Notification_Key]:@[].mutableCopy;
    self.newCount = msgArr.count;
    
    [self.tableView reloadData];
}
-(void)setupSearchController{
    
    self.searchC = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchC.searchResultsUpdater = self;
    self.searchC.dimsBackgroundDuringPresentation = NO;
    self.searchC.hidesNavigationBarDuringPresentation = YES;
    self.searchC.searchBar.frame = CGRectMake(self.searchC.searchBar.frame.origin.x, self.searchC.searchBar.frame.origin.y, self.searchC.searchBar.frame.size.width, 44.0);
    self.searchC.searchBar.placeholder = @"搜索我的好友";
    self.searchC.searchBar.barTintColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    self.searchC.searchBar.tintColor = Global_Color;
    self.searchC.searchBar.layer.borderWidth = 1;
    self.searchC.searchBar.layer.borderColor = RGB_COLOR(245, 245, 245).CGColor;
    
    self.searchC.searchBar.delegate = self;
    self.searchC.delegate = self;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.tableView.backgroundColor = RGB_COLOR(245, 245, 245);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView  setSeparatorLineZero];
    self.tableView.tableHeaderView = self.searchC.searchBar;
    self.tableView.rowHeight = 50;
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];  //设置索引文字的颜色
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionHeaderHeight = 25;
    [self.view addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 66, 0);
    [self.tableView setExtraCellLineHidden];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRAddressListCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    [self.tableView registerClass:[YRMineFriendCell class] forCellReuseIdentifier:@"myCell"];
    
}

-(void)setupTableFootView{
    
    self.footLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    self.footLabel.text = [NSString stringWithFormat:@"共 %ld 位联系人",(long)self.friends.count];
    self.footLabel.font = [UIFont systemFontOfSize:15];
    self.footLabel.textAlignment = NSTextAlignmentCenter;
    self.footLabel.textColor = [UIColor lightGrayColor];
    self.tableView.tableFooterView = self.footLabel;
    if (self.searchC.active) {
        self.footLabel.hidden = YES;
    }else{
        self.footLabel.hidden = NO;
    }
}


-(void)setUpTableSection{
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //create a temp sectionArray
    NSUInteger numberOfSections = [[collation sectionTitles] count];
    NSMutableArray *newSectionArray = [[NSMutableArray alloc]init];
    for (NSUInteger index = 0; index < numberOfSections; index++) {
        [newSectionArray addObject:[[NSMutableArray alloc]init]];
    }
    
    // insert Persons info into newSectionArray
    for (YRAdListItem *item in self.friends) {
        NSUInteger sectionIndex;
        if (item.nameNotes.length) {
            sectionIndex = [collation sectionForObject:item collationStringSelector:@selector(nameNotes)];
        }else{
            sectionIndex = [collation sectionForObject:item collationStringSelector:@selector(custNname)];
        }
        [newSectionArray[sectionIndex] addObject:item];
    }
    
    //sort the person of each section
    //    for (NSUInteger index=0; index < numberOfSections; index++) {
    //        NSMutableArray *personsForSection = newSectionArray[index];
    //        NSArray *sortedPersonsForSection = [collation sortedArrayFromArray:personsForSection collationStringSelector:@selector(custNname)];
    //        newSectionArray[index] = sortedPersonsForSection;
    //    }
    
    //排序
    for (NSUInteger index=0; index < numberOfSections; index++) {
        NSMutableArray *personsForSection = newSectionArray[index];
        NSArray *sortedPersonsForSection = [collation sortedArrayFromArray:personsForSection collationStringSelector:@selector(custNname)];
        newSectionArray[index] = sortedPersonsForSection;
    }
    
    
    NSMutableArray *temp = [NSMutableArray new];
    self.sectionTitlesArray = [NSMutableArray new];
    
    [newSectionArray enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
        if (arr.count == 0) {
            [temp addObject:arr];
        } else {
            [self.sectionTitlesArray addObject:[NSString stringWithFormat:@"    %@",[collation sectionTitles][idx]]];
        }
    }];
    
    [newSectionArray removeObjectsInArray:temp];
    
    NSMutableArray *operrationModels = [NSMutableArray new];
    NSArray *dicts = @[@{@"custNname" : @"关注我的", @"headPath" : @"yr_address_newFriend"},
                       @{@"custNname" : @"我关注的", @"headPath" : @"yr_address_regard"},
                       @{@"custNname" : @"群聊", @"headPath" : @"yr_address_group"},
//                       @{@"custNname" : @"黑名单", @"headPath" : @"yr_address_blackList"},
                       @{@"custNname" : @"我的好友", @"abc" : @"abc"}];
    
    for (NSDictionary *dic in dicts) {
        YRAdListItem *item = [YRAdListItem new];
        item.custNname = dic[@"custNname"];
        item.headPath = dic[@"headPath"];
        [operrationModels addObject:item];
    }
    
    [newSectionArray insertObject:operrationModels atIndex:0];
    [self.sectionTitlesArray insertObject:@"" atIndex:0];
    self.nFriends = newSectionArray;
}


#pragma mark - tableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchC.active){
        return 1;
    }else{
        return self.sectionTitlesArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchC.active){
        return self.filterItems.count;
    }else{
        NSInteger count = [self.nFriends[section] count];
        return count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchC.active) {
        YRMineFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[YRMineFriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
        }
        YRAdListItem *item = self.filterItems[indexPath.row];
        NSString *name;
        if (item.nameNotes.length>1) {
            
            name = [NSString stringWithFormat:@"%@",item.nameNotes];
        }else{
            name = [NSString stringWithFormat:@"%@",item.custNname];
        }
        NSRange range = [name rangeOfString:self.searchC.searchBar.text];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:name];
        [attr addAttributes:@{NSForegroundColorAttributeName: Global_Color} range:range];
        cell.textLabel.attributedText = attr;
        [cell.imageView setImageWithURL:[NSURL URLWithString:item.custImg] placeholder:[UIImage defaultHead]];
        return cell;
    }else{
        NSUInteger section = indexPath.section;
        NSUInteger row = indexPath.row;
        YRAdListItem *item = self.nFriends[section][row];
        YRAddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (item.nameNotes.length>1) {
            cell.nameLabel.text = item.nameNotes;
        }else{
            cell.nameLabel.text = item.custNname;
        }
        if ([cell.nameLabel.text isEqualToString:@"我的好友"]) {
            self.myFriendFocus.frame = cell.bounds;
            cell.nameLabel.hidden = YES;
            [cell.contentView addSubview:self.myFriendFocus];
            cell.nameLabel.font = [UIFont titleFont15];
             cell.nameLabel.textColor = [UIColor grayColorOne];
        }else{
            cell.nameLabel.textColor = [UIColor wordColor];
            cell.nameLabel.font = [UIFont titleFont17];
        }
        
        if (indexPath.section == 0) {
            if (self.newCount>0&&indexPath.row==0) {
                cell.message.text = [NSString stringWithFormat:@"%ld",self.newCount];
                cell.message.hidden = NO;
            }else{
                cell.message.hidden = YES;
            }
            cell.neLabel.hidden = NO;
            cell.iconImage.image = [UIImage imageNamed:item.headPath];
            return cell;
        }else{
            YRMineFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[YRMineFriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
            }
            [cell.imageView setImageWithURL:[NSURL URLWithString:item.custImg] placeholder:[UIImage defaultHead]];
            if (item.nameNotes.length>0) {
                cell.textLabel.text = item.nameNotes;
            }else{
                cell.textLabel.text = item.custNname;
            }
            cell.textLabel.textColor = RGB_COLOR(60, 60, 60);
            return cell;
        }
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.searchC.active) {
        return nil;
    }else{
        return [self.sectionTitlesArray objectAtIndex:section];
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

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (self.searchC.active) {
        return nil;
    }else{
        return self.sectionTitlesArray;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isChat) {
        if (self.searchC.active) {
            YRAdListItem *item = self.filterItems[indexPath.row];
            DLog(@"%@",item.custNname);
            self.searchC.active = NO;
            YWPerson *person = [[YWPerson alloc] initWithPersonId:item.custId];
            [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithPerson:person fromNavigationController:self.navigationController];
        }else{
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    self.newCount = 0;
                    // 刷新一行
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                    [[NSNotificationCenter defaultCenter] postNotificationName:ClearNewFriendCount object:nil];
                    
                    RRZAdListRegardMeController *newGoodFriendVC = [[RRZAdListRegardMeController alloc]init];
                    [self.navigationController pushViewController:newGoodFriendVC animated:YES];
                    
                }else if (indexPath.row == 1){
                    RRZAdListMyRegardViewController *myRegardController = [[RRZAdListMyRegardViewController alloc]init];
                    myRegardController.friends = self.myFocusonArray;
                    [self.navigationController pushViewController:myRegardController animated:YES];
                    
                }else if (indexPath.row  == 2){
                    YRGroupListViewController *groupListVc = [[YRGroupListViewController alloc] init];
                    [self.navigationController pushViewController:groupListVc animated:YES];
                    
                }else if (indexPath.row == 3){
                    //                RRZAdListBlackListController *blackListController = [[RRZAdListBlackListController alloc]init];
                    //                [self.navigationController pushViewController:blackListController animated:YES];
                }
                //点击相互关注
                else if (indexPath.row == 4){
                    
                }
            }else{
                NSUInteger section = indexPath.section;
                NSUInteger row = indexPath.row;
                YRAdListItem *item = self.nFriends[section][row];
                YWPerson *person = [[YWPerson alloc] initWithPersonId:item.custId];
            [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithPerson:person fromNavigationController:self.navigationController];
            }
        }
    }else{
        if (self.searchC.active) {
            YRAdListItem *item = self.filterItems[indexPath.row];
            DLog(@"%@",item.custNname);
            self.searchC.active = NO;
            YRAdListUserInfoController *friendInfoViewController = [[YRAdListUserInfoController alloc]init];
            friendInfoViewController.isFriend = YES;
            friendInfoViewController.custId = item.custId;
            friendInfoViewController.item = item;
            [self.navigationController pushViewController:friendInfoViewController animated:YES];
        }else{
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    self.newCount = 0;
                    // 刷新一行
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                    [[NSNotificationCenter defaultCenter] postNotificationName:ClearNewFriendCount object:nil];
                    
                    RRZAdListRegardMeController *newGoodFriendVC = [[RRZAdListRegardMeController alloc]init];
                    [self.navigationController pushViewController:newGoodFriendVC animated:YES];
                    
                }else if (indexPath.row == 1){
                    RRZAdListMyRegardViewController *myRegardController = [[RRZAdListMyRegardViewController alloc]init];
                    myRegardController.friends = self.myFocusonArray;
                    [self.navigationController pushViewController:myRegardController animated:YES];
                    
                }else if (indexPath.row  == 2){
                    YRGroupListViewController *groupListVc = [[YRGroupListViewController alloc] init];
                    [self.navigationController pushViewController:groupListVc animated:YES];
                    
                }else if (indexPath.row == 3){
                    //                RRZAdListBlackListController *blackListController = [[RRZAdListBlackListController alloc]init];
                    //                [self.navigationController pushViewController:blackListController animated:YES];
                }
                //点击相互关注
                else if (indexPath.row == 4){
                    
                }
            }else{
                NSUInteger section = indexPath.section;
                NSUInteger row = indexPath.row;
                YRAdListItem *item = self.nFriends[section][row];
                
                YRAdListUserInfoController *friendInfoViewController = [[YRAdListUserInfoController alloc]init];
                friendInfoViewController.isFriend = YES;
                //        friendInfoViewController.uid = item.uid;
                friendInfoViewController.custId = item.custId;
                friendInfoViewController.item = item;
                [self.navigationController pushViewController:friendInfoViewController animated:YES];
            }
        }
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            //            [cancel setTitle:@"搜索" forState:UIControlStateNormal];
            cancel.titleLabel.font = [UIFont systemFontOfSize:16];
            //            cancel.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, -8);
        }
    }
}

#pragma mark - UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = [self.searchC.searchBar text];
    
    self.filterItems =[[NSMutableArray alloc]init];
    if ([searchString isEqualToString:@" "]||[searchString isEqualToString:@""]) {
        
    }else{
        for(YRAdListItem *item in self.friends)
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
    [self.tableView reloadData];
    [self setupTableFootView];
}

- (void)willPresentSearchController:(UISearchController *)searchController{
    searchController.searchBar.placeholder = @"输入昵称、手机号或备注名";
    self.navigationController.navigationBar.hidden = YES;
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    self.navigationController.navigationBar.hidden = NO;
}
//- (void)didDismissSearchController:(UISearchController *)searchController{
//      searchController.active = NO;
//}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    [self registerData];
}
#pragma mark - 网络请求
-(void)registerData{
        //好友列表数据
        [YRHttpRequest getFriendListSuccessWithType:kFriends success:^(NSDictionary *info) {
            NSMutableArray *ary = [YRAdListItem mj_objectArrayWithKeyValuesArray:info];
           
                    self.friends = ary;
                    [[YRYYCache share].yyCache removeObjectForKey:@"myFriendModel"];
                    
                    [[YRYYCache share].yyCache setObject:self.friends forKey:@"myFriendModel"];

                    [self setUpTableSection];
                    [self setupTableFootView];
                    [self.tableView reloadData];
            
        } failure:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
            NSMutableArray *model = (NSMutableArray *)[[YRYYCache share].yyCache objectForKey:@"myFriendModel"];
            self.friends = model;
            [self setUpTableSection];
            [self setupTableFootView];
            [self.tableView reloadData];
        }];
    
    //我关注的数组
    [YRHttpRequest getFriendListSuccessWithType:kFocusOn success:^(NSDictionary *data) {
        
        self.myFocusonArray = [RRZGoodFriendItem mj_objectArrayWithKeyValuesArray:data];
        [[YRYYCache share].yyCache removeObjectForKey:@"myFocusOnModel"];
         [[YRYYCache share].yyCache setObject:self.myFocusonArray forKey:@"myFocusOnModel"];
        
    } failure:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
        
        self.myFocusonArray  = (NSMutableArray *)[[YRYYCache share].yyCache objectForKey:@"myFocusOnModel"];
    }];
    
}

#pragma mark - lazy
-(NSMutableArray *)friends{
    if (!_friends) {
        _friends = @[].mutableCopy;
    }
    return _friends;
}
- (NSMutableArray *)myFocusonArray
{
    if (!_myFocusonArray) {
        _myFocusonArray = @[].mutableCopy;
    }
    return _myFocusonArray;
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end




