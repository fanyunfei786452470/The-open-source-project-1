//
//  YRCirleDetailViewController.m
//  YRYZ
//
//  Created by weishibo on 16/8/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRCirleDetailViewController.h"
#import "YRTranTableViewCell.h"
#import "YRRewardTableViewCell.h"
#import "YRCommentTableViewCell.h"
#import "YRWebView.h"
#import "YRMyShareView.h"
#import "YRRedPaperPaymentViewController.h"
#import "RewardGiftView.h"
#import "ZXLayoutTextView.h"
#import "YRRedPaperView.h"
#import "YRRedPaperReceiveViewController.h"
#import "YRAudioUrlPlayView.h"
#import "ZFPlayerView.h"
#import "YRVidioFullController.h"
#import "YRRedListModel.h"
#import "YRRewardListModel.h"
#import "YRProductDetail.h"
#import "SKTagView.h"

#import "YRLoginController.h"
#import "YRReportTextView.h"
#import "RRZSaveMoneyController.h"
#import "YRTagSearchCOntroller.h"
#import "YRPaymentPasswordView.h"
#import "YRAddNewGroupViewController.h"
#import "YRRedListModel.h"
#import "YRChangePayPassWordController.h"
#import "YRRedPaperListViewController.h"
#import "AppDelegate.h"
#import "LWLoadingView.h"
#import "YRRedPaperClearView.h"
#import "YRCircleListModel.h"
static NSString *yrTranCellID = @"yrTranCellID";
static NSString *yrRewardCellID = @"yrRewardCellID";
static NSString *yrCommnetCellID = @"yrCommnetCellID";

@interface YRCirleDetailViewController ()
<WKNavigationDelegate ,UITableViewDelegate ,UITableViewDataSource,YRCommentTableViewCellDelegate,TranSuccessDelegate>
@property (strong, nonatomic)UIView                         *tableHeadView;
@property (strong, nonatomic)UITableView                    *tableView;
@property (strong, nonatomic)SKTagView                      *tagView;
@property (strong, nonatomic)YRWebView                      *webView;
@property (nonatomic,strong) YRMyShareView                  *shareView;
@property (nonatomic,strong) RewardGiftView                 *rewardGiftView;
@property (nonatomic,strong) ZXLayoutTextView               *commentView;

@property (nonatomic,strong) YRAudioUrlPlayView             *soundPlayView;

@property (nonatomic, strong) UIImageView                   *underlineView;//下划线
@property (nonatomic, strong)UIButton                       *bottomTranButton;//底部转发按钮
@property (nonatomic, strong)UIButton                       *bottomLikeButton;//底部转发按钮


@property (nonatomic, assign) NSInteger                      tag; //选中的类型（打赏、评论等）


@property (nonatomic,strong) ZFPlayerView                    *playerView;
@property (nonatomic,weak)   UIImageView                     *imageVideo;


@property (nonatomic,strong) NSMutableArray                  *commentList; //评论列表
@property (nonatomic,strong) NSMutableArray                  *likeList;// 点赞
@property (nonatomic,strong) NSMutableArray                  *tranList;//转发列表
@property (nonatomic,strong) NSMutableArray                  *giftList;// 礼物列表
@property (nonatomic,strong) YRProuductCommentModel          *commentModel;

@property (nonatomic,assign) NSInteger                       start;

@property (nonatomic,strong)UILabel                         *introductionLabel;
@property (nonatomic,strong)UIButton                        *tranButton;
@property (nonatomic,strong)UIButton                        *commentButton;
@property (nonatomic,strong)UIButton                        *rewardButton;
@property (nonatomic,strong)UIButton                        *priaseButton;





//是否设置支付密码
@property (nonatomic, assign) BOOL                          havePassword;
//小额免密开关
@property (nonatomic, assign) BOOL                          smallNopass;



@property (nonatomic, assign) NSInteger                     collectStatus;
@property (nonatomic,strong)UIButton                        *collectionButton;
@property (nonatomic, assign)NSInteger                      likeStatus;//点赞状态

@property (nonatomic ,strong)YRRedListModel                 *redModel;

@property(nonatomic ,strong)NSString                        *forwardCount;//转发数
@property (nonatomic, assign)NSInteger                       commentCount;//评论数
@property (nonatomic, assign)NSInteger                       totalLike;//点赞数rewardCount
@property (nonatomic, assign)NSInteger                       rewardCount;//打赏数

@property (nonatomic,weak) UIButton                         *shareBtn;


@property (nonatomic, assign) BOOL                           isFectDetail;

@property (nonatomic,weak) UIButton                         *soundBtn;//声音按钮

@property (nonatomic,weak) UILabel *label1;
@property (nonatomic,weak) UILabel *label2;
@property (nonatomic,weak) UILabel *label3;

@property (nonatomic,copy) void  (^isTran)(BOOL tran);


@property (nonatomic ,strong)UIImageView                *headImgaeView;
@property (nonatomic ,strong)UILabel                    *nameLabel;
@property (nonatomic ,strong)UILabel                    *timeLabel;

@property (nonatomic,assign) NSInteger                  forwardStatus;

@property (nonatomic,strong) UIImageView                 *forwardImageView;


//收益
@property (nonatomic,strong) UILabel                        *labelFirst;
@property (nonatomic,strong) UILabel                        *labelSecond;
@property (nonatomic,strong) UIButton                       *redBagButton;



/// 是否设置支付密码  是否开启小额免密
@property (nonatomic,copy) void  (^isHavePasswordAndisSmallNopass)(BOOL isHavePassword  ,BOOL isSmallNopass);


@end

@implementation YRCirleDetailViewController


- (void)setStart:(NSInteger)start{
    if (start < 0) {
        _start = 0;
        return;
    }
    _start = start;
}


- (YRCircleListModel*)circleListModel{
    
    if (!_circleListModel) {
        _circleListModel = [[YRCircleListModel alloc] init];
    }
    return _circleListModel;
}

- (void)setProductType:(InfoProductType)productType{
    
    _productType = productType;
    
    switch (productType) {
        case kInfoTypePictureWord:
        {
            self.tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, SCREEN_HEIGHT - 100)];
            self.tableView.tableHeaderView = self.tableHeadView;
            [self initWebView];
            [self initTagView];
            
        }
            break;
        case kInfoTypeVideo:
        {

            
            self.tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, 225  + self.commentHeigt  + 80)];
            self.tableView.tableHeaderView = self.tableHeadView;
            [self initVideoView];
            [self refreshMineView];
        }
            break;
        case kInfoTypeVoice:
        {
            
            self.tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, self.commentHeigt + 65 + 5)];
            self.tableView.tableHeaderView = self.tableHeadView;
            [self initAudioView];
        }
            break;
            
        default:
            break;
    }
    
}

