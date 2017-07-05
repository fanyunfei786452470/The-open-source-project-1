//
//  YRSunTextDetailViewController.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/20.
//  Copyright © 2016年 yryz. All rights reserved.

#import "YRSunTextDetailViewController.h"
#import "YRSunTextDetailHeaderView.h"
#import "YRSunTextDetailLikeCell.h"
#import "YRSunTextDetailGiftCell.h"
#import "YRSunTextDetailCell.h"
#import "YRSunTextDetailCommentCell.h"
#import "YRCommentListModel.h"
#import "RewardGiftView.h"
#import "SunTextCommentView.h"
#import "LWImageBrowserModel.h"
#import "LWImageBrowser.h"
#import "YRShowVideoView.h"
#import "YRMyShareView.h"
#import "YRLikeListModel.h"
#import "YRLikeListHeightModel.h"
#import "YRGiftListHeightModel.h"
#import "YRComementModel.h"
#import "YRGiftListModel.h"
#import "ZXLayoutTextView.h"
#import "YRReportTextView.h"
#import "RRZSaveMoneyController.h"
#import "YRPaymentPasswordView.h"
#import "YRChangePayPassWordController.h"
#import "YRAdListUserInfoController.h"
#import "YRMsgReportViewController.h"
#import "LWLoadingView.h"


static NSString *yrSunTextDetailcommentCellIdentifier = @"yrSunTextDetailcommentCellIdentifier";
static NSString *yrSunTextDetaillikeCellIdentifier = @"yrSunTextDetaillikeCellIdentifier";
static NSString *yrSunTextDetailgiftCellIdentifier = @"yrSunTextDetailgiftCellIdentifier";

@interface YRSunTextDetailViewController ()<UITableViewDelegate,UITableViewDataSource,YRSunTextDetailHeaderViewDelegate,UIActionSheetDelegate,YRSunTextDetailCommentCellDelegate,YRSunTextDetailLikeCellDelegate>
{
    CGFloat _totalKeybordHeight;
}
@property (nonatomic, strong) NSIndexPath *currentEditingIndexthPath;

@property (nonatomic,weak) UITableView    *tb_View;

@property (nonatomic,strong) RewardGiftView *rewardGiftView;

@property (nonatomic,weak) UIActionSheet  *actionSheet;


@property (nonatomic,strong) NSMutableArray *commentListArr;

@property (nonatomic,strong) NSMutableArray *likesListArr;

@property (nonatomic,strong) NSMutableArray *giftsListArr;

@property (nonatomic,strong) YRLikeListHeightModel *likeListHModel;

@property (nonatomic,strong) YRGiftListHeightModel *giftListModel;

@property (nonatomic,weak) YRSunTextDetailHeaderView *headerView;

@property (nonatomic,strong) YRComementModel *commentModel;

@property (nonatomic,weak) ZXLayoutTextView *commentView;

@property (nonatomic, assign)int  start;

//是否设置支付密码
@property (nonatomic, assign) BOOL          havePassword;
//小额免密开关
@property (nonatomic, assign) BOOL          smallNopass;


/// 是否设置支付密码  是否开启小额免密
@property (nonatomic,copy) void  (^isHavePasswordAndisSmallNopass)(BOOL isHavePassword  ,BOOL isSmallNopass);

@end

@implementation YRSunTextDetailViewController

- (void)setStart:(int)start{
    if (start < 0) {
        _start = 0;
        return;
    }
    _start = start;
}
- (YRComementModel *)commentModel{
    if (!_commentModel) {
        _commentModel = [[YRComementModel alloc] init];
    }
    return _commentModel;
}

- (NSMutableArray *)commentListArr{
    if (!_commentListArr) {
        
        _commentListArr = [NSMutableArray array].mutableCopy;
    }
    return _commentListArr;
}

- (NSMutableArray *)likesListArr{
    if (!_likesListArr) {
        
        _likesListArr = [NSMutableArray array];
    }
    return _likesListArr;
}

