//
//  YRDiscoverViewController.m
//  YRYZ
//
//  Created by 易超 on 16/6/29.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRDiscoverViewController.h"
#import "YRCacheController.h"
#import "YRBingoController.h"
#import "YROpenLuckController.h"
#import "YRBingLuckController.h"
#import "RewardGiftView.h"
#import "LuckyDrawController.h"
#import "YRLoginController.h"

#import "YRRedPaperAdPaymemtViewController.h"
#import "YRAfficheController.h"
@interface YRDiscoverViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *titles;

@property (nonatomic,strong) NSArray *images;
@end

@implementation YRDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
   
}

- (void)configUI{
    self.titles = @[@"趣味抽奖",@"用户帮助"];
    self.images = @[@"yr_draw_icom",@"yr_helpOnline"];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
//     tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [tableView setExtraCellLineHidden];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
    cell.imageView.image = [UIImage imageNamed:self.images[indexPath.row]];
    cell.textLabel.text = self.titles[indexPath.row];
    cell.textLabel.font = [UIFont titleFont17];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 47;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        LuckyDrawController *luck = [[LuckyDrawController alloc]init];
        [self.navigationController pushViewController:luck animated:YES];
//        YRRedPaperAdPaymemtViewController *red = [[YRRedPaperAdPaymemtViewController alloc] init];
//        [self.navigationController pushViewController:red animated:YES];
//
    }else if (indexPath.row==1){
        YRAfficheController *afficon = [[YRAfficheController alloc]init];
        [self.navigationController pushViewController:afficon animated:YES];
    }
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end















