//
//  YRFriendTranController.m
//  YRYZ
//
//  Created by Sean on 16/9/20.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRFriendTranController.h"
#import "YRRingTranCell.h"
#import "YRMyWorksCell.h"

#import "YRRingNextTranCell.h"
#import "YRCirleDetailViewController.h"
#import "YRAddNewGroupViewController.h"
#import "RRZMineMyInfoController.h"
#import "YRChangePayPassWordController.h"
#import "YRRedPaperPaymentViewController.h"
static NSString *myWorksCellID = @"MyWorksCellID2";
static NSString *ringTranCellID = @"YRRingTranCellID";
@interface YRFriendTranController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView       *tableView;

@property (nonatomic,assign) NSInteger start;

@property (nonatomic,strong) NSMutableArray *dataArray;
/***首转发**/
@property (nonatomic,copy) NSNumber *forwardCount;
/**被转发**/
@property (nonatomic,copy) NSNumber *toForwardCount;
/*收益额***/
@property (nonatomic,copy) NSNumber *toForwardBonud;

@property (nonatomic,copy) void  (^isHavePassword)(BOOL isHavePassword);

@property (nonatomic,assign) BOOL havePassword;

@property (nonatomic,assign) BOOL smallNopass;

@property (nonatomic,assign) BOOL isNew;
@end

@implementation YRFriendTranController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self configHeader];
    [self setTitle:@"圈子转发"];
    
    [self setupTableView];
    [self loadFirstData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:YES animated:YES];
    
//    if (self.isNew) {
//        
//    }else{
//        [self.tableView.header beginRefreshing];
//    }
//    self.isNew = YES;
    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)loadFirstData{
    [YRHttpRequest getkUserForwardMoneyCustId:self.custId success:^(NSDictionary *data) {
        self.forwardCount = data[@"forwardCount"];
        self.toForwardCount = data[@"toForwardCount"];
        self.toForwardBonud = data[@"toForwardBonud"];
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        [MBProgressHUD showError:error];
        [NSString getCurrentTimestamp];
    }];
}

- (void)configHeader{
    //    self.view.backgroundColor = [UIColor redColor];
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210)];
    //    bgImage.backgroundColor = [UIColor randomColor];
    
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
    title.text = @"圈子转发";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
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
    userName.text = @"";
    userName.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:19];
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
    self.model.nameNotes?(userName.text = self.model.nameNotes):(userName.text = self.model.custNname);
    [userImage setImageWithURL:[NSURL URLWithString:self.model.custImg] placeholder:[UIImage defaultHead]];
   
        allMoney.text = @"";
    userName.font = [UIFont titleFont16];
 
}


- (void)leftButtonClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadData{

    
    NSString *sat = [NSString stringWithFormat:@"%ld",self.start];
    NSString *limit = [NSString stringWithFormat:@"%d",kListPageSize];
    @weakify(self);
    [YRHttpRequest getForMyFnformationByWhatType:kForwardingTheCircle start:sat  limin:limit  custId:self.custId success:^(NSDictionary *data) {
        DLog(@"%@",data);
        @strongify(self);
        
        NSArray  *array =  [YRCircleListModel mj_objectArrayWithKeyValuesArray:data];
        if (self.start == 0) {
            [self.dataArray removeAllObjects];
            
        }
        [self.dataArray addObjectsFromArray:array];
        if ([array count] < kListPageSize) {
            self.start -= kListPageSize;
            [self.tableView.footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.footer endRefreshing];
        }
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
        
    } failure:^(NSString *error) {
        [MBProgressHUD showError:error];
    }];
}

