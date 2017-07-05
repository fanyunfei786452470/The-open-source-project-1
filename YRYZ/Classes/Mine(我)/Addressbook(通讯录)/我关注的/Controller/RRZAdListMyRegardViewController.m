//
//  RRZAdListMyRegardViewController.m
//  Rrz
//
//  Created by 易超 on 16/6/22.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZAdListMyRegardViewController.h"
#import "RRZAddressFriendListCell.h"
#import "YRAdListMyRegardCell.h"
#import "RRZGoodFriendItem.h"
//#import "RRZFriendInfoController.h"
#import "YRAdListUserInfoController.h"
#import "YRYYCache.h"
static NSString *cellID = @"MyRegardFriendListCellID";
static NSString *myRegardCellID = @"YRAdListMyRegardCell";
@interface RRZAdListMyRegardViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UITableView               *tableView;
@property (nonatomic, strong) UISearchController        *searchC;

/** 过滤数组*/
@property (strong, nonatomic) NSMutableArray            *filterFriends;
@property (strong, nonatomic) NSArray                   *nFriends;
@property (nonatomic, strong) NSMutableArray            *sectionTitlesArray;
@end

@implementation RRZAdListMyRegardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我关注的";
    [self setupTableView];
    [self setupSeach];
    
//    @weakify(self);
//    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:SetupAddressListNotification_key object:nil] subscribeNext:^(NSNotification *notification) {
//        @strongify(self);
//        [self registerData];
//    }];
}

-(void)setupTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.tableView.backgroundColor = RGB_COLOR(245, 245, 245);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];  //设置索引文字的颜色
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 66, 0);
    [self.view addSubview:self.tableView];
    [self.tableView setExtraCellLineHidden];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RRZAddressFriendListCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRAdListMyRegardCell class]) bundle:nil] forCellReuseIdentifier:myRegardCellID];
}

- (void)setupSeach
{
    self.searchC = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchC.searchResultsUpdater = self;
    self.searchC.dimsBackgroundDuringPresentation = NO;
    self.searchC.hidesNavigationBarDuringPresentation = YES;
    self.searchC.searchBar.frame = CGRectMake(self.searchC.searchBar.frame.origin.x, self.searchC.searchBar.frame.origin.y, self.searchC.searchBar.frame.size.width, 44.0);
    self.searchC.searchBar.placeholder = @"搜索关键字";
    self.searchC.searchBar.barTintColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    self.searchC.searchBar.tintColor = Global_Color;
    UIImageView *view = [[[self.searchC.searchBar.subviews objectAtIndex:0] subviews] firstObject];
    view.layer.borderColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1].CGColor;
    view.layer.borderWidth = 1;
    
//    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 44)];
//    [headView addSubview:self.searchC.searchBar];
    
    self.tableView.tableHeaderView = self.searchC.searchBar;
    self.searchC.searchBar.delegate = self;
    self.searchC.delegate = self;
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
    for (RRZGoodFriendItem *item in self.friends) {
        NSUInteger sectionIndex;
        if (item.nameNotes.length>1) {
            sectionIndex = [collation sectionForObject:item collationStringSelector:@selector(nameNotes)];
        }else{
            sectionIndex = [collation sectionForObject:item collationStringSelector:@selector(custNname)];
        }
        [newSectionArray[sectionIndex] addObject:item];
    }
    
    //sort the person of each section
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
            [self.sectionTitlesArray addObject:[collation sectionTitles][idx]];
        }
    }];
    
    [newSectionArray removeObjectsInArray:temp];
    
    self.nFriends = newSectionArray;
}

