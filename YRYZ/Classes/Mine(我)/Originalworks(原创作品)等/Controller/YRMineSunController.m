//
//  YRMineSunController.m
//  YRYZ
//
//  Created by Sean on 16/9/12.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRMineSunController.h"

#import "BaskHeadView.h"
#import "BaskImageCell.h"
#import "BaskContenCell.h"
#import "YRUserBaskSunModel.h"
#import "YRPublishTextViewController.h"


#import "YRUserBaskSunModel.h"
#import "QBImagePickerController.h"
#import "YRSunImageModel.h"
#import <ALBBSDK/ALBBSDK.h>
#import <ALBBQuPai/ALBBQuPaiService.h>
#import <ALBBQuPai/QPEffectMusic.h>
#import "YRPublishVideoViewController.h"
#import "YRSunTextDetailViewController.h"
#import "RRZMineMyInfoController.h"
#import "JFImagePickerController.h"


@interface YRMineSunController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate,YRPublishTextViewControllerDeletate,YRPublishVideoViewControllerDelegate,YRSunTextDetailViewControllerDelegate>
@property(nonatomic,strong)NSMutableArray *dataSoure;
@property(nonatomic,strong)NSMutableArray *contentArray;
@property (nonatomic,strong)  UITableView *maintTable;
@property (nonatomic,strong)  BaskHeadView *headView;
@property (nonatomic,assign) NSInteger start;
@property (nonatomic,strong) NSMutableArray *todayArray;

@property (nonatomic,copy) NSString *todayMonth;

@property (nonatomic,copy) NSString *todayDay;

@property (nonatomic,strong) NSMutableArray *otherDay;


@property (nonatomic,copy) NSString *yearDay;

@property (nonatomic,copy) NSString *yearMonth;

@end

