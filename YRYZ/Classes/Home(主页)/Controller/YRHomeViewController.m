//
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

#import "SDCycleScrollView.h"
static NSString *cellID = @"HomeViewControllerID";
@interface YRHomeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>


@property (strong, nonatomic) UITableView       *tableView;
/** <#注释#>*/
@property (strong, nonatomic) NSArray           *dataSource;

@property (strong, nonatomic) YRBannerView      *bannerView;

@property (strong, nonatomic) NSMutableArray    *picBannerList; //banner数组
@property (strong, nonatomic) NSMutableArray    *urlBannerList; //banner数组

@property (strong, nonatomic) NSMutableArray    *textdataSource; // 图文
@property (strong, nonatomic) NSMutableArray    *voicedataSource; // 音频
@property (strong, nonatomic) NSMutableArray    *videodataSource; // 视频

@end

@implementation YRHomeViewController

- (NSMutableArray*)textdataSource{

    if (!_textdataSource) {
        _textdataSource = @[].mutableCopy;
    }
    return _textdataSource;
}

- (NSMutableArray*)videodataSource{

    if (!_videodataSource) {
        _videodataSource = @[].mutableCopy;
    }
    return _videodataSource;
}

- (NSMutableArray*)voicedataSource{

    if (!_voicedataSource) {
        _voicedataSource = @[].mutableCopy;
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
    
    [self setNavigationBar];
    [self setupRotateView];
    
    
    [self fectHomeBannerList];
    [_bannerView startPlay];
    
    
//    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(globalQueue, ^{
    
          [self fectProductTypeList:kInfoTypeVideo];
          [self fectProductTypeList:kInfoTypeVoice];
          [self fectProductTypeList:kInfoTypePictureWord];
    
    
    
//    });

    



}


- (void)fectHomeBannerList{
    [YRHttpRequest homeBannerListsuccess:^(NSArray *data) {
        
        if (data) {
            [data enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj) {
                    [self.picBannerList addObject:obj[@"pic"]];
                    [self.urlBannerList addObject:obj[@"url"]];
                }
            }];
        }
        
    } failure:^(NSString *errorInfo) {
        [MBProgressHUD showError:errorInfo];
    }];
    
    // 情景二：采用网络图片实现
    NSArray *imagesURLStrings = @[
                                  @"http://ww3.sinaimg.cn/mw690/63e6fd01jw1esenz2rq9qj218g18g4fx.jpg",
                                  @"http://ww3.sinaimg.cn/mw690/63e6fd01jw1ez58fhendrj20hs0hswfj.jpg",
                                  @"http://ww4.sinaimg.cn/mw690/63e6fd01jw1eu3g19eds1j20qo0qowkb.jpg"
                                  ];
    // 本地加载 --- 创建不带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH *0.4f) shouldInfiniteLoop:YES imageNamesGroup:imagesURLStrings];
    cycleScrollView.delegate = self;
    
    //    cycleScrollView.pageControlDotSize = CGSizeMake(10, 5);
    cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"selectedPointImage"];
    cycleScrollView.pageDotImage = [UIImage imageNamed:@"unSelectedPointImage"];
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self.view addSubview:cycleScrollView];
    
}

- (void)fectProductTypeList:(InfoProductType)type{

    [YRHttpRequest productTypeListAnd:type cacheKey:nil success:^(NSArray *data) {
        switch (type){
            case kInfoTypeVideo:
            {
                NSArray  *array =  [YRInfoProductTypeModel mj_objectArrayWithKeyValuesArray:data];
                [self.videodataSource  addObjectsFromArray:array];
            }
                break;
            case kInfoTypeVoice:
            {
            NSArray  *array =  [YRInfoProductTypeModel mj_objectArrayWithKeyValuesArray:data];
            [self.voicedataSource addObjectsFromArray:array];
            }
                break;
            case kInfoTypePictureWord:
            {
                 NSArray  *array =  [YRInfoProductTypeModel mj_objectArrayWithKeyValuesArray:data];
                [self.textdataSource addObjectsFromArray:array];
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
    if ([YRUserInfoManager manager].currentUser.custId) {
        leftButton.hidden = YES;
    }
    
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightButton setFrame:CGRectMake(SCREEN_WIDTH - 75, 20, 55, 24)];
//    [rightButton setImage:[UIImage imageNamed:@"rightButtonImage"] forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [navBgView addSubview:titleView];
    [navBgView addSubview:leftButton];
//    [navBgView addSubview:rightButton];
    
   

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
            imageTextController.typeDataSource = self.textdataSource;
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
    NSLog(@"---点击了第%ld张图片", (long)index);
}




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
/**
 *  @author weishibo, 16-08-01 14:08:11
 *
 *  公告
 *
 *  @param button <#button description#>
 */
//-(void)rightButtonAction:(UIButton*)button{
//    YRNoticeViewController  *noticeVc = [[YRNoticeViewController alloc] init];
//    [self.navigationController pushViewController:noticeVc animated:YES];
//}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor randomColor];
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 48;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}


@end