- (ZXLayoutTextView *)commentView {
    if (!_commentView) {
        @weakify(self);
        _commentView = [[ZXLayoutTextView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 60.0f)];
        _commentView.placeholder = @"请输入评论内容";
        [_commentView setSendBlock:^(YRReportTextView *textView) {
            @strongify(self);
            
            //回复评论
            if (self.commentModel.uid) {
                [YRHttpRequest circleCommentReply:self.productDetail.uid content:textView.text replyBy:self.commentModel.authorId replyId:self.commentModel.uid success:^(id data) {
                    [MBProgressHUD showSuccess:@"回复成功"];
                    
                    
                    YRProuductCommentModel *model = [[YRProuductCommentModel alloc] init];
                    model.authorName = [YRUserInfoManager manager].showUserName;
                    model.userHeadimg = [YRUserInfoManager manager].currentUser.custImg;
                    model.authorId =  [YRUserInfoManager manager].currentUser.custId;
                    model.userName = self.commentModel.userNameNotes ?  self.commentModel.userNameNotes : self.commentModel.authorName;
                    model.content = textView.text;
                    model.time = [NSString getCurrentMsTimestamp];
                    model.type = 2;
                    model.uid = data;
                    [self.commentList insertObject:model atIndex:0];
                    
                    self.commentView.textView.text = @"";
                    self.commentCount += 1;
                    [self.tableView reloadData];
                    
                } failure:^(id data) {
                    [MBProgressHUD showError:data];
                }];
                
            }else{
                //添加评论
                [YRHttpRequest circleAddComment:self.productDetail.uid content:textView.text success:^(id data) {
                    [MBProgressHUD showSuccess:@"评论成功"];
                    
                    
                    YRProuductCommentModel *model = [[YRProuductCommentModel alloc] init];
                    model.authorName = [YRUserInfoManager manager].showUserName;
                    model.userHeadimg = [YRUserInfoManager manager].currentUser.custImg;
                    model.authorId =  [YRUserInfoManager manager].currentUser.custId;
                    model.content = textView.text;
                    model.time = [NSString getCurrentMsTimestamp];
                    model.uid = data;
                    model.type = 1;
                    [self.commentList insertObject:model atIndex:0];
                    
                    self.commentCount += 1;
                    self.commentView.textView.text = @"";
                    
                    
                    [self.tableView reloadData];
                    
                } failure:^(id data) {
                    [MBProgressHUD showError:data];
                }];
            }
            
        }];
    }
    
    return _commentView;
}


- (YRProuductCommentModel*)commentModel{
    
    if (!_commentModel) {
        _commentModel = [[YRProuductCommentModel alloc] init];
    }
    return _commentModel;
}

- (void)setCollectStatus:(NSInteger)collectStatus{
    _collectStatus = collectStatus;
    if (collectStatus == 1) {
        [self.collectionButton setBackgroundImage:[UIImage imageNamed:@"yr_myCollect"] forState:UIControlStateNormal];
    }else{
        [self.collectionButton  setBackgroundImage:[UIImage imageNamed:@"yr_myCollect_no"] forState:UIControlStateNormal];
    }
}


- (void)setForwardCount:(NSString *)forwardCount{
    _forwardCount = forwardCount;
    
    if (!forwardCount) {
        forwardCount = @"0";
    }
    [self.tranButton  setTitle:[NSString stringWithFormat:@"转发%@",forwardCount] forState:UIControlStateNormal];
}


- (void)setTag:(NSInteger)tag{
    
    _tag = tag;
    
    [self.tableView reloadData];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteAudioNotifier" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.productDetail.type == 3) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    [self.playerView pause];
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteAudioNotifier" object:nil];
    [super viewWillAppear:animated];
    
    if (!self.productDetail) {
        [self fectDetailData];
    }
    self.forwardStatus = self.productDetail.forwardStatus;
    [self setBottomViewData];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    self.isFectDetail = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.productDetail.type == kInfoTypeVideo) {
        AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSInteger forwardStatus = self.productDetail.forwardStatus;
        if (forwardStatus==1) {
            if ([delegete.netState isEqualToString:@"wifi"]) {
                [self.playerView resetToPlayNewURL];
                self.playerView.videoURL = [NSURL URLWithString:self.productDetail.url];
                [self.playerView autoPlayTheVideo];
                self.soundBtn.selected = NO;
                [self.playerView.player setVolume:0.0];
            }
            self.shareBtn.hidden = YES;
        }
    }
}


//点击阅读数
- (void)infoReadStatus{
    NSString *uid = self.productDetail.uid;
    [YRHttpRequest infoReadStatus:kInfoTypeVideo pid:uid success:^(id data) {
        
    } failure:^(id data) {
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tag = 0;
    
    self.commentList = [[NSMutableArray alloc]init];
    self.likeList    = [[NSMutableArray alloc]init];
    self.tranList    = [[NSMutableArray alloc]init];
    self.giftList    = [[NSMutableArray alloc]init];
    
    self.forwardStatus = 0;
    

    
    [self setTitle:@"转发详情"];
    [self setRightNavButtonWithImage:[UIImage imageNamed:@"yr_navButton_more"]];
    
    [self initHeadView];
    [self initTableView];
    [self initBottomView];
    
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        [self fectCircleLikeList];
        [self fectRewardObjList];
        [self fectCircleTranList];
        [self fectCircleCommentList];
    });
}

- (void)initTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, SCREEN_HEIGHT - 55) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setExtraCellLineHidden];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRTranTableViewCell class]) bundle:nil] forCellReuseIdentifier:yrTranCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRRewardTableViewCell class]) bundle:nil] forCellReuseIdentifier:yrRewardCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRCommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:yrCommnetCellID];
    
    
    [self.view addSubview:self.tableView];
    
    [self.tableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;//几个手指点击
    tableViewGesture.cancelsTouchesInView = NO;//是否取消点击处的其他action
    [self.tableView addGestureRecognizer:tableViewGesture];
    
    
}


// ------tableView 上添加的自定义手势
- (void)tableViewTouchInSide{
    
    [self.view endEditing:YES];
}


- (void)footRefresh{
    self.start += kListPageSize;
    switch (self.tag) {
        case 0:
            [self fectCircleTranList];
            break;
        case 1:
            [self fectRewardObjList];
            break;
        case 2:
            [self fectCircleCommentList];
            break;
        case 3:
            [self fectCircleLikeList];
            break;
            
        default:
            break;
    }
}


