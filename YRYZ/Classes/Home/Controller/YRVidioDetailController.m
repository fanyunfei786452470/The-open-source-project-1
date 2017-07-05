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
#import "YRReportTextView.h"
#import "YRRedPaperView.h"
#import "YRRedPaperReceiveViewController.h"
#import "YRRedPaperPaymentViewController.h"
#import "YRProductDetail.h"
#import "YRRewardListModel.h"
#import "ZXLayoutTextView.h"
#import "YRCollectModel.h"
#import "RRZSaveMoneyController.h"
#import "YRPaymentPasswordView.h"
#import "YRAddNewGroupViewController.h"
#import "AppDelegate.h"
#import "YRChangePayPassWordController.h"
#import "LxxPlaySound.h"
#import "YRVideoMainViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "YRTransmitAlert.h"
static NSString *yrTranCellID = @"yrTranCellID";
static NSString *yrRewardCellID = @"yrRewardCellID";
static NSString *yrCommnetCellID = @"yrCommnetCellID";
@interface YRVidioDetailController ()
<UITableViewDelegate ,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,YRCommentTableViewCellDelegate,TranSuccessDelegate>
@property (strong, nonatomic)UIView                         *tableHeadView;
@property (strong, nonatomic)UITableView                    *tableView;
@property (nonatomic,strong) YRMyShareView                  *shareView;

@property (nonatomic, strong)UIImageView                    *underlineView;//下划线


@property (nonatomic, assign)NSInteger                      tag; //选中的类型（打赏、评论等）

@property (nonatomic,strong) ZFPlayerView                   *playerView;


@property (nonatomic,weak) UIImageView                      *imageVideo;

@property (nonatomic,strong) RewardGiftView                  *rewardGiftView;
@property (nonatomic,strong) ZXLayoutTextView                *commentView;

@property (nonatomic, assign)NSInteger                       forwardStatus;//转发状态
@property (nonatomic,strong) NSMutableArray                  *commentList; //评论列表
@property (nonatomic,strong) NSMutableArray                  *likeList;// 点赞
@property (nonatomic,strong) NSMutableArray                  *tranList;//转发列表
@property (nonatomic,strong) NSMutableArray                  *giftList;// 礼物列表
@property (nonatomic,strong) YRProuductCommentModel          *commentModel;
@property (nonatomic,assign) NSInteger                       start;

@property (nonatomic,strong) YRProductDetail                 *productDetail;


@property (nonatomic,strong)UIButton                        *tranButton;
@property (nonatomic,strong)UIButton                        *commentButton;
@property (nonatomic,strong)UIButton                        *rewardButton;
@property (nonatomic,strong)UIButton                        *priaseButton;

@property (nonatomic,weak) UIImageView                      *forwardImageView;


@property(nonatomic ,strong)NSString                         *forwardCount;//转发数
@property (nonatomic, assign)NSInteger                       totalLike;//点赞数
@property (nonatomic, assign)NSInteger                       commentCount;//评论数
@property (nonatomic, assign)NSInteger                       rewardCount;//打赏数


//是否设置支付密码
@property (nonatomic, assign) BOOL          havePassword;
//小额免密开关
@property (nonatomic, assign) BOOL          smallNopass;

@property (nonatomic, assign) NSInteger          collectStatus;
@property (nonatomic,strong)UIButton             *collectionButton;

@property (nonatomic, assign)NSInteger                      likeStatus;//点赞状态



@property (nonatomic,weak) UIButton                         *shareBtn;//播发按钮

@property (nonatomic,weak) UIButton                     *soundBtn;//声音按钮



@property (nonatomic,strong)UIButton                          *tranBottomButton; //底部转发按钮
@property (nonatomic,strong)UIButton                          *likeBottomButton;//底部点赞按钮



@property (nonatomic,weak) UILabel *label1;
@property (nonatomic,weak) UILabel *label2;
@property (nonatomic,weak) UILabel *label3;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,copy) void  (^isTran)(BOOL tran);

@property (nonatomic,assign) BOOL readAdd;

@property (nonatomic,strong)UIImageView             *headImgaeView;
@property (nonatomic,strong)UILabel                 *nameLabel;
@property (nonatomic,strong)UILabel                 *timeLabel;
@property (nonatomic,strong)UILabel                 *introductionLabel;
@property (nonatomic,strong)UILabel                 *titleLabel;
@property (nonatomic,strong)UILabel                 *contentLabel;

@property (nonatomic,strong)UIView                  *contentViewBgView;

@property (nonatomic,weak) UIButton *tranBtn;
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


- (void)setTag:(NSInteger)tag{
    
    _tag = tag;
    [self.tableView reloadData];
}