- (NSMutableArray *)giftsListArr{
    if (!_giftsListArr) {
        _giftsListArr = [NSMutableArray array];
    }
    return _giftsListArr;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (self.headerViewModel == nil) {
        [LWLoadingView showInView:self.view];
        
        [self setLikeList];
        
        [self setRewardList];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"随手晒详情";
    
    [self refreshBegin];

    [self setRightNavButtonWithImage:[UIImage imageNamed:@"yr_navButton_more"]];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-40) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = RGB_COLOR(245, 245, 245);
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    self.tb_View = table;
    [table jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    
    @weakify(self);
    
    [YRHttpRequest getFriendsCircleDetailByCustSid:self.sid success:^(NSDictionary *data) {
        @strongify(self);
        self.headerViewModel = [YRSunTextDetailHeaderModel mj_objectWithKeyValues:data];
        
        @weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            
            YRSunTextDetailHeaderView *headerView = [[YRSunTextDetailHeaderView alloc] init];
            headerView.delegate = self;
            headerView.model = self.headerViewModel;
            headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.headerViewModel.headerViewH);
            self.tb_View.tableHeaderView = headerView;
            self.headerView = headerView;
            [self setCommentView];
            [LWLoadingView hideInViwe:self.view];

        });
        
        [self.tb_View reloadData];
        
    } failure:^(NSString *errorInfo) {
        
        [LWLoadingView hideInViwe:self.view];
    }];
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    footerView.backgroundColor = [UIColor whiteColor];
    table.tableFooterView = footerView;
    
    [table registerClass:[YRSunTextDetailCommentCell class] forCellReuseIdentifier:yrSunTextDetailcommentCellIdentifier];
    [table registerClass:[YRSunTextDetailLikeCell class] forCellReuseIdentifier:yrSunTextDetaillikeCellIdentifier];
    [table registerClass:[YRSunTextDetailGiftCell class] forCellReuseIdentifier:yrSunTextDetailgiftCellIdentifier];
    
}
- (void)setCommentView{
    
    ZXLayoutTextView *commentView = [[ZXLayoutTextView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50-64, SCREEN_WIDTH, 50)];
    commentView.placeholder = @"评论";
    self.commentView        = commentView;
    [self.view addSubview:commentView];
    
    @weakify(self);
    
    [commentView setSendBlock:^(YRReportTextView *textView) {
        @strongify(self);
        
        
        NSDate* data = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval time=[data timeIntervalSince1970]*1000;
        NSString *timeString = [NSString stringWithFormat:@"%f", time];
        
        [YRHttpRequest sendFriendsCircleCommentByCustSid:self.sid AuthorUid:self.commentModel.toId  Content:textView.text success:^(NSDictionary *data) {
            @strongify(self);
            NSString *cid = data[@"cid"];

            YRCommentListModel *model = [[YRCommentListModel alloc]init];
            model.custId = [YRUserInfoManager manager].currentUser.custId;
            model.custName = [YRUserInfoManager manager].currentUser.custNname;
            model.content = textView.text;
            model.authorName = self.commentModel.toName;
            model.timeStamp = timeString;
            model.cid = [cid intValue];
            
            [self.commentListArr insertObject:model atIndex:0];
            
            self.commentModel.toName = nil;
            self.commentModel.toId = nil;
            self.commentView.textView.text = @"";
            [self.tb_View reloadData];
            
            DLog(@"晒一晒评论：%@",data);
        } failure:^(NSString *errorInfo) {
            
//            [MBProgressHUD showError:@"评论失败！"];
        }];
        

        self.commentView.placeholder = @"评论";
    }];
}

- (void)footRefresh
{
    
    YRCommentListModel *model = [self.commentListArr lastObject];
    
    self.start = model.cid;
    
    [self fectData];
}