- (void)rightNavAction:(UIButton*)button{
    [self.view endEditing:YES];
    self.shareView  = [[YRMyShareView alloc]init];
    self.shareView.delegate = self;
    self.shareView .chooseShareCell = ^(NSInteger tag,NSString *name){
        
    };
    [self.shareView  show];
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
    
    NSString *tranStr = @"";
    
    
    
    NSArray *array = @[tranStr,@" 打赏",@" 评论",@" 点赞"];
    NSArray *imageNameArray = @[@"yr_button_tran",@"yr_button_reward",@"yr_button_comment",@"yr_button_praise"];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) {
            self.bottomTranButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.bottomTranButton setTitle:array[idx] forState:UIControlStateNormal];
            [self.bottomTranButton setTitleColor:RGB_COLOR(102, 102, 102) forState:UIControlStateNormal];
            self.bottomTranButton.frame = CGRectMake(0 , 0, 120 , 40);
            self.bottomTranButton.titleLabel.font = [UIFont systemFontOfSize:16];
            [self.bottomTranButton setImage:[UIImage imageNamed:imageNameArray[idx]] forState:UIControlStateNormal];
            [bottonBgView addSubview:self.bottomTranButton];
            
            UILabel  *verticalLabel = [[UILabel alloc] initWithFrame:CGRectMake(121, 7, 1, 26)];
            verticalLabel.backgroundColor = RGB_COLOR(229, 229, 229);
            [bottonBgView addSubview:verticalLabel];
            self.bottomTranButton.tag = 100;
            [self.bottomTranButton  addTarget:self action:@selector(buttonFuncTionClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
        }else if (idx == 1 ||  idx == 2){
            
            UIButton  *tranButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [tranButton setTitle:array[idx] forState:UIControlStateNormal];
            [tranButton setTitleColor:RGB_COLOR(102, 102, 102) forState:UIControlStateNormal];
            tranButton.frame = CGRectMake(120 + (SCREEN_WIDTH - 120) / 3 * (idx - 1), 0, (SCREEN_WIDTH - 120) / 3, 40);
            tranButton.titleLabel.font = [UIFont systemFontOfSize:16];
            [tranButton setImage:[UIImage imageNamed:imageNameArray[idx]] forState:UIControlStateNormal];
            [bottonBgView addSubview:tranButton];
            tranButton.tag = 100 + idx;
            UILabel  *verticalLabel = [[UILabel alloc] initWithFrame:CGRectMake(120 + (SCREEN_WIDTH - 120) / 3 * (idx), 7, 1, 26)];
            verticalLabel.backgroundColor = RGB_COLOR(229, 229, 229);
            [bottonBgView addSubview:verticalLabel];
            
            [tranButton  addTarget:self action:@selector(buttonFuncTionClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            
            
            self.bottomLikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.bottomLikeButton setTitle:array[idx] forState:UIControlStateNormal];
            [self.bottomLikeButton setTitleColor:RGB_COLOR(102, 102, 102) forState:UIControlStateNormal];
            self.bottomLikeButton.frame = CGRectMake(120 + (SCREEN_WIDTH - 120) / 3 * (idx - 1), 0, (SCREEN_WIDTH - 120) / 3, 40);
            self.bottomLikeButton.titleLabel.font = [UIFont systemFontOfSize:16];
            [self.bottomLikeButton setImage:[UIImage imageNamed:imageNameArray[idx]] forState:UIControlStateNormal];
            [bottonBgView addSubview:self.bottomLikeButton];
            self.bottomLikeButton.tag = 100 + idx;
            UILabel  *verticalLabel = [[UILabel alloc] initWithFrame:CGRectMake(120 + (SCREEN_WIDTH - 120) / 3 * (idx), 7, 1, 26)];
            verticalLabel.backgroundColor = RGB_COLOR(229, 229, 229);
            [bottonBgView addSubview:verticalLabel];
            
            [self.bottomLikeButton  addTarget:self action:@selector(buttonFuncTionClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }];
}



- (void)initHeadView{
    
    UIView *headView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    headView.backgroundColor = [UIColor clearColor];
    
    self.headImgaeView = [[UIImageView alloc] init];
    self.headImgaeView.mj_x = 10;
    self.headImgaeView.mj_y = 10;
    self.headImgaeView.mj_h = 35;
    self.headImgaeView.mj_w = 35;
    [self.headImgaeView setCircleHeadWithPoint:CGPointMake(35, 35) radius:4];
    [self.headImgaeView setImageWithURL:[NSURL URLWithString:self.productDetail.headImg] placeholder:[UIImage defaultHead]];
    [self.headImgaeView addTapGesturesTarget:self selector:@selector(userImageClick)];
    [headView addSubview:self.headImgaeView];
    
    
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont titleFont14];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ 转发了",self.productDetail.nameNotes? self.productDetail.nameNotes : @""];
    self.nameLabel.textColor = RGB_COLOR(51, 51, 51);
    [self.nameLabel addTapGesturesTarget:self selector:@selector(userImageClick)];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:self.nameLabel];
    
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.text = @"";
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [self.timeLabel setBackgroundColor:[UIColor redColor]];
    self.timeLabel.textColor = RGB_COLOR(153, 153, 153);
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview: self.timeLabel];
    
    
    
    self.forwardImageView = [[UIImageView alloc] init];
    self.forwardImageView.image = [UIImage imageNamed:@"yr_prouduct_tran"];
    [headView addSubview:self.forwardImageView];
    
    
    self.introductionLabel = [[UILabel alloc] init];
    self.introductionLabel.frame = CGRectMake(55, 33, 220,12);
    self.introductionLabel.text = [NSString getTimeFormatterWithString:self.productDetail.createDate];
    self.introductionLabel.textColor = RGB_COLOR(153, 153, 153);
    self.introductionLabel.textAlignment = NSTextAlignmentLeft;
    self.introductionLabel.font = [UIFont systemFontOfSize:12];
    [headView addSubview: self.introductionLabel];
    
    
    
    if (kDevice_Is_iPhone5) {
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImgaeView.mas_right).offset(10);
            make.top.equalTo(self.headImgaeView.mas_top);
            make.height.equalTo(@(14));
            make.width.equalTo(@(110));
        }];
    }else{
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImgaeView.mas_right).offset(10);
            make.top.equalTo(self.headImgaeView.mas_top);
            make.height.equalTo(@(14));
        }];
    }
    

    
    [ self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImgaeView.mas_top);
        make.height.equalTo(@(14));
        make.left.equalTo(self.nameLabel.mas_right).offset(5);
        
    }];
    
    
    [self.forwardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(43));
        make.height.equalTo(@(13));
        make.top.equalTo(self.nameLabel.mas_top);
        make.left.equalTo( self.timeLabel.mas_right).offset(5);
    }];
    
    
    self.collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectionButton.frame = CGRectMake(SCREEN_WIDTH - 20 - 10, 15, 23, 23);
    [self.collectionButton setBackgroundImage:[UIImage imageNamed:@"yr_myCollect_no"] forState:UIControlStateNormal];
    [self.collectionButton addTarget:self action:@selector(collectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:self.collectionButton];
    
    
    
    
    
    self.redBagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.redBagButton.frame = CGRectMake(SCREEN_WIDTH - 20 - 10 - 36, 18, 17, 20);
    [self.redBagButton setImage:[UIImage imageNamed:@"yr_button_havered"] forState:UIControlStateNormal];
    [self.redBagButton addTarget:self action:@selector(redBagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:self.redBagButton];
    self.redBagButton.hidden = NO;

    
    [self.view  addSubview:headView];
    
}

/**
 *  @author weishibo, 16-08-23 17:08:07
 *
 *  图文加载
 */
- (void)initWebView{
    NSString *urlStr = self.productDetail.url;
    
    if ([urlStr containsString:@"vpc100-"]) {
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"vpc100-" withString:@""];
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.webView = [[YRWebView alloc] init];
    self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH ,100);
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:request];
    [self.tableHeadView  addSubview:self.webView];
    
}

/**
 *  @author weishibo, 16-08-23 17:08:17
 *
 *  加载音频
 */
- (void)initAudioView{
    
    
    UIView   *contentViewBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.commentHeigt + 65)];
    [self.tableHeadView addSubview:contentViewBgView];
    
    NSInteger time = self.productDetail.infoTime/1000;
    YRAudioUrlPlayView  *soundPlayView = [[YRAudioUrlPlayView alloc] initWithFrame:CGRectMake(10, 10, 190, 40) AudioUrl:self.productDetail.url AudioTime:time productDetail:self.productDetail];
    soundPlayView.productDetail = self.productDetail;
    soundPlayView.type = 2;
    [contentViewBgView addSubview:soundPlayView];
    self.soundPlayView = soundPlayView;
    
    @weakify(self);
    //    转发去挣收益按钮被点击
    self.soundPlayView.forward = ^(NSInteger    playState){
        @strongify(self);
        if (playState == 0  ) {
            [self noLoginTip];
            return;
        }else if (playState == 1){
            YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"转发之后才可以收听语音" cancelButtonText:@"再看看" confirmButtonText:@"转发得奖励"];
            alertView.comfirmButtonColor = [UIColor themeColor];
            alertView.addCancelAction = ^{
                
            };
            alertView.addConfirmAction = ^{
                
                @weakify(self);
                self.isHavePasswordAndisSmallNopass = ^(BOOL isHavePassword ,BOOL isSmallNopass) {
                    @strongify(self);
                    if (isHavePassword) {
                        
                        YRRedPaperPaymentViewController *redVc = [[YRRedPaperPaymentViewController alloc]init];
                        redVc.circleModel = self.circleListModel;
                        redVc.circleDetail = self.productDetail;
                        redVc.tranSuccessDelegate  = self;
                        [self.navigationController pushViewController:redVc animated:YES];
                        
                    }
                };
                [self queryPassWord];
            };
            [alertView show];
            
        }else if (playState == 2){
            
            [self infoReadStatus];
        }
        
        return;
    };
    
    
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, SCREEN_WIDTH - 20 , 0)];
    contentLabel.numberOfLines = 0;
    contentLabel.text = self.productDetail.infoIntroduction;
    contentLabel.font = [UIFont titleFont18];
    [contentLabel sizeToFit];
    [contentViewBgView addSubview:contentLabel];
    
    [self.tableHeadView  addSubview:contentViewBgView];
}


