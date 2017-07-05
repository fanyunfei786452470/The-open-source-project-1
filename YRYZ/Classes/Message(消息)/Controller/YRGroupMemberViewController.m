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

@end

@implementation YRGroupMemberViewController
#pragma mark - init
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.searchC.active = NO;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.searchC.active = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择联系人";
    [self setupSearchController];
    [self registerData];
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:SetupAddressListNotification_key object:nil] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        [self registerData];
    }];

}


-(void)setupSearchController{
    
    self.searchC = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchC.searchResultsUpdater = self;
    self.searchC.dimsBackgroundDuringPresentation = NO;
    self.searchC.hidesNavigationBarDuringPresentation = NO;
    self.searchC.searchBar.frame = CGRectMake(self.searchC.searchBar.frame.origin.x, self.searchC.searchBar.frame.origin.y, self.searchC.searchBar.frame.size.width, 44.0);
    self.searchC.searchBar.placeholder = @"搜索关键字";
    self.searchC.searchBar.barTintColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    self.searchC.searchBar.tintColor = Global_Color;
    
    UIImageView *view = [[[self.searchC.searchBar.subviews objectAtIndex:0] subviews] firstObject];
    view.layer.borderColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1].CGColor;
    view.layer.borderWidth = 1;
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 44)];
    [headView addSubview:self.searchC.searchBar];
    
    self.searchC.searchBar.delegate = self;
    self.searchC.delegate = self;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.tableView.backgroundColor = RGB_COLOR(245, 245, 245);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = headView;//bar;
    self.tableView.rowHeight = 57;
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];  //设置索引文字的颜色
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionHeaderHeight = 25;
    [self.view addSubview:self.tableView];
    //    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 66, 0);
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
        if (item.nameNotes) {
            sectionIndex = [collation sectionForObject:item collationStringSelector:@selector(nameNotes)];
        }else{
            sectionIndex = [collation sectionForObject:item collationStringSelector:@selector(custNname)];
        }
        [newSectionArray[sectionIndex] addObject:item];
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    self.sectionTitlesArray = [NSMutableArray new];
    
    [newSectionArray enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
        if (arr.count == 0) {
            [temp addObject:arr];
        } else {
            [self.sectionTitlesArray addObject:[collation sectionTitles][idx]];
        }
    }];
    
    [newSectionArray removeObjectsInArray:temp];
    
    
    
    NSMutableArray *operrationModels = [NSMutableArray new];
//    NSArray *dicts = @[@{@"custNname" : @"关注我的", @"headPath" : @"yr_address_newFriend"},
//                      ];
    
//    for (NSDictionary *dic in dicts) {
//        YRAdListItem *item = [YRAdListItem new];
//        item.custNname = dic[@"custNname"];
//        item.headPath = dic[@"headPath"];
//        [operrationModels addObject:item];
//    }
    
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
        YRGroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:yrGroupMemberCellIdentifier];
        YRAdListItem *item = self.filterItems[indexPath.row];
        NSString *name;
        if (item.nameNotes) {
            name = item.nameNotes;
        }else{
            name = item.custNname;
        }
        NSRange range = [name rangeOfString:self.searchC.searchBar.text];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:name];
        [attr addAttributes:@{NSForegroundColorAttributeName: Global_Color} range:range];
        cell.nameLab.attributedText = attr;
        [cell.headerImg setImageWithURL:[NSURL URLWithString:[NSString headImageUrl:item.headPath]] placeholder:[UIImage defaultHead]];
        return cell;
    }else{
        NSUInteger section = indexPath.section;
        NSUInteger row = indexPath.row;
        YRAdListItem *item = self.nFriends[section][row];
        YRGroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:yrGroupMemberCellIdentifier];
        if (item.nameNotes) {
            cell.nameLab.text = item.nameNotes;
        }else{
            cell.nameLab.text = item.custNname;
        }
        
//        if (indexPath.section == 0) {
//            if (indexPath.row == 0) {
//                if (self.newCount > 0) {
//                    cell.neLabel.hidden = NO;
//                    cell.neLabel.text = [NSString stringWithFormat:@"%ld",self.newCount];
//                }else{
//                    cell.neLabel.hidden = YES;
//                }
//            }
//            cell.headerImg.image = [UIImage imageNamed:item.headPath];
//        }else{
//            cell.neLabel.hidden = YES;
            [cell.headerImg setImageWithURL:[NSURL URLWithString:[NSString headImageUrl:item.headPath]] placeholder:[UIImage defaultHead]];
//        }
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



#pragma mark - 网络请求
-(void)registerData{
    
    [YRHttpRequest getFriendListSuccess:^(NSDictionary *info) {
        [self.friends removeAllObjects];
        
        self.friends = [YRAdListItem mj_objectArrayWithKeyValuesArray:info];
        
        [self setUpTableSection];
        [self setupTableFootView];
        
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        
    }];
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
