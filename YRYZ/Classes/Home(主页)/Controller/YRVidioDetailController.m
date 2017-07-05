//
//  YRVidioDetailController.m
//  YRYZ
//
//  Created by weishibo on 16/8/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRVidioDetailController.h"
#import "YRMyShareView.h"
#import "YRTranTableViewCell.h"
#import "YRRewardTableViewCell.h"
#import "YRCommentTableViewCell.h"
#import "YRVidioFullController.h"
#import <ZFPlayer.h>
#import "RewardGiftView.h"
#import "YRInputView.h"
#import "YRRedPaperView.h"
#import "YRRedPaperReceiveViewController.h"
#import "YRRedPaperPaymentViewController.h"
#import "YRProductDetail.h"
#import "YRRewardListModel.h"

static NSString *yrTranCellID = @"yrTranCellID";
static NSString *yrRewardCellID = @"yrRewardCellID";
static NSString *yrCommnetCellID = @"yrCommnetCellID";
@interface YRVidioDetailController ()
<UITableViewDelegate ,UITableViewDataSource,YRInputViewDelegate>
@property (strong, nonatomic)UIView                         *tableHeadView;
@property (strong, nonatomic)UITableView                    *tableView;
@property (nonatomic,strong) YRMyShareView                  *shareView;


@property (nonatomic,strong)UIButton                        *selTitleButton; //选中按钮
@property (nonatomic, strong)UIImageView                    *underlineView;//下划线


@property (nonatomic, assign)NSInteger                      tag; //选中的类型（打赏、评论等）

@property (nonatomic,strong) ZFPlayerView                   *playerView;


@property (nonatomic,weak) UIImageView                      *imageVideo;

@property (nonatomic,strong) RewardGiftView                 *rewardGiftView;
@property (nonatomic,strong) YRInputView                     *inputView;

@property (nonatomic,strong) NSMutableArray                  *commentList; //评论列表
@property (nonatomic,strong) NSMutableArray                  *likeList;// 点赞
@property (nonatomic,strong) NSMutableArray                  *tranList;//转发列表
@property (nonatomic,strong) NSMutableArray                  *giftList;// 礼物列表
@property (nonatomic,strong) YRProuductCommentModel          *commentModel;
@property (nonatomic,assign) NSInteger                       start;

@property (nonatomic,strong) YRProductDetail                 *productDetail;

@end

@implementation YRVidioDetailController
#pragma mark 初始化
- (void)setStart:(NSInteger)start{
    if (start < 0) {
        _start = 0;
        return;
    }
    _start = start;
}
- (YRProductDetail *)productDetail{
    
    if (!_productDetail) {
        _productDetail = [[YRProductDetail alloc] init];
    }
    return _productDetail;
}

- (YRProductListModel*)productListModel{
    
    if (!_productListModel) {
        _productListModel = [[YRProductListModel alloc] init];
    }
    return _productListModel;
}

- (YRProuductCommentModel*)commentModel{
    
    if (!_commentModel) {
        _commentModel = [[YRProuductCommentModel alloc] init];
    }
    return _commentModel;
}

- (NSMutableArray*)commentList{
    
    if (!_commentList) {
        _commentList = @[].mutableCopy;
    }
    return _commentList;
}

- (NSMutableArray*)likeList{
    
    if (!_likeList) {
        _likeList = @[].mutableCopy;
    }
    return _likeList;
}

- (NSMutableArray*)tranList{
    
    if (!_tranList) {
        _tranList = @[].mutableCopy;
    }
    return _tranList;
}

-(NSMutableArray*)giftList{
    
    if (!_giftList) {
        _giftList = @[].mutableCopy;
    }
    return _giftList;
}

- (YRInputView*)inputView{
    
    if (!_inputView) {
        _inputView = [[YRInputView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50-64, SCREEN_WIDTH, 50)];
        _inputView.backgroundColor = [UIColor whiteColor];
        _inputView.delegate = self;
        [self.view addSubview:_inputView];
    }
    return _inputView;
    
}

#pragma mark 获取数据
/**
 *  @author weishibo, 16-08-20 16:08:43
 *
 *  获取详情
 */
