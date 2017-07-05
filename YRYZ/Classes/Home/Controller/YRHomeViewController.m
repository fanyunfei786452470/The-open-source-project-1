#//
//  YRHomeViewController.m
//  YRYZ
//
//  Created by 易超 on 16/6/29.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRHomeViewController.h"
#import "UMMobClick/MobClick.h"
#import "YRImageTextMainViewController.h"
#import "YRRotateView.h"
#import "YRBannerView.h"
#import "YRLoginController.h"
#import "YRCircleMainViewController.h"
#import "YRVideoMainViewController.h"
#import "YRAudioMainViewController.h"
#import "LuckyDrawController.h"
#import "YRRedAdsMainViewController.h"
#import "YRNoticeViewController.h"
#import "YRInfoProductTypeModel.h"
#import "SPKitExample.h"

#import "SDCycleScrollView.h"

#import "YRVidioFullController.h"
#import "YRMineWebController.h"
static NSString *cellID = @"HomeViewControllerID";
@interface YRHomeViewController ()<SDCycleScrollViewDelegate>


@property (strong, nonatomic) UITableView       *tableView;
/** <#注释#>*/
@property (strong, nonatomic) NSArray           *dataSource;

@property (strong, nonatomic) YRBannerView      *bannerView;

@property (strong, nonatomic) NSMutableArray    *picBannerList; //banner数组
@property (strong, nonatomic) NSMutableArray    *urlBannerList; //banner数组
@property (strong, nonatomic) NSMutableArray    *voicedataSource; // 音频
@property (strong, nonatomic) NSMutableArray    *videodataSource; // 视频

//@property (nonatomic,strong) UIButton *bannerBtn;

@end

@implementation YRHomeViewController

- (NSMutableArray*)videodataSource{
    
    if (!_videodataSource) {
        _videodataSource = @[].mutableCopy;
        [_videodataSource addObjectsFromArray:(NSMutableArray *)[[YRYYCache share].yyCache objectForKey:@"videodataSource"]];
    }
    return _videodataSource;
}

- (NSMutableArray*)voicedataSource{
    
    if (!_voicedataSource) {
        _voicedataSource = @[].mutableCopy;
        [_voicedataSource addObjectsFromArray:(NSMutableArray *)[[YRYYCache share].yyCache objectForKey:@"voicedataSource"]];
    }
    return _voicedataSource;
}

- (NSMutableArray*)picBannerList{
    
    if (!_picBannerList) {
        _picBannerList = @[].mutableCopy;
    }
    return _picBannerList;
}

- (NSMutableArray*)urlBannerList{
    
    if (!_urlBannerList) {
        _urlBannerList = @[].mutableCopy;
    }
    return _urlBannerList;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    [MobClick beginLogPageView:@"YRHomeViewController"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"YRHomeViewController"];
    [_bannerView endPlay];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self UserLogin];

    [self setNavigationBar];
    [self setupRotateView];
    
    [self fectHomeBannerList];
    [_bannerView startPlay];
    
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        
        [self fectProductTypeList:kInfoTypeVideo];
        [self fectProductTypeList:kInfoTypeVoice];
    });
    
}


- (void)fectHomeBannerList{
    // 本地加载 --- 创建不带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH *0.4f) delegate:self placeholderImage:[UIImage imageNamed:@"yr_list_default"]];
    cycleScrollView.autoScroll = NO;
    cycleScrollView.delegate = self;
    cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"selectedPointImage"];
    cycleScrollView.pageDotImage = [UIImage imageNamed:@"unSelectedPointImage"];
    cycleScrollView.showPageControl = NO;
    cycleScrollView.isMineAnimation = YES;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.view addSubview:cycleScrollView];
    
//    self.bannerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    self.bannerBtn.frame = cycleScrollView.bounds;
//    [cycleScrollView addSubview:self.bannerBtn];
//    [self.bannerBtn addTarget:self action:@selector(bannerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cycleScrollView.imageURLStringsGroup = (NSArray *)[[YRYYCache share].yyCache objectForKey:@"bannerList"];
//    cycleScrollView.localizationImageNamesGroup = @[@"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1820014/big-hero-6.gif"];

    
    
    [YRHttpRequest homeBannerListsuccess:^(NSArray *data) {
        if (data) {
            [data enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj) {
                    [self.picBannerList addObject:obj[@"pic"]];
                    [self.urlBannerList addObject:obj[@"url"]];
                    [[YRYYCache share].yyCache removeObjectForKey:@"bannerList"];
                    [[YRYYCache share].yyCache setObject:self.picBannerList forKey:@"bannerList"];
                }
            }];
            if (self.picBannerList.count>1) {
                cycleScrollView.showPageControl = YES;
            }else{
                cycleScrollView.showPageControl = NO;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                cycleScrollView.imageURLStringsGroup = self.picBannerList;
            });
        }
    } failure:^(NSString *errorInfo) {
        [MBProgressHUD showError:errorInfo];
    }];
}

