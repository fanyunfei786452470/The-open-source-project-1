//
//  YRAddNewGroupViewController.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/9/9.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRAddNewGroupViewController.h"
#import "YRGroupMemberCell.h"
#import "SDContactsSearchResultController.h"
#import "YRAdListItem.h"
#import "RRZAdListRegardMeController.h"
#import "RRZAdListMyRegardViewController.h"
#import "YRAdListUserInfoController.h"
#import "SPKitExample.h"
//#import "IQKeyboardManager.h"

static NSString *yrGroupMemberCellIdentifier = @"yrAddGroupChatCellIdentifier";

@interface YRAddNewGroupViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate>

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

@property (strong,nonatomic) NSIndexPath                *seleteIndexPath;
@property (nonatomic,weak) UIButton                     *confirmBtn;
@property (nonatomic,strong) UIView                     *allSeleteView;

@end

@implementation YRAddNewGroupViewController
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
    
    [self setNavTitle];
    
    [self setupSearchController];
    
   if(self.infoId != nil && ![self.infoId isEqualToString:@""]){
       [self setConfirmView];
   }
    [self registerData];
}

/**添加群成员*/
- (void)addGroupChatAction{
    
    if(self.infoId != nil && ![self.infoId isEqualToString:@""]){
        
        [self.nFriends enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *arr = obj;
            
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YRAdListItem *item = obj;
                item.isSelete = YES;
            }];
        
    }];
        [self.tableView reloadData];
        self.confirmBtn.backgroundColor = [UIColor themeColor];

    }else{
        
        NSMutableArray *personArr = [NSMutableArray array];
        NSMutableArray *nameArr = [NSMutableArray array];
        [self.nFriends enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *arr = obj;
            
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YRAdListItem *item = obj;
                
                if (item.isSelete == YES) {
                    YWPerson *person = [[YWPerson alloc] initWithPersonId:item.custId];
                    [personArr addObject:person];
                    NSString *name;
                    if (![item.nameNotes isEqualToString:@""] && item.nameNotes!= nil) {
                        name = item.nameNotes;
                    }else{
                        name = item.custNname;
                    }
                    [nameArr addObject:name];
                }
            }];
            
        }];
        
    if (personArr.count == 0 || personArr == nil) {
        [MBProgressHUD showError:@"请选择群成员"];
    }else{
        NSString *groupName;
        if (nameArr.count == 1) {
            groupName = [NSString stringWithFormat:@"%@",nameArr[0]];
        }else if (nameArr.count == 2){
            groupName = [NSString stringWithFormat:@"%@、%@",nameArr[0],nameArr[1]];
        }else{
            groupName = [NSString stringWithFormat:@"%@、%@、%@",nameArr[0],nameArr[1],nameArr[2]];
        }
        
        YWTribeDescriptionParam *param = [[YWTribeDescriptionParam alloc] init];
        param.tribeName = groupName?groupName:@"yryz";
        param.tribeNotice = @"无";
        param.tribeType = YWTribeTypeMultipleChat;
        __weak __typeof(self) weakSelf = self;

        [MBProgressHUD showMessage:@"正在创建..." toView:self.view];
        [self.ywTribeService createTribeWithDescription:param completion:^(YWTribe *tribe, NSError *error) {
            
            if(error == nil) {
                
        [[self ywTribeService] inviteMembers:personArr
                                    toTribe:tribe.tribeId
                                completion:^(NSArray *members, NSString *tribeId, NSError *error) {
                                    [MBProgressHUD hideHUD];
                             if (!error) {
                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                    [MBProgressHUD showError:@"创建成功"];
                            }
                    }];
            }else {
                [MBProgressHUD showError:@"创建失败"];
                [MBProgressHUD hideHUD];
            }
        }];
    }
    }
}

