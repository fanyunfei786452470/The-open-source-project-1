//
//  YRFriendsShowViewController.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/12.
//  Copyright © 2016年 yryz. All rights reserved.
//  消息-->好友动态

#import "YRFriendsShowViewController.h"
#import "YRFriendsshowTableViewCell.h"
static NSString *yrFriendsShowCellIdentifier = @"yrFriendsShowCellIdentifier";

@interface YRFriendsShowViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tb_View;

@end

@implementation YRFriendsShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-50-49) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 70.f;
    table.backgroundColor = RGB_COLOR(245, 245, 245);
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    self.tb_View = table;
    
    [table registerNib:[UINib nibWithNibName:@"YRFriendsshowTableViewCell" bundle:nil] forCellReuseIdentifier:yrFriendsShowCellIdentifier];
}

#pragma mark -  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YRFriendsshowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:yrFriendsShowCellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