- (void)fectDetailData{
    
    [YRHttpRequest productdetailProductId:self.productListModel.uid success:^(NSDictionary *data) {
        self.productDetail = [YRProductDetail mj_objectWithKeyValues:data];
    } failure:^(id data) {
        [MBProgressHUD showError:data];
    }];
    
}


/**
 *  @author yichao, 16-08-22 15:08:54
 *
 *  评论列表
 */
- (void)fectProductCommentList{
    
    [YRHttpRequest productCommentList:self.productListModel.uid  start:self.start    limit:kListPageSize success:^(NSArray *data) {
        NSArray    *array= [YRProuductCommentModel mj_objectArrayWithKeyValuesArray:data];
        if (self.start == 0) {
            [self.commentList removeAllObjects];
        }
        [self.commentList addObjectsFromArray:array];
        
        if ([array count] < kListPageSize) {
            self.start -= kListPageSize;
            [self.tableView.footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.footer endRefreshing];
        }
        [self.tableView reloadData];
        
    } failure:^(id data) {
        [MBProgressHUD showError:NetworkError];
    }];
}

/**
 *  @author yichao, 16-08-22 15:08:45
 *
 *  点赞列表
 */
- (void)fectProductLikeList{
    
    [YRHttpRequest productLikeList:self.productListModel.uid start:self.start      limit:kListPageSize success:^(NSArray *data) {
        NSArray    *array= [YRProudTranModel mj_objectArrayWithKeyValuesArray:data];
        if (self.start == 0) {
            [self.likeList removeAllObjects];
        }
        [self.likeList addObjectsFromArray:array];
        
        if ([array count] < kListPageSize) {
            self.start -= kListPageSize;
            [self.tableView.footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.footer endRefreshing];
        }
        [self.tableView reloadData];

    } failure:^(id data) {
        [MBProgressHUD showError:data];
    }];
    
}


/**
 *  @author weishibo, 16-08-29 10:08:43
 *
 *  打赏礼物列表 0转发1晒一晒 2作品
 
 */
- (void)fectRewardObjList{
    [YRHttpRequest rewardObjList:2 pid:self.productListModel.uid pageNumber:self.start pageSize:kListPageSize success:^(NSArray *data) {
        NSArray  *array = [YRRewardListModel mj_keyValuesArrayWithObjectArray:data];
        
        if (self.start == 0) {
            [self.giftList removeAllObjects];
        }
        [self.giftList addObjectsFromArray:array];
        
        if ([array count] < kListPageSize) {
            self.start -= kListPageSize;
            [self.tableView.footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.footer endRefreshing];
        }
        [self.tableView reloadData];
        
        
    } failure:^(id data) {
        [MBProgressHUD showError:data];
    }];
    
}


/**
 *  @author yichao, 16-08-22 15:08:38
 *
 *  转发列表
 */
- (void)fectProductTranList{
    
    [YRHttpRequest productTranList:self.productListModel.uid start:self.start   limit:kListPageSize success:^(NSArray *data) {
        NSArray    *array= [YRProudTranModel mj_objectArrayWithKeyValuesArray:data];
        if (self.start == 0) {
            [self.tranList removeAllObjects];
        }
        [self.tranList addObjectsFromArray:array];
        
        if ([array count] < kListPageSize) {
            self.start -= kListPageSize;
            [self.tableView.footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.footer endRefreshing];
        }
        [self.tableView reloadData];
    } failure:^(id data) {
        [MBProgressHUD showError:NetworkError];
    }];
    
}

/**
 *  @author yichao, 16-08-22 14:08:39
 *
 *  add评论
 *
 *  @param content 评论内容
 */
- (void)fectAddComment:(NSString*)content{
    
    [YRHttpRequest poductAddComment:self.productListModel.uid content:content success:^(id data) {
        
    } failure:^(id data) {
        [MBProgressHUD showError:data];
    }];
}

/**
 *  @author yichao, 16-08-22 16:08:37
 *
 *  点赞取消点赞
 *
 *  @param like 0取消 1点赞
 */