#pragma mark - Getter
- (ZXLayoutTextView *)commentView {
    if (!_commentView) {
        @weakify(self);
        _commentView = [[ZXLayoutTextView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT  - 64, SCREEN_WIDTH, 60.0f)];
        _commentView.placeholder = @"请输入评论内容";
        [_commentView setSendBlock:^(YRReportTextView *textView) {
            @strongify(self);
            NSString *uid = self.productListModel.uid ? self.productListModel.uid : self.productListModel.infoId;
            if ([uid isBlank]) {
                [MBProgressHUD showError:@"作品不存在"];
                return;
            }
            //回复评论
            if (self.commentModel.uid) {
                [YRHttpRequest poductCommentReply:uid content:textView.text replyBy:self.commentModel.authorId replyId:self.commentModel.uid success:^(id data) {
                    
                    [MBProgressHUD showSuccess:@"回复成功"];
                    YRProuductCommentModel *model = [[YRProuductCommentModel alloc] init];
                    model.authorName = [YRUserInfoManager manager].showUserName;
                    model.userHeadimg = [YRUserInfoManager manager].currentUser.custImg;
                    model.authorId =  [YRUserInfoManager manager].currentUser.custId;
                    model.content = textView.text;
                    model.time = [NSString getCurrentMsTimestamp];
                    model.userName  = self.commentModel.authorName;
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
                [YRHttpRequest poductAddComment:uid content:textView.text success:^(id data) {
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
- (void)setCollectStatus:(NSInteger)collectStatus{
    _collectStatus = collectStatus;

    if (collectStatus == 1) {
        [self.collectionButton setBackgroundImage:[UIImage imageNamed:@"yr_myCollect"] forState:UIControlStateNormal];
    }else{
        [self.collectionButton  setBackgroundImage:[UIImage imageNamed:@"yr_myCollect_no"] forState:UIControlStateNormal];
    }
}
-(void)setLikeStatus:(NSInteger)likeStatus{
    _likeStatus = likeStatus;
    if (likeStatus == 1) {
        [self.likeBottomButton setImage:[UIImage imageNamed:@"yr_button_praise"] forState:UIControlStateNormal];
    }else{
        [self.likeBottomButton setImage:[UIImage imageNamed:@"yr_button_unpraise"] forState:UIControlStateNormal];
    }
}


- (void)setForwardCount:(NSString *)forwardCount{
    _forwardCount = forwardCount;
    if (!forwardCount) {
        forwardCount = @"0";
    }
    [self.tranButton  setTitle:[NSString stringWithFormat:@"转发%@",forwardCount ? forwardCount :@""] forState:UIControlStateNormal];
}


- (void)setCommentCount:(NSInteger)commentCount{
    _commentCount = commentCount;
    [ self.rewardButton setTitle:[NSString stringWithFormat:@"评论%ld",(long)self.commentCount] forState:UIControlStateNormal];
}
- (void)setTotalLike:(NSInteger)totalLike{
    _totalLike = totalLike;
    [self.priaseButton setTitle:[NSString stringWithFormat:@"赞%ld",(long)self.totalLike] forState:UIControlStateNormal];
}
- (void)setRewardCount:(NSInteger)rewardCount{
    _rewardCount = rewardCount;
    [self.commentButton  setTitle:[NSString stringWithFormat:@"打赏%ld",self.rewardCount] forState:UIControlStateNormal];
}

//转发状态
- (void)setForwardStatus:(NSInteger)forwardStatus{
    _forwardStatus = forwardStatus;

    if (forwardStatus) {
        self.forwardImageView.hidden = NO;
        [self.tranBottomButton setTitleColor:RGB_COLOR(153, 153, 153) forState:UIControlStateNormal];
        [self.tranBottomButton setImage:[UIImage imageNamed:@"yr_button_traned"] forState:UIControlStateNormal];
        
    }else{
        self.forwardImageView.hidden = YES;
        [self.tranBottomButton setTitleColor:RGB_COLOR(102, 102, 102) forState:UIControlStateNormal];
        [self.tranBottomButton setImage:[UIImage imageNamed:@"yr_button_tran"] forState:UIControlStateNormal];
    }
    NSString  *tranStr = forwardStatus ? @" 已转发" : @" 转发得奖励";
    [self.tranBottomButton setTitle:tranStr forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.time > 0 && self.url) {
        [self.playerView resetToPlayNewURL];
        self.playerView.videoURL = self.url;
        self.playerView.seekTime = self.time;
        [self.playerView play];
        [self.playerView autoPlayTheVideo];
        self.soundBtn.selected = NO;
        [self.playerView.player setVolume:0.0];
    }
    if (self.isFectDetail) {
        [self fectDetailData];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.playerView pause];
    //    [self.playerView resetPlayer];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    self.isFectDetail = NO;
}

- (void)refreshMineView{

    
    if (self.isOriginalWorks == YES) {
        self.productDetail.infoForwardStatus = YES;
    }
    
    
    [self.playerView resetToPlayNewURL];
    NSString *count ;
    count  = [NSString stringWithFormat:@"%ld",[self.productDetail.readCount integerValue]];
    self.playerView.videoURL = [NSURL URLWithString:self.productDetail.url];
    if (self.productDetail.forwardStatus==1||self.productListModel.recommand==1||self.productDetail.infoForwardStatus==1) {
        if (self.productDetail.forwardStatus==1) {
            self.forwardImageView.hidden = NO;
        }
        if (self.productListModel.readStatus==0) {
            [self infoReadStatus];
            count = [NSString stringWithFormat:@"%ld",[self.productDetail.readCount integerValue]];
        }
        self.shareBtn.hidden = YES;
    }else{
        self.forwardImageView.hidden = YES;
        self.shareBtn.hidden = NO;
    }

    
    [self.imageVideo setImageWithURL:[NSURL URLWithString:self.productDetail.urlThumbnail] placeholder:[UIImage defaultImage]];
    
    NSMutableAttributedString *lstr1 = [[NSMutableAttributedString alloc]initWithString:count attributes:@{NSForegroundColorAttributeName:[UIColor themeColor]}];
    NSMutableAttributedString *lstr12 = [[NSMutableAttributedString alloc]initWithString:@"次播放" attributes:@{NSForegroundColorAttributeName:RGB_COLOR(175, 175, 175)}];
    [lstr1 appendAttributedString:lstr12];
    
    self.label1.attributedText = lstr1;
    NSMutableAttributedString *lstr2 = [[NSMutableAttributedString alloc]initWithString:@"被转发" attributes:@{NSForegroundColorAttributeName:RGB_COLOR(175, 175, 175)}];
    NSMutableAttributedString *lstr22 = [[NSMutableAttributedString alloc]initWithString:self.forwardCount attributes:@{NSForegroundColorAttributeName:[UIColor themeColor]}];
    [lstr2 appendAttributedString:lstr22];
    self.label2.attributedText = lstr2;
    UITapGestureRecognizer  * taplabel2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLabel2Click:)];
    self.label2.userInteractionEnabled = YES;
    [self.label2 addGestureRecognizer:taplabel2];
    NSMutableAttributedString *lstr3 = [[NSMutableAttributedString alloc]initWithString:@"奖励" attributes:@{NSForegroundColorAttributeName:RGB_COLOR(175, 175, 175)}];
    NSMutableAttributedString *lstr32 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f",self.productDetail.transferBonud*0.01] attributes:@{NSForegroundColorAttributeName:[UIColor themeColor]}];
    [lstr3 appendAttributedString:lstr32];
       UITapGestureRecognizer  * taplabel3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLabel2Click:)];
    self.label3.userInteractionEnabled = YES;
    [self.label3 addGestureRecognizer:taplabel3];
    self.label3.attributedText = lstr3;;
    
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.forwardStatus = _productDetail ? self.productDetail.forwardStatus:self.productListModel.forwardStatus;
    if (self.forwardStatus == 1 || self.productListModel.recommand == 1||self.productDetail.infoForwardStatus==1 || self.productListModel.infoForwardStatus == 1) {
        if ([delegete.netState isEqualToString:@"wifi"]) {
            [self.playerView resetToPlayNewURL];
            self.playerView.videoURL = [NSURL URLWithString:self.productDetail.url];
            [self.playerView autoPlayTheVideo];
            self.soundBtn.selected = NO;
            [self.playerView.player setVolume:0.0];
        }else{
            [self.playerView resetToPlayNewURL];
            self.playerView.videoURL = [NSURL URLWithString:self.productDetail.url];
            self.soundBtn.selected = NO;
            [self.playerView.player setVolume:0.0];
        }
    }
}
#pragma mark 点击被转发
- (void)tapLabel2Click:(UIGestureRecognizer *)sender{
    YRTransmitAlert * alert = [[YRTransmitAlert alloc]init];
    [alert showForwardingruletitle:@"作品奖励规则" rule:@"用户在 “悠然一指” 平台成功发布的作品,均有机会被用户付费转发到平台“圈子”中或在“圈子”中被其他用户付费跟转。无论作品被付费转发或跟转,发布作品的用户均能按照平台规则获得 “转发定价x10%x被付费转发次数” 的奖励。"];
}
#pragma mark 获取数据
/**
 *  @author weishibo, 16-08-20 16:08:43
 *
 *  获取详情
 */
- (void)fectDetailData{
    
    
    NSString *uid = self.productListModel.uid ? self.productListModel.uid : self.productListModel.infoId;
    
    if ([uid isBlank]) {
        [MBProgressHUD showError:@"作品不存在"];
        return;
    }
    [YRHttpRequest productdetailProductId:uid success:^(NSDictionary *data) {
        self.productDetail = [YRProductDetail mj_objectWithKeyValues:data];

        if ([self.productDetail.auditStatus integerValue]==4) {
            UIImageView *image = [[UIImageView alloc]initWithFrame:self.view.bounds];
            image.image = [UIImage imageNamed:@"yr_down_works"];
            [self.view addSubview:image];
        }else{
            [self settingData];
        }
    } failure:^(id data) {
        [MBProgressHUD showError:data];
    }];
    
}

//填充数据
- (void)settingData{

    CGFloat h = [self.productDetail.infoIntroduction heightForStringfontSize:18.f];
    self.commentHeigt = h;
    
    self.collectStatus = self.productDetail.collectStatus ;
    self.likeStatus = self.productDetail.goodStatus;
    
    self.forwardCount = self.productDetail.forwardCount;
    self.commentCount = self.productDetail.commentCount;
    self.rewardCount = self.productDetail.rewardCount;
    self.totalLike = self.productDetail.goodCount;
    
    [self refreshMineView];
    
    
    self.isFectDetail = NO;
    
    [self.headImgaeView setImageWithURL:[NSURL URLWithString:self.productDetail.headImg] placeholder:[UIImage defaultHead]];
    self.timeLabel.text = [NSString getTimeFormatterWithString:self.productDetail.createDate];
    self.nameLabel .text =  self.productDetail.nameNotes ? self.productDetail.nameNotes : self.productDetail.custNname;
    self.introductionLabel.text = self.productDetail.custSignature;
    
    
    self.titleLabel.text = self.productDetail.desc ? self.productListModel.desc : @"";
    self.contentLabel.text = self.productDetail.infoIntroduction;

}

- (void)setCommentHeigt:(CGFloat)commentHeigt{
    
    _commentHeigt = commentHeigt;

    [self.tableView reloadData];
    
}
- (void)queryPassWord{
    
    @weakify(self);
    
    [YRHttpRequest QueryThePaymentPasswordSuccess:^(NSDictionary *data) {
        @strongify(self);
        //是否设置支付密码
        self.havePassword = [data[@"isPayPassword"] boolValue];
        //小额免密开关
        self.smallNopass = [data[@"smallNopass"] boolValue];
        
        self.tranBottomButton.userInteractionEnabled =YES;
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
            if (self.isTran) {
                self.isTran(YES);
            }
        }
    } failure:^(NSString *error) {
        
        [MBProgressHUD showError:error];
    }];
    
}

    

/**
 *  @author weishibo, 16-09-18 14:09:06
 *
 *  作品状态阅读
 */
- (void)infoReadStatus{
    NSString *uid = self.productListModel.uid ? self.productListModel.uid : self.productListModel.infoId;
    [YRHttpRequest infoReadStatus:kInfoTypeVideo pid:uid success:^(id data) {
        
    } failure:^(id data) {
//        [MBProgressHUD showError:data];
    }];
    
}


/**
 *  @author yichao, 16-08-22 15:08:54
 *
 *  评论列表
 */
- (void)fectProductCommentList{
    
    NSString *uid = self.productListModel.uid ? self.productListModel.uid : self.productListModel.infoId;
    
    if ([uid isBlank]) {
        [MBProgressHUD showError:@"作品不存在"];
        return;
    }
    
    
    [YRHttpRequest productCommentList:uid start:self.start    limit:kListPageSize success:^(NSArray *data) {
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
    NSString *uid = self.productListModel.uid ? self.productListModel.uid : self.productListModel.infoId;
    
    if ([uid isBlank]) {
        [MBProgressHUD showError:@"作品不存在"];
        return;
    }
    
    [YRHttpRequest productLikeList:uid start:self.start      limit:kListPageSize success:^(NSArray *data) {
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
    
    NSString *uid = self.productListModel.uid ? self.productListModel.uid : self.productListModel.infoId;
    
    if ([uid isBlank]) {
        [MBProgressHUD showError:@"作品不存在"];
        return;
    }
    
    [YRHttpRequest rewardObjList:2 pid:uid pageNumber:self.start pageSize:kListPageSize success:^(NSArray *data) {
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
 *  @author yichao, 16-08-22 15:08:38
 *
 *  转发列表
 */
- (void)fectProductTranList{
    NSString *uid = self.productListModel.uid ? self.productListModel.uid : self.productListModel.infoId;
    
    if ([uid isBlank]) {
        [MBProgressHUD showError:@"作品不存在"];
        return;
    }
    [YRHttpRequest productTranList:uid start:self.start   limit:kListPageSize success:^(NSArray *data) {
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
    NSString *uid = self.productListModel.uid ? self.productListModel.uid : self.productListModel.infoId;
    
    if ([uid isBlank]) {
        [MBProgressHUD showError:@"作品不存在"];
        return;
    }
    
    [YRHttpRequest poductAddComment:uid content:content success:^(id data) {
        
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
    NSString *uid = self.productListModel.uid ? self.productListModel.uid : self.productListModel.infoId;
    
    if ([uid isBlank]) {
        [MBProgressHUD showError:@"作品不存在"];
        return;
    }
    
    [YRHttpRequest productAddLikeAndUnLike:uid like:like success:^(id data) {
        if (like == 0) {
            [MBProgressHUD showSuccess:@"取消点赞"];
            
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
            model.userName = [YRUserInfoManager manager].currentUser.custNname;
            model.userHeadimg = [YRUserInfoManager manager].currentUser.custImg;
            model.userId = [YRUserInfoManager manager].currentUser.custId;
            [self.likeList insertObject:model atIndex:0];
            self.totalLike += 1;
        }
        self.likeStatus = like;
        [self.tableView reloadData];
    } failure:^(id data) {
        [MBProgressHUD showError:data];
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.readAdd = YES;
    [self setTitle:@"视频详情"];
    [self setLeftNavButtonWithImage:[UIImage imageNamed:@"yr_return"]];
    [self setRightNavButtonWithImage:[UIImage imageNamed:@"yr_navButton_more"]];
    
    self.tag = 0;
    self.collectStatus = 0;
    

    
    self.isFectDetail = YES;
    [self initTableView];
    [self initTableHeadView];
    [self initBottomView];

    
    
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        [self fectProductTranList];
        [self fectProductLikeList];
        [self fectRewardObjList];
        [self fectProductCommentList];
        
    });
    
}

- (void)leftNavAction:(UIButton *)button{
    
        if (self.videoTranSucessDelegate && self.forwardStatus == 1 ) {
            self.productListModel.forwardStatus = 1;
            [self.videoTranSucessDelegate videoTranSucessDelegate:1];
        }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavAction:(UIButton*)button{
    [self.view endEditing:YES];
    self.shareView  = [[YRMyShareView alloc]init];
    self.shareView.delegate = self;
    self.shareView .chooseShareCell = ^(NSInteger tag,NSString *name){
        
    };
    [self.shareView  show];
}

- (void)initTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
    self.tableView.tableHeaderView = self.tableHeadView;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.tableView setExtraCellLineHidden];
    [self.view addSubview:self.tableView];
    
    
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRTranTableViewCell class]) bundle:nil] forCellReuseIdentifier:yrTranCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRRewardTableViewCell class]) bundle:nil] forCellReuseIdentifier:yrRewardCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRCommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:yrCommnetCellID];

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
    
    self.tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 370 + self.commentHeigt + 10)];
    self.tableView.tableHeaderView = self.tableHeadView;
    [self initHeadView];
    [self initContentView];
    
}


- (void)initHeadView{
    UIView *headView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    
    self.headImgaeView = [[UIImageView alloc] init];
    self.headImgaeView.mj_x = 10;
    self.headImgaeView.mj_y = 10;
    self.headImgaeView.mj_h = 35;
    self.headImgaeView.mj_w = 35;
    [self.headImgaeView setCircleHeadWithPoint:CGPointMake(35, 35) radius:4];
    [self.headImgaeView setImageWithURL:[NSURL URLWithString:self.productListModel.headImg] placeholder:[UIImage defaultHead]];
    [headView addTapGesturesTarget:self selector:@selector(userImageClick)];
    [headView addSubview:self.headImgaeView];
    
    
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel .numberOfLines = 1;
    self.nameLabel .text = self.productListModel.nameNotes ?  self.productListModel.nameNotes : self.productListModel.custNname;
    self.nameLabel .textColor = [UIColor blackColor];
    self.nameLabel .font = [UIFont titleFont14];
    self.nameLabel .textAlignment = NSTextAlignmentLeft;
    [self.nameLabel  addTapGesturesTarget:self selector:@selector(userImageClick)];
    [headView addSubview:self.nameLabel ];
    
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.text = [NSString getTimeFormatterWithString:self.productListModel.createDate];
    self.timeLabel.textColor = RGB_COLOR(153, 153, 153);
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    [headView addSubview:self.timeLabel];
    
    
    UIImageView         *forwardImageView = [[UIImageView alloc] init];
    self.forwardImageView = forwardImageView;
    forwardImageView.image = [UIImage imageNamed:@"yr_prouduct_tran"];
    forwardImageView.hidden = YES;
    [headView addSubview:forwardImageView];

    
    
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
    
    
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImgaeView.mas_top);
        make.height.equalTo(@(14));
        make.left.equalTo(self.nameLabel .mas_right).offset(5);
        
    }];
    
    
    [forwardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(43));
        make.height.equalTo(@(13));
        make.top.equalTo(self.nameLabel .mas_top);
        make.left.equalTo(self.timeLabel.mas_right).offset(5);
    }];
    
    //已转发的状态
    forwardImageView.tag = 20002;
    if (self.productListModel.forwardStatus) {
        forwardImageView.hidden = NO;
    }else{
        forwardImageView.hidden = YES;
    }
    
    
    self.introductionLabel = [[UILabel alloc] init];

    self.introductionLabel.text = self.productListModel.custSignature;
    self.introductionLabel.textColor = RGB_COLOR(102, 102, 102);
    self.introductionLabel.textAlignment = NSTextAlignmentLeft;
    self.introductionLabel.font = [UIFont systemFontOfSize:13];
    [headView addSubview:self.introductionLabel];
    
    
    [self.introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgaeView.mas_right).offset(10);
        make.bottom.equalTo(self.headImgaeView.mas_bottom);
        make.height.equalTo(@(12));
        make.right.equalTo(headView.mas_right).offset(-50);
    }];
    
    
    
    self.collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.collectionButton setBackgroundImage:[UIImage imageNamed:@"yr_myCollect_no"] forState:UIControlStateNormal];
    [self.collectionButton setBackgroundImage:[UIImage imageNamed:@"yr_myCollect"] forState:UIControlStateSelected];
    self.collectionButton.frame = CGRectMake(SCREEN_WIDTH - 20 - 10, 15, 23, 23);
    [ self.collectionButton addTarget:self action:@selector(collectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:self.collectionButton];
    
    [self.tableHeadView  addSubview:headView];
    
    
}


