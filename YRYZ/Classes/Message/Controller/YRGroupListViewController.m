//
//  YRGroupListViewController.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/9/29.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRGroupListViewController.h"
#import "YRAddNewGroupViewController.h"
#import "SPKitExample.h"


static NSString *groupListIdentifier = @"groupListIdentifier";

@interface YRGroupListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UITableView *tb_View;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableDictionary *groupedTribes;

@property (strong, nonatomic) YWTribeMember *myTribeMember;

@end

@implementation YRGroupListViewController

- (NSMutableArray *)dataSource{
   
    if (_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群聊";
    [self.groupedTribes removeAllObjects];
    [self setTableView];
}

- (void)reloadData {
    NSArray *tribes = [self.ywTribeService fetchAllTribes];
    [self configureDataWithTribes:tribes];
    [self.tb_View reloadData];
}
- (void)configureDataWithTribes:(NSArray *)tribes {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableArray *normalTribes = [NSMutableArray array];
    dictionary[[@(YWTribeTypeNormal) stringValue]] = normalTribes;
    NSMutableArray *multipleChatTribes = [NSMutableArray array];
    dictionary[[@(YWTribeTypeMultipleChat) stringValue]] = multipleChatTribes;
    
    for (YWTribe *tribe in tribes) {
        if (tribe.tribeType == YWTribeTypeNormal) {
            [normalTribes addObject:tribe];
        }
        else if (tribe.tribeType == YWTribeTypeMultipleChat) {
            [multipleChatTribes addObject:tribe];
        }
    }
    self.groupedTribes = dictionary;
}

- (void)setTableView{

    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 50.f;
    self.tb_View = table;
    [self.view addSubview:table];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    table.tableHeaderView = headView;
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.backgroundColor = RGB_COLOR(245, 245, 245);
    addBtn.frame = CGRectMake(15, 15, 30, 30);
    [addBtn setImage:[UIImage imageNamed:@"yr_msg_addGroupChat"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addGroupChatAction) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:addBtn];
    
    UILabel *textLab = [UILabel new];
    textLab.frame = CGRectMake(CGRectGetMaxX(addBtn.frame)+5, 20, 100, 20);
    textLab.text = @"创建群聊";
    textLab.font = [UIFont systemFontOfSize:16.f];
    textLab.textColor = [UIColor lightGrayColor];
    textLab.userInteractionEnabled = YES;
    [textLab addTapGesturesTarget:self selector:@selector(addGroupChatAction)];
    [headView addSubview:textLab];
    
    CALayer *lineLay = [CALayer layer];
    lineLay.frame = CGRectMake(0, 59, kScreenWidth, 0.7);
    lineLay.backgroundColor = [UIColor lightGrayColor].CGColor;
    [headView.layer addSublayer:lineLay];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    footView.backgroundColor = [UIColor clearColor];
    table.tableFooterView = footView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupedTribes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString *groupedTribesKey = @(section).stringValue;
    NSArray *tribes = self.groupedTribes[groupedTribesKey];
    return tribes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *groupedTribesKey = @(indexPath.section).stringValue;
    NSArray *tribes = self.groupedTribes[groupedTribesKey];

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:groupListIdentifier];
    
    UIImageView *groupImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yr_msg_groupChat"]];
    groupImageView.frame = CGRectMake(15, 10, 30, 30);
    
    [cell.contentView addSubview:groupImageView];
   
    UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(groupImageView.frame)+5, 10, kScreenWidth-100, 30)];
    
    textLab.font = [UIFont systemFontOfSize:17.f];
    [cell.contentView addSubview:textLab];
    
    if( indexPath.row >= [tribes count] ) {
        NSAssert(0, @"数据出错了");
    }  else {
        YWTribe *tribe = tribes[indexPath.row];
        textLab.text = tribe.tribeName;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *groupedTribesKey = @(indexPath.section).stringValue;
    NSMutableArray *tribes = self.groupedTribes[groupedTribesKey];
    YWTribe *tribe = [tribes objectAtIndex:indexPath.row];
    [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithTribe:tribe fromNavigationController:self.navigationController];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *groupedTribesKey = @(indexPath.section).stringValue;
    NSArray *tribes = self.groupedTribes[groupedTribesKey];
    YWTribe *tribe = tribes[indexPath.row];

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
       self.myTribeMember = [[self ywTribeService] fetchTribeMember:[[[self ywIMCore] getLoginService] currentLoginedUser]inTribe:tribe.tribeId];
        
        YWTribeMember *tribeMember = [self myTribeMember];
        
        if (tribeMember.role == YWTribeMemberRoleOwner && tribe.tribeType == YWTribeTypeNormal) {

            [[self ywTribeService] disbandTribe:tribe.tribeId completion:^(NSString *tribeId, NSError *error) {
            }];
        }else {

            [[self ywTribeService] exitFromTribe:tribe.tribeId completion:^(NSString *tribeId, NSError *error) {
            }];
        }
        
        
        [self.groupedTribes[groupedTribesKey] removeObjectAtIndex:indexPath.row];


        [self.tb_View deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

}
//添加群聊
- (void)addGroupChatAction{
    YRAddNewGroupViewController *newChatVc = [[YRAddNewGroupViewController alloc] init];
    newChatVc.title = @"选择联系人";
    [self.navigationController pushViewController:newChatVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utility
- (YWIMCore *)ywIMCore {
    return [SPKitExample sharedInstance].ywIMKit.IMCore;
}

- (id<IYWTribeService>)ywTribeService {
    return [[self ywIMCore] getTribeService];
}

@end
