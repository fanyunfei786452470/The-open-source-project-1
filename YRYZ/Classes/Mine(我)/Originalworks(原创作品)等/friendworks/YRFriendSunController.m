//
//  YRFriendSunController.m
//  YRYZ
//
//  Created by Sean on 16/9/20.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRFriendSunController.h"
#import "BaskHeadView.h"
#import "BaskImageCell.h"
#import "BaskContenCell.h"
#import "YRUserBaskSunModel.h"
#import "YRPublishTextViewController.h"
#import "YRSunTextDetailViewController.h"
@interface YRFriendSunController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *dataSoure;
@property(nonatomic,strong)NSMutableArray *contentArray;
@property (nonatomic,strong)  UITableView *maintTable;
@property (nonatomic,strong)  BaskHeadView *headView;
@property (nonatomic,assign) NSInteger start;
@property (nonatomic,strong) NSMutableArray *todayArray;

@property (nonatomic,copy) NSString *todayMonth;

@property (nonatomic,copy) NSString *todayDay;

@property (nonatomic,strong) NSMutableArray *otherDay;
@end

@implementation YRFriendSunController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self  setTitle:@" "];
    [self setUI];
    [self configHeader];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)loadData{
    NSArray *monthArray = @[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月"];
    NSDate *date = [[NSDate alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd"];
    NSString *today = [formatter stringFromDate:date];
    NSArray *todayary = [today componentsSeparatedByString:@"-"];
    self.todayDay = todayary.lastObject;
    self.todayMonth = monthArray[[todayary.firstObject integerValue]-1];
    
    NSString *limit = [NSString stringWithFormat:@"%d",kListPageSize];
    NSString *sid =[NSString stringWithFormat:@"%ld",self.start];
    [YRHttpRequest baskInTheSunListForSid:sid limit:limit custId:self.custId success:^(id data) {
        
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0;i< [(NSArray *)data count];i++) {
            NSDictionary *dic = data[i];
            YRUserBaskSunModel *model = [[YRUserBaskSunModel alloc]mj_setKeyValues:dic];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.timeStamp integerValue]/1000];
            NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
            BOOL Yesterday = confromTimesp.isYesterday;
            NSArray *ary = [confromTimespStr componentsSeparatedByString:@"-"];
            model.month = monthArray[[ary.firstObject integerValue]-1];
            model.day = ary.lastObject;
            model.isYesterday = Yesterday;
            if ([model.month isEqualToString:self.todayMonth]&&[model.day isEqualToString:self.todayDay]) {
                [self.todayArray addObject:model];
            }else{
                [self.otherDay addObject:model];
            }
            [array addObject:model];
        }
        if (self.start == 0) {
            [self.dataSoure removeAllObjects];
        }
        [self.dataSoure addObjectsFromArray:array];
        if ([array count] < kListPageSize) {
            [self.maintTable.footer endRefreshingWithNoMoreData];
        }else{
            [self.maintTable.footer endRefreshing];
        }
        self.start = [[(YRUserBaskSunModel *)[array lastObject] sid] integerValue];
        [self.maintTable reloadData];
        [self.maintTable.header endRefreshing];
        
    } failure:^(NSString *error) {
        
    }];
    
}
- (void)headRefresh{
    self.start = 0;
    [self loadData];
}
#pragma mark ----设置界面
-(void)setUI{
    self.maintTable = [[UITableView alloc]initWithFrame:CGRectMake(0,210, SCREEN_WIDTH, SCREEN_HEIGHT-210) style:UITableViewStylePlain];
    self.maintTable.delegate = self;
    self.maintTable.dataSource = self;
    self.maintTable.separatorStyle =  UITableViewCellSeparatorStyleNone;
    self.maintTable.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.maintTable];
    [self setExtraCellLineHidden:self.maintTable];
    self.headView = [[[NSBundle mainBundle]loadNibNamed:@"BaskHeadView" owner:nil options:nil]lastObject];
    self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
    [self.headView.headImageBtn addTarget:self action:@selector(chooseheadImage) forControlEvents:UIControlEventTouchUpInside];
    //    maintTable.tableHeaderView = headView;
    [self.maintTable registerNib:[UINib nibWithNibName:@"BaskImageCell" bundle:nil] forCellReuseIdentifier:@"imageCell"];
    [self.maintTable registerNib:[UINib nibWithNibName:@"BaskContenCell" bundle:nil] forCellReuseIdentifier:@"textCell"];
    
    [self.maintTable jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.maintTable jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    [self.maintTable.header beginRefreshing];
}
#pragma mark ----点击头像
-(void)chooseheadImage{
    
    
}
#pragma mark ----table代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSoure.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

        YRUserBaskSunModel *model = self.dataSoure[indexPath.section ];
        if ([model.type intValue]==0) {
            return 70;
        }else{
            return 105;
        }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

        YRUserBaskSunModel *model = self.dataSoure[indexPath.section];
        
        if ([model.type isEqualToString:@"1"]){
            BaskImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
            cell.typeImage.hidden = YES;
            [self setUIWithIndexPath:indexPath cell:cell model:model];
            cell.headImageBtn.userInteractionEnabled = NO;
            return cell;
        }else if ([model.type isEqualToString:@"2"]){
            BaskImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
            cell.typeImage.hidden = NO;
            cell.typeImage.image = [UIImage imageNamed:@"yr_mine_video"];
            cell.headImageBtn.userInteractionEnabled = NO;
            [self setUIWithIndexPath:indexPath cell:cell model:model];
            return cell;
        }else{
            BaskContenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
            [self setUITextWithIndexPath:indexPath cell:cell model:model];
            return cell;
        }
    
}
- (void)setUITextWithIndexPath:(NSIndexPath *)indexPath cell:(BaskContenCell *)cell model:(YRUserBaskSunModel *)model{
    
    NSMutableAttributedString *cellText = [NSMutableAttributedString new];
    NSMutableAttributedString *prefix = [[NSMutableAttributedString alloc]initWithString:model.day];
    NSMutableAttributedString *subfix = [[NSMutableAttributedString alloc]initWithString:model.month];
    [prefix addAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                            NSFontAttributeName : [UIFont systemFontOfSize:28],
                            } range:NSMakeRange(0, prefix.length)];
    [subfix addAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                            NSFontAttributeName : [UIFont systemFontOfSize:12],
                            } range:NSMakeRange(0, subfix.length)];
    
    [cellText appendAttributedString:prefix];
    [cellText appendAttributedString:subfix];
    if (model.isYesterday) {
        cell.timeLab.text = @"昨天";
    }else{
        cell.timeLab.attributedText = cellText;
    }
    cell.contentLab.text = model.content;
    if ([model.day isEqualToString:self.todayDay]&&[model.month isEqualToString:self.todayMonth]) {
        cell.timeLab.hidden = YES;
        if (indexPath.section==0) {
            cell.timeLab.hidden = NO;
            cell.timeLab.text = @"今天";
        }
    }else{
        cell.timeLab.hidden = NO;
//        cell.timeLab.text = @"今天";
    }
    
   

    if (indexPath.section>=1) {
        YRUserBaskSunModel *model1 = self.dataSoure[indexPath.section-1];
        if ([model.day isEqualToString:model1.day]&&[model.month isEqualToString:model1.month]) {
            cell.timeLab.hidden = YES;
            
        }else{
            cell.timeLab.hidden = NO;
        }
    }
 
    
}