- (void)initContentView{
    
    
    self.contentViewBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, 370 + self.commentHeigt + 10)];
    [self.tableHeadView addSubview:self.contentViewBgView ];
    

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 20, 0)];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont titleFont20];
    self.titleLabel.text = self.productListModel.desc ? self.productListModel.desc : @"";
    self.titleLabel.numberOfLines = 0;
    [self.titleLabel sizeToFit];
    [self.contentViewBgView  addSubview:self.titleLabel];
    

    UIImageView *videoView = [[UIImageView alloc] init];
    videoView.mj_x = 10;
    videoView.mj_y = self.titleLabel.mj_y + self.titleLabel.mj_h + 5;
    videoView.mj_w = SCREEN_WIDTH - 20;
    videoView.mj_h = 225;
    [videoView setImageWithURL:[NSURL URLWithString:self.productListModel.urlThumbnail] placeholder:[UIImage defaultImage] options:kNilOptions completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        self.shareImage = image;
    }];
    [self.contentViewBgView  addSubview:videoView];
    videoView.userInteractionEnabled = YES;
    self.imageVideo = videoView;
    
    self.playerView = [[ZFPlayerView alloc] initWithFrame:videoView.bounds];
    [self.playerView cancelAutoFadeOutControlBar];
    UIButton *soundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.soundBtn = soundBtn;
    soundBtn.frame = CGRectMake(10, 10, 40, 40);
    //    soundBtn.backgroundColor = [UIColor redColor];
    [self.playerView.controlView.topImageView addSubview:soundBtn];
    [soundBtn setBackgroundImage:[UIImage imageNamed:@"yr_no_sound"] forState:UIControlStateNormal];
    [soundBtn setBackgroundImage:[UIImage imageNamed:@"yr_sound"] forState:UIControlStateSelected];
    
    //    [soundBtn setTitle:@"静音" forState:UIControlStateNormal];
    [soundBtn addTarget:self action:@selector(soundBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSURL *url = [NSURL URLWithString:self.productListModel.url];
    
    self.playerView.placeholderImageName = @" ";
    self.playerView.videoURL = url;
    
    ZFPlayerControlView    *controlView = self.playerView.controlView;
    
    controlView.backBtn.hidden = YES;
    controlView.fullScreenBtn.selected = NO;
    [controlView.fullScreenBtn addTarget:self action:@selector(fullScreen:) forControlEvents:UIControlEventTouchUpInside];
    [controlView.playeBtn setImage:[UIImage imageNamed:@"yr_show_video"] forState:UIControlStateNormal];
    [videoView addSubview:self.playerView];
        [controlView.playeBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [controlView.repeatBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shareNumBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    shareNumBtn.frame = self.playerView.frame;
    self.shareBtn = shareNumBtn;
    //    shareNumBtn.backgroundColor = [UIColor redColor];
    [videoView addSubview:shareNumBtn];
    
    [shareNumBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bgView = [[UIView alloc]init];
    bgView.mj_x = 10;
    bgView.mj_y = videoView.mj_y + videoView.mj_h + 10;
    bgView.mj_w = SCREEN_WIDTH - 20;
    bgView.mj_h = 20;
    [self.contentViewBgView addSubview:bgView];
    bgView.backgroundColor = RGB_COLOR(245, 245, 245);
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 100, 20)];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20-80-100, 0, 100, 20)];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20-80, 0, 80, 20)];
    
    
    [bgView addSubview:label1];
    [bgView addSubview:label2];
    [bgView addSubview:label3];
    label1.font = [UIFont systemFontOfSize:15];
    label2.font = [UIFont systemFontOfSize:15];
    label3.font = [UIFont systemFontOfSize:15];
    self.label1=label1;
    self.label2 = label2;
    self.label3 = label3;

    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.mj_x = 10;
    self.contentLabel.mj_y = bgView.mj_y + bgView.mj_h + 10;
    self.contentLabel.mj_w = SCREEN_WIDTH - 20;
    self.contentLabel.mj_h = 0;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.text = self.productListModel.infoIntroduction ? self.productListModel.infoIntroduction : @"";
    self.contentLabel.font = [UIFont titleFont18];
    [self.contentLabel sizeToFit];
    [self.contentViewBgView  addSubview:self.contentLabel];


    [self.tableHeadView  addSubview:self.contentViewBgView ];
}
- (void)soundBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        //        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        //        for (UIView *view in [volumeView subviews]){
        //            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
        //               UISlider *volumeViewSlider = (UISlider *)view;
        //                [self.playerView.player setVolume:volumeViewSlider.value];
        //                break;
        //            }
        //        }
        [self.playerView.player setVolume:0.5];
    }else{
        [self.playerView.player setVolume:0.0];
    }
}


