//
//  YRRedPackDetailViewController.m
//  YRYZ
//
//  Created by weishibo on 16/8/18.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedPackDetailViewController.h"
#import "YRTranTableViewCell.h"
#import "YRCommentTableViewCell.h"
#import "YRWebView.h"
#import "YRRedPaperPaymentViewController.h"
#import "RewardGiftView.h"
#import "ZXLayoutTextView.h"
#import "YRRedPaperView.h"
#import "YRRedPaperReceiveViewController.h"
#import "ZFPlayerView.h"
#import "YRVidioFullController.h"
#import "YRReportTextView.h"
#import "YRProuductCommentModel.h"
#import "YRProductListModel.h"
#import "YRRedListModel.h"
#import "YRAdListUserInfoController.h"
#import "SPKitExample.h"
#import "YRRedPaperListViewController.h"
#import "YRRedPaperReceiveViewController.h"
#import "YRRedPaperClearView.h"
static NSString *yrTranCellID = @"yrTranCellID";
static NSString *yrCommnetCellID = @"yrCommnetCellID";


@interface YRRedPackDetailViewController ()
<WKNavigationDelegate ,UITableViewDelegate ,UITableViewDataSource,YRCommentTableViewCellDelegate>
@property (strong, nonatomic)UIView                         *tableHeadView;
@property (strong, nonatomic)UITableView                    *tableView;
@property (strong, nonatomic)YRWebView                      *webView;
@property (strong, nonatomic)UIImageView                    *redPackView;
@property (nonatomic,strong) RewardGiftView                 *rewardGiftView;
//@property (nonatomic,strong)ZXLayoutTextView                *commentView;

@property (nonatomic,strong)UIButton                        *selTitleButton; //选中按钮
@property (nonatomic, strong) UIImageView                   *underlineView;//下划线


@property (nonatomic, assign)NSInteger                      tag; //选中的类型（打赏、评论等）
@property (nonatomic,assign) NSInteger                      start;

@property (nonatomic,strong) NSMutableArray                  *commentList; //评论列表
@property (nonatomic,strong) NSMutableArray                  *likeList;// 点赞
@property (nonatomic,strong) YRProuductCommentModel          *commentModel;
@property (nonatomic,strong)YRProductListModel               *productListModel;


@property (nonatomic,strong) ZFPlayerView                 *playerView;


@property (nonatomic,weak) UIImageView                    *imageVideo;
@property (nonatomic, assign)NSInteger                    totalComment;//评论数
@property (nonatomic, assign)NSInteger                    totalLike;//点赞数


@property (nonatomic, assign)NSInteger                      likeStatus;//点赞状态


@property (nonatomic ,strong)YRRedListModel                 *redModel;

@property (nonatomic ,strong)UILabel                        *nameLabel;
@property (nonatomic ,strong)UILabel                        *introductionLabel;

@property (nonatomic,strong)UIButton                        *commentButton;
@property (nonatomic,strong)UIButton                        *priaseButton;
@property (nonatomic ,strong)UILabel                        *timeLabel;
@property (nonatomic ,strong)UIButton                       *likeBottomButton;


@property (nonatomic, assign)CGFloat                        textH;



@end

@implementation YRRedPackDetailViewController