- (void)setNavTitle{
    
    NSString *navTitle;
    if(self.infoId != nil && ![self.infoId isEqualToString:@""]){
        navTitle = @"全选";
    }else{
        navTitle = @"确定";
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:navTitle style:UIBarButtonItemStylePlain target:self action:@selector(addGroupChatAction)];
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

    CGFloat tabH;
    if(self.infoId != nil && ![self.infoId isEqualToString:@""]){
        tabH = SCREEN_HEIGHT- 50;
        
    }else{
        tabH = SCREEN_HEIGHT;
    }
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, tabH)];
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
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRGroupMemberCell class]) bundle:nil] forCellReuseIdentifier:yrGroupMemberCellIdentifier];
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
    for (YRAdListItem *item in self.friends) {
        NSUInteger sectionIndex;
        if (item.nameNotes.length>1) {
            sectionIndex = [collation sectionForObject:item collationStringSelector:@selector(nameNotes)];
        }else{
            sectionIndex = [collation sectionForObject:item collationStringSelector:@selector(custNname)];
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
        YRGroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:yrGroupMemberCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        YRAdListItem *item = self.filterItems[indexPath.row];
        NSString *name;
        
        if (![item.nameNotes isEqualToString:@""] && item.nameNotes!= nil) {
            name = item.nameNotes;
        }else{
            name = item.custNname;
        }

        if (item.isSelete) {
            cell.seleteBtn.selected = YES;
        }else{
            cell.seleteBtn.selected = NO;
        }
        
        NSRange range = [name rangeOfString:self.searchC.searchBar.text];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:name];
        [attr addAttributes:@{NSForegroundColorAttributeName: Global_Color} range:range];
        cell.nameLab.attributedText = attr;
      
        [cell.headerImg setImageWithURL:[NSURL URLWithString:item.custImg] placeholder:[UIImage defaultHead]];
        
        return cell;
        
    }else{
        
        NSUInteger section = indexPath.section;
        NSUInteger row = indexPath.row;
        YRAdListItem *item = self.nFriends[section][row];
        YRGroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:yrGroupMemberCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (![item.nameNotes isEqualToString:@""] && item.nameNotes!= nil) {
            cell.nameLab.text = item.nameNotes;
        }else{
            cell.nameLab.text = item.custNname;
        }
    
        if (item.isSelete) {
            cell.seleteBtn.selected = YES;
        }else{
            cell.seleteBtn.selected = NO;
        }
        
        [cell.headerImg setImageWithURL:[NSURL URLWithString:item.custImg] placeholder:[UIImage defaultHead]];
 
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
        YRAdListItem *item = self.filterItems[indexPath.row];
        if (item.isSelete) {
            item.isSelete = NO;
        }else{
            item.isSelete = YES;
        }
    }else{
        NSUInteger section = indexPath.section;
        NSUInteger row = indexPath.row;
        YRAdListItem *item = self.nFriends[section][row];
        if (item.isSelete) {
            item.isSelete = NO;
        }else{
            item.isSelete = YES;
        }
    }
    
    [self.tableView reloadData];
    
    if ([self opinionPersonIsSelete]) {
        self.confirmBtn.backgroundColor = [UIColor themeColor];
    }else{
        self.confirmBtn.backgroundColor = RGB_COLOR(245, 245, 245);
    }
}

//判断用户是否选择
- (BOOL)opinionPersonIsSelete{
    NSMutableArray *personArr = [NSMutableArray array];
    
    [self.nFriends enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *arr = obj;
        
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YRAdListItem *item = obj;
            
            if (item.isSelete == YES) {
  
                [personArr addObject:item];
            }
        }];
        
    }];
    if (personArr.count >0) {
        return YES;
    }else{
        return NO;
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
        
        if([name rangeOfString:searchString].location != NSNotFound || [notes rangeOfString:searchString].location != NSNotFound || [phone rangeOfString:searchString].location != NSNotFound)
        {
            [self.filterItems addObject:item];
        }
    }
    
    [self.tableView reloadData];
    [self setupTableFootView];
}