-(void)setupTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,210, SCREEN_WIDTH, SCREEN_HEIGHT-210) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGB_COLOR(245, 245, 245);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRRingTranCell class]) bundle:nil] forCellReuseIdentifier:ringTranCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRRingNextTranCell class]) bundle:nil] forCellReuseIdentifier:myWorksCellID];
    [self.tableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self.tableView jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    [self.tableView.header beginRefreshing];
}
- (void)headRefresh{
    self.start = 0;
    [self loadData];
}
- (void)footRefresh{
    self.start += kListPageSize;
    [self loadData];
}
#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        YRRingTranCell *cell = [tableView dequeueReusableCellWithIdentifier:ringTranCellID];
        if (self.forwardCount) {
            cell.fristTranLabel.text = [NSString stringWithFormat:@"%@",self.forwardCount];
            cell.byTranLabel.text = [NSString stringWithFormat:@"%.2f",[self.toForwardBonud floatValue]/100];
            cell.lucreLabel.text = [NSString stringWithFormat:@"%@",self.toForwardCount];;
        }
        return cell;
    }else{
        YRRingNextTranCell *cell = [tableView dequeueReusableCellWithIdentifier:myWorksCellID];
        YRCircleListModel *model = self.dataArray[indexPath.row-1];
        cell.chooseBtn = ^(BOOL isChoose){
            if (isChoose) {
                YRAddNewGroupViewController *newChatVc = [[YRAddNewGroupViewController alloc] init];
                newChatVc.title = @"选择联系人";
                newChatVc.infoId = model.clubId;
                newChatVc.type = 2;
                [self.navigationController pushViewController:newChatVc animated:YES];
            }
        };
        [self setUIWithModel:model cell:cell indexPath:indexPath];
        return cell;
    }
    
}
- (void)setUIWithModel:(YRCircleListModel *)model cell:(YRRingNextTranCell *)cell  indexPath:(NSIndexPath *)indexPath{
    NSString *type ;
    NSString *imageType ;
    NSString *placeImage;
    if (model.infoType == 1) {
        type = @"yr_msg_defaul";
        imageType = @"";
        cell.bigType.alpha = 0;
        cell.title.text = model.infoTitle;
        placeImage = @"yr_pic_default";
    }else if (model.infoType ==2){
        type = @"yr_mine_video_default";
        imageType = @"yr_mine_video";
        cell.bigType.alpha = 1;
        cell.title.text = model.infoTitle;
        placeImage = @"yr_video_default";
    }else{
        type = @"yr_mine_miuse_default";
        //        imageType = @"yr_mine_miuse";
        cell.title.text = model.infoIntroduction;
        cell.bigType.alpha = 1;
        placeImage = @"yr_audio_default";
    }
    cell.bigType.image = [UIImage imageNamed:imageType];
    cell.imagType.image = [UIImage imageNamed:type];
    cell.time.text = [NSString getTimeFormatterWithString:model.createDate];
    NSMutableAttributedString *forwardedText = [[NSMutableAttributedString alloc]initWithString:@"被转发" attributes:@{NSForegroundColorAttributeName:RGB_COLOR(121, 121, 121)}];
    NSAttributedString *text = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld",model.transferCount] attributes:@{NSForegroundColorAttributeName:[UIColor themeColor]}];
    [forwardedText appendAttributedString:text];
    cell.forwarded.attributedText = forwardedText;
    
    NSMutableAttributedString *moneyText = [[NSMutableAttributedString alloc]initWithString:@"奖励" attributes:@{NSForegroundColorAttributeName:RGB_COLOR(121, 121, 121)}];
    NSAttributedString *text2 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f",model.transferBonud*0.01]  attributes:@{NSForegroundColorAttributeName:[UIColor themeColor]}];
    
    [moneyText appendAttributedString:text2];
    cell.money.attributedText = moneyText;
    [cell.myImge setImageWithURL:[NSURL URLWithString:model.infoThumbnail] placeholder:[UIImage imageNamed:placeImage]];
    if (model.forwardStatus==0) {
        [cell.shareBtn setTitle:@"转发得奖励" forState:UIControlStateNormal];
    }else{
        [cell.shareBtn setTitle:@"已转发" forState:UIControlStateNormal];
    }
    if (model.auditStatus==4) {
        cell.downImage.hidden = NO;
    }else{
        cell.downImage.hidden = YES;
    }
    
    @weakify(cell);
    cell.chooseBtn = ^(BOOL isChoose){
        @strongify(cell);
        if (isChoose) {
            if ([cell.shareBtn.currentTitle isEqualToString:@"已转发"]) {
                DLog(@"已转发");
            }else{
                 DLog(@"转发得奖励");
                self.isNew = NO;
                [self forwordWorkToModel:model];
                
            }
        }
    };
    
    cell.title.font = [UIFont titleFont17];
    cell.title.font = [UIFont titleFont14];
    cell.money.font = [UIFont titleFont15];
    cell.forwarded.font = [UIFont titleFont15];
}
- (void)forwordWorkToModel:(YRCircleListModel *)modle{
    @weakify(self);
    self.isHavePassword = ^(BOOL isHavePassword){
        @strongify(self);
        if (isHavePassword) {
            
            YRRedPaperPaymentViewController *redVC = [[YRRedPaperPaymentViewController alloc]init];
            redVC.circleModel = modle;
            [YRModelManager manager].corcleModel = modle;
            
            [self.navigationController pushViewController:redVC animated:YES];
            
        }
    };
    [self queryPassWord];
}
- (void)queryPassWord{
    [YRHttpRequest QueryThePaymentPasswordSuccess:^(NSDictionary *data) {
        //是否设置支付密码
        self.havePassword = [data[@"isPayPassword"] boolValue];
        //小额免密开关
        self.smallNopass = [data[@"smallNopass"] boolValue];
        if (!self.havePassword) {
            
            YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"请先设置支付密码" cancelButtonText:@"取消" confirmButtonText:@"确认"];
            
            alertView.addCancelAction = ^{
                
            };
            alertView.addConfirmAction = ^{
                YRChangePayPassWordController *payVc = [[YRChangePayPassWordController alloc]init];
                payVc.title = @"设置支付密码";
                [self.navigationController pushViewController:payVc animated:YES];
            };
            [alertView show];
            
            return;
        }else{
            if (self.isHavePassword) {
                self.isHavePassword(YES);
            }
        }
        
    } failure:^(NSString *error) {
        
        [MBProgressHUD showError:error];
    }];
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 60;
    }else{
        return 145;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
    }
    else{
        if (self.dataArray.count>0) {
            YRCircleListModel *moedel = self.dataArray[indexPath.row-1];
            if (moedel.auditStatus==4) {
                [MBProgressHUD showError:@"该作品已下架"];
            }else{
                YRCirleDetailViewController *cirleVc = [[YRCirleDetailViewController alloc] init];
                cirleVc.circleListModel = self.dataArray[indexPath.row-1];
                NSString *title = cirleVc.circleListModel.infoIntroduction;
                CGFloat h = [title heightForStringfontSize:18.f];
                cirleVc.commentHeigt = h;
                [YRModelManager manager].corcleModel = self.dataArray[indexPath.row-1];
                [self.navigationController pushViewController:cirleVc animated:YES];
            }

        }
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteAudioNotifier" object:nil];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