#pragma mark - Getter
//- (ZXLayoutTextView *)commentView {
//    if (!_commentView) {
//        @weakify(self);
//        _commentView = [[ZXLayoutTextView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT  - 64, SCREEN_WIDTH, 60.0f)];
//        _commentView.placeholder = @"请输入评论内容";
//        [_commentView setSendBlock:^(YRReportTextView *textView) {
//            @strongify(self);
//            NSString *uid = self.redPackerModel.adsId;
//            if ([uid isBlank]) {
//                [MBProgressHUD showError:@"作品不存在"];
//                return;
//            }
//            //            回复评论
//            if (self.commentModel.uid) {
//                [YRHttpRequest adsReplyComment:uid content:textView.text replyBy:self.commentModel.authorId replyId:self.commentModel.authorId success:^(id data) {
//                    [MBProgressHUD showSuccess:@"回复成功"];
//                    YRProuductCommentModel *model = [[YRProuductCommentModel alloc] init];
//                    
//                    
//                    model.authorName = [YRUserInfoManager manager].showUserName;
//                    model.authorHeadimg = [YRUserInfoManager manager].currentUser.custImg;
//                    model.authorId =  [YRUserInfoManager manager].currentUser.custId;
//                    model.content = textView.text;
//                    model.time = [NSString getCurrentMsTimestamp];
//                    model.userName  = self.commentModel.authorName;
//                    
//                    model.type = 2;
//                    model.uid = data;
//                    [self.commentList insertObject:model atIndex:0];
//                    
//                    self.commentView.textView.text = @"";
//                    self.totalComment += 1;
//                    [self.tableView reloadData];
//                    
//                } failure:^(id data) {
//                    [MBProgressHUD showError:data];
//                }];
//                
//            }else{
//                //添加评论
//                [YRHttpRequest adsAddComment:uid content:textView.text success:^(id data) {
//                    [MBProgressHUD showSuccess:@"评论成功"];
//                    YRProuductCommentModel *model = [[YRProuductCommentModel alloc] init];
//                    model.authorName = [YRUserInfoManager manager].currentUser.custNname;
//                    model.authorHeadimg = [YRUserInfoManager manager].currentUser.custImg;
//                    model.uid = data;
//                    model.content = textView.text;
//                    model.time = [NSString getCurrentMsTimestamp];
//                    model.type = 1;
//                    model.authorId = [YRUserInfoManager manager].currentUser.custId;
//                    [self.commentList insertObject:model atIndex:0];
//                    
//                    self.totalComment += 1;
//                    self.commentView.textView.text = @"";
//                    
//                    
//                    [self.tableView reloadData];
//                } failure:^(id data) {
//                    [MBProgressHUD showError:data];
//                }];
//            }
//            
//        }];
//    }
//    return _commentView;
//}

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
- (void)setStart:(NSInteger)start{
    if (start < 0) {
        _start = 0;
        return;
    }
    _start = start;
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



- (YRRedAdsModel *)redPackerModel{
    
    if (!_redPackerModel) {
        _redPackerModel = [[YRRedAdsModel alloc] init];
    }
    return _redPackerModel;
}


- (void)setTag:(NSInteger)tag{
    _tag = tag;
//    if (_tag == 0){
//        if((_commentList.count * 36 + 144) < SCREEN_HEIGHT){
//            self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (_commentList.count * 36 + 144))];
//        }else{
//            self.tableView.tableFooterView = nil;
//        }
//    }else
    
        if(_tag == 1){
        if((_likeList.count * 36 + 144) < SCREEN_HEIGHT){
            self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (_likeList.count * 36 + 144))];
        }else{
            self.tableView.tableFooterView = nil;
        }
    }
    self.tableView.tableFooterView.backgroundColor = RGB_COLOR(245, 245, 245);
    [self.tableView reloadData];
}


- (UIView*)nullFootView{

    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    footView.backgroundColor = [UIColor redColor];
    return footView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.redPackerModel.type != 0) {
        if (self.time > 0 && self.url) {
            self.playerView.placeholderImageName = @" ";
            [self.playerView resetToPlayNewURL];
            self.playerView.videoURL = self.url;
            self.playerView.seekTime = self.time;
            [self.playerView play];
            [self.playerView autoPlayTheVideo];
        }
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.playerView pause];
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)footerRefresh{
    self.start += kListPageSize;
//    switch (self.tag) {
//        case 0:
//            [self fectProductCommentList];
//            break;
//        case 1:
            [self fectProductLikeList];
//            break;
//        default:
//            break;
//    }
}

- (void)setTotalComment:(NSInteger)totalComment{
    _totalComment = totalComment;
    [self.commentButton  setTitle:[NSString stringWithFormat:@"评论%ld",(long)self.totalComment] forState:UIControlStateNormal];
}
- (void)setTotalLike:(NSInteger)totalLike{
    _totalLike = totalLike;
    [self.priaseButton  setTitle:[NSString stringWithFormat:@"赞%ld",(long)self.totalLike] forState:UIControlStateNormal];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tag = 1;
    self.likeStatus = 0;
    
    self.title = @"广告详情";
    self.textH = [self.redPackerModel.adsDesc heightForStringfontSize:15.f];
    [self fectDetailData];
    [self adsCommentsNum];
    
    [self initTableHeadView];
    [self initTableView];
    [self initBottomView];
    
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
//        [self fectProductCommentList];
        [self fectProductLikeList];
    });
    
    
}


-(void)setLikeStatus:(NSInteger)likeStatus{
    _likeStatus = likeStatus;
    
    if (likeStatus == 1) {
        [self.likeBottomButton setImage:[UIImage imageNamed:@"yr_button_praise"] forState:UIControlStateNormal];
    }else{
        [self.likeBottomButton setImage:[UIImage imageNamed:@"yr_button_unpraise"] forState:UIControlStateNormal];
    }
}


- (void)initTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableHeaderView = self.tableHeadView;
    [self.tableView setExtraCellLineHidden];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRTranTableViewCell class]) bundle:nil] forCellReuseIdentifier:yrTranCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRCommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:yrCommnetCellID];
    
    
    [self.tableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;//几个手指点击
    tableViewGesture.cancelsTouchesInView = NO;//是否取消点击处的其他action
    [self.tableView addGestureRecognizer:tableViewGesture];
    
    
}


// ------tableView 上添加的自定义手势
- (void)tableViewTouchInSide{
    
    [self.view endEditing:YES];
}

