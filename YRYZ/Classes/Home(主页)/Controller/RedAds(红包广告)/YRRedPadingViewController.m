//
//  YRRedPadingViewController.m
//  YRYZ
//
//  Created by Sean on 16/8/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedPadingViewController.h"
#import "YRRedPackingTableViewCell.h"
@interface YRRedPadingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL padOrPass;
//state==0 退款中  state==1 退款完成 state==2 显示两个按钮 红包退款和修改按钮
@property (nonatomic,assign) NSInteger state;
@end

@implementation YRRedPadingViewController
- (instancetype)initWithPadOrPass:(BOOL)padOrPass
{
    self = [super init];
    if (self) {
        _padOrPass = padOrPass;
    }
    return self;
}

- (void)viewDidLoad {
    self.state = 2;
    [super viewDidLoad];
    [self configUI];
}

- (void)configUI{
    
    UITableView *tabel = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-210*SCREEN_POINT-44) style:UITableViewStyleGrouped];
    [tabel registerNib:[UINib nibWithNibName:@"YRRedPackingTableViewCell" bundle:nil] forCellReuseIdentifier:@"mycell"];
    tabel.delegate = self;
    tabel.dataSource = self;
    tabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tabel];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YRRedPackingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    

    cell.myImage.image = [UIImage imageNamed:@"cLINSHI"];
    
    cell.titles.text = @"周五,中国将在人们对中国经济放缓和中国金融体系健康状态的担忧之中体系健康状态不";
    cell.time.text =@" 审核时间: 2016-07-28 17:20";
    if (self.padOrPass) {
       cell.isBacking.backgroundColor = [UIColor clearColor];
        cell.redBack.backgroundColor = [UIColor clearColor];
        [cell.redBack setTitle:@"   购买了:" forState:UIControlStateNormal];
        [cell.redBack setTitleColor:RGB_COLOR(113, 113, 113) forState:UIControlStateNormal];
        cell.redBack.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
   
        [cell.isBacking setTitle:@"7天" forState:UIControlStateNormal];
        [cell.isBacking setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.isBacking setTitleColor:RGB_COLOR(43, 193, 183) forState:UIControlStateNormal]; 
        
    }else{
        if (_state==0||_state==1) {
            cell.redBack.hidden = YES;
            cell.isBacking.backgroundColor = [UIColor clearColor];
            if (_state==0) {
                     [cell.isBacking setTitle:@"退款中" forState:UIControlStateNormal];
            }else{
                [cell.isBacking setTitle:@"退款完成" forState:UIControlStateNormal];

            }
        }else{
            cell.redBack.hidden = NO;
            cell.redBack.backgroundColor = RGB_COLOR(246, 246, 246);
            [cell.redBack setTitle:@"红包退款" forState:UIControlStateNormal];
            [cell.redBack setTitleColor:RGB_COLOR(43, 193, 183) forState:UIControlStateNormal];
            
            cell.isBacking.backgroundColor = RGB_COLOR(43, 193, 183);
            [cell.isBacking setTitle:@"修改" forState:UIControlStateNormal];
             [cell.isBacking setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
     
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
