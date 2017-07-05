//
//  YRGroupMemberViewController.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/14.
//  Copyright © 2016年 yryz. All rights reserved.
//  消息-->群成员列表

#import "YRGroupMemberViewController.h"
#import "YRGroupMemberCell.h"
#import "SDContactsSearchResultController.h"
#import "YRAdListItem.h"
#import "RRZAdListRegardMeController.h"
#import "RRZAdListMyRegardViewController.h"
#import "YRAdListUserInfoController.h"
//#import "IQKeyboardManager.h"
#import "SPKitExample.h"

static NSString *yrGroupMemberCellIdentifier = @"yrGroupMemberCellIdentifier";

@interface YRGroupMemberViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate>

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

@end

@implementation YRGroupMemberViewController
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

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.isAddPerson== YES?@"确定":@"移除" style:UIBarButtonItemStylePlain target:self action:@selector(addGroupChatAction)];
    [self setupSearchController];
    [self registerData];
}

/**添加群成员*/
- (void)addGroupChatAction{
    
    NSMutableArray *personArr = [NSMutableArray array];
    [self.nFriends enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *arr = obj;
        
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YRAdListItem *item = obj;
            
            if (item.isSelete == YES) {
                YWPerson *person = [[YWPerson alloc] initWithPersonId:item.custId];
                [personArr addObject:person];
            }
        }];
        
    }];
    
    if (personArr.count == 0 || personArr == nil) {
        [MBProgressHUD showError:@"请选择群成员"];
    }else{
        __weak __typeof(self) weakSelf = self;

        if (self.isAddPerson) {
            [[self ywTribeService] inviteMembers:personArr
                                         toTribe:self.tribe.tribeId
                                      completion:^(NSArray *members, NSString *tribeId, NSError *error) {
                                          if (!error) {
                                              if (weakSelf.tribe.tribeType == YWTribeTypeMultipleChat) {
                                                  [MBProgressHUD showError:@"群成员已加入"];
                                              }else if (weakSelf.tribe.tribeType == YWTribeTypeNormal) {
                                                  [MBProgressHUD showError:@"群邀请已发出"];
                                              }
                                              [weakSelf.navigationController popViewControllerAnimated:YES];
                                              
                                          }
                                      }];
        }else{
            
         [personArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             YWPerson *person = obj;
             
             [self.ywTribeService expelMember:person fromTribe:self.tribe.tribeId completion:^(YWPerson *member, NSString *tribeId, NSError *error) {
                 
                 if (idx == personArr.count-1) {
                     if(error == nil) {
                         [MBProgressHUD showError:@"移除群成员成功"];
                         [weakSelf.navigationController popViewControllerAnimated:YES];

                     }else{
                         [MBProgressHUD showError:@"移除群成员失败"];
                     }
                 }
             }];
         }];
        }
    }
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
        if (self.isAddPerson) {
            [cell.headerImg setImageWithURL:[NSURL URLWithString:item.custImg] placeholder:[UIImage defaultHead]];
        }else{
            cell.headerImg.image = item.avatar?item.avatar:[UIImage imageNamed:@"yr_user_defaut"];
        }
 
        
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

    
        if (self.isAddPerson) {

            [cell.headerImg setImageWithURL:[NSURL URLWithString:item.custImg] placeholder:[UIImage defaultHead]];
            
        }else{
            cell.headerImg.image = item.avatar?item.avatar:[UIImage imageNamed:@"yr_user_defaut"];
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
    self.navigationController.navigationBar.hidden = YES;
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    self.navigationController.navigationBar.hidden = NO;
}


#pragma mark - 网络请求
-(void)registerData{
    
    if (!self.isAddPerson) {
        [self.friends removeAllObjects];
        [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YWTribeMember *tribeMember = obj;
            YWProfileItem *item = [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService] getProfileForPerson:tribeMember withTribe:nil];
            YRAdListItem *model = [[YRAdListItem alloc] init];
            model.nameNotes = item.displayName;
            model.custNname = tribeMember.nickname;
            model.custId = tribeMember.personId;
            model.avatar = item.avatar;
            [self.friends addObject:model];
            
        }];
        [self setUpTableSection];
        [self setupTableFootView];
        
        [self.tableView reloadData];
        

    }else{
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
    
    
}

- (YWIMCore *)ywIMCore {
    return [SPKitExample sharedInstance].ywIMKit.IMCore;
}

- (id<IYWTribeService>)ywTribeService {
    return [[self ywIMCore] getTribeService];
}
#pragma btnClick


#pragma mark - lazy
-(NSMutableArray *)friends{
    if (!_friends) {
        _friends = @[].mutableCopy;
    }
    return _friends;
}


@end