/**
 *  @author weishibo, 16-09-03 09:09:02
 *
 *  加载视频
 */
- (void)initVideoView{
    
    
    UIView *contentViewBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 225  + self.commentHeigt  + 80)];
    [self.tableHeadView addSubview:contentViewBgView ];
    
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 0)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.text = self.productDetail.desc;
    titleLabel.numberOfLines = 0;
    [titleLabel sizeToFit];
    [contentViewBgView  addSubview:titleLabel];
    
    
    UIImageView *videoView = [[UIImageView alloc] init];
    videoView.mj_x = 10;
    videoView.mj_y = titleLabel.mj_y + titleLabel.mj_h + 5;
    videoView.mj_w = SCREEN_WIDTH - 20;
    videoView.mj_h = 225;
    [contentViewBgView  addSubview:videoView];
    videoView.userInteractionEnabled = YES;
    self.imageVideo = videoView;
    
    self.playerView = [[ZFPlayerView alloc] initWithFrame:videoView.bounds];
    
    NSURL *url = [NSURL URLWithString:self.productDetail.url];
    
    self.playerView.placeholderImageName = @"";
    
    [videoView setImageWithURL:[NSURL URLWithString:self.productDetail.urlThumbnail] placeholder:[UIImage defaultImage]];
    
    
    self.playerView.videoURL = url;
    
    
    
    ZFPlayerControlView    *controlView = self.playerView.controlView;
    controlView.backBtn.hidden = YES;
    controlView.fullScreenBtn.selected = NO;
    [controlView.fullScreenBtn addTarget:self action:@selector(fullScreen:) forControlEvents:UIControlEventTouchUpInside];
    [controlView.playeBtn setImage:[UIImage imageNamed:@"yr_show_video"] forState:UIControlStateNormal];
    
    [videoView addSubview:self.playerView];
    
    
    UIButton *shareNumBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    shareNumBtn.frame = self.playerView.frame;
    self.shareBtn = shareNumBtn;
    [videoView addSubview:shareNumBtn];
    
    [shareNumBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *soundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.soundBtn = soundBtn;
    soundBtn.frame = CGRectMake(10, 10, 40, 40);
    [self.playerView.controlView.topImageView addSubview:soundBtn];
    [soundBtn setBackgroundImage:[UIImage imageNamed:@"yr_no_sound"] forState:UIControlStateNormal];
    [soundBtn setBackgroundImage:[UIImage imageNamed:@"yr_sound"] forState:UIControlStateSelected];
    
    [soundBtn addTarget:self action:@selector(soundBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 275, SCREEN_WIDTH - 20, 20)];
    [contentViewBgView  addSubview:bgView];
    bgView.backgroundColor = RGB_COLOR(245, 245, 245);
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 100, 20)];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20-80-100, 0, 100, 20)];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20-80, 0, 80, 20)];
    
    bgView.hidden = YES;
    [bgView addSubview:label1];
    [bgView addSubview:label2];
    [bgView addSubview:label3];
    label1.font = [UIFont systemFontOfSize:15];
    label2.font = [UIFont systemFontOfSize:15];
    label3.font = [UIFont systemFontOfSize:15];
    
    self.label1 =   label1;
    self.label2 =   label2;
    self.label3 =   label3;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    
    contentLabel.mj_x = 10;
    contentLabel.mj_y = bgView.mj_y + bgView.mj_h + 5;
    contentLabel.mj_w = SCREEN_WIDTH - 20;
    contentLabel.mj_h = 0;
    
    
    contentLabel.numberOfLines = 0;
    contentLabel.text = self.productDetail.infoIntroduction;
    contentLabel.font = [UIFont titleFont18];
    [contentLabel sizeToFit];
    [contentViewBgView  addSubview:contentLabel];
    
    [self.tableHeadView  addSubview:contentViewBgView];
}
- (void)shareBtnClick:(UIButton *)sender{
    
    
    if (_commentView) {
        _commentView.hidden = YES;
        [_commentView.textView resignFirstResponder];
    }
    
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([YRUserInfoManager manager].currentUser==nil) {
        [self noLoginTip];
    }else if (self.productDetail.recommand || self.productDetail.forwardStatus ){
        if ([delegete.netState isEqualToString:@"wifi"]) {
            [self.playerView resetToPlayNewURL];
            self.playerView.videoURL = [NSURL URLWithString:self.productDetail.url];
            [self.playerView autoPlayTheVideo];
            self.soundBtn.selected = NO;
            [self.playerView.player setVolume:0.0];
        }
    }else{
        
        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"转发之后才可以播放" cancelButtonText:@"再看看" confirmButtonText:@"转发得奖励"];
        alertView.comfirmButtonColor = [UIColor themeColor];
        alertView.addCancelAction = ^{
            
        };
        alertView.addConfirmAction = ^{
            @weakify(self);
            self.isTran = ^(BOOL tran){
                @strongify(self);
                if (tran) {
                    YRRedPaperPaymentViewController *redVc = [[YRRedPaperPaymentViewController alloc]init];
                    redVc.circleModel = self.circleListModel;
                    redVc.circleDetail = self.productDetail;
                    redVc.tranSuccessDelegate  = self;
                    [self.navigationController pushViewController:redVc animated:YES];
                }
            };
            [self queryPassWord];
        };
        [alertView show];
    }
}
- (void)soundBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.playerView.player setVolume:0.5];
    }else{
        [self.playerView.player setVolume:0.0];
    }
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