- (void)setUIWithIndexPath:(NSIndexPath *)indexPath cell:(BaskImageCell *)cell model:(YRUserBaskSunModel *)model{
    
    if ([model.type intValue]==1) {
        BaskPicModel *pic = model.pics.firstObject;
        cell.typeImage.hidden = YES;
        [cell.headImageBtn setBackgroundImageWithURL:[NSURL URLWithString:pic.url]  forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"yr_pic_default"]];
        cell.sumLab.hidden = NO;
        cell.sumLab.text = [NSString stringWithFormat:@"共%ld张",(NSInteger)model.pics.count];
        cell.contentLab.text = model.content;
        cell.tag = 1000+indexPath.section;
        [cell.headImageBtn removeAllTargets];
       // [cell.headImageBtn addTarget:self action:@selector(gotoPhoto:) forControlEvents:UIControlEventTouchUpInside];
        
    }else if([model.type intValue]==2){
        cell.typeImage.image = [UIImage imageNamed:@"yr_mine_video"];
        cell.sumLab.hidden = YES;
        cell.tag = 1000+indexPath.section;
        cell.contentLab.text = model.content;
        [cell.headImageBtn setBackgroundImageWithURL:[NSURL URLWithString:model.videoPic] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"yr_video_default"]];
       // [cell.headImageBtn addTarget:self action:@selector(gotoVideo:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSMutableAttributedString *cellText = [NSMutableAttributedString new];
    NSMutableAttributedString *prefix = [[NSMutableAttributedString alloc]initWithString:model.day];
    NSMutableAttributedString *subfix = [[NSMutableAttributedString alloc]initWithString:model.month];
    [prefix addAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                            NSFontAttributeName : [UIFont systemFontOfSize:28],
                            } range:NSMakeRange(0, prefix.length)];
    [subfix addAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                            NSFontAttributeName : [UIFont systemFontOfSize:12],
                            } range:NSMakeRange(0, subfix.length)];
    
    [cellText appendAttributedString:prefix];
    [cellText appendAttributedString:subfix];
    if (model.isYesterday) {
        cell.timeLab.text = @"昨天";
    }else{
        cell.timeLab.attributedText = cellText;
    }
    if ([model.day isEqualToString:self.todayDay]&&[model.month isEqualToString:self.todayMonth]) {
        cell.timeLab.hidden = YES;
        if (indexPath.section==0) {
            cell.timeLab.hidden = NO;
            cell.timeLab.text = @"今天";
        }
    }else{
        cell.timeLab.hidden = NO;
    }

    
    if (indexPath.section>=1) {
        YRUserBaskSunModel *model1 = self.dataSoure[indexPath.section-1];
        if ([model.day isEqualToString:model1.day]&&[model.month isEqualToString:model1.month]) {
            cell.timeLab.hidden = YES;
        }else{
            cell.timeLab.hidden = NO;
        }
    }
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

        YRUserBaskSunModel *statusModel = self.dataSoure[indexPath.section];
        YRSunTextDetailViewController *detailVc = [[YRSunTextDetailViewController alloc] init];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        NSString *isLike = [NSString stringWithFormat:@"%ld",(long)[statusModel.isLike integerValue]];
        [dic setValue:statusModel.type forKey:@"type"];
        [dic setValue:statusModel.custId forKey:@"custId"];
        [dic setValue:statusModel.sid forKey:@"sid"];
        [dic setValue:statusModel.custImg forKey:@"custImg"];
        [dic setValue:statusModel.content forKey:@"content"];
        [dic setValue:statusModel.timeStamp forKey:@"sendTime"];
        [dic setValue:statusModel.custNname forKey:@"custName"];
        [dic setValue:statusModel.pics forKey:@"pics"];
        [dic setValue:statusModel.comments forKey:@"comments"];
        [dic setValue:statusModel.likes forKey:@"likes"];
        [dic setValue:statusModel.gifts forKey:@"giftList"];
        [dic setValue:statusModel.videoUrl forKey:@"videoUrl"];
        [dic setValue:statusModel.videoPic forKey:@"videoPic"];
        [dic setValue:isLike forKey:@"isLike"];
        
        detailVc.sid = [statusModel.sid intValue];
        
        [self.navigationController pushViewController:detailVc animated:YES];
}
- (void)configHeader{
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210)];
    bgImage.image = [UIImage imageNamed:@"yr_red_user_bg"];
    [self.view addSubview:bgImage];
    bgImage.userInteractionEnabled = YES;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"backIndicatorImage"] forState:UIControlStateNormal];
    [bgImage addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(5);
        make.top.equalTo(self.view).mas_offset(20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *title = [[UILabel alloc]init];
    title.text = @"随手晒";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:19];
    [bgImage addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftButton);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];
    
    UIImageView *userImage =[[UIImageView alloc]init];
    userImage.backgroundColor = [UIColor randomColor];
    [bgImage addSubview:userImage];
    [userImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(title);
        make.top.equalTo(title.mas_bottom).mas_offset(10);
        make.size.mas_equalTo(CJSizeMake(60, 60));
    }];
    userImage.layer.cornerRadius = 30*SCREEN_POINT;
    userImage.clipsToBounds = YES;
    
    
    UILabel *userName = [[UILabel alloc]init];
    userName.textAlignment = NSTextAlignmentCenter;
    userName.text = @"珊惬意苏黎世";
    userName.textColor = [UIColor whiteColor];
    userName.backgroundColor = RGBA_COLOR(0, 71, 70, 0.75);
    [bgImage addSubview:userName];
       
    NSInteger width =150;
    NSString *str =  self.model.nameNotes?(self.model.nameNotes):(self.model.custNname);
    if (str.length>=8) {
        width = 180;
        userName.font = [UIFont systemFontOfSize:15];
    }
    
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(userImage);
        make.top.equalTo(userImage.mas_bottom).mas_offset(10);
        make.size.mas_equalTo(CJSizeMake(width, 30));
    }];
    userName.layer.cornerRadius = 15*SCREEN_POINT;
    userName.clipsToBounds = YES;
    
    UILabel *allMoney = [[UILabel alloc]init];
    allMoney.textAlignment = NSTextAlignmentCenter;
    //    allMoney.text = @"坚持减肥,加油胜利就在眼前,加油坚持减肥";
    allMoney.textColor = [UIColor whiteColor];
    //    allMoney.font = [UIFont boldSystemFontOfSize:15];
    allMoney.font = [UIFont systemFontOfSize:15];
    [bgImage addSubview:allMoney];
    [allMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(userName);
        make.top.equalTo(userName.mas_bottom).mas_offset(5);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-50, 30));
    }];
   
    [userImage setImageWithURL:[NSURL URLWithString:self.model.custImg] placeholder:[UIImage defaultHead]];
    self.model.nameNotes?(userName.text = self.model.nameNotes):(userName.text = self.model.custNname);
        allMoney.text = self.model.custSignature;
    allMoney.text = @"";
    userImage.userInteractionEnabled = YES;
    userName.font = [UIFont titleFont16];
}
 
- (void)leftButtonClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSMutableArray *)dataSoure{
    if (!_dataSoure) {
        _dataSoure = [[NSMutableArray alloc]init];
    }
    return _dataSoure;
}
- (NSMutableArray *)todayArray
{
    if (!_todayArray) {
        _todayArray = [[NSMutableArray alloc]init];
    }
    return _todayArray;
}
- (NSMutableArray *)otherDay
{
    if (!_otherDay) {
        _otherDay = [[NSMutableArray alloc]init];
    }
    return _otherDay;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