-(void)setupTableFootView{
    UILabel *footLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    footLabel.text = [NSString stringWithFormat:@"共 %ld 位关注的人",self.friends.count];
    footLabel.font = [UIFont systemFontOfSize:15];
    footLabel.textAlignment = NSTextAlignmentCenter;
    footLabel.textColor = [UIColor lightGrayColor];
    self.tableView.tableFooterView = footLabel;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.searchC.active = NO;
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchC.active){
        return 1;
    }else{
        return self.sectionTitlesArray.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchC.active){
        return self.filterFriends.count;
    }else{
        NSInteger count = [self.nFriends[section] count];
        return count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchC.active) {
        RRZGoodFriendItem *item = self.filterFriends[indexPath.row];
        RRZAddressFriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        NSString *name;
        if (item.nameNotes.length>=1) {
            
            name = [NSString stringWithFormat:@"%@",item.nameNotes];
        }else{
            name = [NSString stringWithFormat:@"%@",item.custNname];
        }
        NSRange range = [name rangeOfString:self.searchC.searchBar.text];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:name];
        [attr addAttributes:@{NSForegroundColorAttributeName: Global_Color} range:range];
        cell.nameLabel.attributedText = attr;
        
         [cell.iconImage setImageWithURL:[NSURL URLWithString:item.custImg] placeholder:[UIImage defaultHead]];
        return cell;
    }else{
        NSUInteger section = indexPath.section;
        NSUInteger row = indexPath.row;
        RRZGoodFriendItem *item = self.nFriends[section][row];
        YRAdListMyRegardCell *cell = [tableView dequeueReusableCellWithIdentifier:myRegardCellID];
        cell.item = item;
//        if (item.nameNotes) {
//            cell.nameLabel.text = item.nameNotes;
//        }else{
//            cell.nameLabel.text = item.custNname;
//        }
//        
//        [cell.iconImage setImageWithURL:[NSURL URLWithString:[NSString headImageUrl:item.headPath]] placeholder:[UIImage defaultHead]];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchC.active) {
        return 44;
    }else{
        return 58;
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
    
    RRZGoodFriendItem *item;
    if (self.searchC.active) {
        item = self.filterFriends[indexPath.row];
        self.searchC.active = NO;
        DLog(@"%@",item.custNname);
        YRAdListUserInfoController *userInfo = [[YRAdListUserInfoController alloc]init];
        userInfo.custId = item.custId;
        userInfo.isFriend = YES;
        [self.navigationController pushViewController:userInfo animated:YES];
        
    }else{
        NSUInteger section = indexPath.section;
        NSUInteger row = indexPath.row;
        item = self.nFriends[section][row];
        YRAdListUserInfoController *userInfo = [[YRAdListUserInfoController alloc]init];
        userInfo.custId = item.custId;
        userInfo.isFriend = YES;
        [self.navigationController pushViewController:userInfo animated:YES];
    }

//    RRZFriendInfoController *friendInfoViewController = [[RRZFriendInfoController alloc]init];
//    friendInfoViewController.custId = item.custId;
//    [self.navigationController pushViewController:friendInfoViewController animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.searchC.active) {
        if (section==0) {
            return 20;
        }
    }
   
    return 25;
}
#pragma mark - UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = [self.searchC.searchBar text];
    if ([searchString isEqualToString:@""]) {
        [self.filterFriends removeAllObjects];
    }else{
        self.filterFriends =[[NSMutableArray alloc]init];
        for(RRZGoodFriendItem *item in self.friends)
        {
            NSString* name = item.custNname;
            if (!name) {
                name = @"";
            }
            NSString *phone = item.custPhone;
            if (!phone) {
                phone = @"";
            }
            NSString *nameNote = item.nameNotes;
            if (!nameNote) {
                nameNote = @"";
            }
            if([name rangeOfString:searchString].location != NSNotFound || [phone isEqualToString:searchString]||[nameNote rangeOfString:searchString].location != NSNotFound)
            {
                [self.filterFriends addObject:item];
            }
        }
    }
    [self.tableView reloadData];
}
- (void)willPresentSearchController:(UISearchController *)searchController{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self registerData];
}
/*#pragma mark DZNEmptyDataSetSource
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
    NSString *text = @"快去关注好友吧";
    
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
}*/
#pragma mark - loadData
- (void)registerData{
//    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
//    
//    [YRHttpRequest getMyRegardListSuccess:^(NSDictionary *data) {
//        
//        self.friends = [RRZGoodFriendItem mj_objectArrayWithKeyValuesArray:data];
//        [self setUpTableSection];
//        [self.tableView reloadData];
//        
//    } failure:^(NSString *data) {
//        [MBProgressHUD showError:@"加载失败" toView:self.view];
//    }];
    [YRHttpRequest getFriendListSuccessWithType:kFocusOn success:^(NSDictionary *data) {
        
        self.friends = [RRZGoodFriendItem mj_objectArrayWithKeyValuesArray:data];
        
                [self setUpTableSection];
                [self.tableView reloadData];
    } failure:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
        self.friends = (NSMutableArray *)[[YRYYCache share].yyCache objectForKey:@"myFocusOnModel"];
        [self setUpTableSection];
        [self.tableView reloadData];
    }];
}

#pragma mark - lazy
-(NSMutableArray *)friends{
    if (!_friends) {
        _friends = @[].mutableCopy;
//        [_friends addObjectsFromArray:[[RRZDataCache sharedController] readListForKey:NSStringFromClass([self class])]];
    }
    return _friends;
}

@end
