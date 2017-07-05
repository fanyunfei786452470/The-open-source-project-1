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
#import "YRMyShareView.h"
#import "YRRedPaperPaymentViewController.h"
#import "RewardGiftView.h"
#import "YRInputView.h"
#import "YRRedPaperView.h"
#import "YRRedPaperReceiveViewController.h"
#import "ZFPlayerView.h"
#import "YRVidioFullController.h"

static NSString *yrTranCellID = @"yrTranCellID";
static NSString *yrCommnetCellID = @"yrCommnetCellID";


@interface YRRedPackDetailViewController ()
<UIWebViewDelegate ,UITableViewDelegate ,UITableViewDataSource,YRInputViewDelegate>
@property (strong, nonatomic)UIView                         *tableHeadView;
@property (strong, nonatomic)UITableView                    *tableView;
@property (strong, nonatomic)YRWebView                      *webView;
@property (strong, nonatomic)UIImageView                    *redPackView;
@property (nonatomic,strong) YRMyShareView                  *shareView;
@property (nonatomic,strong) RewardGiftView                 *rewardGiftView;
@property (nonatomic,strong)YRInputView                     *InputView;

@property (nonatomic,strong)UIButton                        *selTitleButton; //选中按钮
@property (nonatomic, strong) UIImageView                   *underlineView;//下划线


@property (nonatomic, assign)NSInteger                      tag; //选中的类型（打赏、评论等）


@property (nonatomic,strong) ZFPlayerView *playerView;


@property (nonatomic,weak) UIImageView *imageVideo;

@end

@implementation YRRedPackDetailViewController


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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setRightNavButtonWithImage:[UIImage imageNamed:@"yr_navButton_more"]];
    [self initTableHeadView];
    [self initTableView];
    [self initShareView];
    [self initBottomView];
    
    self.tag = 0;
    
    
}



- (void)initTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableHeaderView = self.tableHeadView;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRTranTableViewCell class]) bundle:nil] forCellReuseIdentifier:yrTranCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRCommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:yrCommnetCellID];
    
    
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.tableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    
}

- (void)initShareView{
    self.shareView  = [[YRMyShareView alloc]init];
    self.shareView.delegate = self;
    self.shareView .chooseShareCell = ^(NSInteger tag,NSString *name){
        NSLog(@"你点击了第%ld个cell  点击的是%@",tag,name);
    };
}

- (void)footerRefresh{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.footer endRefreshing];
        
    });
    
}


- (void)rightNavAction:(UIButton*)button{
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
    
    
    NSArray *array = @[@" 评论",@" 联系TA",@" 点赞"];
    NSArray *imageNameArray = @[@"yr_button_comment",@"yr_button_reward",@"yr_button_praise"];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton  *tranButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tranButton setTitle:array[idx] forState:UIControlStateNormal];
        [tranButton setTitleColor:RGB_COLOR(153, 153, 153) forState:UIControlStateNormal];
        tranButton.frame = CGRectMake( SCREEN_WIDTH/3 * idx, 0, SCREEN_WIDTH/3 , 40);
        tranButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [tranButton setImage:[UIImage imageNamed:imageNameArray[idx]] forState:UIControlStateNormal];
        [bottonBgView addSubview:tranButton];
        
        
        UILabel  *verticalLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH) / 3 * (idx), 7, 1, 26)];
        verticalLabel.backgroundColor = RGB_COLOR(229, 229, 229);
        [bottonBgView addSubview:verticalLabel];
        
        tranButton.tag = 100 + idx;
        [tranButton  addTarget:self action:@selector(buttonFuncTionClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }];
    
}



-(void) initTableHeadView {
    
    
    self.tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT )];
    
    
    [self initHeadView];
    if ([self.title isEqualToString:@"视频广告"]) {
        [self initVideoView];
        self.tableHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 400 + 50);
    }else{
        [self initWebView];
    }
    
    [self initRedPackView];
    
}
/**
 *  @author weishibo, 16-08-18 19:08:40
 *
 *  视频控件初始化
 */