- (void)fectProductAddLikeAndUnLike:(NSInteger)like{
    
    [YRHttpRequest productAddLikeAndUnLike:self.productListModel.uid like:like success:^(id data) {
        if (like == 0) {
            [MBProgressHUD showSuccess:@"取消点赞"];
        }else{
            [MBProgressHUD showSuccess:@"点赞成功"];
        }
    } failure:^(id data) {
        [MBProgressHUD showError:data];
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setTitle:@"视频详情"];
    [self setRightNavButtonWithImage:[UIImage imageNamed:@"yr_navButton_more"]];
    
    self.tag = 0;
    
    [self initTableView];
    [self initTableHeadView];
    [self initShareView];
    [self initBottomView];
    
    
    [self fectDetailData];
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        [self fectProductTranList];
    });
    
}

- (void)initShareView{
    self.shareView  = [[YRMyShareView alloc]init];
    self.shareView.delegate = self;
    self.shareView .chooseShareCell = ^(NSInteger tag,NSString *name){
        DLog(@"你点击了第%ld个cell  点击的是%@",tag,name);
    };
}

- (void)rightNavAction:(UIButton*)button{
    [self.shareView  show];
}


- (void)initTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
    self.tableView.tableHeaderView = self.tableHeadView;
    [self.view addSubview:self.tableView];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRTranTableViewCell class]) bundle:nil] forCellReuseIdentifier:yrTranCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRRewardTableViewCell class]) bundle:nil] forCellReuseIdentifier:yrRewardCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRCommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:yrCommnetCellID];
    
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.tableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    
}


- (void)footRefresh{
    self.start += kListPageSize;
    switch (self.tag) {
        case 0:
            [self fectProductTranList];
            break;
        case 1:
            [self fectRewardObjList];
            break;
        case 2:
            [self fectProductCommentList];
            break;
        case 3:
            [self fectProductLikeList];
            break;
            
        default:
            break;
    }
}


-(void) initTableHeadView {
    
    self.tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400 )];
    self.tableView.tableHeaderView = self.tableHeadView;
    [self initHeadView];
    [self initContentView];
    
}


- (void)initHeadView{
    
    
    
    UIView *headView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    
    
    UIImageView *headImgaeView = [[UIImageView alloc] init];
    headImgaeView.mj_x = 10;
    headImgaeView.mj_y = 10;
    headImgaeView.mj_h = 35;
    headImgaeView.mj_w = 35;
    [headImgaeView setImageWithURL:[NSURL URLWithString:self.productListModel.headImg] placeholder:[UIImage defaultHead]];
    [headView addSubview:headImgaeView];
    headImgaeView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userImageClick)];
    [headImgaeView addGestureRecognizer:tap];
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(55, 12, 200,12);
    nameLabel.text = @"???????"; // ???
    nameLabel.textColor = RGB_COLOR(153, 153, 153);
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:nameLabel];
    
    
    
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"???????";
    timeLabel.frame = CGRectMake(55, 33, 200,12);
    timeLabel.textColor = RGB_COLOR(153, 153, 153);
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:timeLabel];
    
    
    
    
    UIButton *collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectionButton setBackgroundImage:[UIImage imageNamed:@"yr_myCollect_no"] forState:UIControlStateNormal];
    [collectionButton setBackgroundImage:[UIImage imageNamed:@"yr_myCollect"] forState:UIControlStateSelected];
    collectionButton.frame = CGRectMake(SCREEN_WIDTH - 20 - 10, 18, 20, 20);
    [collectionButton addTarget:self action:@selector(collectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:collectionButton];
    
    [self.tableHeadView  addSubview:headView];
    
}


