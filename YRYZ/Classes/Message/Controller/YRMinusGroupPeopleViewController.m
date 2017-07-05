//
//  YRMinusGroupPeopleViewController.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/18.
//  Copyright © 2016年 yryz. All rights reserved.
//  消息-->移除群成员

#import "YRMinusGroupPeopleViewController.h"
#import "YRGroupMinusCell.h"
#import "SDContactsSearchResultController.h"
#import "YRAdListItem.h"
#import "RRZAdListRegardMeController.h"
#import "RRZAdListMyRegardViewController.h"
#import "YRAdListUserInfoController.h"
#import "SPKitExample.h"
#import "YRRemovePersonModel.h"
#import "YRGroupMemberViewController.h"
//#import "IQKeyboardManager.h"

static NSString *yrGroupMinusCellIdentifier = @"yrGroupMinusCellIdentifier";

@interface YRMinusGroupPeopleViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate,UIActionSheetDelegate>
/** 搜索*/
@property (strong, nonatomic) UISearchController        *searchC;
/** tableView*/
@property (strong, nonatomic) UITableView               *tableView;
@property (nonatomic, strong) NSMutableArray            *sectionTitlesArray;
@property (strong, nonatomic) NSMutableArray            *nFriends;
/** 搜索过滤item数组*/
@property (strong, nonatomic) NSMutableArray            *filterItems;
/** 原始好友列表*/
@property (strong, nonatomic) NSMutableArray            *friends;
@property (strong, nonatomic) UILabel                   *footLabel;


@end

@implementation YRMinusGroupPeopleViewController

- (NSMutableArray *)nFriends{
    if (!_nFriends) {
        _nFriends = [NSMutableArray array];
    }
    return _nFriends;
}

#pragma mark - init
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(self.searchC.active){
        self.searchC.active = NO;
        [self.searchC.searchBar removeFromSuperview];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [IQKeyboardManager sharedManager].enable = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群成员";
//    [IQKeyboardManager sharedManager].enable = NO;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加群成员" style:UIBarButtonItemStylePlain target:self action:@selector(addGroupPersonAction)];
    [self setupSearchController];
    [self registerData];
}

/**添加群成员*/
- (void)addGroupPersonAction{
    
    YRGroupMemberViewController *groupMemberVc = [[YRGroupMemberViewController alloc] init];
    groupMemberVc.title = @"选择联系人";
    groupMemberVc.tribe = self.tribe;
    groupMemberVc.dataSource = self.dataSource;
    groupMemberVc.isAddPerson = YES;
    [self.navigationController pushViewController:groupMemberVc animated:YES];

}


-(void)setupSearchController{
    
    self.searchC = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchC.searchResultsUpdater = self;
    self.searchC.dimsBackgroundDuringPresentation = NO;
    self.searchC.hidesNavigationBarDuringPresentation = YES;
    self.searchC.searchBar.frame = CGRectMake(self.searchC.searchBar.frame.origin.x, self.searchC.searchBar.frame.origin.y, self.searchC.searchBar.frame.size.width, 44.0);
    self.searchC.searchBar.placeholder = @"搜索关键字";
    self.searchC.searchBar.barTintColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    self.searchC.searchBar.tintColor = Global_Color;
    self.searchC.searchBar.layer.borderWidth = 1;
    self.searchC.searchBar.layer.borderColor = RGB_COLOR(245, 245, 245).CGColor;
    
    self.searchC.searchBar.delegate = self;
    self.searchC.delegate = self;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    self.tableView.backgroundColor = RGB_COLOR(245, 245, 245);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView  setSeparatorLineZero];
    self.tableView.tableHeaderView = self.searchC.searchBar;
    self.tableView.rowHeight = 56.f;
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];  //设置索引文字的颜色
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionHeaderHeight = 25;
    [self.view addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 66, 0);
    [self.tableView setExtraCellLineHidden];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRGroupMinusCell class]) bundle:nil] forCellReuseIdentifier:yrGroupMinusCellIdentifier];
}

