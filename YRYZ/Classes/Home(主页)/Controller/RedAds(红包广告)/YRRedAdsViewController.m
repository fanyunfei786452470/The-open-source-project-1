//
//  YRRedAdsViewController.m
//  YRYZ
//
//  Created by Sean on 16/8/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedAdsViewController.h"
#import "YRRedAdsTableViewCell.h"
#import "YRAdsRulesViewController.h"
#import "YRRealseAdsViewController.h"
#import "YRRedPaperView.h"
#import "YRRedPaperReceiveViewController.h"
#import "YRRedPackDetailViewController.h"
#import "YRRedListModel.h"
@interface YRRedAdsViewController ()<UITableViewDelegate,UITableViewDataSource,YRRedAdsTableViewCellDelegate>

@property (nonatomic,strong) NSMutableArray *array;

@end

@implementation YRRedAdsViewController
- (NSMutableArray *)array
{
    if (!_array) {
        _array = @[].mutableCopy;
    }
    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)configUI{
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [table registerNib:[UINib nibWithNibName:@"YRRedAdsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.estimatedRowHeight = 230;
    table.contentInset = UIEdgeInsetsMake(0, 0, 150, 0);
    [self.view addSubview:table];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.01;
    }else{
        return 10;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSArray *ary = @[@"似懂非懂舒服的沙发上发呆是根深蒂固是打发打发舒服",@"阿斯顿撒的发烧发烧发烧许多的舒服噶速度发发撒打撒分身乏术发发顺丰啊俄方娃发发撒伐啊上次发烧发发撒伐是伐",@"a啊吃烧烤撒谎短发接我电话我就肯定会是喀就会反抗撒娇和福建省佛教卡是否看见阿双方将卡上撒考虑结婚就开始多久啊手机啊蝴蝶结",@"看见撒谎的风景卡是贷记卡是贷记卡圣诞节狂欢看到就会忘记和 iu 我请假啊寒暑假开放和科技孵化器我家咖啡亲王府 i 去围观发生对抗肌肤吧速度加快步伐将卡颂古非今开个房间看完宫崎骏风格完全借古讽今卡舍不得分开就啊不舒服控件啊时刻记得",@"啊时刻和防空军啊是贷记卡是贷记卡手机客户打算看就会打开就是贷记卡合适的",@"间看完宫崎骏风格完全借古讽今卡舍"];
    
    YRRedAdsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.userImage.image = [UIImage imageNamed:@"userDefaultImage"];
    cell.redPack.image = [UIImage imageNamed:@"yr_red_pack"];
    cell.time.text = @"6-24 17:20";
    
    [cell.num setImage:[UIImage imageNamed:@"yr_see_nor"] forState:UIControlStateNormal];
    [cell.num setTitle:@"  1200" forState:UIControlStateNormal];
    cell.num.titleLabel.font = [UIFont systemFontOfSize:15];
    cell.text.text = ary[indexPath.row];
    cell.text.numberOfLines = 0;
    [cell.text sizeToFit];
    cell.userName.text = @"蓝色的大河蓝色的大河";
    cell.mainImage.image = [UIImage imageNamed:@"cwshi"];
    [cell.imageNum setTitle:@"14" forState:UIControlStateNormal];
    [cell.imageNum setBackgroundImage:[UIImage imageNamed:@"yr_mark_angle"] forState:UIControlStateNormal];
    [cell.imageNum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *text = @"";
    if (indexPath.section == 0) {
        text = @"图文广告";
    }else{
        text = @"视频广告";
    }
    YRRedPackDetailViewController *redpackDetailVC = [[YRRedPackDetailViewController alloc] init];
    redpackDetailVC.title = text;
    [self.navigationController pushViewController:redpackDetailVC animated:YES];
}

#pragma marl  imageTextCell Delegate

- (void)redAdsTableViewCellDelegate:(BasicAction)basicAction{
    switch (basicAction) {
        case kRedBag:
        {
            @weakify(self);
            [YRRedPaperView showRedPaperViewWithName:@"xxxx" OpenBlock:^(){
                @strongify(self);
                YRRedPaperReceiveViewController *ViewController = [[YRRedPaperReceiveViewController alloc]init];
                [self.navigationController pushViewController:ViewController animated:NO];
            }];
        }
            break;
        default:
            break;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