- (void)fectData{
    
    @weakify(self);
    [YRHttpRequest getFriendsCircleCommentListByCustSid:self.sid Limit:kListPageSize Cid:self.start success:^(id data) {
        DLog(@"晒一晒评论列表：%@",data);
        @strongify(self);
        if (self.start == 0) {
            [self.commentListArr removeAllObjects];
        }
        NSArray *arr = [YRCommentListModel mj_objectArrayWithKeyValuesArray:data];
        [self.commentListArr addObjectsFromArray:arr];
    
        if ([arr count] ==  0) {
            [self.tb_View.footer endRefreshingWithNoMoreData];
        }else{
            [self.tb_View.footer endRefreshing];
        }
        
        
        [self.tb_View reloadData];
        
    } failure:^(NSString *eCorrorInfo) {
        
    }];
}

- (void)queryPassWord{
    
    [YRHttpRequest QueryThePaymentPasswordSuccess:^(NSDictionary *data) {
        //是否设置支付密码
        self.havePassword = [data[@"isPayPassword"] boolValue];
        //小额免密开关
        self.smallNopass = [data[@"smallNopass"] boolValue];
        
        if (!self.havePassword) {
            
            YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"请设置支付密码" cancelButtonText:@"取消" confirmButtonText:@"确认"];
            
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
            if (self.isHavePasswordAndisSmallNopass) {
                self.isHavePasswordAndisSmallNopass(self.havePassword ,self.smallNopass);
            }
        }
        
    } failure:^(NSString *error) {
        
        [MBProgressHUD showError:error];
    }];
}

/**
 *  @author ZX, 16-07-28 11:07:06
 *
 *  更多按钮
 */
- (void)rightNavAction:(UIButton*)button{
    [self.commentView endEditing:YES];

    YRMsgReportViewController *reportVc = [[YRMsgReportViewController alloc] init];
    reportVc.type = 1;
    reportVc.sourceId = [NSString stringWithFormat:@"%d",self.sid];
    [self.navigationController pushViewController:reportVc animated:YES];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2+self.commentListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        YRSunTextDetailLikeCell *likeCell = [tableView dequeueReusableCellWithIdentifier:yrSunTextDetaillikeCellIdentifier forIndexPath:indexPath];
        likeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        likeCell.likeListArr = self.likeListHModel.likeListArr;
        likeCell.model = self.likeListHModel;
        likeCell.delegate = self;
        [likeCell reloadData];
        
        return likeCell;
        
    }else if (indexPath.row == 1){
        
        YRSunTextDetailGiftCell *giftCell = [tableView dequeueReusableCellWithIdentifier:yrSunTextDetailgiftCellIdentifier forIndexPath:indexPath];
        giftCell.selectionStyle = UITableViewCellSelectionStyleNone;
        giftCell.giftListArr = self.giftListModel.giftListArr;
        giftCell.model = self.giftListModel;
        [giftCell reloadData];
        
        return giftCell;
        
    }else{
        
        YRSunTextDetailCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:yrSunTextDetailcommentCellIdentifier forIndexPath:indexPath];
        commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        commentCell.delegate  = self;
        commentCell.indexPath = indexPath;
        commentCell.model     = self.commentListArr[indexPath.row-2];
        
        if (indexPath.row == 2) {
            commentCell.msgImage.hidden = NO;
        }else{
            commentCell.msgImage.hidden = YES;
        }
        return commentCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        return self.likeListHModel.likeListHeight;
    }else if (indexPath.row == 1){
        return self.giftListModel.giftListHeight;
    }else{
        YRCommentListModel *model = self.commentListArr[indexPath.row-2];
        return model.cellHeight;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
    }else if (indexPath.row == 1){
        
    }else{
        
        YRCommentListModel *model = self.commentListArr[indexPath.row-2];
        
        if ([model.custId isEqualToString: [YRUserInfoManager manager].currentUser.custId]) {
            return;
        }
        self.commentModel.toName = model.custName;
        self.commentModel.toId = model.custId;
        self.currentEditingIndexthPath = indexPath;
        self.commentView.placeholder = [NSString stringWithFormat: @"回复 %@",model.custName];
        
        [self.commentView.textView becomeFirstResponder];
    }
}