-(void)setupTableFootView{
    
    self.footLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    self.footLabel.text = [NSString stringWithFormat:@"共 %ld 位联系人",self.friends.count];
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
    for (YRRemovePersonModel *item in self.friends) {
        NSUInteger sectionIndex;
        if (item.displayName.length>1) {
            sectionIndex = [collation sectionForObject:item collationStringSelector:@selector(displayName)];
        }else{
            sectionIndex = [collation sectionForObject:item collationStringSelector:@selector(nickName)];
        }
        [newSectionArray[sectionIndex] addObject:item];
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    self.sectionTitlesArray = [NSMutableArray new];
    
    //排序
//    for (NSUInteger index=0; index < numberOfSections; index++) {
//        NSMutableArray *personsForSection = newSectionArray[index];
//        NSArray *sortedPersonsForSection = [collation sortedArrayFromArray:personsForSection collationStringSelector:@selector(custNname)];
//        newSectionArray[index] = sortedPersonsForSection;
//    }
    
    [newSectionArray enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
        if (arr.count == 0) {
            [temp addObject:arr];
        } else {
            [self.sectionTitlesArray addObject:[NSString stringWithFormat:@"    %@",[collation sectionTitles][idx]]];
        }
    }];
    
    [newSectionArray removeObjectsInArray:temp];
    
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
        YRGroupMinusCell *cell = [tableView dequeueReusableCellWithIdentifier:yrGroupMinusCellIdentifier];
        YRRemovePersonModel *item = self.filterItems[indexPath.row];
        NSString *name;
        if (item.displayName) {
            name = item.displayName;
        }else{
            name = item.nickName;
        }
        NSRange range = [name rangeOfString:self.searchC.searchBar.text];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:name];
        [attr addAttributes:@{NSForegroundColorAttributeName: Global_Color} range:range];
        cell.nameLab.attributedText = attr;
        if (item.avatar) {
            cell.headImg.image = item.avatar;
        }else{
            cell.headImg.image = [UIImage imageNamed:@"yr_user_defaut"];
        }
        return cell;
    }else{
        NSUInteger section = indexPath.section;
        NSUInteger row = indexPath.row;
        YRRemovePersonModel *item = self.nFriends[section][row];
        YRGroupMinusCell *cell = [tableView dequeueReusableCellWithIdentifier:yrGroupMinusCellIdentifier];
        if (item.displayName) {
            cell.nameLab.text = item.displayName;
        }else{
            cell.nameLab.text = item.nickName;
        }
        if (item.avatar) {
            cell.headImg.image = item.avatar;
        }else{
            cell.headImg.image = [UIImage imageNamed:@"yr_user_defaut"];
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


- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (self.searchC.active) {
        return nil;
    }else{
        return self.sectionTitlesArray;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.searchC.active) {
        
        YRRemovePersonModel *item = self.filterItems[indexPath.row];

        YRAdListUserInfoController *userInfoVc = [[YRAdListUserInfoController alloc] init];
        userInfoVc.custId = item.personId;
        userInfoVc.isFriend = YES;
        [self.navigationController pushViewController:userInfoVc animated:YES];
        
    }else{
        NSUInteger section = indexPath.section;
        NSUInteger row = indexPath.row;
        YRRemovePersonModel *item = self.nFriends[section][row];
        YRAdListUserInfoController *userInfoVc = [[YRAdListUserInfoController alloc] init];
        userInfoVc.custId = item.personId;
        userInfoVc.isFriend = YES;
        [self.navigationController pushViewController:userInfoVc animated:YES];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            cancel.titleLabel.font = [UIFont systemFontOfSize:16];
        }
    }
}

#pragma mark - UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = [self.searchC.searchBar text];
    
    self.filterItems =[[NSMutableArray alloc]init];
    
    for(YRRemovePersonModel *item in self.friends)
    {
        NSString *name = item.nickName;
        if (!name) {
            name = @"";
        }
        NSString *notes = item.displayName;
        if (!notes) {
            notes = @"";
        }
        NSString *phone = item.custPhone;
        if (!phone) {
            phone = @"";
        }
        
        if([name rangeOfString:searchString].location != NSNotFound || [notes rangeOfString:searchString].location != NSNotFound || [phone rangeOfString:searchString].location != NSNotFound)
        {
            [self.filterItems addObject:item];
        }
    }
    
    [self.tableView reloadData];
    [self setupTableFootView];
}



#pragma mark - 网络请求
-(void)registerData{
    
        [self.friends removeAllObjects];
        [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YWTribeMember *tribeMember = obj;
            YWProfileItem *item = [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService] getProfileForPerson:tribeMember withTribe:nil];
            YRRemovePersonModel *model = [[YRRemovePersonModel alloc] init];
            model.displayName = item.displayName;
            model.nickName = tribeMember.nickname;
            model.personId = tribeMember.personId;
            model.avatar = item.avatar;
            [self.friends addObject:model];
            
        }];
            [self setUpTableSection];
            [self setupTableFootView];
    
            [self.tableView reloadData];
    
}

#pragma mark - lazy
-(NSMutableArray *)friends{
    if (!_friends) {
        _friends = @[].mutableCopy;
    }
    return _friends;
}
- (void)willPresentSearchController:(UISearchController *)searchController{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    self.navigationController.navigationBar.hidden = NO;
}


// iOS8.0之前可用
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet{
    for (UIView *view in actionSheet.subviews) {
        UIButton *btn = (UIButton *)view;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        if([[btn titleForState:UIControlStateNormal] isEqualToString:@"取消"]){
            [btn setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:RGB_COLOR(0, 121, 255) forState:UIControlStateNormal];
        }
    }
}


@end