- (void)fectProductTypeList:(InfoProductType)type{
    
    [YRHttpRequest productTypeListAnd:type cacheKey:nil success:^(NSArray *data) {
        switch (type){
            case kInfoTypeVideo:
            {
                NSArray  *array =  [YRInfoProductTypeModel mj_objectArrayWithKeyValuesArray:data];
                [self.videodataSource removeAllObjects];
                [self.videodataSource  addObjectsFromArray:array];
                
                [[YRYYCache share].yyCache removeObjectForKey:@"videodataSource"];
                [[YRYYCache share].yyCache setObject:array forKey:@"videodataSource"];
                
                
            }
                break;
            case kInfoTypeVoice:
            {
                NSArray  *array =  [YRInfoProductTypeModel mj_objectArrayWithKeyValuesArray:data];
                [self.voicedataSource removeAllObjects];
                [self.voicedataSource addObjectsFromArray:array];
                
                [[YRYYCache share].yyCache removeObjectForKey:@"voicedataSource"];
                [[YRYYCache share].yyCache setObject:array forKey:@"voicedataSource"];
                
            }
                break;

                
            default:
                break;
        }
    } failure:^(NSString *data) {
        
        [MBProgressHUD showError:data];
    }];
    
}

-(void)setNavigationBar
{
    UIImageView  *navBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,64 )];
    navBgView.userInteractionEnabled = YES;
    
    
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, 20, 100, 30)];
    titleView.image = [UIImage imageNamed:@"homeTitleImage"];
    titleView.contentMode = UIViewContentModeScaleAspectFit;
    [navBgView addSubview:titleView];
    [self.navigationController.navigationBar addSubview:titleView];
    
    self.navigationItem.titleView = navBgView;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"userDefaultImage"] forState:UIControlStateNormal];
    [leftButton setFrame:CGRectMake(6, 18, 30, 30)];
    
    [leftButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:Login_Notification_Key object:nil] subscribeNext:^(NSNotification *notification) {
        if ([YRUserInfoManager manager].currentUser.custId) {
            leftButton.hidden = YES;
        }
    }];
    
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:Logout_Notification_Key object:nil] subscribeNext:^(NSNotification *notification) {
        leftButton.hidden = NO;
    }];
    
    if ([YRUserInfoManager manager].currentUser.custId) {
        leftButton.hidden = YES;
    }
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(SCREEN_WIDTH - 75, 20, 55, 24)];
    [rightButton setImage:[UIImage imageNamed:@"rightButtonImage"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [navBgView addSubview:titleView];
    [navBgView addSubview:leftButton];
    [navBgView addSubview:rightButton];
}

-(void)setupRotateView
{
    UIImageView *bgImageView = [[UIImageView alloc]init];
    bgImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bgImageView.image = [UIImage imageNamed:@"homeBgImage"];
    [self.view addSubview:bgImageView];
    
    //    _bannerView = [[YRBannerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH *0.4f)];
    //    [self.view addSubview:_bannerView];
    
    YRRotateView *rotateView = [[YRRotateView alloc]initWithFrame:YRRectMake(16, 134, 288, 288)];
//    rotateView.centerX = self.view.centerX;
//  
//    
    rotateView.centerY = (SCREEN_HEIGHT- 49 - (SCREEN_WIDTH *0.4f)-64)/2 +(SCREEN_WIDTH *0.4f);
    
    @weakify(self);
    rotateView.itemClikedBlock = ^(NSUInteger buttonTag){
        @strongify(self);
        NSInteger tag = buttonTag - 100;
        //圈子
        if (tag == 0) {
            
            YRCircleMainViewController *circleVc = [[YRCircleMainViewController alloc] init];
            [self.navigationController pushViewController:circleVc animated:YES];
        }
        //你说我听
        else if (tag == 1){
            YRAudioMainViewController *audioVc = [[YRAudioMainViewController alloc] init];
            audioVc.typeDataSource = self.voicedataSource;
            [self.navigationController pushViewController:audioVc animated:YES];
        }
        //精彩视频
        else if (tag == 2){
            YRVideoMainViewController *imageTextController = [[YRVideoMainViewController alloc]init];
            imageTextController.typeDataSource = self.videodataSource;
            [self.navigationController pushViewController:imageTextController animated:YES];
        }
        //红包广告
        else if (tag == 3){
            YRRedAdsMainViewController *redAds = [[YRRedAdsMainViewController alloc]init];
            [self.navigationController pushViewController:redAds animated:YES];
        }
        //抽奖
        else if (tag == 4){
            LuckyDrawController *luckyDraw = [[LuckyDrawController alloc]init];
            [self.navigationController pushViewController:luckyDraw animated:YES];
            
        }
        //靓图美文
        else if (tag == 5){
            YRImageTextMainViewController *imageTextController = [[YRImageTextMainViewController alloc]init];
            [self.navigationController pushViewController:imageTextController animated:YES];
            
        }
    };
    [self.view addSubview:rotateView];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [_bannerView setBannerOffset];
}


#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //    NSLog(@"---点击了第%ld张图片", (long)index);
    //    YRVidioFullController *video = [[YRVidioFullController alloc]init];
    //    video.url = [NSURL URLWithString:@"http://oery7dqsp.bkt.clouddn.com/yryz-720p.mp4"];
    //
    //    [self.navigationController pushViewController:video animated:YES];
    
//    if (self.picBannerList.count>1) {
//        DLog(@"有多张");
//        YRVidioFullController *video = [[YRVidioFullController alloc]init];
//        NSString *str = [[NSMutableString alloc]initWithString:self.urlBannerList[index]];
//        NSString *url = [str removeSubString:@"\n"];
//        video.url = [NSURL URLWithString:url];
//        [self.navigationController pushViewController:video animated:YES];
//    }else
        if(self.picBannerList.count>0){
       
        NSString *str = [[NSMutableString alloc]initWithString:self.urlBannerList[index]];
            NSString *url;
            if ([str hasSuffix:@"\n"]) {
               url = [str removeSubString:@"\n"];
            }else{
                url = str;
            }
            if ([url hasSuffix:@".mp4"]) {
                YRVidioFullController *video = [[YRVidioFullController alloc]init];
                video.url = [NSURL URLWithString:url];
                [self.navigationController pushViewController:video animated:YES];
            }else{
                YRMineWebController *mine = [[YRMineWebController alloc]init];
                mine.url = url;
                mine.titletext = @" ";
                [self.navigationController pushViewController:mine animated:YES];
            }
    }else{
        DLog(@"无数据");
    }
}


