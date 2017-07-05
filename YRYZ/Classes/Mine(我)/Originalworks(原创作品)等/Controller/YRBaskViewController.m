//
//  BaskViewController.m
//  TimeDemo
//
//  Created by 21.5 on 16/7/20.
//  Copyright © 2016年 21.5. All rights reserved.
//

#import "YRBaskViewController.h"
#import "BaskHeadView.h"
#import "BaskImageCell.h"
#import "BaskContenCell.h"

#import "YRUserBaskSunModel.h"
#import "YRPublishTextViewController.h"
#import "QBImagePickerController.h"
#import "YRSunImageModel.h"
#import <ALBBSDK/ALBBSDK.h>
#import <ALBBQuPai/ALBBQuPaiService.h>
#import <ALBBQuPai/QPEffectMusic.h>
#import "YRPublishVideoViewController.h"
@interface YRBaskViewController ()<UITableViewDelegate,UITableViewDataSource,QBImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,YRPublishTextViewControllerDeletate,YRPublishVideoViewControllerDelegate>

@property(nonatomic,strong)NSMutableArray *dataSoure;
@property(nonatomic,strong)NSMutableArray *contentArray;

@property (nonatomic,strong)  UITableView *maintTable;

@property (nonatomic,strong)  BaskHeadView *headView;

@property (nonatomic,assign) NSInteger start;
@end