- (void)willPresentSearchController:(UISearchController *)searchController{
    self.allSeleteView.hidden = YES;
    searchController.searchBar.placeholder = @"输入昵称、手机号或备注名";
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 66, 0);
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    self.allSeleteView.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 66, 0);
}



//邀请转发全选
- (void)setConfirmView{
    
    _allSeleteView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50-64, kScreenWidth, 50)];
    _allSeleteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_allSeleteView];
    
    CALayer *lineLay = [CALayer layer];
    lineLay.frame = CGRectMake(0, 0, kScreenWidth, 1);
    lineLay.backgroundColor = RGB_COLOR(245, 245, 245).CGColor;
    [_allSeleteView.layer addSublayer:lineLay];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(SCREEN_WIDTH-90, 10, 70, 30);
    confirmBtn.layer.cornerRadius = 3.f;
    confirmBtn.clipsToBounds = YES;
    confirmBtn.backgroundColor = RGB_COLOR(245, 245, 245);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_allSeleteView addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    self.confirmBtn = confirmBtn;
    
}

//确定按钮
- (void)confirmAction{
    
    NSMutableArray *personArr = [NSMutableArray array];
//    NSMutableArray *nameArr = [NSMutableArray array];
    [self.nFriends enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *arr = obj;
        
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YRAdListItem *item = obj;
            
            if (item.isSelete == YES) {
                
                [personArr addObject:item.custId];
                
//                YWPerson *person = [[YWPerson alloc] initWithPersonId:item.custId];
//                [personArr addObject:person];
//                NSString *name;
//                if (![item.nameNotes isEqualToString:@""] && item.nameNotes!= nil) {
//                    name = item.nameNotes;
//                }else{
//                    name = item.custNname;
//                }
//                [nameArr addObject:name];
                
            }
        }];
        
    }];
    
    if (personArr.count == 0 || personArr == nil) {
        [MBProgressHUD showError:@"请选择邀请对象"];
    }else{

//        NSMutableArray   *list = @[].mutableCopy;
//        [personArr enumerateObjectsUsingBlock:^(YWPerson *person, NSUInteger idx, BOOL * _Nonnull stop) {
//            [list addObject:person.personId];
//        }];
        
        [YRHttpRequest inviteTransfer:personArr infoId:self.infoId type:self.type success:^(id data) {
            [MBProgressHUD showSuccess:@"邀请成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(id data) {
            [MBProgressHUD showError:data];
        }];
    }
}

#pragma mark - 网络请求
-(void)registerData{

        //好友列表数据
        [YRHttpRequest getFriendListSuccessWithType:kFriends success:^(NSDictionary *info) {
            
            NSMutableArray *ary = [YRAdListItem mj_objectArrayWithKeyValuesArray:info];
            
            if ([ary isEqualToArray:self.friends]) {
                return ;
            }else{
                self.friends = ary;
                [[YRYYCache share].yyCache removeObjectForKey:@"myFriendModel"];
                
                [[YRYYCache share].yyCache setObject:self.friends forKey:@"myFriendModel"];
                
                [self setUpTableSection];
                [self setupTableFootView];
                [self.tableView reloadData];
            }
        } failure:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
            NSMutableArray *model = (NSMutableArray *)[[YRYYCache share].yyCache objectForKey:@"myFriendModel"];
            self.friends = model;
            [self setUpTableSection];
            [self setupTableFootView];
            [self.tableView reloadData];
        }];
    
}

- (YWIMCore *)ywIMCore {
    return [SPKitExample sharedInstance].ywIMKit.IMCore;
}

- (id<IYWTribeService>)ywTribeService {
    return [[self ywIMCore] getTribeService];
}
#pragma mark - lazy
-(NSMutableArray *)friends{
    if (!_friends) {
        _friends = @[].mutableCopy;
    }
    return _friends;
}

- (void)dealloc{
    [self.view removeAllSubviews];
    [self.searchC removeFromParentViewController];
}


@end