//- (void)bannerBtnClick:(UIButton *)sender{
//    
//    YRVidioFullController *video = [[YRVidioFullController alloc]init];
//    NSString *str = [[NSMutableString alloc]initWithString:self.urlBannerList.firstObject];
//    NSString *url = [str removeSubString:@"\n"];
//    video.url = [NSURL URLWithString:url];
//    [self.navigationController pushViewController:video animated:YES];
//}



#pragma mark  button


/**
 *  @author weishibo, 16-08-01 14:08:14
 *
 *  登录
 */

- (void)loginButtonClick{
    
    YRLoginController  *loginVc = [[YRLoginController alloc] init];
    [self.navigationController pushViewController:loginVc animated:YES];
    
}


- (void)UserLogin{
    
    //应用登陆成功后，调用SDK
    if ([YRUserInfoManager manager].currentUser.custId) {
        
        [[SPKitExample sharedInstance] callThisAfterISVAccountLoginSuccessWithYWLoginId:[YRUserInfoManager manager].currentUser.custId passWord:[YRUserInfoManager manager].currentUser.custId
                                                                        preloginedBlock:^{
                                                                            
                                                                        } successBlock:^{
//                                                                            [MBProgressHUD showError:@"登录成功"];
                                                                        } failedBlock:^(NSError *aError) {
                                                                            
                                                                            if (aError.code == YWLoginErrorCodePasswordError || aError.code == YWLoginErrorCodePasswordInvalid || aError.code == YWLoginErrorCodeUserNotExsit) {
                                                                                
                                                                                
//                                                                                [MBProgressHUD showError:@"IM登录失败"];
                                                                                
                                                                            }
                                                                        }];
    }
}
/**
 *  @author weishibo, 16-08-01 14:08:11
 *
 *  公告
 *
 *  @param button <#button description#>
 */
-(void)rightButtonAction:(UIButton*)button{
    YRNoticeViewController  *noticeVc = [[YRNoticeViewController alloc] init];
    [self.navigationController pushViewController:noticeVc animated:YES];
}



@end