- (void)initVideoView{
    UIView   *contentViewBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, 400)];
    [self.tableHeadView addSubview:contentViewBgView];
    
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.text = @"那你不不不不不不不的爸爸的吧";
    [contentViewBgView addSubview:titleLabel];
    
    
    UIImageView *videoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH - 20, 225)];
    videoView.backgroundColor = [UIColor randomColor];
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
    
    NSURL *url = [NSURL URLWithString:@"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4"];
    
    self.playerView.placeholderImageName = @"logo";
    self.playerView.videoURL = url;
    
    ZFPlayerControlView    *controlView = self.playerView.controlView;
    controlView.backBtn.hidden = YES;
    controlView.fullScreenBtn.selected = NO;
    [controlView.fullScreenBtn addTarget:self action:@selector(fullScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [videoView addSubview:self.playerView];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 275, SCREEN_WIDTH - 20 , 80)];
    contentLabel.numberOfLines = 0;
    contentLabel.text = @"斑马快跑斑马快跑斑马快跑斑马快跑斑马快跑斑马快跑斑马快跑斑马快跑斑马快跑斑马快跑斑马快跑斑马快跑";
    contentLabel.font = [UIFont systemFontOfSize:15];
    [contentViewBgView addSubview:contentLabel];
    
    [self.tableHeadView  addSubview:contentViewBgView];
}
- (void)initHeadView{
    
    
    
    UIView *headView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    headView.backgroundColor = [UIColor clearColor];
    
    
    UIImageView *headImgaeView = [[UIImageView alloc] init];
    headImgaeView.mj_x = 10;
    headImgaeView.mj_y = 10;
    headImgaeView.mj_h = 35;
    headImgaeView.mj_w = 35;
    [headImgaeView setImageWithURL:nil placeholder:[UIImage defaultHead]];
    [headView addSubview:headImgaeView];
    
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(55, 12, 200,12);
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = RGB_COLOR(153, 153, 153);
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:nameLabel];
    
    
    
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.frame = CGRectMake(55, 33, 200,12);
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = RGB_COLOR(153, 153, 153);
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:timeLabel];
    
    
    UIButton *redBagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [redBagButton setImage:[UIImage imageNamed:@"yr_button_havered"] forState:UIControlStateNormal];
    redBagButton.frame =  CGRectMake(SCREEN_WIDTH - 20 - 10, 18, 20, 20);
    [redBagButton addTarget:self action:@selector(redButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:redBagButton];
    
    nameLabel.text = @"蓝色的小河 转发了";
    timeLabel.text = @"2016-08-17";
    
    
    [self.tableHeadView  addSubview:headView];
    
}


- (void)initWebView{
    NSString *urlStr = @"https://www.baidu.com/";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.webView = [[YRWebView alloc] init];
    self.webView.frame = CGRectMake(0, 55, SCREEN_WIDTH ,  SCREEN_HEIGHT);
    self.webView.delegate = self;
    [self.webView loadRequest:request];
    [self.tableHeadView  addSubview:self.webView];
    
}


- (void)initRedPackView{
    
    
    self.redPackView = [[UIImageView alloc] init];
    self.redPackView.frame = CGRectMake(0, self.webView.mj_x + self.webView.mj_h , SCREEN_WIDTH, 140);
    self.redPackView.userInteractionEnabled = YES;
    self.redPackView.hidden = YES;
    [self.tableHeadView addSubview:self.redPackView];
    
    
    UIButton  *redPackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [redPackButton setImage:[UIImage imageNamed:@"yr_button_havered"] forState:UIControlStateNormal];
    redPackButton.frame = CGRectMake((SCREEN_WIDTH - 74)/2, 20, 74, 74);
    [redPackButton setBackgroundColor:[UIColor randomColor]];
    [redPackButton addTarget:self action:@selector(redButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.redPackView addSubview:redPackButton];
    
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.mj_y = redPackButton.mj_y + redPackButton.mj_h + 10;
    tipLabel.mj_x = 0;
    tipLabel.mj_w = SCREEN_WIDTH;
    tipLabel.mj_h = 15;
    tipLabel.text = @"点击领取红包";
    tipLabel.textColor = RGB_COLOR(255, 96, 96);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.redPackView addSubview:tipLabel];
    
    
    
}


#pragma mark - NJKWebViewProgressDelegate



-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    double width = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetWidth;"]doubleValue];
    double height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"]doubleValue];
    webView.frame =CGRectMake(0,55,SCREEN_WIDTH,height);
    self.tableHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height + 140 + 50);
    self.tableView.tableHeaderView = self.tableHeadView;
    
    
    self.redPackView.hidden = NO;
    self.redPackView.frame =  CGRectMake(0, 50 + self.webView.mj_x + self.webView.mj_h, SCREEN_WIDTH, 140);
    
    
}