- (void)rightNavAction:(UIButton*)button{
    [self.view endEditing:YES];
    
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
    
    
    NSArray *array = @[@" 联系TA",@" 点赞"];
    NSArray *imageNameArray = @[@"r_Tel_Ta",@"yr_button_unpraise"];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx ==0) {
            UIButton  *tranButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [tranButton setTitle:array[idx] forState:UIControlStateNormal];
            [tranButton setTitleColor:RGB_COLOR(85,85,85) forState:UIControlStateNormal];
            tranButton.frame = CGRectMake( SCREEN_WIDTH/2 * idx, 0, SCREEN_WIDTH/2 , 40);
            tranButton.titleLabel.font = [UIFont titleFont18];
            [tranButton setImage:[UIImage imageNamed:imageNameArray[idx]] forState:UIControlStateNormal];
            [bottonBgView addSubview:tranButton];
            tranButton.tag = 100 + idx;
            [tranButton  addTarget:self action:@selector(buttonFuncTionClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            
            self.likeBottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.likeBottomButton setTitle:array[idx] forState:UIControlStateNormal];
            [self.likeBottomButton setTitleColor:RGB_COLOR(85,85,85) forState:UIControlStateNormal];
            self.likeBottomButton.frame = CGRectMake( SCREEN_WIDTH/2 * idx, 0, SCREEN_WIDTH/2 , 40);
            self.likeBottomButton.titleLabel.font = [UIFont titleFont18];
            [self.likeBottomButton setImage:[UIImage imageNamed:imageNameArray[idx]] forState:UIControlStateNormal];
            [bottonBgView addSubview:self.likeBottomButton];
            self.likeBottomButton.tag = 100 + idx;
            [ self.likeBottomButton  addTarget:self action:@selector(buttonFuncTionClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        UILabel  *verticalLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH) / 2 * (idx), 7, 1, 26)];
        verticalLabel.backgroundColor = RGB_COLOR(229, 229, 229);
        [bottonBgView addSubview:verticalLabel];
        
    }];
    
}



-(void) initTableHeadView {
    self.tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.tableHeadView.userInteractionEnabled = YES;
    [self initHeadView];
    //0 图文广告
    if (self.redPackerModel.type == 0) {
        [self initWebView];
        [self initRedPackView];
    }else{
        [self initVideoView];
        self.tableHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 400 + self.textH + 120);
    }
}
/**
 *  @author weishibo, 16-08-18 19:08:40
 *
 *  视频控件初始化
 */
- (void)initVideoView{
    UIView   *contentViewBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH,400 + self.textH + 120)];
    [self.tableHeadView addSubview:contentViewBgView];
    
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.text = self.redPackerModel.title;
    [contentViewBgView addSubview:titleLabel];
    
    
    UIImageView *videoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH - 20, 225)];
    videoView.backgroundColor = [UIColor clearColor];
    [videoView setImageWithURL:[NSURL URLWithString:self.redPackerModel.smallPic] placeholder:nil];
    [contentViewBgView addSubview:videoView];
    videoView.userInteractionEnabled = YES;
    self.imageVideo = videoView;
    self.playerView = [[ZFPlayerView alloc] initWithFrame:videoView.bounds];
    
    NSURL *url = [NSURL URLWithString:self.redPackerModel.contentPath ? self.redPackerModel.contentPath :@""];
    
    self.playerView.placeholderImageName = @"";
    self.playerView.videoURL = url;
    
    ZFPlayerControlView    *controlView = self.playerView.controlView;
    controlView.backBtn.hidden = YES;
    controlView.fullScreenBtn.selected = NO;
    [controlView.fullScreenBtn addTarget:self action:@selector(fullScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [videoView addSubview:self.playerView];
    
    
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.mj_x = 10;
    contentLabel.mj_y = videoView.mj_y + videoView.mj_h + 8;
    contentLabel.mj_w = SCREEN_WIDTH - 20;
    contentLabel.mj_h = self.textH;
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.numberOfLines = 0;
    contentLabel.text = self.redPackerModel.adsDesc;
    [contentLabel   sizeToFit];
    
    
    [contentViewBgView addSubview:contentLabel];
    
    
    self.redPackView = [[UIImageView alloc] init];
    self.redPackView.userInteractionEnabled = YES;
    self.redPackView.mj_x = 0;
    self.redPackView.mj_y = contentLabel.mj_y + contentLabel.mj_h + 8;
    self.redPackView.mj_w = SCREEN_WIDTH;
    self.redPackView.mj_h = 140;
    self.redPackView.hidden = NO;
    [contentViewBgView addSubview:self.redPackView];
    
    
    UIButton  *redPackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [redPackButton setImage:[UIImage imageNamed:@"yr_ads_redPack"] forState:UIControlStateNormal];
    redPackButton.frame = CGRectMake((SCREEN_WIDTH - 74)/2, 20, 74, 74);
    [redPackButton addTarget:self action:@selector(redButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.redPackView addSubview:redPackButton];
    
    
    UIImageView * adsTag = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 35, 10, 25, 12.5)];
    [adsTag setImage:[UIImage imageNamed:@"adsicon"]];
    [self.redPackView addSubview:adsTag];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.mj_y = redPackButton.mj_y + redPackButton.mj_h + 10;
    tipLabel.mj_x = 0;
    tipLabel.mj_w = SCREEN_WIDTH;
    tipLabel.mj_h = 15;
    tipLabel.text = @"点击领取红包";
    tipLabel.textColor = RGB_COLOR(255, 96, 96);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.redPackView addSubview:tipLabel];
    
    
    [self.tableHeadView  addSubview:contentViewBgView];
}