- (void)initTagView{
    
    
    self.tagView = [[SKTagView alloc] initWithFrame:CGRectMake(0, 55 + 100 , SCREEN_WIDTH, 40)];
    //    self.tagView.backgroundColor = [UIColor clearColor];
    self.tagView.padding    = UIEdgeInsetsMake(10, 10, 10, 10);
    self.tagView.hidden = YES;
    self.tagView.interitemSpacing = 8;
    self.tagView.lineSpacing = 10;
    [self.tableHeadView addSubview:self.tagView];
    
    @weakify(self);
    self.tagView.didTapTagAtIndex = ^(NSUInteger index){
        @strongify(self);
        NSArray *arr = self.productDetail.tageList;
        NSDictionary *dic = arr[index];
        if (dic) {
            YRTagSearchCOntroller   *tagVc = [[YRTagSearchCOntroller alloc] init];
            tagVc.tagId = [dic[@"uid"] integerValue];
            tagVc.tagStr = dic[@"tagName"];
            tagVc.productType = kInfoTypePictureWord;
            [self.navigationController pushViewController:tagVc animated:YES];
        }
    };
}
#pragma mark - WKWebView
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    @weakify(self);
    [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable Height,NSError *_Nullable error) {
        @strongify(self);
        double pageHeight = [Height doubleValue];
        
        CGFloat height;
        if (SCREEN_WIDTH <= 375) {
            height = pageHeight / 2.0f;
        }else{
            height = pageHeight / 3.0f;
        }
        CGRect frame = webView.frame;
        CGFloat h  = 20;
        frame.size.height = height + h;
        webView.frame = frame;
        
        
        
        self.tableHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height + 55 + h);
        self.tableView.tableHeaderView = self.tableHeadView;
        
        
        self.tagView.hidden = NO;
        self.tagView.frame = CGRectMake(0, self.webView.mj_x + self.webView.mj_h + 5 + h, SCREEN_WIDTH, 40);
        
        
        NSArray *arr = self.productDetail.tageList;
        @weakify(self);
        [arr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL *stop) {
            @strongify(self);
            //            SKTag *tag = [SKTag tagWithText:dic[@"tagName"]];
            SKTag *tag = [SKTag tagWithText:@"1111"];;
            tag.textColor = UIColor.whiteColor;
            tag.bgImg = [UIImage imageNamed:@"yr_buttontag_bg"];
            tag.cornerRadius = 3;
            tag.fontSize = 15;
            tag.padding = UIEdgeInsetsMake(8, 5, 8, 5);
            
            [self.tagView addTag:tag];
        }];
    }];
}

#pragma mark 转发成功代理