- (void)didSeleteHeaderImgWithCustId:(NSString *)custId{
    
    YRAdListUserInfoController *friendInfoViewController = [[YRAdListUserInfoController alloc]init];
    friendInfoViewController.isFriend = YES;
    friendInfoViewController.custId = custId?custId:@"";
    [self.navigationController pushViewController:friendInfoViewController animated:YES];
}
- (void)didClickLongPressGestureRecognizerCellWithIndexPath:(NSIndexPath *)indexPath{
    
    
    YRCommentListModel *model = self.commentListArr[indexPath.row-2];

    if (![self.headerViewModel.custId isEqualToString:[YRUserInfoManager manager].currentUser.custId]) {
        if (![model.custId isEqualToString: [YRUserInfoManager manager].currentUser.custId]) {
            return;
        }
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
#pragma mark - YRSunTextDetailHeaderViewDelegate
//查看图片
- (void)headerView:(YRSunTextDetailHeaderView *)view didClickedImageWithCellModel:(YRSunTextDetailHeaderModel *)model atIndex:(NSInteger)index WithArr:(NSMutableArray *)positionArr{
    
    NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:model.pics.count];
    for (NSInteger i = 0; i < model.pics.count; i ++) {
        LWImageBrowserModel* imageModel = [[LWImageBrowserModel alloc] initWithplaceholder:nil
                                                                              thumbnailURL:[NSURL URLWithString:[model.pics objectAtIndex:i][@"url"]] HDURL:[NSURL URLWithString:[model.pics objectAtIndex:i][@"url"]] imageViewSuperView:self.view positionAtSuperView:CGRectFromString(positionArr[i]) index:index];
        [tmp addObject:imageModel];
    }
    LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self
                                                                            imageModels:tmp
                                                                           currentIndex:index];
    imageBrowser.view.backgroundColor = [UIColor grayColor];
    [imageBrowser show];
    
}

- (void)headerView:(YRSunTextDetailHeaderView *)view didClickedVideoWithCellModel:(YRSunTextDetailHeaderModel *)model{
    
    YRShowVideoView *videoView = [[YRShowVideoView alloc] initWithFrame:self.view.frame IsRequest:YES WithPathOrUrl:model.videoUrl];
    [videoView show];
}
//点赞
- (void)headerView:(YRSunTextDetailHeaderView *)view didClickedLikeButtonWithIsLike:(NSInteger)isLike{
    [self.commentView endEditing:YES];

    NSMutableArray *likeArr = [NSMutableArray array];
    [likeArr addObjectsFromArray:self.likeListHModel.likeListArr];
    
    if (isLike == 1) {
        
        [likeArr removeObjectAtIndex:0];
        
        self.headerView.zanBtn.selected = NO;
        
        self.likeListHModel.likeListArr = likeArr;
        
        self.headerViewModel.isLike = 0;
        
        
        [YRHttpRequest getFriendsCircleLikeByCustSid:self.sid Action:0 success:^(NSDictionary *data) {
            DLog(@"点赞：%@",data);
        } failure:^(NSString *errorInfo) {
            
        }];
        
    }else{
        self.headerView.zanBtn.selected = YES;
        
        NSDictionary *dic = @{
                              @"lid": @(123),
                              @"custId": [YRUserInfoManager manager].currentUser.custId?[YRUserInfoManager manager].currentUser.custId:@"",
                              @"custName": @"test",
                              @"custImg": [YRUserInfoManager manager].currentUser.custImg?[YRUserInfoManager manager].currentUser.custImg:@""
                              };
        
        
        [likeArr insertObject:dic atIndex:0];
        
        self.likeListHModel.likeListArr = likeArr;
        
        self.headerViewModel.isLike = 1;
        
        
        [YRHttpRequest getFriendsCircleLikeByCustSid:self.sid Action:1 success:^(NSDictionary *data) {
            DLog(@"点赞：%@",data);
        } failure:^(NSString *errorInfo) {
            
        }];
    }
    
    [self.tb_View reloadData];
}