- (void)initHeadView{
    UIView *headView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    
    UIImageView *headImgaeView = [[UIImageView alloc] init];
    headImgaeView.mj_x = 10;
    headImgaeView.mj_y = 10;
    headImgaeView.mj_h = 35;
    headImgaeView.mj_w = 35;
    [headImgaeView setCircleHeadWithPoint:CGPointMake(35, 35) radius:4];
    [headImgaeView setImageWithURL:[NSURL URLWithString:self.redPackerModel.headImg] placeholder:[UIImage defaultHead]];
    [headView addTapGesturesTarget:self selector:@selector(headImageClick)];
    [headView addSubview:headImgaeView];
    
    
    NSString  *headName = self.redPackerModel.nickName;
    if (!headName) {
        headName = [YRUserInfoManager manager].currentUser.custNname ? [YRUserInfoManager manager].currentUser.custNname :[YRUserInfoManager manager].currentUser.custName;
    }
    
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.numberOfLines = 1;
    nameLabel.text = headName;
    nameLabel.textColor = RGB_COLOR(51, 51, 51);
    nameLabel.font = [UIFont titleFont15];
    [nameLabel addTapGesturesTarget:self selector:@selector(headImageClick)];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:nameLabel];
    
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = RGB_COLOR(27, 194, 184);
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.font = [UIFont titleFont12];
    [headView addSubview:self.timeLabel];
    
    self.introductionLabel = [[UILabel alloc] init];
    self.introductionLabel.textColor = RGB_COLOR(153, 153, 153);
    self.introductionLabel.textAlignment = NSTextAlignmentLeft;
    self.introductionLabel.font = [UIFont titleFont13];
    [headView addSubview:self.introductionLabel];
    
    UILabel * numLabel = [[UILabel alloc]init];
    numLabel.font = [UIFont titleFont13];
    numLabel.textColor = RGB_COLOR(153, 153, 153);
    [headView addSubview:numLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImgaeView.mas_right).offset(10);
        make.top.equalTo(headImgaeView.mas_top);
        make.height.equalTo(@(14));
    }];
    
    
    //个性签名
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImgaeView.mas_top);
        make.height.equalTo(@(14));
        make.left.equalTo(nameLabel.mas_right).offset(10);
        
    }];
    
    //时间
    [self.introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headImgaeView.mas_bottom);
        make.left.equalTo(nameLabel.mas_left);
        make.height.equalTo(@(13));
        make.right.lessThanOrEqualTo(numLabel.mas_left).offset(-10);
    }];
    
    
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.equalTo(timeLabel.mas_right);
        make.bottom.equalTo(headImgaeView.mas_bottom);
        //        make.right.lessThanOrEqualTo(headView.mas_right);
        make.height.equalTo(@(14));
        make.width.lessThanOrEqualTo(@(100));
    }];
    
    
    UIButton *redBagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [redBagButton setImage:[UIImage imageNamed:@"yr_button_havered"] forState:UIControlStateNormal];
    redBagButton.frame =  CGRectMake(SCREEN_WIDTH - 40 - 10, 5, 44, 44);
    [redBagButton addTarget:self action:@selector(redButtonHeadClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:redBagButton];
    
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@",self.redPackerModel.nickName];
    self.timeLabel.text =  @"";
    self.introductionLabel.text = [NSString getDateStringWithTimestamp:self.redPackerModel.upedTime];
    //    [numButton setTitle:[NSString stringWithFormat:@"%@",self.redPackerModel.readCount] forState:UIControlStateNormal];
    numLabel.text = [NSString stringWithFormat:@"浏览次数 %@",self.redPackerModel.readCount];
    [self.tableHeadView  addSubview:headView];
    
}


- (void)initWebView{
    self.webView = [[YRWebView alloc] init];
    self.webView.frame = CGRectMake(0, 55, SCREEN_WIDTH , 100);
    self.webView.navigationDelegate = self;
    [self.tableHeadView  addSubview:self.webView];
    
}