- (void)tranSuccessDelegate:(YRProductListModel *)productListModel circleListModel:(YRCircleListModel *)circleListModel indexPosition:(NSInteger)indexPosition{
    
    YRProudTranModel  *model = [[YRProudTranModel alloc] init];
    NSInteger  count = [self.forwardCount integerValue] + 1;
    
    self.forwardCount = [NSString stringWithFormat:@"%ld",count];
    self.productDetail.forwardCount = self.forwardCount;
    self.productDetail.forward1Count += 1;
    
    self.productDetail.forwardStatus = 1;
    
    if (self.productDetail.forwardStatus) {
        self.forwardImageView.hidden = NO;
    
        if (self.productDetail.type == kInfoTypeVideo) {
//                self.playerView.placeholderImageName = @" ";
//                [self.playerView resetToPlayNewURL];
//                self.playerView.videoURL = self.url;
//                self.playerView.seekTime = self.time;
//                [self.playerView play];
//                [self.playerView autoPlayTheVideo];
//                self.soundBtn.selected = NO;
//                [self.playerView.player setVolume:0.0];
            }
    }else{
        self.forwardImageView.hidden = YES;
    }
    
    
    model.headImg = [YRUserInfoManager manager].currentUser.custImg;
    model.custNname = [YRUserInfoManager manager].showUserName;
    
    model.custId = [YRUserInfoManager manager].currentUser.custId;
    model.createDate = [NSString getCurrentMsTimestamp];
    [self.tranList insertObject:model atIndex:0];
    
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TranSuccess_Cirle_Notification_Key object:self];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_commentView) {
        _commentView.hidden = YES;
        self.commentModel = nil;
        _commentView.placeholder = @"请输入评论内容";
        [_commentView.textView resignFirstResponder];
    }
    if (_rewardGiftView) {
        _rewardGiftView.hidden = YES;
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.tag == 0) {
        return 36 + 36;
    }else{
        return 36;
    }
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
    
    
    
    
    self.tranButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.tranButton.frame = CGRectMake(10, 10, 60, 20);
    self.tranButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    if (!self.forwardCount) {
        self.forwardCount = @"0";
    }
    [self.tranButton setTitle:[NSString stringWithFormat:@"转发%@",self.forwardCount] forState:UIControlStateNormal];
    [self.tranButton setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
    [self.tranButton addTarget:self action:@selector(tranButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.tranButton];
    
    
    self.underlineView.width =  65;
    self.underlineView.height = 3;
    self.underlineView.centerX = self.tranButton.centerX;
    self.underlineView.mj_y = self.tranButton.mj_x + self.tranButton.mj_h + 4;
    [view addSubview:self.underlineView];
    
    
    
    self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentButton.frame = CGRectMake(self.tranButton.mj_x + self.tranButton.mj_w + 20 , 10, 60, 20);
    self.commentButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.commentButton setTitle:[NSString stringWithFormat:@"打赏%ld",(long)self.rewardCount] forState:UIControlStateNormal];
    [self.commentButton setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
    [self.commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.commentButton];
    
    
    self.rewardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rewardButton.frame = CGRectMake(self.commentButton.mj_x + self.commentButton.mj_w + 20, 10, 60, 20);
    [self.rewardButton setTitle:[NSString stringWithFormat:@"评论%ld",(long)self.commentCount] forState:UIControlStateNormal];
    [self.rewardButton setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
    self.rewardButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.rewardButton addTarget:self action:@selector(rewardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.rewardButton];
    
    
    
    self.priaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.priaseButton.frame = CGRectMake(SCREEN_WIDTH - 80, 10, 60, 20);
    self.priaseButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.priaseButton setTitle:[NSString stringWithFormat:@"赞%ld",(long)self.totalLike] forState:UIControlStateNormal];
    [self.priaseButton setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
    [self.priaseButton addTarget:self action:@selector(priaseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.priaseButton];
    
    
    if (_tag == 0) {
        UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 36, SCREEN_WIDTH, 36)];
        tipView.backgroundColor = RGB_COLOR(245, 245, 245);
        [view addSubview:tipView];
        
        self.labelFirst = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 36)];
        self.labelFirst.text = [NSString stringWithFormat:@"第一层转发%ld ",(long)self.productDetail.forward1Count];
        self.labelFirst.font = [UIFont systemFontOfSize:12];
        self.labelFirst.textAlignment = NSTextAlignmentLeft;
        [tipView addSubview:self.labelFirst];
        
        self.labelSecond = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, SCREEN_WIDTH -  130, 36)];
        self.labelSecond .textAlignment = NSTextAlignmentRight;
        self.labelSecond .text = [NSString stringWithFormat:@"第二层转发%ld  第三层转发%ld",(long)self.productDetail.forward2Count , (long)self.productDetail.forward3Count ];
        self.labelSecond .font = [UIFont systemFontOfSize:10];
        [tipView addSubview:self.labelSecond];
        
        NSInteger count = self.productDetail.forward1Count + self.productDetail.forward2Count + self.productDetail.forward3Count;
        self.forwardCount = [NSString stringWithFormat:@"%ld",(long)count];
        
        self.underlineView.centerX = self.tranButton.centerX;
        self.underlineView.mj_y = self.tranButton.mj_y + self.tranButton.mj_h + 4;
        [self.tranButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    }else if (_tag == 1){
        [self.commentButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        self.underlineView.centerX = self.commentButton.centerX;
        self.underlineView.mj_y = self.commentButton.mj_y + self.tranButton.mj_h + 4;
        
    }else if (_tag == 2){
        [self.rewardButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        self.underlineView.centerX = self.rewardButton.centerX;
        self.underlineView.mj_y = self.rewardButton.mj_y + self.rewardButton.mj_h + 4;
        
    }else if (_tag == 3){
        [self.priaseButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        self.underlineView.centerX = self.priaseButton.centerX;
        self.underlineView.mj_y = self.priaseButton.mj_y + self.priaseButton.mj_h + 4;
        
    }
    return view;
    
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_tag == 0 ){
        return self.tranList.count;
    }else if(_tag == 1 ){
        return self.giftList.count;
    }else if (_tag == 2) {
        return self.commentList.count;
    }else{
        return self.likeList.count;
    }
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (_tag == 0) {
        YRTranTableViewCell *topCell = [tableView dequeueReusableCellWithIdentifier:yrTranCellID];
        [topCell setCircleTranModel:self.tranList[indexPath.row]];
        YRProudTranModel *tranModel = self.tranList[indexPath.row];
        topCell.nameLabel.text = tranModel.nameNotes.length>0 ? tranModel.nameNotes : tranModel.custNname;
        topCell.timeLabel.hidden = NO;
        return topCell;
    } else if (_tag == 1) {
        YRRewardListModel *model = self.giftList[indexPath.row];
        YRRewardTableViewCell *topCell = [tableView dequeueReusableCellWithIdentifier:yrRewardCellID];
        [topCell setRewardModel:model];
        return topCell;
    }else if(_tag == 2){
        YRCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:yrCommnetCellID];
        cell.indexPath = indexPath;
        cell.delegate = self;
        [cell setCommentModel:self.commentList[indexPath.row]];
        return cell;
    }else {
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
    if (_tag==0) {
        YRProudTranModel * model = self.tranList[indexPath.row];
        [self pushUserInfoViewController:model.custId withIsFriend:YES];
    }
    if (_tag==1) {
        YRRewardListModel * model = self.giftList[indexPath.row];
        [self pushUserInfoViewController:model.custId withIsFriend:YES];
    }
    if (_tag == 2) {
        self.commentModel = self.commentList[indexPath.row];
        if ([self.commentModel.authorId isEqualToString:[YRUserInfoManager manager].currentUser.custId]) {
            self.commentModel = nil;
            return;
        }
        self.commentView.hidden = NO;
        [self.view addSubview:self.commentView];
        self.commentView.placeholder = [NSString stringWithFormat:@"回复:%@",self.commentModel.authorName];
        [self.commentView.textView becomeFirstResponder];
    }
    if (_tag==3) {
        YRProudTranModel * model = self.likeList[indexPath.row];
        [self pushUserInfoViewController:model.userId withIsFriend:YES];
    }
}



///判断权限
- (void)refreshMineView{
    if (self.isMySelfProuduct == YES) {
        self.productDetail.infoForwardStatus = 1;
    }
    [self.playerView resetToPlayNewURL];
    NSString *count ;
    count  = [NSString stringWithFormat:@"%ld",[self.productDetail.readCount integerValue]];
    self.playerView.videoURL = [NSURL URLWithString:self.productDetail.url];
    if (self.productDetail.forwardStatus == 1||self.productDetail.recommand==1||self.productDetail.infoForwardStatus==1) {
        if (self.productDetail.forwardStatus==1) {
            self.forwardImageView.hidden = NO;
        }
        if (self.productDetail.readStatus==0) {
            count = [NSString stringWithFormat:@"%ld",[self.productDetail.readCount integerValue]];
        }
        self.shareBtn.hidden = YES;
    }else{
        self.forwardImageView.hidden = YES;
        self.shareBtn.hidden = NO;
    }
    
    
    [self.imageVideo setImageWithURL:[NSURL URLWithString:self.productDetail.urlThumbnail] placeholder:[UIImage defaultImage]];
    
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.forwardStatus = self.productDetail.forwardStatus;
    if (self.forwardStatus == 1 || self.productDetail.recommand == 1||self.productDetail.infoForwardStatus==1) {
        if ([delegete.netState isEqualToString:@"wifi"]) {
            [self.playerView resetToPlayNewURL];
            self.playerView.videoURL = [NSURL URLWithString:self.productDetail.url];
            [self.playerView autoPlayTheVideo];
            self.soundBtn.selected = NO;
            [self.playerView.player setVolume:0.0];
        }
    }
    
    
}
/**
 *  @author weishibo, 16-08-20 16:08:43
 *
 *  获取详情
 */
- (void)fectDetailData{
    [LWLoadingView showInView:self.view];
    [YRHttpRequest circleDetailProductId:self.circleListModel.clubId infoId:self.circleListModel.infoId success:^(NSDictionary *data) {
        self.productDetail = [YRProductDetail mj_objectWithKeyValues:data];
        
        [self getShareImage];
        
        if ([self.productDetail.auditStatus integerValue]==4) {
            UIImageView *image = [[UIImageView alloc]initWithFrame:self.view.bounds];
            image.image = [UIImage imageNamed:@"yr_down_works"];
            [self.view addSubview:image];
        }else{
            if (_commentHeigt == 0) {
                CGFloat h = [self.productDetail.infoIntroduction heightForStringfontSize:18.f];
                self.commentHeigt = h;
            }
            self.productType = self.productDetail.type;
        }
        
        self.collectStatus = self.productDetail.collectStatus;
        self.likeStatus = self.productDetail.goodStatus;
        self.forwardStatus = self.productDetail.forwardStatus;
        
        [self setHeadViewData];
        
        [self setBottomViewData];
        
        NSInteger count = self.productDetail.forward1Count + self.productDetail.forward2Count + self.productDetail.forward3Count;
        self.forwardCount = [NSString stringWithFormat:@"%ld",(long)count];
        self.rewardCount =  self.productDetail.rewardCount;
        self.commentCount = self.productDetail.commentCount;
        self.totalLike = self.productDetail.goodCount;
        
        [self.tableView reloadData];
        
        [LWLoadingView hideInViwe:self.view];
        self.isFectDetail = YES;
        
    } failure:^(id data) {
        [LWLoadingView hideInViwe:self.view];
        [MBProgressHUD showError:data];
    }];
    
    
}

/**
  设置图视图数据
 */
- (void)setHeadViewData{
    [self.headImgaeView setImageWithURL:[NSURL URLWithString:self.productDetail.headImg] placeholder:[UIImage defaultHead]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ 转发了",self.productDetail.nameNotes ? self.productDetail.nameNotes:self.productDetail.custNname];
    self.timeLabel.text = @"";
    self.introductionLabel.text = [NSString getTimeFormatterWithString:self.productDetail.createDate];
    //已转发的状态
    if (self.productDetail.forwardStatus) {
        self.forwardImageView.hidden = NO;
    }else{
        self.forwardImageView.hidden = YES;
    }
    self.collectStatus = self.productDetail.collectStatus;
    
    
    if (self.productDetail.redpacketId != nil && self.productDetail.redpacketId.length > 0) {
        self.redBagButton.hidden = NO;
    }else{
        self.redBagButton.hidden = YES;
    }
    
}

- (void)setBottomViewData{
    
    NSString  *tranStr = @"";
    if([self.productDetail.custId isEqualToString:[YRUserInfoManager manager].currentUser.custId] && !self.productDetail.forwardStatus){
        tranStr = @" 邀请转发";
        [self.bottomTranButton setTitleColor:RGB_COLOR(102, 102, 102) forState:UIControlStateNormal];
        [self.bottomTranButton setImage:[UIImage imageNamed:@"yr_button_tran"] forState:UIControlStateNormal];
    }else if (self.productDetail.forwardStatus) {
        tranStr = @" 已转发";
        [self.bottomTranButton setTitleColor:RGB_COLOR(153, 153, 153) forState:UIControlStateNormal];
        [self.bottomTranButton setImage:[UIImage imageNamed:@"yr_button_traned"] forState:UIControlStateNormal];
    }else{
        tranStr = @" 转发得奖励";
        [self.bottomTranButton setTitleColor:RGB_COLOR(102, 102, 102) forState:UIControlStateNormal];
        [self.bottomTranButton setImage:[UIImage imageNamed:@"yr_button_tran"] forState:UIControlStateNormal];
    }
    [self.bottomTranButton setTitle:tranStr forState:UIControlStateNormal];
    
    if (self.productDetail.goodStatus == 1) {
        [self.bottomLikeButton setImage:[UIImage imageNamed:@"yr_button_praise"] forState:UIControlStateNormal];
    }else{
        [self.bottomLikeButton setImage:[UIImage imageNamed:@"yr_button_unpraise"] forState:UIControlStateNormal];
        
    }
    
}



//获取分享的图片
- (void)getShareImage{
    
    
    UIImageView *image = [[UIImageView alloc]init];
    [image setImageWithURL:[NSURL URLWithString:self.productDetail.urlThumbnail] placeholder:nil options:kNilOptions completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        self.shareImage = image;
        if (self.productDetail.infoType == kInfoTypeVoice) {
            self.shareImage = [UIImage imageNamed:@"yr_audio_default"];
        }
    }];
    
    
}
/**
 *  @author yichao, 16-08-22 15:08:54
 *
 *  评论
 
 */
- (void)fectCircleCommentList{
    
    [YRHttpRequest circleCommentList:self.circleListModel.clubId start:self.start limit:kListPageSize success:^(id data) {
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
        
        
    } failure:^(NSString *data) {
        [MBProgressHUD showError:data];
    }];}

/**
 *  @author yichao, 16-08-22 15:08:45
 *
 *  点赞列表
 */
- (void)fectCircleLikeList{
    
    [YRHttpRequest circleLikeList:self.circleListModel.clubId start:self.start  limit:kListPageSize success:^(NSArray *data) {
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
        
    } failure:^(NSString *data) {
        [MBProgressHUD showError:data];
    }];
    
    
}

/**
 *  @author yichao, 16-08-22 15:08:38
 *
 *  转发列表
 */
- (void)fectCircleTranList{
    [YRHttpRequest circleTranList:self.circleListModel.clubId start:self.start  limit:kListPageSize success:^(NSArray *data) {
        
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
        
    } failure:^(NSString *data) {
        [MBProgressHUD showError:data];
    }];
    
}

/**
 *  @author weishibo, 16-08-29 10:08:43
 *
 *  打赏礼物列表 0转发1晒一晒 2作品
 
 */
- (void)fectRewardObjList{
    [YRHttpRequest rewardObjList:0 pid:self.circleListModel.clubId pageNumber:self.start pageSize:kListPageSize success:^(NSArray *data) {
        NSArray  *array = [YRRewardListModel mj_objectArrayWithKeyValuesArray:data];
        
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
        
    } failure:^(id data) {
        [MBProgressHUD showError:data];
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
    
    [YRHttpRequest circleAddComment:self.circleListModel.clubId content:content success:^(id data) {
        
    } failure:^(NSString *data) {
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
    
    [YRHttpRequest circleAddLikeAndUnLike:self.circleListModel.clubId like:like success:^(id data) {
        if (like == 0) {
            [self.likeList enumerateObjectsUsingBlock:^(YRProudTranModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.userId isEqualToString:[YRUserInfoManager manager].currentUser.custId]) {
                    [self.likeList removeObject:obj];
                }
            }];
            self.totalLike -= 1;
            self.tag = 3;
            
        }else{
            [MBProgressHUD showSuccess:@"点赞成功"];
            YRProudTranModel *model = [[YRProudTranModel alloc] init];
            model.userName = [YRUserInfoManager manager].showUserName;
            model.userHeadimg = [YRUserInfoManager manager].currentUser.custImg;
            model.userId = [YRUserInfoManager manager].currentUser.custId;
            [self.likeList insertObject:model atIndex:0];
            self.totalLike += 1;
            
        }
        self.likeStatus = like;
        [self.tableView reloadData];
    } failure:^(NSString *data) {
        [MBProgressHUD showError:data];
    }];
}


- (void)queryPassWord{
    
    @weakify(self);
    
    [YRHttpRequest QueryThePaymentPasswordSuccess:^(NSDictionary *data) {
        @strongify(self);
        //是否设置支付密码
        self.havePassword = [data[@"isPayPassword"] boolValue];
        //小额免密开关
        self.smallNopass = [data[@"smallNopass"] boolValue];
        
        if (!self.havePassword) {
            self.bottomTranButton.userInteractionEnabled = YES;
            YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"请先设置支付密码" cancelButtonText:@"取消" confirmButtonText:@"确认"];
            
            alertView.addCancelAction = ^{
                
            };
            alertView.addConfirmAction = ^{
                if (_rewardGiftView) {
                    _rewardGiftView.hidden = YES;
                    _rewardGiftView = nil;
                }
                YRChangePayPassWordController *payVc = [[YRChangePayPassWordController alloc]init];
                payVc.title = @"设置支付密码";
                [self.navigationController pushViewController:payVc animated:YES];
            };
            [alertView show];
            
            return;
        }else{
            if (self.isTran) {
                self.isTran(YES);
            }
            if (self.isHavePasswordAndisSmallNopass) {
                self.isHavePasswordAndisSmallNopass(self.havePassword ,self.smallNopass);
            }
        }
    } failure:^(NSString *error) {
        
        [MBProgressHUD showError:error];
    }];
    
}

#pragma mark 按钮监听
/**
 *  @author weishibo, 16-08-29 11:08:44
 *
 *  转发
 *
 *  @param btn <#btn description#>
 */
- (void)tranButtonClick:(UIButton*)btn{
    if (_commentView) {
        _commentView.hidden = YES;
        [_commentView.textView resignFirstResponder];
    }
    
    [btn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    
    self.start = 0;
    self.tag = 0;
}
//打赏
- (void)commentButtonClick:(UIButton*)btn{
    if (_commentView) {
        _commentView.hidden = YES;
        [_commentView.textView resignFirstResponder];
    }
    [btn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    
    self.start = 0;
    self.tag = 1;
}

//评论
- (void)rewardButtonClick:(UIButton*)btn{
    if (_commentView) {
        _commentView.hidden = YES;
        [_commentView.textView resignFirstResponder];
    }
    [btn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    self.start = 0;
    self.tag = 2;
    
}

//赞
- (void)priaseButtonClick:(UIButton*)btn{
    if (_commentView) {
        _commentView.hidden = YES;
        [_commentView.textView resignFirstResponder];
    }
    btn.selected = !btn.selected;
    [btn setTitleColor:[UIColor themeColor] forState:UIControlStateSelected];
    self.start = 0;
    self.tag = 3;
    
    
}
/**
 *  @author weishibo, 16-08-17 20:08:34
 *
 *  底部4个功能按钮action
 *
 *  @param b
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
        case 100:
        {
            self.tag = 0;
            if ([btn.titleLabel.text isEqualToString:@" 邀请转发"]) {
                YRAddNewGroupViewController *newChatVc = [[YRAddNewGroupViewController alloc] init];
                newChatVc.title = @"选择联系人";
                newChatVc.type = 2;
                newChatVc.infoId = self.circleListModel.clubId;
                [self.navigationController pushViewController:newChatVc animated:YES];
            }else  if ([btn.titleLabel.text isEqualToString:@" 已转发"]) {
                
            }else{
                self.bottomTranButton.userInteractionEnabled = NO;
                @weakify(self);
                self.isTran = ^(BOOL tran){
                    @strongify(self);
                    if (tran) {
                        YRRedPaperPaymentViewController *redVc = [[YRRedPaperPaymentViewController alloc]init];
                        redVc.circleModel = self.circleListModel;
                        redVc.circleDetail = self.productDetail;
                        redVc.tranSuccessDelegate = self;
                        [self.navigationController pushViewController:redVc animated:YES];
                        self.bottomTranButton.userInteractionEnabled = YES;
                    }
                };
                [self queryPassWord];
            }
        }
            break;
        case 101:
        {
            
            self.tag = 1;
            
            @weakify(self);
            self.isTran = ^(BOOL tran){
                @strongify(self);
                if (tran) {
                    self.rewardGiftView = [[RewardGiftView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT, self.rewardGiftView.frame.size.width, self.rewardGiftView.frame.size.height)];
                    @weakify(self);
                    self.rewardGiftView .rewardBlock = ^(RewardGiftModel *giftModel ,float money){
                        @strongify(self);
                        NSString *allMoneyStr = [NSString stringWithFormat:@"%.2f",money];
                        
                        //小额免密打开并总支付小于50
                        if (self.smallNopass && [allMoneyStr floatValue] * 0.01 <= 50) {
                            @weakify(self);
                            [YRHttpRequest sendReward:giftModel.giftid touserid:self.circleListModel.custId type:0 infoId:self.circleListModel.clubId giftNum:1 password:@"" infoType:self.productType infoTitle:self.circleListModel.infoTitle  pid:self.circleListModel.infoId success:^(id data) {
                                @strongify(self);
                                [MBProgressHUD showSuccess:@"打赏成功"];
                                self.rewardCount += 1;
                                
                                YRRewardListModel *model = [[YRRewardListModel alloc] init];
                                model.headImg = [YRUserInfoManager manager].currentUser.custImg;
                                model.img = giftModel.img;
                                model.rewardPrice = giftModel.price;
                                model.nickName = [YRUserInfoManager manager].showUserName;
                                model.custId = [YRUserInfoManager manager].currentUser.custId;
                                
                                [self.giftList insertObject:model atIndex:0];
                                
                                [self.tableView reloadData];
                            } failure:^(NSString *data) {
                                [MBProgressHUD showError:data];
                            }];
                            return ;
                        }
                        
                        
                        [self sendReward:allMoneyStr giftModel:giftModel touserid:self.circleListModel.custId pid:self.circleListModel.infoId];
                        
                        
                    };
                    [self.rewardGiftView .rechargeButton addTarget:self action:@selector(rechargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.rewardGiftView  showGiftView];
                }
            };
            [self queryPassWord];
            
        }
            break;
            
        case 102:
        {
            self.tag = 2;
            self.commentView.hidden = NO;
            [self.view addSubview:self.commentView];
            [self.commentView.textView becomeFirstResponder];
        }
            break;
        case 103:
        {
            
            if (self.likeStatus == 0) {
                self.tag = 3;
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

/**
 *  @author weishibo, 16-09-12 10:09:38
 *
 *  充值
 */
- (void)rechargeButtonClick{
    RRZSaveMoneyController  *saveVc = [[RRZSaveMoneyController alloc] init];
    [self.navigationController pushViewController:saveVc animated:YES];
}

- (void)collectionButtonClick:(UIButton*)btn{
    if (self.collectStatus != 1) {
        [YRHttpRequest circleAddCollect:self.circleListModel.clubId like:1 success:^(id data) {
            [MBProgressHUD showSuccess:@"收藏成功"];
            self.collectStatus = 1;
        } failure:^(NSString *data) {
            [MBProgressHUD showError:data];
        }];
    }else{
        [YRHttpRequest circleAddCollect:self.circleListModel.clubId like:0 success:^(id data) {
            [MBProgressHUD showSuccess:@"取消收藏"];
            self.collectStatus = 0;
        } failure:^(NSString *data) {
            [MBProgressHUD showError:data];
        }];
    }
    
}
- (void)userImageClick{
    [self pushUserInfoViewController:self.productDetail.custId withIsFriend:YES];
}

-(void)redBagButtonClick:(UIButton*)btn{
    btn.selected = !btn.selected;
    
    if (!self.productDetail.redpacketId) {
        [MBProgressHUD showError:@"无效红包"];
        return;
    }
    
    if ([self.productDetail.custId isEqualToString:[YRUserInfoManager manager].currentUser.custId]) {
        YRRedPaperListViewController  *redRecordVc = [[YRRedPaperListViewController alloc] init];
        redRecordVc.redId = self.productDetail.redpacketId;
        [self.navigationController pushViewController:redRecordVc animated:YES];
        
    }else{
        [MBProgressHUD showSuccess:@"跟转该作品方可抢红包"];
    }
    
    
}



- (void)addFriend:(NSString*)custID{
    
    [YRHttpRequest AddOrRemoveAttentionToRemoveByType:@"1" friendID:custID actionType:@(0) success:^(NSDictionary *data) {
        
    } failure:^(NSString *error) {
        [MBProgressHUD showError:error];
    }];
    
    
}



/**
 *  @author weishibo, 16-09-12 17:09:13
 *
 *  发送打赏
 */
- (void)sendReward:(NSString*)allMoneyStr giftModel:(RewardGiftModel*)giftModel touserid:(NSString*)touserid pid:(NSString*)pid{
    
    @weakify(self);
    [YRPaymentPasswordView showPaymentViewWithMoney:allMoneyStr  paymentBlock:^(NSString  *password){
        @strongify(self);
        [YRPaymentPasswordView hidePaymentPasswordView];
        [YRHttpRequest sendReward:giftModel.giftid touserid:touserid type:0 infoId:pid giftNum:1 password:password infoType:_productType infoTitle:self.circleListModel.infoTitle pid:self.circleListModel.infoId success:^(id data) {
            
            [MBProgressHUD showSuccess:@"打赏成功"];
            self.rewardCount += 1;
            
            YRRewardListModel *model = [[YRRewardListModel alloc] init];
            model.headImg = [YRUserInfoManager manager].currentUser.custImg;
            model.img = giftModel.img;
            model.rewardPrice = giftModel.price;
            model.nickName = [YRUserInfoManager manager].showUserName;
            
            [self.giftList insertObject:model atIndex:0];
            
            [self.tableView reloadData];
            
            
        } failure:^(NSString *data) {
            if ([data isEqualToString:@"支付密码错误"]) {
                [YRPaymentPasswordView hidePaymentPasswordView];
                
                YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"支付密码错误，请重试" cancelButtonText:@"确定"  ];
                
                alertView.addCancelAction = ^{
                    
                    [self sendReward:allMoneyStr giftModel:giftModel touserid:touserid pid:pid];
                };
                [alertView show];
                return ;
            }
            [MBProgressHUD showError:data];
            
        }];
        
    }];
    
}


#pragma mark 红包按钮监听


- (void)didClickLongPressGestureRecognizerCellWithIndexPath:(NSIndexPath *)indexPath{
    
    if (_commentView) {
        _commentView.hidden = YES;
        [_commentView.textView resignFirstResponder];
    }
    
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


// 添加其他按钮
- (void)addActionTarget:(UIAlertController *)alertController titles:(NSArray *)titles indexPath:(NSIndexPath *)indexPath{
    for (NSString *title in titles) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            YRProuductCommentModel *commentModel = self.commentList[indexPath.row];
            
            [YRHttpRequest circleDeleteComment:commentModel.uid clubId:self.circleListModel.clubId success:^(id data) {
                [self.commentList removeObjectAtIndex:indexPath.row];
                self.commentCount -= 1;
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




@end