@implementation YRMineSunController
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
    //    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    self.navigationController.navigationBar.hidden = NO;
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
    [YRHttpRequest baskInTheSunListForSid:sid limit:limit custId:[YRUserInfoManager manager].currentUser.custId success:^(id data) {
        
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
        [MBProgressHUD showError:error];
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
    return self.dataSoure.count+1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 105;
    }else{
        YRUserBaskSunModel *model = self.dataSoure[indexPath.section -1];
        if ([model.type intValue]==0) {
            return 70;
        }else{
            return 105;
        }
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        BaskImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
        cell.timeLab.text =@"今天";
        cell.timeLab.hidden = NO;
        cell.sumLab.hidden = YES;
        cell.contentLab.hidden = YES;
        cell.typeImage.hidden = YES;
        cell.headImageBtn.tag = 1000;
        [cell.headImageBtn removeTarget:self action:@selector(gotoPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [cell.headImageBtn addTarget:self action:@selector(pushBaskPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [cell.headImageBtn setBackgroundImage:[UIImage imageNamed:@"yr_up_data"] forState:UIControlStateNormal];
        cell.headImageBtn.userInteractionEnabled = YES;
        return cell;
    }else{
        YRUserBaskSunModel *model = self.dataSoure[indexPath.section-1];
       
        if ([model.type isEqualToString:@"1"]){
            BaskImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
             cell.contentLab.hidden = NO;
             cell.headImageBtn.userInteractionEnabled = NO;
            cell.typeImage.hidden = YES;
            [self setUIWithIndexPath:indexPath cell:cell model:model];
            return cell;
        }else if ([model.type isEqualToString:@"2"]){
            BaskImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
             cell.contentLab.hidden = NO;
            cell.headImageBtn.userInteractionEnabled = NO;
            cell.typeImage.hidden = NO;
            cell.typeImage.image = [UIImage imageNamed:@"yr_mine_video"];
            [self setUIWithIndexPath:indexPath cell:cell model:model];
            return cell;
        }else{
                BaskContenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
                [self setUITextWithIndexPath:indexPath cell:cell model:model];
                return cell;
        }
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
    }else{
        cell.timeLab.hidden = NO;
    }
    
    if (indexPath.section>=2) {
        YRUserBaskSunModel *model1 = self.dataSoure[indexPath.section-2];
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
        [cell.headImageBtn addTarget:self action:@selector(gotoPhoto:) forControlEvents:UIControlEventTouchUpInside];
        
    }else if([model.type intValue]==2){
        cell.typeImage.image = [UIImage imageNamed:@"yr_mine_video"];
        cell.sumLab.hidden = YES;
        cell.tag = 1000+indexPath.section;
        cell.contentLab.text = model.content;
        [cell.headImageBtn setBackgroundImageWithURL:[NSURL URLWithString:model.videoPic] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"yr_video_default"]];
        [cell.headImageBtn addTarget:self action:@selector(gotoVideo:) forControlEvents:UIControlEventTouchUpInside];
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
    }else{
        cell.timeLab.hidden = NO;
    }
    
    if (indexPath.section>=2) {
        YRUserBaskSunModel *model1 = self.dataSoure[indexPath.section-2];
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
    if (indexPath.section == 0) {
        
    }else{
         YRUserBaskSunModel *statusModel = self.dataSoure[indexPath.section-1];
        YRSunTextDetailViewController *detailVc = [[YRSunTextDetailViewController alloc] init];
        detailVc.delegate = self;
        detailVc.seleteIndex = indexPath;
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
    
    
    
   
    
}
#pragma mark ----- 发布
-(void)pushBaskPhoto:(UIButton *)sender{
    if (sender.tag ==1000) {
//        YRPublishTextViewController *publishVc = [[YRPublishTextViewController alloc] init];
//        BaseNavigationController *navigation = [[BaseNavigationController alloc] initWithRootViewController:publishVc];
//        [self presentViewController:navigation animated:YES completion:nil];
        [self compileAction];
    }
}
#pragma mark -----点击头像
-(void)gotoPhoto:(UIButton *)sender{
    DLog(@"点击图片");
}
#pragma mark -----点击视频
- (void)gotoVideo:(UIButton *)sender{
    DLog(@"点击视频按钮");
}

- (void)compileAction{
    
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
#pragma mark - 发布
// 添加其他按钮
- (void)addActionTarget:(UIAlertController *)alertController titles:(NSArray *)titles{
    
    @weakify(self);
    for (NSString *title in titles) {
        
        if ([title isEqualToString:@"文字"]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                @strongify(self);
                [self sendText];
                
            }];
            if (SYSTEMVERSION>8.4) {
                 [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
            }
           
            
            [alertController addAction:action];
        }
        
        if ([title isEqualToString:@"小视频"]) {
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                @strongify(self);
                [self movieAction];
            }];
            if (SYSTEMVERSION>8.4) {
                [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
            }
            [alertController addAction:action];
            
        }
        
        if ([title isEqualToString:@"拍照"]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                @strongify(self);
                
                [self camera];
                
            }];
            if (SYSTEMVERSION>8.4) {
                [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
            }
            [alertController addAction:action];
            
            
        }
        if ([title isEqualToString:@"从手机相册选取"]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                @strongify(self);
                
                [self picker];
                
            }];
            if (SYSTEMVERSION>8.4) {
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
    if (SYSTEMVERSION>8.4) {
          [action setValue:[UIColor wordColor] forKey:@"_titleTextColor"];
    }
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
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *images = [self resetSizeOfImageData:image maxSize:150];
    [dataArray addObject:images];
    
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
    
    [[NSUserDefaults standardUserDefaults] setObject:@"9" forKey:@"seletePicCount"];//设置选择个数
    
    JFImagePickerController *picker = [[JFImagePickerController alloc] initWithRootViewController:self];
    picker.pickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerDidFinished:(JFImagePickerController *)picker{
    
    
    NSMutableArray *dataArray = [NSMutableArray array].mutableCopy;
    
    for (ALAsset *asset in picker.assets) {
        UIImage *copyOfOriginalImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
        
        UIImage *image = [self resetSizeOfImageData:copyOfOriginalImage maxSize:150];
        
        if ([image isKindOfClass:[UIImage class]]) {
            [dataArray addObject:image];
        }
    }
    
    if (dataArray.count == picker.assets.count) {
        [picker dismissViewControllerAnimated:YES completion:^{
            YRPublishTextViewController *publishVc = [[YRPublishTextViewController alloc] init];
            BaseNavigationController *navigation = [[BaseNavigationController alloc] initWithRootViewController:publishVc];
            publishVc.imageArr = dataArray;
            publishVc.delegate = self;
            
            [self presentViewController:navigation animated:YES completion:nil];
            [JFImagePickerController clear];
        }];
    }
    
}
- (void)imagePickerDidCancel:(JFImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [JFImagePickerController clear];
}

// 压缩图片
- (UIImage *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize
{
    CGSize newSize;
    if(source_image.size.width / source_image.size.height > 750.0f / 1334.0f){
        newSize = CGSizeMake(750, source_image.size.height * 750.0f / source_image.size.width);
    }else{
        newSize = CGSizeMake(source_image.size.width * 1334.0f / source_image.size.height, 1334);
    }
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.5);
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    title.font = [UIFont systemFontOfSize:19];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftButton);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];
    
    UIImageView *userImage =[[UIImageView alloc]init];
    userImage.backgroundColor = [UIColor clearColor];
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
   userName.backgroundColor = RGBA_COLOR(0, 71, 70, 0.75);
    [bgImage addSubview:userName];
    
    UserModel *model = [YRUserInfoManager manager].currentUser;
    NSInteger width =150;
    if (model.custNname.length>=8) {
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
 
    [userImage setImageWithURL:[NSURL URLWithString:model.custImg] placeholder:[UIImage defaultHead]];
    userName.text = model.custNname;
    allMoney.text = model.custSignature;
    
    userImage.userInteractionEnabled = YES;
    allMoney.text = @"";
//      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap:)];
//    [userImage addGestureRecognizer:tap];
    userName.font = [UIFont titleFont16];
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
- (void)doTap:(UITapGestureRecognizer *)tap{
//    
//    RRZMineMyInfoController *userInfo = [[RRZMineMyInfoController alloc]init];
//    [self.navigationController pushViewController:userInfo animated:YES];
//    [self pushUserInfoViewController:[YRUserInfoManager manager].currentUser.custId withIsFriend:NO];
}
//删除model
- (void)deleteSunTextWithIndexPath:(NSIndexPath *)indexPath{
    
    [self.dataSoure removeObjectAtIndex:indexPath.section-1];
    [self.maintTable reloadData];
    
    
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
@end