- (void)shareBtnClick:(UIButton *)sender{
    [self.view endEditing:YES];
    if ([YRUserInfoManager manager].currentUser==nil) {
        [self noLoginTip];
    }else{
//        NSAttributedString *str = [[NSAttributedString alloc]initWithString:@"转发得奖励" attributes:@{NSForegroundColorAttributeName:[UIColor themeColor]}];
        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"转发之后才可以收看视频" cancelButtonText:@"再看看" confirmButtonText:@"转发得奖励"];
        alertView.comfirmButtonColor = [UIColor themeColor];
        alertView.addCancelAction = ^{
            
        };
        alertView.addConfirmAction = ^{
            @weakify(self);
            self.isTran = ^(BOOL tran){
                @strongify(self);
                if (tran) {
                    YRRedPaperPaymentViewController *redVc = [[YRRedPaperPaymentViewController alloc]init];
                    redVc.productModel = self.productListModel;
                    redVc.tranSuccessDelegate = self;
                    redVc.delegate = self;
                    self.isFectDetail = YES;
                    [self.navigationController pushViewController:redVc animated:YES];
                }
            };
            [self queryPassWord];
        };
        [alertView show];
    }
}
- (void)playBtnClick:(UIButton *)sender{
    
     if ((self.productDetail.forwardStatus==1||self.productListModel.recommand==1)&&(self.productListModel.readStatus==0)) {
        [self infoReadStatus];
        NSString *str = [NSString stringWithFormat:@"%ld",[self.productDetail.readCount integerValue]+1];
        NSMutableAttributedString *lstr1 = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor themeColor]}];
        NSMutableAttributedString *lstr12 = [[NSMutableAttributedString alloc]initWithString:@"次播放" attributes:@{NSForegroundColorAttributeName:RGB_COLOR(175, 175, 175)}];
        [lstr1 appendAttributedString:lstr12];
        self.label1.attributedText = lstr1;
    }
  
}

