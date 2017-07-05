//
//  YRMineShowViewController.m
//  
//
//  Created by Mrs_zhang on 16/7/12.
//
//  消息-->我的动态

#import "YRMineShowViewController.h"
#import "YRMineShowTableViewCell.h"
static NSString *yrMineShowCellIdentifier = @"yrMineShowCellIdentifier";
@interface YRMineShowViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tb_View;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation YRMineShowViewController

- (NSMutableArray *)dataSource{

    if (!_dataSource) {
#warning 此个数只做测试
        _dataSource = [NSMutableArray array];
        
        for (int i = 0; i<10; i++) {
        [_dataSource addObject:@"1"];
        }
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-50-49) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.estimatedRowHeight = 200;
    table.rowHeight = UITableViewAutomaticDimension;
//    table.rowHeight = 50;
    table.backgroundColor = RGB_COLOR(245, 245, 245);
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    self.tb_View = table;

    [table registerNib:[UINib nibWithNibName:@"YRMineShowTableViewCell" bundle:nil] forCellReuseIdentifier:yrMineShowCellIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMsgNotification:) name:MsgClear_Notification_Key object:nil];
}

- (void)clearMsgNotification:(NSNotification *)notification{

    [self.dataSource removeAllObjects];
    [self.tb_View reloadData];
}

#pragma mark -  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YRMineShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:yrMineShowCellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