@implementation YRBaskViewController
-(NSMutableArray *)dataSoure{
    if (!_dataSoure) {
        _dataSoure = [[NSMutableArray alloc]init];
    }
    return _dataSoure;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadData];
    
    [self  setTitle:@" "];
    [self setUI];
    [self configHeader];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)loadData{

        NSArray *monthArray = @[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月"];
//        NSDate *currentDate = [NSDate date];//获取当前时间，日期
//        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[currentDate timeIntervalSince1970]];
//        [YRHttpRequest getFriendsCircleListByCustUserId:nil Limit:kListPageSize Time:timeSp success:^(NSDictionary *data) {
//            // NSLog(@"晒一晒：%@",data);
//            NSMutableArray *array = [NSMutableArray array];
//            
//            for (NSDictionary *dic  in data) {
//                YRUserBaskSunModel *model = [[YRUserBaskSunModel alloc]mj_setKeyValues:dic];
//                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                [formatter setDateFormat:@"MM-dd"];
//                NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.timeStamp integerValue]/1000];
//                NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
//                NSArray *ary = [confromTimespStr componentsSeparatedByString:@"-"];
//                model.month = monthArray[[ary.firstObject integerValue]-1];
//                model.day = ary.lastObject;
//                [array addObject:model];
//                DLog(@"%@",ary);
//            }
//            if (self.start == 0) {
//                [self.dataSoure removeAllObjects];
//            }
//            [self.dataSoure addObjectsFromArray:array];
//            if ([array count] < kListPageSize) {
//                self.start -= kListPageSize;
//                [self.maintTable.footer endRefreshingWithNoMoreData];
//            }else{
//                [self.maintTable.footer endRefreshing];
//            }
//            
//            [self.maintTable reloadData];
//            [self.maintTable.header endRefreshing];
//        } failure:^(NSString *errorInfo) {
//    
//        }];

    NSString *limit = [NSString stringWithFormat:@"%d",kListPageSize];
    NSString *sid =[NSString stringWithFormat:@"%ld",self.start];
    [YRHttpRequest baskInTheSunListForSid:sid limit:limit custId:[YRUserInfoManager manager].currentUser.custId success:^(id data) {
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        for (int i = 0;i< [(NSArray *)data count];i++) {
            NSDictionary *dic = data[i];
            YRUserBaskSunModel *model = [[YRUserBaskSunModel alloc]mj_setKeyValues:dic];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM-dd"];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.timeStamp integerValue]/1000];
            NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
            NSArray *ary = [confromTimespStr componentsSeparatedByString:@"-"];
            model.month = monthArray[[ary.firstObject integerValue]-1];
            model.day = ary.lastObject;
            [array addObject:model];
            DLog(@"%@",ary);
        }
        
        if (self.start == 0) {
            [self.dataSoure removeAllObjects];
        }
        [self.dataSoure addObjectsFromArray:array];
        if ([array count] < kListPageSize) {
//            self.start -= kListPageSize;
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
- (void)leftButtonClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
    [self.maintTable jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.maintTable jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    [self.maintTable.header beginRefreshing];
}

#pragma mark ----点击头像
-(void)chooseheadImage{
    
    
}

#pragma mark ----table代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSoure.count+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==1) {
        //假数据 到时候根据数据源来判断
        return 2;
    }else if(section == 0){
        return 2;
    }else{
        return 1;
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 10;
//}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * imagereuseid = @"imagereuseid";
//    static NSString * contentreuseid = @"contentreuseid";
    if (indexPath.section == 0) {
        BaskImageCell *cell = [tableView dequeueReusableCellWithIdentifier:imagereuseid];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"BaskImageCell" owner:nil options:nil]lastObject];
        }
       
        cell.timeLab.text =@"今天";
       
        if (indexPath.row==0) {
            cell.sumLab.hidden = YES;
            cell.contentLab.hidden = YES;
            [cell.headImageBtn addTarget:self action:@selector(pushBaskPhoto) forControlEvents:UIControlEventTouchUpInside];
            [cell.headImageBtn setBackgroundImage:[UIImage imageNamed:@"yr_up_data"] forState:UIControlStateNormal];
            
        }else{
            cell.timeLab.hidden = YES;
           
            cell.headImageBtn.tag = indexPath.row;
            [cell.headImageBtn addTarget:self action:@selector(gotoPhoto:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return cell;

    }
//    else if (indexPath.section==1) {
//        
//        if (indexPath.row ==0 ) {
//            BaskImageCell *cell = [tableView dequeueReusableCellWithIdentifier:imagereuseid];
//            if (!cell) {
//                cell = [[[NSBundle mainBundle]loadNibNamed:@"BaskImageCell" owner:nil options:nil]lastObject];
//                cell.headImageBtn.tag = indexPath.row;
//                [cell.headImageBtn addTarget:self action:@selector(gotoPhoto:) forControlEvents:UIControlEventTouchUpInside];
//
//            }
//            return cell;
//
//        }else{
//             //假数据 到时候根据数据源来判断
//             BaskContenCell*cell = [tableView dequeueReusableCellWithIdentifier:contentreuseid];
//            if (!cell) {
//                cell = [[[NSBundle mainBundle]loadNibNamed:@"BaskContenCell" owner:nil options:nil]lastObject];
//            }
//         
//            return cell;
//  
//            
//        }
//    }
    else{
    BaskImageCell *cell = [tableView dequeueReusableCellWithIdentifier:imagereuseid];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"BaskImageCell" owner:nil options:nil]lastObject];
    }
        cell.headImageBtn.tag = indexPath.row;
        [cell.headImageBtn addTarget:self action:@selector(gotoPhoto:) forControlEvents:UIControlEventTouchUpInside];
        if (self.dataSoure.count>0) {
              [cell setUIWithModel:self.dataSoure[indexPath.section-1]];
        }
        return cell;
    
   }
}
#pragma mark -----点击头像
-(void)gotoPhoto:(UIButton *)sender{
    NSLog(@"点击头像");
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.section==1) {
    //        if (indexPath.row==1) {
    //
    //            BaskContenCell *cell = [[BaskContenCell alloc]init];
    //            NSDictionary *dic = @{@"content":@"11111111111"};
    //            return [cell cellHeight:dic];
    //
    //
    //        }else{
    //            if (kScreenWidth  == kDevice_Is_iPhone4) {
    //                return 90;
    //            }else{
    //                return 105;
    //            }
    //        }
    //    }else{
    //        if (kScreenWidth  == kDevice_Is_iPhone4) {
    //            return 90;
    //        }else{
    //            return 105;
    //        }
    //    }
    
    if (kScreenWidth  == kDevice_Is_iPhone4) {
        return 90;
    }else{
        return 105;
    }
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark ----- 发布
-(void)pushBaskPhoto{
     NSLog(@"发布");
//    YRPublishTextViewController *publishVc = [[YRPublishTextViewController alloc] init];
//    BaseNavigationController *navigation = [[BaseNavigationController alloc] initWithRootViewController:publishVc];
//    
//    [self presentViewController:navigation animated:YES completion:nil];

        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSArray *titles = @[@"文字",@"小视频",@"拍照",@"从手机相册选取"];
        [self addActionTarget:alert titles:titles];
        [self addCancelActionTarget:alert title:@"取消"];
        
        // 会更改UIAlertController中所有字体的内容（此方法有个缺点，会修改所以字体的样式）
        UILabel *appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
        UIFont *font         = [UIFont systemFontOfSize:15];
        appearanceLabel.font = font;
        
        [self presentViewController:alert animated:YES completion:nil];
}
// 添加其他按钮
- (void)addActionTarget:(UIAlertController *)alertController titles:(NSArray *)titles{
    
    @weakify(self);
    for (NSString *title in titles) {
        
        if ([title isEqualToString:@"文字"]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                @strongify(self);
                [self sendText];
                
            }];
            if (SYSTEMVERSION>=8.4) {
                [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
            }
            [alertController addAction:action];
        }
        
        if ([title isEqualToString:@"小视频"]) {
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                @strongify(self);
                [self movieAction];
            }];
            if (SYSTEMVERSION>=8.4) {
                [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
            }
            [alertController addAction:action];
            
        }
        
        if ([title isEqualToString:@"拍照"]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                @strongify(self);
                
                [self camera];
                
            }];
            if (SYSTEMVERSION>=8.4) {
                [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
            }
            
            [alertController addAction:action];
            
            
        }
        if ([title isEqualToString:@"从手机相册选取"]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                @strongify(self);
                
                [self picker];
                
            }];
            if (SYSTEMVERSION>=8.4) {
                [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
            }
            [alertController addAction:action];
        }
    }
}
// 取消按钮
- (void)addCancelActionTarget:(UIAlertController *)alertController title:(NSString *)title{
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        
    }];
    
    [action setValue:[UIColor wordColor] forKey:@"_titleTextColor"];
    [alertController addAction:action];
}
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet{
    for (UIView *view in actionSheet.subviews) {
        UIButton *btn = (UIButton *)view;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        if([[btn titleForState:UIControlStateNormal] isEqualToString:@"取消"]){
            [btn setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:RGB_COLOR(0, 121, 255) forState:UIControlStateNormal];
        }
    }
}
/**发布文字*/
- (void)sendText{
    
    YRPublishTextViewController *publishVc = [[YRPublishTextViewController alloc] init];
    BaseNavigationController *navigation = [[BaseNavigationController alloc] initWithRootViewController:publishVc];
    publishVc.delegate = self;
//    publishVc.sendText = ^{
//        @strongify(self);
//        [self.maintTable.header beginRefreshing];
//    };
    
    [self presentViewController:navigation animated:YES completion:nil];
}
/**拍摄视频*/
- (void)movieAction{
    
    id<ALBBQuPaiService> sdk = [[ALBBSDK sharedInstance] getService:@protocol(ALBBQuPaiService)];
    [sdk setDelegte:(id<QupaiSDKDelegate>)self];
    
    /* 可选设置 */
    [sdk setEnableImport:YES]; //开启导入
    [sdk setEnableMoreMusic:NO]; //更多音乐
    [sdk setEnableBeauty:NO]; // 美颜开关
    [sdk setEnableVideoEffect:NO]; //视频编辑
    [sdk setEnableWatermark:NO]; //开启水印
    [sdk setTintColor:[UIColor themeColor]]; //RGB颜色
    [sdk setThumbnailCompressionQuality:0.3]; //首贞图片质量
    [sdk setWatermarkImage:YES ? [UIImage imageNamed:@"watermask"] : nil ]; //开启水印
    [sdk setWatermarkPosition:QupaiSDKWatermarkPositionTopRight];
    [sdk setCameraPosition:QupaiSDKCameraPositionBack]; //前置摄像头
    
    /**
     *  @author ZX, 16-07-09 17:07:31
     *
     *  MinDuration 最小时长
     *  maxDuration 最大时长
     *  bitRate     码率
     */
    UIViewController *recordController = [sdk createRecordViewControllerWithMinDuration:5 maxDuration:15 bitRate:500000];
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:recordController];
    navigation.navigationBarHidden = YES;
    [self presentViewController:navigation animated:YES completion:nil];
    //    BaseNavigationController *navigation = [[BaseNavigationController alloc] initWithRootViewController:recordController];
    //    [self presentViewController:navigation animated:YES completion:nil];
    
}
- (void)qupaiSDK:(id<ALBBQuPaiService>)sdk compeleteVideoPath:(NSString *)videoPath thumbnailPath:(NSString *)thumbnailPath{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (videoPath) {
        
        UISaveVideoAtPathToSavedPhotosAlbum(videoPath, nil, nil, nil);
        YRPublishVideoViewController *publishVc = [[YRPublishVideoViewController alloc] init];
        publishVc.videoPath = videoPath;
        publishVc.thumbnailPath = thumbnailPath;
        BaseNavigationController *navigation = [[BaseNavigationController alloc] initWithRootViewController:publishVc];
        publishVc.delegate = self;
        
        [self presentViewController:navigation animated:YES completion:nil];
        
    }
    if (thumbnailPath) {
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithContentsOfFile:thumbnailPath], nil, nil, nil);
    }
}
/**拍照*/
- (void)camera{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:nil message:@"该设备不支持拍照" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:NULL];
        [alert show];
    }else{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;//设置可编辑
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];//进入照相界面
    }
    
}
#pragma mark UIImagePickerControllerDelegate
// 拍照回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSMutableArray *dataArray = [NSMutableArray array].mutableCopy;
    
    UIImage *pickerImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    YRSunImageModel *model = [[YRSunImageModel alloc] init];
    model.image = pickerImage;
    [dataArray addObject:model];
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        YRPublishTextViewController *publishVc = [[YRPublishTextViewController alloc] init];
        BaseNavigationController *navigation = [[BaseNavigationController alloc] initWithRootViewController:publishVc];
        publishVc.imageArr = dataArray;
        publishVc.delegate = self;
        [self presentViewController:navigation animated:YES completion:nil];
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/**相册*/
- (void)picker{
    
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    imagePickerController.mediaType = QBImagePickerMediaTypeImage;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}
#pragma mark - QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    
    NSMutableArray *dataArray = [NSMutableArray array].mutableCopy;
    
    static NSInteger index = 0;
    
    index = assets.count;
    
    @weakify(self);
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:index];
    for (PHAsset *asset in assets) {
        
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        
        [imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            YRSunImageModel *model = [[YRSunImageModel alloc] init];
            model.image = result;
            [images addObject:model];
            index --;
            
            if (index == 0) {
                
                [dataArray addObjectsFromArray:images];
                
                [imagePickerController dismissViewControllerAnimated:YES completion:^{
                    @strongify(self);
                    YRPublishTextViewController *publishVc = [[YRPublishTextViewController alloc] init];
                    BaseNavigationController *navigation = [[BaseNavigationController alloc] initWithRootViewController:publishVc];
                    publishVc.imageArr = dataArray;
                    publishVc.delegate = self;
                    [self presentViewController:navigation animated:YES completion:nil];
                }];
            }
            
        }];
    }
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    userName.backgroundColor = RGB_COLOR(254, 208, 48);
    [bgImage addSubview:userName];
    
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(userImage);
        make.top.equalTo(userImage.mas_bottom).mas_offset(10);
        make.size.mas_equalTo(CJSizeMake(150, 30));
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
    UserModel *model = [YRUserInfoManager manager].currentUser;
    [userImage setImageWithURL:[NSURL URLWithString:model.custImg] placeholder:[UIImage defaultHead]];
    userName.text = model.custNname;
//    allMoney.text = model.custSignature;
}


#pragma mark - 发布晒一晒回调方法
//发布视频
- (void)getPublishVideoShowSunTextWithDic:(NSDictionary *)dic{
    [_maintTable.header beginRefreshing];
}
//发布图文
- (void)getYRPublishTextShowSunTextWithDic:(NSDictionary *)dic{
    [_maintTable.header beginRefreshing];
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