//礼物
- (void)headerView:(YRSunTextDetailHeaderView *)view didClickedGiftButtonWithIsGift:(BOOL)isGift{
    [self.commentView endEditing:YES];


    @weakify(self);
    self.isHavePasswordAndisSmallNopass = ^(BOOL isHavePassword ,BOOL isSmallNopass) {
        @strongify(self);
        if (isHavePassword) {

        self.rewardGiftView = [[RewardGiftView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT, self.rewardGiftView.frame.size.width, self.rewardGiftView.frame.size.height)];
        @weakify(self);
        self.rewardGiftView.rewardBlock = ^(RewardGiftModel *giftModel ,float money){
            @strongify(self);
            NSString *allMoneyStr = [NSString stringWithFormat:@"%.2f",money];
            
            //小额免密打开并总支付小于50
            if (self.smallNopass && [allMoneyStr floatValue] * 0.01 <= 50) {
                
                [YRHttpRequest sendReward:giftModel.giftid touserid:self.headerViewModel.custId type:1 infoId:[NSString stringWithFormat:@"%d",self.sid] giftNum:1 password:@"" infoType:0 infoTitle:@"" pid:@"" success:^(id data) {
                    @strongify(self);

                    [MBProgressHUD showSuccess:@"打赏成功"];
                    
                    [self setRewardList];

                } failure:^(NSString *data) {
                    [MBProgressHUD showError:data];
                }];
                return ;
            }
            
            [self sendReward:allMoneyStr giftid:giftModel.giftid touserid:self.headerViewModel.custId pid:[NSString stringWithFormat:@"%d",self.sid]];
            
        };
        [self.rewardGiftView.rechargeButton addTarget:self action:@selector(rechargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [self.rewardGiftView showGiftView];
        
        }
    };
        
    [self queryPassWord];

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

//评论
- (void)headerView:(YRSunTextDetailHeaderView *)view didClickedCommentWithCellModel:(YRSunTextDetailHeaderModel *)model{
    self.commentView.placeholder = @"评论";
    
    self.commentModel.toName = @"";
    self.commentModel.toId = @"";
    [self.commentView.textView becomeFirstResponder];
}
//删除
- (void)didClickDeleteSunText{
    [self.commentView endEditing:YES];

    @weakify(self);
    YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"确定删除当前动态" cancelButtonText:@"取消" confirmButtonText:@"确定"];
    
    alertView.addCancelAction = ^{
        
    };
    
    alertView.addConfirmAction = ^{
        
        [YRHttpRequest deleteFriendsCircleDetailByCustSid:self.sid success:^(NSDictionary *data) {
            
            @strongify(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];

            });
            
            if ([self.delegate respondsToSelector:@selector(deleteSunTextWithIndexPath:)]) {
                [self.delegate deleteSunTextWithIndexPath:self.seleteIndex];
            }
            
        } failure:^(NSString *errorInfo) {
        }];
    };
    
    [alertView show];
}

- (void)headerView:(YRSunTextDetailHeaderView *)view didClickedHeadImgWithCellModel:(YRSunTextDetailHeaderModel *)model{
    
    YRAdListUserInfoController *friendInfoViewController = [[YRAdListUserInfoController alloc]init];
    friendInfoViewController.isFriend = YES;
    friendInfoViewController.custId = model.custId;
    [self.navigationController pushViewController:friendInfoViewController animated:YES];
}

-(float)widthForString:(NSString *)value fontSize:(float)fontSize{
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-18, 100) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.height;
}