- (void)initContentView{
    
    
    UIView   *contentViewBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, 400)];
    [self.tableHeadView addSubview:contentViewBgView];
    
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.text = @"?????????";
    [contentViewBgView addSubview:titleLabel];
    
    
    UIImageView *videoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH - 20, 225)];
    [contentViewBgView addSubview:videoView];
    videoView.userInteractionEnabled = YES;
    self.imageVideo = videoView;
    //
    //    UIButton  *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    playButton.backgroundColor = [UIColor randomColor];
    //    playButton.mj_w = 75;
    //    playButton.mj_h = 50;
    //    playButton.centerX = videoView.centerX;
    //    playButton.mj_y = 88;
    //    [videoView addSubview:playButton];
    self.playerView = [[ZFPlayerView alloc] initWithFrame:videoView.bounds];
    
    NSURL *url = [NSURL URLWithString:self.productListModel.url];
    
    self.playerView.placeholderImageName = @"logo";
    self.playerView.videoURL = url;
    
    ZFPlayerControlView    *controlView = self.playerView.controlView;
    controlView.backBtn.hidden = YES;
    controlView.fullScreenBtn.selected = NO;
    [controlView.fullScreenBtn addTarget:self action:@selector(fullScreen:) forControlEvents:UIControlEventTouchUpInside];
    [controlView.playeBtn setImage:[UIImage imageNamed:@"yr_show_video"] forState:UIControlStateNormal];
    
    [videoView addSubview:self.playerView];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 275, SCREEN_WIDTH - 20 , 80)];
    contentLabel.numberOfLines = 0;
    contentLabel.text = self.productListModel.desc;
    contentLabel.font = [UIFont systemFontOfSize:15];
    [contentViewBgView addSubview:contentLabel];
    
    [self.tableHeadView  addSubview:contentViewBgView];
}

- (void)fullScreen:(UIButton *)sender{
    
    
    [self.playerView pause];
    YRVidioFullController *full = [[YRVidioFullController alloc]initWithNibName:@"YRVidioFullController" bundle:nil];
    NSArray *array = [self.playerView.controlView.currentTimeLabel.text componentsSeparatedByString:@":"];
    NSInteger time = [array[1] integerValue]+[array[0] integerValue]*60;
    //    播放的url地址
    full.url= self.playerView.videoURL;
    //播放的时间
    full.time = time;
    
    [self.navigationController pushViewController:full animated:YES];
    
}
//好友详情页跳转
- (void)userImageClick{
    
    [self pushUserInfoViewController:self.productListModel.uid withIsFriend:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.time>0&&self.url) {
        self.playerView.placeholderImageName = @"logo";
        [self.playerView resetToPlayNewURL];
        self.playerView.videoURL = self.url;
        self.playerView.seekTime = self.time;
        [self.playerView play];
        [self.playerView autoPlayTheVideo];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.playerView pause];
    //    [self.playerView resetPlayer];
    
}