- (void)initRedPackView{
    self.redPackView = [[UIImageView alloc] init];
    self.redPackView.frame = CGRectMake(0, self.webView.mj_x + self.webView.mj_h + 12, SCREEN_WIDTH, 140);
    self.redPackView.userInteractionEnabled = YES;
    self.redPackView.hidden = YES;
    [self.tableHeadView addSubview:self.redPackView];
    
    
    UIButton  *redPackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [redPackButton setImage:[UIImage imageNamed:@"yr_ads_redPack"] forState:UIControlStateNormal];
    redPackButton.frame = CGRectMake((SCREEN_WIDTH - 74)/2, 20, 74, 74);
    [redPackButton addTarget:self action:@selector(redButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.redPackView addSubview:redPackButton];
    
    UIImageView * adsTag = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 35, 10, 25, 14)];
    [adsTag setImage:[UIImage imageNamed:@"adsicon"]];
    [self.redPackView addSubview:adsTag];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.mj_y = redPackButton.mj_y + redPackButton.mj_h + 10;
    tipLabel.mj_x = 0;
    tipLabel.mj_w = SCREEN_WIDTH;
    tipLabel.mj_h = 15;
    tipLabel.text = @"点击领取红包";
    tipLabel.font = [UIFont titleFont16];
    tipLabel.adjustsFontSizeToFitWidth = YES;
    tipLabel.textColor = RGB_COLOR(255, 96, 96);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.redPackView addSubview:tipLabel];
}


- (void)headImageClick{
    
    [self pushUserInfoViewController:self.redPackerModel.custId withIsFriend:YES];
}

#pragma mark - NJKWebViewProgressDelegate



-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //    document.body.offsetHeight;
    
    @weakify(self);
    [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError *_Nullable error) {
        @strongify(self);
        //获取页面高度，并重置webview的frame
        CGFloat height = [result doubleValue];
        if(SCREEN_WIDTH <= 375){
            height = height / 2.0f;
        }else{
            height = height / 3.0f;
        }
        
        
        CGRect frame = webView.frame;
        frame.size.height = height;
        webView.frame = frame;
        
        self.tableHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height + 140 + 50 + 20);
        [self.tableHeadView addSubview:webView];
        
        
        self.tableView.tableHeaderView = self.tableHeadView;
        
        
        self.redPackView.hidden = NO;
        self.redPackView.frame =  CGRectMake(0, 50 + self.webView.mj_x + self.webView.mj_h + 12  , SCREEN_WIDTH, 140);
    }];
    
}