// 添加删除评论按钮
- (void)addActionTarget:(UIAlertController *)alertController titles:(NSArray *)titles indexPath:(NSIndexPath *)indexPath{
    
    @weakify(self);
    for (NSString *title in titles) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            YRCommentListModel *model = self.commentListArr[indexPath.row-2];
            int sid = [model.sid intValue];
            int cid = model.cid;
            
            [YRHttpRequest deleteFriendsCircleCommentByCustSid:sid Cid:cid success:^(NSDictionary *data) {
                @strongify(self);
                DLog(@"删除评论：%@",data);
                [self.commentListArr removeObjectAtIndex:indexPath.row-2];
                [self.tb_View reloadData];
                
            } failure:^(NSString *eCorrorInfo) {
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
        
        UIButton *btn       = (UIButton *)view;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        if([[btn titleForState:UIControlStateNormal] isEqualToString:@"取消"]){
            [btn setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:RGB_COLOR(0, 121, 255) forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 获取数据
- (void)refreshBegin{
    
    @weakify(self);
    [YRHttpRequest getFriendsCircleCommentListByCustSid:self.sid Limit:kListPageSize Cid:0 success:^(id data) {
        DLog(@"晒一晒评论列表：%@",data);
        @strongify(self);
        
        self.commentListArr = [YRCommentListModel mj_objectArrayWithKeyValuesArray:data];
        
        [self.tb_View reloadData];
        
        if ([self.commentListArr count] <  kListPageSize) {
            [self.tb_View.footer endRefreshingWithNoMoreData];
        }else{
            [self.tb_View.footer endRefreshing];
        }
        
    } failure:^(NSString *eCorrorInfo) {
        [self.tb_View.footer endRefreshingWithNoMoreData];

    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.commentView.placeholder = @"评论";
    [self.commentView.textView resignFirstResponder];
  
}

/**
 *  @author weishibo, 16-09-12 17:09:13
 *
 *  发送打赏
 */
- (void)sendReward:(NSString*)allMoneyStr giftid:(NSString*)giftid touserid:(NSString*)touserid pid:(NSString*)pid{
    
    @weakify(self);
    [YRPaymentPasswordView showPaymentViewWithMoney:allMoneyStr  paymentBlock:^(NSString  *password){
        @strongify(self);
        [YRPaymentPasswordView hidePaymentPasswordView];
        [YRHttpRequest sendReward:giftid touserid:touserid type:1 infoId:pid giftNum:1 password:password infoType:0 infoTitle:@""  pid:@"" success:^(id data) {
            [MBProgressHUD showSuccess:@"打赏成功"];
            [self setRewardList];

        } failure:^(NSString *data) {
            if ([data isEqualToString:@"支付密码错误"]) {
                [YRPaymentPasswordView hidePaymentPasswordView];
                
                YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"支付密码错误，请重试" cancelButtonText:@"确定"  ];
                
                alertView.addCancelAction = ^{
                    
                    [self sendReward:allMoneyStr giftid:giftid touserid:touserid pid:pid];
                };
                [alertView show];
                return ;
            }
            [MBProgressHUD showError:data];
            
        }];
        
    }];
}

//点赞列表
- (void)setLikeList{
    @weakify(self);

    [YRHttpRequest getFriendsCircleLikeListByCustSid:self.sid Lid:0 Limit:kListPageSize success:^(id data) {
        @strongify(self);
        
        DLog(@"点赞列表：%@",data);
        
        NSDictionary *dic = @{@"likeListArr" : data};
        
        self.likeListHModel = [YRLikeListHeightModel mj_objectWithKeyValues:dic];
        
        self.likesListArr = [YRLikeListModel mj_keyValuesArrayWithObjectArray:(NSArray *)data];
        
        [self.tb_View reloadData];
        [LWLoadingView hideInViwe:self.view];

    } failure:^(NSString *errorInfo) {
        [LWLoadingView hideInViwe:self.view];

    }];
}

//打赏列表
- (void)setRewardList{
    @weakify(self);
    [YRHttpRequest rewardObjList:1 pid:[NSString stringWithFormat:@"%d",self.sid] pageNumber:0 pageSize:kListPageSize success:^(id data) {
        DLog(@"打赏列表：%@",data);
        @strongify(self);
        
        NSDictionary *dic = @{@"giftListArr" : data};
        
        self.giftsListArr = [YRGiftListModel mj_keyValuesArrayWithObjectArray:(NSArray*)data];
        self.giftListModel = [YRGiftListHeightModel mj_objectWithKeyValues:dic];
        
        [self.tb_View reloadData];
        [LWLoadingView hideInViwe:self.view];

    } failure:^(id data) {
        [LWLoadingView hideInViwe:self.view];

    }];

}





- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