- (void)fullScreen:(UIButton *)sender{
    
    [self.playerView pause];
    YRVidioFullController *full = [[YRVidioFullController alloc]initWithNibName:@"YRVidioFullController" bundle:nil];
    full.delegate = self;
    NSArray *array = [self.playerView.controlView.currentTimeLabel.text componentsSeparatedByString:@":"];
    full.ima = self.imageVideo.image;
    NSInteger time = [array[1] integerValue]+[array[0] integerValue]*60;
    //    播放的url地址
    full.url= self.playerView.videoURL;
    //播放的时间
    full.time = time;
    
    [self.navigationController pushViewController:full animated:YES];
    
}
//好友详情页跳转
- (void)userImageClick{
    
    [self pushUserInfoViewController:self.productListModel.custId withIsFriend:NO];
}

- (void)initBottomView{
    
    UIView *bottonBgView = [[UIView alloc] init];
    [bottonBgView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bottonBgView];
    self.bottomView = bottonBgView;
    
    [bottonBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(40));
        make.left.equalTo(@(0));
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    
    UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    topLine.backgroundColor = RGB_COLOR(229, 229, 229);
    [bottonBgView addSubview:topLine];
    
    NSString *tranStr = self.productDetail.forwardStatus ? @" 已转发" : @" 转发得奖励";
    NSArray *array = @[tranStr,@" 打赏",@" 评论",@" 点赞"];
    

    NSArray *imageNameArray = @[@"yr_button_tran",@"yr_button_reward",@"yr_button_comment",@"yr_button_unpraise"];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) {
            self.tranBottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.tranBottomButton  setTitle:array[idx] forState:UIControlStateNormal];
            [self.tranBottomButton  setTitleColor:RGB_COLOR(85, 85, 85) forState:UIControlStateNormal];
            self.tranBottomButton.frame = CGRectMake(0 , 0, 120 , 40);
            self.tranBottomButton.titleLabel.font = [UIFont systemFontOfSize:16];
            [self.tranBottomButton  setImage:[UIImage imageNamed:imageNameArray[idx]] forState:UIControlStateNormal];
            [bottonBgView addSubview:self.tranBottomButton ];
            
            UILabel  *verticalLabel = [[UILabel alloc] initWithFrame:CGRectMake(121, 7, 1, 26)];
            verticalLabel.backgroundColor = RGB_COLOR(229, 229, 229);
            [bottonBgView addSubview:verticalLabel];
            self.tranBottomButton.tag = 100;
            
            [self.tranBottomButton  addTarget:self action:@selector(buttonFuncTionClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
        }else if (idx == 1 || idx == 2){
            
            UIButton  *tranButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [tranButton setTitle:array[idx] forState:UIControlStateNormal];
            [tranButton setTitleColor:RGB_COLOR(85, 85, 85) forState:UIControlStateNormal];
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
        
            self.likeBottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.likeBottomButton setTitle:array[idx] forState:UIControlStateNormal];
            [self.likeBottomButton setTitleColor:RGB_COLOR(85, 85, 85) forState:UIControlStateNormal];
            self.likeBottomButton.frame = CGRectMake(120 + (SCREEN_WIDTH - 120) / 3 * (idx - 1), 0, (SCREEN_WIDTH - 120) / 3, 40);
            self.likeBottomButton.titleLabel.font = [UIFont systemFontOfSize:16];
            [self.likeBottomButton setImage:[UIImage imageNamed:imageNameArray[idx]] forState:UIControlStateNormal];
            [bottonBgView addSubview:self.likeBottomButton];
            self.likeBottomButton.tag = 100 + idx;
            UILabel  *verticalLabel = [[UILabel alloc] initWithFrame:CGRectMake(120 + (SCREEN_WIDTH - 120) / 3 * (idx), 7, 1, 26)];
            verticalLabel.backgroundColor = RGB_COLOR(229, 229, 229);
            [bottonBgView addSubview:verticalLabel];
            [self.likeBottomButton  addTarget:self action:@selector(buttonFuncTionClick:) forControlEvents:UIControlEventTouchUpInside];
            
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
    if (_commentView) {
        _commentView.hidden = YES;
        [_commentView.textView resignFirstResponder];
    }
    [btn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    
    self.start = 0;
    self.tag = 0;
}

- (void)commentButtonClick:(UIButton*)btn{
    if (_commentView) {
        _commentView.hidden = YES;
        [_commentView.textView resignFirstResponder];
    }
    [btn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    
    self.start = 0;
    self.tag  = 1;
}
/**
 *  @author yichao, 16-08-22 15:08:21
 *
 *  评论按钮监听
 *
 *  @param btn <#btn description#>
 */
- (void)rewardButtonClick:(UIButton*)btn{
    if (_commentView) {
        _commentView.hidden = YES;
        [_commentView.textView resignFirstResponder];
    }
    [btn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    self.tag = 2;
    self.start = 0;

    
    
}

- (void)priaseButtonClick:(UIButton*)btn{
    if (_commentView) {
        _commentView.hidden = YES;
        [_commentView.textView resignFirstResponder];
    }
    [btn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    self.tag = 3;
    self.start = 0;

}



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
    
    
    
    self.tranButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.tranButton .frame = CGRectMake(10, 10, 60, 20);
    self.tranButton .titleLabel.font = [UIFont systemFontOfSize:16];
    
    if (!self.productDetail.forwardCount) {
        self.productDetail.forwardCount = @"0";
    }
    [self.tranButton  setTitle:[NSString stringWithFormat:@"转发%@",self.forwardCount ? self.forwardCount : @""] forState:UIControlStateNormal];
    [self.tranButton  setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
    [self.tranButton  addTarget:self action:@selector(tranButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.tranButton ];
    
    
    self.underlineView.width =  65;
    self.underlineView.height = 3;
    self.underlineView.centerX = self.tranButton .centerX;
    self.underlineView.mj_y = self.tranButton .mj_x + self.tranButton .mj_h + 4;
    [view addSubview:self.underlineView];
    
    
    
    self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentButton .titleLabel.font = [UIFont systemFontOfSize:16];
    self.commentButton .frame = CGRectMake(self.tranButton .mj_x + self.tranButton .mj_w + 20 , 10, 60, 20);
    [self.commentButton  setTitle:[NSString stringWithFormat:@"打赏%ld",self.rewardCount] forState:UIControlStateNormal];
    [self.commentButton  setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
    [self.commentButton  addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.commentButton ];
    
    
    self.rewardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rewardButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.rewardButton.frame = CGRectMake(self.commentButton .mj_x + self.commentButton .mj_w + 20, 10, 60, 20);
    [ self.rewardButton setTitle:[NSString stringWithFormat:@"评论%ld",(long)self.commentCount] forState:UIControlStateNormal];
    [ self.rewardButton setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
    [ self.rewardButton addTarget:self action:@selector(rewardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview: self.rewardButton];
    
    
    
    self.priaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.priaseButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.priaseButton.frame = CGRectMake(SCREEN_WIDTH - 80, 10, 60, 20);
    [self.priaseButton setTitle:[NSString stringWithFormat:@"赞%ld",(long)self.totalLike] forState:UIControlStateNormal];
    [self.priaseButton setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
    [self.priaseButton addTarget:self action:@selector(priaseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.priaseButton];
    
    
    
    if (_tag == 0) {
        self.underlineView.centerX = self.tranButton .centerX;
        self.underlineView.mj_y = self.tranButton .mj_y + self.tranButton .mj_h + 4;
        [self.tranButton  setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    }else if (_tag == 1){
        [self.commentButton  setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        self.underlineView.centerX = self.commentButton .centerX;
        self.underlineView.mj_y = self.commentButton .mj_y + self.tranButton .mj_h + 4;
        
    }else if (_tag == 2){
        [ self.rewardButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        self.underlineView.centerX =  self.rewardButton.centerX;
        self.underlineView.mj_y =  self.rewardButton.mj_y +  self.rewardButton.mj_h + 4;
        
    }else if (_tag == 3){
        [self.priaseButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        self.underlineView.centerX = self.priaseButton.centerX;
        self.underlineView.mj_y = self.priaseButton.mj_y + self.priaseButton.mj_h + 4;
        
    }
    
    
    return view;
    
    
}



#pragma mark DZNEmptyDataSetSource

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{

    return  YES;
}

//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
//    NSString *text = @"暂无相关信息";
//    if (_tag == 0) {
//        text = @"快来转发获奖励";
//    } else if (_tag == 1) {
//        text = @"快来赏一个";
//    }else  if (_tag == 2) {
//        text = @"快来发表评论吧";
//    } else if (_tag == 3) {
//        text = @"快来点个赞";
//    }
//    
//    
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
//                                 NSForegroundColorAttributeName:RGB_COLOR(153, 153, 153)};
//    
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}
//
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
//    //    DLog(@"%ld",self.tableView.tableHeaderView.frame.size.height/2.0f - 120);
//    return self.tableView.tableHeaderView.frame.size.height/2.0f;
//}

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
        [topCell setTranModel:self.tranList[indexPath.row]];
        topCell.timeLabel.hidden = NO;
        return topCell;
    } else if (_tag == 1) {
        YRRewardTableViewCell *topCell = [tableView dequeueReusableCellWithIdentifier:yrRewardCellID];
        [topCell setRewardModel:self.giftList[indexPath.row]];
        return topCell;
    }else if(_tag == 2){
        YRCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:yrCommnetCellID];
        cell.delegate = self;
        cell.indexPath = indexPath;
        [cell setCommentModel:self.commentList[indexPath.row]];
        return cell;
    }else {
        YRTranTableViewCell *topCell = [tableView dequeueReusableCellWithIdentifier:yrTranCellID];
        topCell.timeLabel.hidden = YES;
        [topCell setCircleTranModel:self.likeList[indexPath.row]];
        return topCell;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 44;
//}

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
    if (_tag ==1) {
        YRRewardListModel * model = self.giftList[indexPath.row];
        [self pushUserInfoViewController:model.custId withIsFriend:YES];
    }
    if (_tag == 2) {
        
        if (![YRUserInfoManager manager].currentUser.custId) {
            [self noLoginTip];
            return;
        }
        
        self.commentModel = self.commentList[indexPath.row];
        if ([self.commentModel.authorId isEqualToString:[YRUserInfoManager manager].currentUser.custId]) {
            self.commentModel = nil;
            return;
        }
        self.commentView.hidden = NO;
        [self.view addSubview:self.commentView];
        self.commentView.placeholder = [NSString stringWithFormat:@"回复:%@",self.commentModel.authorName];
        [self.commentView.textView becomeFirstResponder];
    }  if (_tag ==3) {
        YRProudTranModel * model = self.likeList[indexPath.row];
        [self pushUserInfoViewController:model.userId withIsFriend:YES];
    }
    
}

#pragma mark 评论



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
            
            [YRHttpRequest productDeleteComment:commentModel.uid infoId:self.productDetail.uid success:^(id data) {
                [self.commentList removeObjectAtIndex:indexPath.row];
                self.commentCount -=1;
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




- (void)dealloc{    
    [self.imageVideo removeAllSubviews];
    [self.tableView removeAllSubviews];
    [self.view removeAllSubviews];
    
    self.imageVideo = nil;
    self.tableView = nil;
    self.view = nil;
}


- (void)buttonFuncTionClick:(UIButton*)btn{
    
    //取消此方法
//    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(doSth:) object:btn];
//    [self performSelector:@selector(doSth:) withObject:btn afterDelay:0.5f];
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
            
            if ([btn.titleLabel.text isEqualToString:@" 邀请转发"]) {
                YRAddNewGroupViewController *newChatVc = [[YRAddNewGroupViewController alloc] init];
                newChatVc.title = @"选择联系人";
                newChatVc.infoId = self.productListModel.uid;
                [self.navigationController pushViewController:newChatVc animated:YES];
            }else  if ([btn.titleLabel.text isEqualToString:@" 已转发"]) {
                
            }else{
                self.tag = 0;
                self.tranBottomButton.userInteractionEnabled =NO;
                @weakify(self);
                self.isTran = ^(BOOL tran){
                    @strongify(self);
                    if (tran) {
                        YRRedPaperPaymentViewController *redVc = [[YRRedPaperPaymentViewController alloc]init];
                        redVc.productModel = self.productListModel;
                        redVc.tranSuccessDelegate = self;
                        self.isFectDetail = YES;
                        [self.navigationController pushViewController:redVc animated:YES];
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
                    self.rewardGiftView.rewardBlock = ^(RewardGiftModel *giftModel ,float money){
                        @strongify(self);
                        NSString *allMoneyStr = [NSString stringWithFormat:@"%.2f",money];
                        
                        //小额免密打开并总支付小于50
                        if (self.smallNopass && [allMoneyStr floatValue] * 0.01 <= 50) {
                            
                            [YRHttpRequest sendReward:giftModel.giftid touserid:self.productDetail.custId type:2 infoId:self.productDetail.uid giftNum:1 password:@"" infoType:kInfoTypeVideo infoTitle:self.productListModel.desc ? self.productListModel.desc : @"" pid:@"" success:^(id data) {
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
                        
                        
                        [self sendReward:allMoneyStr giftModel:giftModel touserid:self.productDetail.custId pid:self.productDetail.uid];
                        
                        
                    };
                    [self.rewardGiftView.rechargeButton addTarget:self action:@selector(rechargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.rewardGiftView showGiftView];
                    
                    
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
                [btn setImage:[UIImage imageNamed:@"yr_button_praise"] forState:UIControlStateNormal];
                self.tag = 3;
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
- (void)rechargeButtonClick{
    RRZSaveMoneyController  *saveVc = [[RRZSaveMoneyController alloc] init];
    [self.navigationController pushViewController:saveVc animated:YES];
}
- (void)collectionButtonClick:(UIButton*)btn{
    btn.selected = !btn.selected;
    NSString *uid = self.productListModel.uid ? self.productListModel.uid : self.productListModel.infoId;
    if ([uid isBlank]) {
        [MBProgressHUD showError:@"作品不存在"];
        return;
    }
    
    if (self.collectStatus != 1) {
        [YRHttpRequest productAddCollect:uid like:1 success:^(id data) {
            [MBProgressHUD showSuccess:@"收藏成功"];
            self.collectStatus = 1;
        } failure:^(id data) {
            [MBProgressHUD showError:data];
        }];
    }else{
        [YRHttpRequest productAddCollect:uid like:0 success:^(id data) {
            [MBProgressHUD showSuccess:@"取消收藏"];
            self.collectStatus = 0;
        } failure:^(id data) {
            [MBProgressHUD showError:data];
        }];
    }
    
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
        [YRHttpRequest sendReward:giftModel.giftid touserid:touserid type:2 infoId:pid giftNum:1 password:password infoType:kInfoTypeVideo infoTitle:self.productListModel.infoTitle ? self.productListModel.desc : @"" pid:@"" success:^(id data) {
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


- (void)tranSuccessDelegate:(YRProductListModel *)productListModel circleListModel:(YRCircleListModel *)circleListModel indexPosition:(NSInteger)indexPosition{
    
    YRProudTranModel  *model = [[YRProudTranModel alloc] init];
    NSInteger  count = [self.forwardCount integerValue] + 1;
    
    self.forwardCount = [NSString stringWithFormat:@"%ld",count];
    model.custImg = [YRUserInfoManager manager].currentUser.custImg;
    model.custNname = [YRUserInfoManager manager].showUserName;
    model.createDate = [NSString getCurrentMsTimestamp];
    [self.tranList insertObject:model atIndex:0];
    model.custId = [YRUserInfoManager manager].currentUser.custId;
    self.forwardStatus = 1;
    [self.tableView reloadData];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