- (void)didClickLongPressGestureRecognizerCellWithIndexPath:(NSIndexPath *)indexPath{
    
//    if (_commentView) {
//        _commentView.hidden = YES;
//        [_commentView.textView resignFirstResponder];
//    }
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *titles = @[@"删除评论"];
    [self addActionTarget:alert titles:titles indexPath:indexPath];
    [self addCancelActionTarget:alert title:@"取消"];
    
    // 会更改UIAlertController中所有字体的内容（此方法有个缺点，会修改所以字体的样式）
    UILabel *appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
    UIFont *font = [UIFont systemFontOfSize:15];
    appearanceLabel.font = font;
    
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - UITableViewDelegate & UITableViewDataSource

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (_commentView) {
//        self.commentModel = nil;
//        _commentView.placeholder = @"请输入评论内容";
//        _commentView.hidden = YES;
//        [_commentView.textView resignFirstResponder];
//    }
    
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
    
//    self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.commentButton .frame = CGRectMake(10, 10, 60, 20);
//    self.commentButton .titleLabel.font = [UIFont systemFontOfSize:16];
//    [self.commentButton  setTitle:[NSString stringWithFormat:@"评论%ld",(long)self.totalComment] forState:UIControlStateNormal];
//    [self.commentButton  setTitleColor:RGB_COLOR(102, 102, 102) forState:UIControlStateNormal];
//    [self.commentButton  addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:self.commentButton ];
    

    
    
    
    self.priaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.priaseButton .frame = CGRectMake(10, 10, 60, 20);
    self.priaseButton .titleLabel.font = [UIFont systemFontOfSize:16];
    [self.priaseButton  setTitle:[NSString stringWithFormat:@"赞%ld",(long)self.totalLike] forState:UIControlStateNormal];
    [self.priaseButton  setTitleColor:RGB_COLOR(102, 102, 102) forState:UIControlStateNormal];
    [self.priaseButton  setTitleColor:[UIColor themeColor] forState:UIControlStateSelected];
    [self.priaseButton  addTarget:self action:@selector(priaseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.priaseButton ];
    
    
//    if (self.tag == 0) {
//        self.underlineView.centerX = self.commentButton .centerX;
//        self.underlineView.mj_y = self.commentButton.mj_y + self.commentButton.mj_h + 4;
//    }else if (self.tag == 1){
//        self.underlineView.centerX = self.priaseButton .centerX;
//        self.underlineView.mj_y = self.priaseButton.mj_y + self.priaseButton.mj_h + 4;
//    }

    self.underlineView.width =  65;
    self.underlineView.height = 3;
    self.underlineView.centerX = self.priaseButton .centerX;
    self.underlineView.mj_y = self.priaseButton.mj_y + self.priaseButton.mj_h + 4;
    //    self.underlineView.centerX = self.commentButton.centerX;
    //    self.underlineView.mj_y = self.commentButton.mj_x + self.commentButton.mj_h + 4;
    [view addSubview:self.underlineView];
    
    
    return view;
    
    
}




- (void)commentButtonClick:(UIButton*)btn{
//    if (_commentView) {
//        _commentView.hidden = YES;
//        [_commentView.textView resignFirstResponder];
//    }
    [btn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    
    self.start = 0;
    self.tag = 0;
    
}



- (void)priaseButtonClick:(UIButton*)btn{
//    if (_commentView) {
//        _commentView.hidden = YES;
//        [_commentView.textView resignFirstResponder];
//    }
    [btn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    self.tag = 1;
    self.start = 0;
    
}
/**
 *  @author weishibo, 16-08-17 20:08:34
 *
 *  底部4个功能按钮action
 *
 *  @param b <#b description#>
 */
- (void)buttonFuncTionClick:(UIButton*)btn{
    
    [self doSth:btn];
    
}

- (void)doSth:(UIButton*)btn{
    
    if (![YRUserInfoManager manager].currentUser.custId) {
        [self noLoginTip];
        return;
    }
    btn.selected = !btn.selected;
    switch (btn.tag) {
//        case 100:
//        {
//            self.tag = 0;
//            self.commentView.hidden = NO;
//            [self.view addSubview:self.commentView];
//            [self.commentView.textView becomeFirstResponder];
//        }
//            break;
            //联系他
        case 100:
        {
            
            
            if ([self.redPackerModel.custId isEqualToString:[YRUserInfoManager manager].currentUser.custId]) {
                [MBProgressHUD showError:@"自己的广告"];
                return;
            }
            if (self.redPackerModel.custId) {
                YWPerson *person = [[YWPerson alloc] initWithPersonId:self.redPackerModel.custId];
                [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithPerson:person fromNavigationController:self.navigationController];
            }

        }
            break;
            //点赞
            
        case 101:
        {
            
            self.tag = 1;
            if (self.likeStatus == 0) {
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


#pragma mark 红包按钮监听


- (void)redButtonHeadClick:(UIButton*)button{
    
    
    if (![YRUserInfoManager manager].currentUser.custId ) {
        [self noLoginTip];
        return;
    }
    
    if (!self.redPackerModel.redpacketId) {
        [MBProgressHUD showError:@"无效红包" toView:self.view];
        return;
    }
    
    if ([self.redPackerModel.custId isEqualToString:[YRUserInfoManager manager].currentUser.custId]) {
        YRRedPaperListViewController  *redRecordVc = [[YRRedPaperListViewController alloc] init];
        redRecordVc.redId = self.redPackerModel.redpacketId;
        [self.navigationController pushViewController:redRecordVc animated:YES];
    }else{
        [MBProgressHUD showSuccess:@"查看完整广告即可获得一个红包"];
    }
    
}

- (void)redButtonClick:(UIButton*)button{
    
    if (![YRUserInfoManager manager].currentUser.custId ) {
        [self noLoginTip];
        return;
    }
    
    if (!self.redPackerModel.redpacketId) {
        [MBProgressHUD showError:@"无效红包" toView:self.view];
        return;
    }
    
    
    [self fectRobRed:self.redPackerModel];
    
}


- (void)fectRobRed:(YRRedAdsModel*)redPackerModel{
    
    if (!redPackerModel.redpacketId ) {
        [MBProgressHUD showError:@"无效红包"];
        return;
    }
    
    [MBProgressHUD showMessage:@""];
    
    
    [YRHttpRequest robRed:redPackerModel.redpacketId success:^(NSDictionary  *data) {
        [MBProgressHUD hideHUD];
        NSUInteger code = [data[@"code"] integerValue];
        
        YRRedListModel  *model =  [YRRedListModel mj_objectWithKeyValues:data];
        
        NSLog(@"%ld",code);
        
        //1:成功，3:失败,22:已拆 21:已过期 23:已抢光 24:自己的红包 20:广告红包没有审核
        switch (code) {
            case 1:
            {
                [self fectOpenRed:redPackerModel];
            }
                break;
            case 3:
            {
                [MBProgressHUD showSuccess:@"失败"];
            }
                break;
            case 21:
            {
                [YRRedPaperClearView showRedPaperClearViewWithName:@"redPaperOverImage"];
            }
                break;
            case 22:
            {
                if (![model.custId isEqualToString:[YRUserInfoManager manager].currentUser.custId]) {
                    YRRedPaperReceiveViewController *redVc = [[YRRedPaperReceiveViewController alloc] init];
                    redVc.redModel = model;
                    [self.navigationController pushViewController:redVc animated:YES];
                }else{
                    YRRedPaperListViewController  *redRecordVc = [[YRRedPaperListViewController alloc] init];
                    redRecordVc.redId = self.redPackerModel.redpacketId;
                    [self.navigationController pushViewController:redRecordVc animated:YES];
                    
                }
            }
                break;
            case 23:
            {
                
                [YRRedPaperClearView showRedPaperClearViewWithName:@"redPaperClearImage"];
                
            }
                break;
            case 24:
            {
                [self fectOpenRed:redPackerModel];
                
            }
                break;
            case 20:
            {
                [MBProgressHUD showSuccess:@"广告红包没有审核"];
            }
                break;
            default:
                break;
        }
    } failure:^(id data) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:data];
    }];
    
}

/**
 *  @author weishibo, 16-08-26 17:08:02
 *
 *  拆红包
 */
- (void)fectOpenRed:(YRRedAdsModel*)redPackerModel{
    @weakify(self);
    [YRRedPaperView showRedPaperViewWithName:redPackerModel.nickName OpenBlock:^(){
        @strongify(self);
        
        if (!redPackerModel.redpacketId ) {
            [MBProgressHUD showError:@"无效红包"];
            return;
        }
        
        [YRHttpRequest openRed:redPackerModel.redpacketId friendStatus:1 success:^(NSDictionary *data) {
            
            self.redModel = [YRRedListModel mj_objectWithKeyValues:data];
            if (self.redModel) {
                
                if (![self.redModel.custId isEqualToString:[YRUserInfoManager manager].currentUser.custId]) {
                    [self addFriend:self.redModel.custId];
                }
                YRRedPaperReceiveViewController *viewController = [[YRRedPaperReceiveViewController alloc]init];
                viewController.redModel = self.redModel;
                [self.navigationController pushViewController:viewController animated:NO];
            }
        } failure:^(id data) {
            [MBProgressHUD showError:data];
        }];
    }];
    
}


- (void)addFriend:(NSString*)custID{
    
    [YRHttpRequest AddOrRemoveAttentionToRemoveByType:@"1" friendID:custID actionType:@(0) success:^(NSDictionary *data) {
        
    } failure:^(NSString *error) {
        [MBProgressHUD showError:error];
    }];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_tag == 0 ){
        return self.commentList.count;
    }else{
        return self.likeList.count;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tag == 0) {
        YRCommentTableViewCell  *topCell = [tableView dequeueReusableCellWithIdentifier:yrCommnetCellID];
        [topCell setCommentModel:self.commentList[indexPath.row]];
        topCell.delegate = self;
        topCell.indexPath = indexPath;
        return topCell;
    }else{
        YRTranTableViewCell *topCell = [tableView dequeueReusableCellWithIdentifier:yrTranCellID];
        topCell.timeLabel.hidden = YES;
        [topCell setCircleTranModel:self.likeList[indexPath.row]];
        return topCell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (![YRUserInfoManager manager].currentUser.custId) {
        [self noLoginTip];
        return;
    }
    if (_tag == 0) {
//        self.commentModel = self.commentList[indexPath.row];
//        if ([self.commentModel.authorId isEqualToString:[YRUserInfoManager manager].currentUser.custId]) {
//            self.commentModel = nil;
//            return;
//        }
//        self.commentView.hidden = NO;
//        [self.view addSubview:self.commentView];
//        self.commentView.placeholder = [NSString stringWithFormat:@"回复:%@",self.commentModel.authorName];
//        [self.commentView.textView becomeFirstResponder];
        
    }
    if (_tag==1) {
        
        
        if (self.likeList != nil) {
            
            YRProudTranModel * model = self.likeList[indexPath.row];
            
            [self pushUserInfoViewController:model.userid withIsFriend:YES];
            
            
        }
        
    }
    
    
    
}
#pragma mark input

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark 视频广告

- (void)fullScreen:(UIButton *)sender{
    
    
    [self.playerView pause];
    YRVidioFullController *full = [[YRVidioFullController alloc]initWithNibName:@"YRVidioFullController" bundle:nil];
    
    
    //     DLog(@"%@",self.playerView.controlView.currentTimeLabel.text);
    NSArray *array = [self.playerView.controlView.currentTimeLabel.text componentsSeparatedByString:@":"];
    
    NSInteger time = [array[1] integerValue]+[array[0] integerValue]*60;
    
    
    //    播放的url地址
    full.url= self.playerView.videoURL;
    //播放的时间
    full.time = time;
    
    [self.navigationController pushViewController:full animated:YES];
    
}


#pragma mark 评论


// 添加其他按钮
- (void)addActionTarget:(UIAlertController *)alertController titles:(NSArray *)titles indexPath:(NSIndexPath *)indexPath{
    for (NSString *title in titles) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            YRProuductCommentModel *commentModel = self.commentList[indexPath.row];
            
            [YRHttpRequest adsDeleteComment:commentModel.uid custId:commentModel.authorId
                                    success:^(id data) {
                                        [self.commentList removeObjectAtIndex:indexPath.row];
                                        self.totalComment = self.totalComment - 1;
                                        [self.tableView reloadData];
                                    } failure:^(id data) {
                                        [MBProgressHUD showError:data];
                                    }];
        }];
        if (SYSTEMVERSION>=8.4) {
            [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
        }
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




#pragma mark fect

/**
 *  @author yichao, 16-08-22 16:08:37
 *
 *  点赞取消点赞
 *
 *  @param like 0取消 1点赞
 */
- (void)fectProductAddLikeAndUnLike:(NSInteger)like{
    
    NSString *uid = self.redPackerModel.adsId;
    
    if ([uid isBlank]) {
        [MBProgressHUD showError:@"广告不存在"];
        return;
    }
    
    
    [YRHttpRequest adAddLikeOrUnLike:uid like:like success:^(id data) {
        
        
        YRProudTranModel *model = [[YRProudTranModel alloc] init];
        if (like == 0) {
            [MBProgressHUD showSuccess:@"取消点赞"];
            
            [self.likeList enumerateObjectsUsingBlock:^(YRProudTranModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.userid isEqualToString:[YRUserInfoManager manager].currentUser.custId]) {
                    [self.likeList removeObject:obj];
                }
            }];
            self.totalLike -= 1;
        }else{
            [MBProgressHUD showSuccess:@"点赞成功"];
            
            model.userName = [YRUserInfoManager manager].currentUser.custNname;
            model.userHeadimg = [YRUserInfoManager manager].currentUser.custImg;
            model.userid = [YRUserInfoManager manager].currentUser.custId;
            [self.likeList insertObject:model atIndex:0];
            
            self.totalLike += 1;
        }
        
        self.likeStatus = like;
        [self.tableView reloadData];
        
        
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
    
    NSString *uid = self.redPackerModel.adsId;
    
    if ([uid isBlank]) {
        [MBProgressHUD showError:@"作品不存在"];
        return;
    }
    
    
    [YRHttpRequest adsCommentList:uid start:self.start    limit:kListPageSize success:^(NSArray *data) {
        NSMutableArray    *array= [YRProuductCommentModel mj_objectArrayWithKeyValuesArray:data];
        if (self.start == 0) {
            [self.commentList removeAllObjects];
        }
        
        [array enumerateObjectsUsingBlock:^(YRProuductCommentModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.auditStatus==2 ||obj.delFlag==1) {
                
            }else{
                [self.commentList addObject:obj];
            }
        }];
        
        
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
 *  @author yichao, 16-08-22 15:08:45
 *
 *  点赞列表
 */
- (void)fectProductLikeList{
    NSString *uid = self.redPackerModel.adsId;
    
    if ([uid isBlank]) {
        [MBProgressHUD showError:@"作品不存在"];
        return;
    }
    
    
    @weakify(self);
    [YRHttpRequest adsLikeList:uid start:self.start  limit:kListPageSize success:^(NSArray *data) {
        @strongify(self);
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


- (void)adsCommentsNum{
    NSString *uid = self.redPackerModel.adsId;
    
    if ([uid isBlank]) {
        [MBProgressHUD showError:@"作品不存在"];
        return;
    }
    [YRHttpRequest adsCommentsNum:uid success:^(NSDictionary *data) {
        self.totalComment = [data[@"totalComment"] integerValue];
        self.totalLike = [data[@"totalLike"] integerValue];
        self.likeStatus = [data[@"likeStatus"] integerValue];
        [self.tableView reloadData];
    } failure:^(id data) {
        [MBProgressHUD showError:data];
    }];
    
}

/**
 *  @author weishibo, 16-08-20 16:08:43
 *
 *  获取详情
 */
- (void)fectDetailData{
    NSString *uid = self.redPackerModel.adsId;
    if (!uid) {
        [MBProgressHUD showError:@"广告不存在"];
        return;
    }
    @weakify(self);
    [YRHttpRequest adsdetailProductId:uid success:^(NSDictionary *data) {
        @strongify(self);
        self.redPackerModel = [YRRedAdsModel mj_objectWithKeyValues:data];
        
        
        self.nameLabel.text = self.redPackerModel.nickName;
        self.introductionLabel.text = [NSString getDateStringWithTimestamp:self.redPackerModel.upedTime];
        self.timeLabel.text =  @"";
        
        NSString *urlStr = self.redPackerModel.contentPath;
        if ([urlStr containsString:@"vpc100-"]) {
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"vpc100-" withString:@""];
        }
        
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        
        
        if (self.redPackerModel.type == 1) {
            self.playerView.videoURL = url;
        }else if (self.redPackerModel.type == 0){
            [self.webView loadRequest:request];
        }
        
        [self.tableView reloadData];
    } failure:^(id data) {
        [MBProgressHUD showError:data];
    }];
    
}



@end