#pragma mark - UITableViewDelegate & UITableViewDataSource


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
    
    UIButton  * commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.frame = CGRectMake(10, 10, 60, 20);
    commentButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [commentButton setTitle:[NSString stringWithFormat:@"评论%ld",(long)9] forState:UIControlStateNormal];
    [commentButton setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:commentButton];
    
    self.underlineView.width =  65;
    self.underlineView.height = 2;
    self.underlineView.centerX = commentButton.centerX;
    self.underlineView.mj_y = commentButton.mj_x + commentButton.mj_h + 4;
    [view addSubview:self.underlineView];
    
    
    
    
    UIButton  * priaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    priaseButton.frame = CGRectMake(SCREEN_WIDTH - 80, 10, 60, 20);
    priaseButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [priaseButton setTitle:[NSString stringWithFormat:@"赞%ld",(long)9] forState:UIControlStateNormal];
    [priaseButton setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
    [priaseButton setTitleColor:[UIColor themeColor] forState:UIControlStateSelected];
    [priaseButton addTarget:self action:@selector(priaseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:priaseButton];
    
    
    if (self.tag == 0) {
        self.underlineView.centerX = commentButton.centerX;
        self.underlineView.mj_y = commentButton.mj_y + commentButton.mj_h + 4;
    }else if (self.tag == 1){
        self.underlineView.centerX = priaseButton.centerX;
        self.underlineView.mj_y = priaseButton.mj_y + priaseButton.mj_h + 4;
    }
    
    return view;
    
    
}




- (void)commentButtonClick:(UIButton*)btn{
    
    if (self.selTitleButton) {
        [self.selTitleButton setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
        self.selTitleButton.transform = CGAffineTransformIdentity;
    }
    [btn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    _selTitleButton = btn;
    self.tag = 0;
    [self.tableView reloadData];
}



- (void)priaseButtonClick:(UIButton*)btn{
    //    btn.selected = !btn.selected;
    if (self.selTitleButton) {
        [self.selTitleButton setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
        self.selTitleButton.transform = CGAffineTransformIdentity;
    }
    [btn setTitleColor:[UIColor themeColor] forState:UIControlStateSelected];
    _selTitleButton = btn;
    
    self.tag = 1;
    [self.tableView reloadData];
    
}
/**
 *  @author weishibo, 16-08-17 20:08:34
 *
 *  底部4个功能按钮action
 *
 *  @param b <#b description#>
 */
- (void)buttonFuncTionClick:(UIButton*)b{
    switch (b.tag) {
        case 100:
        {
            YRInputView *inputView = [[YRInputView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50-64, SCREEN_WIDTH, 50)];
            inputView.backgroundColor = [UIColor whiteColor];
            inputView.delegate = self;
            [self.view addSubview:inputView];
            self.InputView = inputView;
        }
            break;
            //联系他
        case 101:
        {
            [MBProgressHUD showError:@"联系他功能待定"];
        }
            break;
            //点赞
            
        case 102:
        {
            [MBProgressHUD showError:@"点赞"];
        }
            break;
            
        default:
            break;
    }
    
    
}


#pragma mark 红包按钮监听

- (void)redButtonClick:(UIButton*)button{
    @weakify(self);
    [YRRedPaperView showRedPaperViewWithName:@"xxxx" OpenBlock:^(){
        @strongify(self);
        YRRedPaperReceiveViewController *ViewController = [[YRRedPaperReceiveViewController alloc]init];
//        ViewController.redModel = redModel;
        [self.navigationController pushViewController:ViewController animated:NO];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 12;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tag == 0) {
        YRCommentTableViewCell  *topCell = [tableView dequeueReusableCellWithIdentifier:yrCommnetCellID];
        return topCell;
    }else{
        YRTranTableViewCell *topCell = [tableView dequeueReusableCellWithIdentifier:yrTranCellID];
        topCell.timeLabel.hidden = YES;
        return topCell;
    }
    
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//
//    return 44;
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

#pragma mark input

- (void)textViewChangeHeightWithText:(NSString *)text Return:(BOOL)isReturn{
    
    CGFloat height = [self widthForString:text fontSize:16];
    
    if (isReturn) {
        self.InputView.frame = CGRectMake(0, SCREEN_HEIGHT-50-64, SCREEN_WIDTH, 50);
    }else{
        self.InputView.frame = CGRectMake(0, SCREEN_HEIGHT-64-31-height, SCREEN_WIDTH, 31+height);
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



@end