- (void)initBottomView{
    
    UIView *bottonBgView = [[UIView alloc] init];
    [bottonBgView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bottonBgView];
    
    [bottonBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(40));
        make.left.equalTo(@(0));
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    
    UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    topLine.backgroundColor = RGB_COLOR(229, 229, 229);
    [bottonBgView addSubview:topLine];
    
    
    NSArray *array = @[@"转发挣收益",@"打赏",@"评论",@"点赞"];
    NSArray *imageNameArray = @[@"yr_button_tran",@"yr_button_reward",@"yr_button_comment",@"yr_button_unpraise"];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) {
            UIButton  *tranButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [tranButton setTitle:array[idx] forState:UIControlStateNormal];
            [tranButton setTitleColor:RGB_COLOR(153, 153, 153) forState:UIControlStateNormal];
            tranButton.frame = CGRectMake(0 , 0, 120 , 40);
            tranButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [tranButton setImage:[UIImage imageNamed:imageNameArray[idx]] forState:UIControlStateNormal];
            [bottonBgView addSubview:tranButton];
            
            UILabel  *verticalLabel = [[UILabel alloc] initWithFrame:CGRectMake(121, 7, 1, 26)];
            verticalLabel.backgroundColor = RGB_COLOR(229, 229, 229);
            [bottonBgView addSubview:verticalLabel];
            tranButton.tag = 100;
            [tranButton  addTarget:self action:@selector(buttonFuncTionClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
        }else{
            
            UIButton  *tranButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [tranButton setTitle:array[idx] forState:UIControlStateNormal];
            [tranButton setTitleColor:RGB_COLOR(153, 153, 153) forState:UIControlStateNormal];
            tranButton.frame = CGRectMake(120 + (SCREEN_WIDTH - 120) / 3 * (idx - 1), 0, (SCREEN_WIDTH - 120) / 3, 40);
            tranButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [tranButton setImage:[UIImage imageNamed:imageNameArray[idx]] forState:UIControlStateNormal];
            [bottonBgView addSubview:tranButton];
            tranButton.tag = 100 + idx;
            UILabel  *verticalLabel = [[UILabel alloc] initWithFrame:CGRectMake(120 + (SCREEN_WIDTH - 120) / 3 * (idx), 7, 1, 26)];
            verticalLabel.backgroundColor = RGB_COLOR(229, 229, 229);
            [bottonBgView addSubview:verticalLabel];
            
            [tranButton  addTarget:self action:@selector(buttonFuncTionClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }];
    
}

#pragma mark 点击事件

/**
 *  @author yichao, 16-08-22 16:08:14
 *
 *  转发按钮监听
 *
 *  @param btn <#btn description#>
 */
- (void)tranButtonClick:(UIButton*)btn{
    if (_inputView) {
        _inputView.hidden = YES;
    }
    if (self.selTitleButton) {
        [self.selTitleButton setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
        self.selTitleButton.transform = CGAffineTransformIdentity;
    }
    [btn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    _selTitleButton = btn;
    self.start = 0;
    [self fectProductTranList];
    self.tag = 0;
//    [self.tableView reloadData];
}

- (void)commentButtonClick:(UIButton*)btn{
    if (_inputView) {
        _inputView.hidden = YES;
    }
    if (self.selTitleButton) {
        [self.selTitleButton setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
        self.selTitleButton.transform = CGAffineTransformIdentity;
    }
    [btn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    _selTitleButton = btn;
    self.tag = 1;
    self.start = 0;
    [self fectProductCommentList];
//    [self.tableView reloadData];
}

- (void)rewardButtonClick:(UIButton*)btn{
    if (_inputView) {
        _inputView.hidden = YES;
    }
    if (self.selTitleButton) {
        [self.selTitleButton setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
        self.selTitleButton.transform = CGAffineTransformIdentity;
    }
    [btn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    _selTitleButton = btn;
    self.tag = 2;
    self.start = 0;
    [self fectRewardObjList];
//    [self.tableView reloadData];
    
}

- (void)priaseButtonClick:(UIButton*)btn{
    if (_inputView) {
        _inputView.hidden = YES;
    }
    self.underlineView.width = btn.titleLabel.width ;
    self.underlineView.height = 2;
    self.underlineView.centerX = btn.centerX;
    self.underlineView.mj_y = btn.mj_y + btn.mj_h + 4;
    
    if (self.selTitleButton) {
        [self.selTitleButton setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
        self.selTitleButton.transform = CGAffineTransformIdentity;
    }
    [btn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    _selTitleButton = btn;
    self.tag = 3;
    self.start = 0;
    [self fectProductLikeList];
//    [self.tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 36;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view  = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    
    UILabel  *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineLabel.backgroundColor = RGB_COLOR(229, 229, 229);
    [view addSubview:lineLabel];
    
    self.underlineView = [[UIImageView alloc] init];
    self.underlineView.backgroundColor = [UIColor themeColor];
    
    
    
    UIButton  * tranButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tranButton.frame = CGRectMake(10, 10, 60, 20);
    tranButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [tranButton setTitle:[NSString stringWithFormat:@"转发%ld",(long)self.productDetail.forwardCount] forState:UIControlStateNormal];
    [tranButton setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
    [tranButton addTarget:self action:@selector(tranButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:tranButton];
    
    
    self.underlineView.width =  65;
    self.underlineView.height = 2;
    self.underlineView.centerX = tranButton.centerX;
    self.underlineView.mj_y = tranButton.mj_x + tranButton.mj_h + 4;
    [view addSubview:self.underlineView];
    
    
    
    UIButton  * commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.titleLabel.font = [UIFont systemFontOfSize:15];
    commentButton.frame = CGRectMake(tranButton.mj_x + tranButton.mj_w + 20 , 10, 60, 20);
    [commentButton setTitle:[NSString stringWithFormat:@"打赏%ld",self.productDetail.rewardCount] forState:UIControlStateNormal];
    [commentButton setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:commentButton];
    
    
    UIButton  * rewardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rewardButton.titleLabel.font = [UIFont systemFontOfSize:15];
    rewardButton.frame = CGRectMake(commentButton.mj_x + commentButton.mj_w + 20, 10, 60, 20);
    [rewardButton setTitle:[NSString stringWithFormat:@"评论%ld",(long)self.productDetail.commentCount] forState:UIControlStateNormal];
    [rewardButton setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
    [rewardButton addTarget:self action:@selector(rewardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rewardButton];
    
    
    
    UIButton  * priaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    priaseButton.titleLabel.font = [UIFont systemFontOfSize:15];
    priaseButton.frame = CGRectMake(SCREEN_WIDTH - 80, 10, 60, 20);
    [priaseButton setTitle:[NSString stringWithFormat:@"赞%ld",(long)self.productDetail.goodCount] forState:UIControlStateNormal];
    [priaseButton setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
    [priaseButton addTarget:self action:@selector(priaseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:priaseButton];
    
    
    if (self.tag == 0) {
        self.underlineView.centerX = tranButton.centerX;
        self.underlineView.mj_y = tranButton.mj_y + tranButton.mj_h + 4;
        [tranButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    }else if (self.tag == 1){
        [commentButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        self.underlineView.centerX = commentButton.centerX;
        self.underlineView.mj_y = commentButton.mj_y + tranButton.mj_h + 4;
        
    }else if (self.tag == 2){
        [rewardButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        self.underlineView.centerX = rewardButton.centerX;
        self.underlineView.mj_y = rewardButton.mj_y + rewardButton.mj_h + 4;
        
    }else if (self.tag == 3){
        [priaseButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        self.underlineView.centerX = priaseButton.centerX;
        self.underlineView.mj_y = priaseButton.mj_y + priaseButton.mj_h + 4;
        
    }
    
    return view;
    
    
}


#pragma mark tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.tag == 0 ){
        return self.tranList.count;
    }else if(self.tag == 1 ){
        return self.giftList.count;
    }else if (self.tag == 2) {
        return self.commentList.count;
    }else{
        return self.likeList.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.tag == 0) {
        YRTranTableViewCell *topCell = [tableView dequeueReusableCellWithIdentifier:yrTranCellID];
        [topCell setTranModel:self.tranList[indexPath.row]];
        return topCell;
    } else if (self.tag == 1) {
        YRRewardTableViewCell *topCell = [tableView dequeueReusableCellWithIdentifier:yrRewardCellID];
        return topCell;
    }else if(self.tag == 2){
        YRCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:yrCommnetCellID];
        
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration = 1.0;
        [cell addGestureRecognizer:longPressGr];
        
        [cell setCommentModel:self.commentList[indexPath.row]];
        return cell;
    }else {
        YRTranTableViewCell *topCell = [tableView dequeueReusableCellWithIdentifier:yrTranCellID];
        topCell.timeLabel.hidden = YES;
        return topCell;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 44;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.tag == 2) {
        self.commentModel = self.commentList[indexPath.row];
        [self.view addSubview:self.inputView];
        self.inputView.textView.placeholder = [NSString stringWithFormat:@"回复:%@",self.commentModel.authorName];
        [self.inputView.textView becomeFirstResponder];
    }
    
}

#pragma mark 评论
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture{
    
    
    if (_inputView) {
        _inputView.hidden = YES;
    }
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *titles = @[@"删除评论"];
    [self addActionTarget:alert titles:titles indexPath:nil];
    [self addCancelActionTarget:alert title:@"取消"];
    
    // 会更改UIAlertController中所有字体的内容（此方法有个缺点，会修改所以字体的样式）
    UILabel *appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
    UIFont *font = [UIFont systemFontOfSize:15];
    appearanceLabel.font = font;
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

// 添加其他按钮
- (void)addActionTarget:(UIAlertController *)alertController titles:(NSArray *)titles indexPath:(NSIndexPath *)indexPath{
    for (NSString *title in titles) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            YRProuductCommentModel *commentModel = self.commentList[indexPath.row];
            
            [YRHttpRequest productDeleteComment:commentModel.uid success:^(id data) {
                [self.commentList removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
            } failure:^(id data) {
                
            }];
            
            
        }];
        [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
        [alertController addAction:action];
    }
}

// 取消按钮
- (void)addCancelActionTarget:(UIAlertController *)alertController title:(NSString *)title{
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        
    }];
    
    [action setValue:[UIColor wordColor] forKey:@"_titleTextColor"];
    [alertController addAction:action];
}

// iOS8.0之前可用
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




- (void)dealloc{
    DLog(@"detal die");
    
    [self.imageVideo removeAllSubviews];
    [self.tableView removeAllSubviews];
    [self.view removeAllSubviews];
    
    self.imageVideo = nil;
    self.tableView = nil;
    self.view = nil;
}


- (void)buttonFuncTionClick:(UIButton*)btn{
    btn.selected = !btn.selected;
    
    if (![YRUserInfoManager manager].currentUser.custId) {
        
        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"您尚未登录，请先登录！" cancelButtonText:@"取消" confirmButtonText:@"确定"];
        
        alertView.addCancelAction = ^{
            
        };
        alertView.addConfirmAction = ^{
            
        };
        [alertView show];
        return;
    }
    

    switch (btn.tag) {
        case 100:
        {
            
            YRRedPaperPaymentViewController *redVc = [[YRRedPaperPaymentViewController alloc]init];
            redVc.productModel = self.productListModel;
            [self.navigationController pushViewController:redVc animated:YES];
        }
            break;
        case 101:
        {
            [self.rewardGiftView showGiftView];
        }
            break;
            
        case 102:
        {
            self.inputView.hidden = NO;
            [self.view addSubview:self.inputView];
        }
            break;
        case 103:
        {
            
            if (btn.selected) {
                [btn setImage:[UIImage imageNamed:@"yr_button_praise"] forState:UIControlStateNormal];
                [self fectProductAddLikeAndUnLike:1];
            }else{
                [btn setImage:[UIImage imageNamed:@"yr_button_unpraise"] forState:UIControlStateNormal];
                [self fectProductAddLikeAndUnLike:0];
            }

        }
            break;
            
        default:
            break;
    }
    
}

- (void)collectionButtonClick:(UIButton*)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [YRHttpRequest productAddCollect:self.productListModel.uid like:1 success:^(id data) {
            [MBProgressHUD showSuccess:@"收藏成功"];
        } failure:^(id data) {
            [MBProgressHUD showError:NetworkError];
        }];
    }else{
        [YRHttpRequest productAddCollect:self.productListModel.uid like:0 success:^(id data) {
            [MBProgressHUD showSuccess:@"取消收藏"];
        } failure:^(id data) {
            [MBProgressHUD showError:NetworkError];
        }];
    }
    
}


#pragma mark input

- (void)textViewChangeHeightWithText:(NSString *)text Return:(BOOL)isReturn{
    CGFloat height = [self widthForString:text fontSize:16];
    
    if (isReturn) {
        self.inputView.frame = CGRectMake(0, SCREEN_HEIGHT-50-64, SCREEN_WIDTH, 50);\
        //回复评论
        if (self.commentModel.uid) {
            [YRHttpRequest poductCommentReply:self.productListModel.uid content:text replyBy:self.commentModel.uid replyId:self.commentModel.userid success:^(id data) {
                [MBProgressHUD showSuccess:@"回复成功"];
            } failure:^(id data) {
                [MBProgressHUD showError:NetworkError];
            }];
            
        }else{
            //添加评论
            [YRHttpRequest poductAddComment:self.productListModel.uid content:text success:^(id data) {
                [MBProgressHUD showSuccess:@"评论成功"];
            } failure:^(id data) {
                [MBProgressHUD showError:NetworkError];
            }];
        }
    }else{
        self.inputView.frame = CGRectMake(0, SCREEN_HEIGHT-64-31-height, SCREEN_WIDTH, 31+height);
    }    
}

-(float)widthForString:(NSString *)value fontSize:(float)fontSize{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-18, 100) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.height;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
