
/********************* 有任何问题欢迎反馈给我 liuweiself@126.com ****************************************/
/***************  https://github.com/waynezxcv/Gallop 持续更新 ***************************/
/******************** 正在不断完善中，谢谢~  Enjoy ******************************************************/

#import "YRSunTextViewController.h"
#import "BaseNavigationController.h"
#import "YRSunTextDetailViewController.h"
#import "SunTextTableViewCell.h"
#import "GallopUtils.h"
#import "LWAlchemy.h"
#import "StatusModel.h"
#import "SunTextCellLayout.h"
#import "SunTextCommentView.h"
#import "CommentModel.h"
#import "LWImageBrowserModel.h"
#import "LWImageBrowser.h"
#import "YRPublishTextViewController.h"
#import "RewardGiftView.h"
#import "YRShowVideoView.h"
#import "YRPublishVideoViewController.h"
#import "YRBaskViewController.h"
#import "YRSunTextFirstView.h"
#import <ALBBSDK/ALBBSDK.h>
#import <ALBBQuPai/ALBBQuPaiService.h>
#import <ALBBQuPai/QPEffectMusic.h>
#import "NSArray+YRInfo.h"
#import "YRHttpRequest.h"
#import "QBImagePickerController.h"
#import "YRSunImageModel.h"
#import "ZXLayoutTextView.h"
#import "YRReportTextView.h"
#import "RRZSaveMoneyController.h"
#import "YRPaymentPasswordView.h"
#import "YRLoginController.h"
#import "YRChangePayPassWordController.h"
#import "YRAdListUserInfoController.h"
#import "RRZAddressAddFriendController.h"
#import "JFImagePickerController.h"

#define maxInteger 99999

@interface YRSunTextViewController () <UITableViewDataSource,UITableViewDelegate,TableViewCellDelegate,UIActionSheetDelegate,QBImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,LWImageBrowserDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,YRSunTextDetailViewControllerDelegate,YRPublishTextViewControllerDeletate,YRPublishVideoViewControllerDelegate,LoginSuccessDelegate>
{
    BOOL _down;
}
@property (nonatomic,strong) ZXLayoutTextView    *commentView;
@property (nonatomic,strong) UITableView         *tableView;
@property (nonatomic,strong) NSMutableArray      *dataSource;
@property (nonatomic,assign,getter = isNeedRefresh) BOOL needRefresh;
@property (nonatomic,strong) CommentModel       *postComment;
@property (nonatomic,strong) NSArray            *imgArr;
@property (nonatomic,strong) RewardGiftView     *rewardGiftView;
@property (nonatomic,copy) NSString         *commentId;

@property (nonatomic,strong)YRSunTextFirstView  *sunTextFirstView;

@property (nonatomic, assign)int           start;

@property (nonatomic,assign) NSInteger     commentIndex;

@property (nonatomic, assign) BOOL         havePassword; //是否设置支付密码

@property (nonatomic, assign) BOOL          smallNopass;//小额免密开关

@property (nonatomic,copy) void  (^isHavePasswordAndisSmallNopass)(BOOL isHavePassword  ,BOOL isSmallNopass);/// 是否设置支付密码  是否开启小额免密

@end

@implementation YRSunTextViewController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray array] mutableCopy];
        [_dataSource removeAllObjects];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSArray *dataArray = (NSArray *)[[YRYYCache share].yyCache objectForKey:NSStringFromClass([self class])];
        NSMutableArray *dataArr = [NSMutableArray array];
            
        for (NSInteger i = 0; i < dataArray.count; i ++) {
            StatusModel* statusModel = [StatusModel modelWithJSON:dataArray[i]];
            LWLayout* layout = [self layoutWithStatusModel:statusModel index:i];
            [dataArr addObject:layout];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
                
        [_dataSource addObjectsFromArray:dataArr];
            });
        });
    }
    return _dataSource;
}

- (void)setStart:(int)start{
    if (start < 0) {
        _start = 0;
        return;
    }
    _start = start;
}

#pragma mark - ViewControllerLifeCycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
   
    @weakify(self);
    if (![YRUserInfoManager manager].currentUser.custId) {
        
        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"请登录进行后续操作" cancelButtonText:@"再逛逛" confirmButtonText:@"登录"];
        alertView.addCancelAction = ^{
        };
        alertView.addConfirmAction = ^{
            @strongify(self);
            YRLoginController *loginVc = [[YRLoginController alloc] init];
            loginVc.loginSuccessDelegate = self;
            [self.navigationController pushViewController:loginVc animated:YES];
        };
        
        [alertView show];
    }
    if (![YRUserInfoManager manager].currentUser.custId) {
        [self.dataSource removeAllObjects];
        [self.sunTextFirstView removeFromSuperview];

        [self.tableView reloadData];
    }else{
        if (![[YRYYCache share].yyCache objectForKey:NSStringFromClass([self class])]) {
            [self.dataSource removeAllObjects];
            [self.tableView reloadData];
            [_tableView.header beginRefreshing];
        }
    }
}

//登录成功
- (void)loginSuccessDelegate:(UserModel*)userModel{
    [_tableView.header beginRefreshing];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftNavButtonWithImage:[UIImage imageNamed:@""]];
    self.commentIndex = maxInteger;
    self.navigationItem.title = @"随手晒";
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [rightBtn setImage:[UIImage imageNamed:@"yr_show_edit"] forState:UIControlStateNormal];
    [rightBtn setTitle:@" 发布" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    rightBtn.titleLabel.textColor = [UIColor whiteColor];
    [rightBtn addTarget:self action:@selector(compileAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem     *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;

    
    self.sunTextFirstView = [[[NSBundle mainBundle] loadNibNamed:@"YRSunTextFirstView" owner:nil options:nil]lastObject];
    
    self.sunTextFirstView.frame = self.view.frame;
    [self.sunTextFirstView.addFriendBtn addTarget:self action:@selector(addFriendBtnClick) forControlEvents:UIControlEventTouchUpInside];

    [self setupTableView];
}

-(void)setupTableView{

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.decelerationRate = 1.0f;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    [self.view addSubview:_tableView];
    [self.view addSubview:self.commentView];
    
    [_tableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [_tableView jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];

    [_tableView.header beginRefreshing];

}

- (void)headRefresh{
    self.start = 0;
    [self fectData];
}

- (void)footRefresh{
    
    self.start += kListPageSize;
    [self fectData];
}

- (void)fectData{
    
    NSMutableArray *dataArr = [NSMutableArray array].mutableCopy;
    
    @weakify(self);
    [YRHttpRequest getFriendsCircleListFeedsByCustLimit:kListPageSize Page:self.start success:^(NSArray *dataArray) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        DLog(@"晒一晒数据：%@",dataArray);

        @strongify(self);
        for (NSInteger i = 0; i < dataArray.count; i ++) {
            StatusModel* statusModel = [StatusModel modelWithJSON:dataArray[i]];
            LWLayout* layout = [self layoutWithStatusModel:statusModel index:i];
            [dataArr addObject:layout];
        }
            
        if (self.start == 0) {
            [self.dataSource removeAllObjects];
            [[YRYYCache share].yyCache removeObjectForKey:NSStringFromClass([self class])];
            [[YRYYCache share].yyCache setObject:dataArray forKey:NSStringFromClass([self class])];
        }
        [self.dataSource addObjectsFromArray:dataArr];
        

        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            
            if (self.dataSource.count == 0) {
                [self.view addSubview:self.sunTextFirstView];
            }else{
                [self.sunTextFirstView removeFromSuperview];
            }
            [self.tableView.header endRefreshing];
            
            if ([dataArray count] ==  0) {
                [self.tableView.footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.footer endRefreshing];
            }
            [self.tableView reloadData];
        });
    });

    } failure:^(NSString *errorInfo) {
//        dispatch_async(dispatch_get_main_queue(), ^{
        
//            [self.view addSubview:self.sunTextFirstView];
     
            [self.tableView.header endRefreshing];
//            [self.tableView reloadData];
//        });
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
 *  @author ZX, 16-07-28 11:07:00
 *
 *  编辑
 */
- (void)compileAction{
    
    if ([YRUserInfoManager manager].currentUser.custId) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSArray *titles = @[@"文字",@"小视频",@"拍照",@"从手机相册选取"];
        [self addActionTarget:alert titles:titles];
        [self addCancelActionTarget:alert title:@"取消"];
        
        // 会更改UIAlertController中所有字体的内容（此方法有个缺点，会修改所以字体的样式）
        UILabel *appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
        UIFont *font         = [UIFont systemFontOfSize:15];
        appearanceLabel.font = font;
        
        [self presentViewController:alert animated:YES completion:nil];
    }else{

        [self setLogin];
        return;
    }

}

- (void)setLogin{
    
    @weakify(self);
    YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"请登录进行后续操作" cancelButtonText:@"再逛逛" confirmButtonText:@"登录"];
    alertView.addCancelAction = ^{
    };
    alertView.addConfirmAction = ^{
        @strongify(self);
        YRLoginController *loginVc = [[YRLoginController alloc] init];
        loginVc.loginSuccessDelegate = self;
        [self.navigationController pushViewController:loginVc animated:YES];
    };
    
    [alertView show];
    
}
#pragma mark - Actions
/***  点赞 ***/
- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedLikeButtonWithIsLike:(NSInteger)isLike atIndexPath:(NSIndexPath *)indexPath {
    [self.commentView endEditing:YES];

    @weakify(self);
    /* 由于是异步绘制，而且为了减少View的层级，整个显示内容都是在同一个UIView上面，所以会在刷新的时候闪一下，这里可以先把原先Cell的内容截图覆盖在Cell上，
     延迟0.25s后待刷新完成后，再将这个截图从Cell上移除 */
    UIImage* screenshot = [GallopUtils screenshotFromView:cell];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:[self.tableView convertRect:cell.frame toView:self.tableView]];
    imgView.image = screenshot;
    [self.tableView addSubview:imgView];
    
    
    SunTextCellLayout* layout = [self.dataSource objectAtIndexCheck:indexPath.row];
    if (isLike == 0) {
        NSMutableArray* newLikeList = [[NSMutableArray alloc] initWithArray:layout.statusModel.likes];
        
        NSDictionary *dic = @{  @"lid": @(123),
                                @"custId": [YRUserInfoManager manager].currentUser.custId?[YRUserInfoManager manager].currentUser.custId:@"",
                                @"custNname": [YRUserInfoManager manager].currentUser.custNname?[YRUserInfoManager manager].currentUser.custNname:@"",
                                @"custImg": @""
                                };
        
        [newLikeList insertObject:dic atIndex:0];
        StatusModel* statusModel = layout.statusModel;
        statusModel.likes = newLikeList;
        statusModel.isLike = 1;
        NSInteger likeCount = statusModel.likeCount + 1;
        statusModel.likeCount = likeCount;
        layout = [self layoutWithStatusModel:statusModel index:indexPath.row];
        [self.dataSource replaceObjectAtIndex:indexPath.row withObject:layout];
        
        int sid = [statusModel.sid intValue];
        
        [YRHttpRequest getFriendsCircleLikeByCustSid:sid Action:1 success:^(NSDictionary *data) {
//            DLog(@"点赞：%@",data);
        } failure:^(NSString *errorInfo) {
            
        }];
        
          dispatch_async(dispatch_get_main_queue(), ^{
              @strongify(self);
              [imgView removeFromSuperview];
            
              [self.tableView reloadData];

          });
    } else {
        
        NSMutableArray *newLikeList = [[NSMutableArray alloc] initWithArray:layout.statusModel.likes];
        NSMutableArray *likeList = newLikeList.mutableCopy;
        
        [likeList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *dic = obj;
            if ([dic[@"custId"] isEqualToString: [YRUserInfoManager manager].currentUser.custId]) {
                [likeList removeObjectAtIndex:idx];
            }
        }];
        
        if (likeList.count != newLikeList.count) {
            DLog(@"点赞列表：%@",newLikeList);
            StatusModel* statusModel = layout.statusModel;
            statusModel.likes = likeList;
            statusModel.isLike = 0;
            NSInteger likeCount = statusModel.likeCount - 1;
            statusModel.likeCount = likeCount;
            layout = [self layoutWithStatusModel:statusModel index:indexPath.row];
            
            [self.dataSource replaceObjectAtIndex:indexPath.row withObject:layout];
            int sid = [statusModel.sid intValue];
            
            [YRHttpRequest getFriendsCircleLikeByCustSid:sid Action:0 success:^(NSDictionary *data) {
                DLog(@"点赞：%@",data);
                
            } failure:^(NSString *errorInfo) {
                
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [imgView removeFromSuperview];
            
            [self.tableView reloadData];

        });
    }
}

/***  送礼物 ***/
- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedGiftButtonWithIsGift:(BOOL)isGift atIndexPath:(NSIndexPath *)indexPath {
    [self.commentView endEditing:YES];
 
    /* 由于是异步绘制，而且为了减少View的层级，整个显示内容都是在同一个UIView上面，所以会在刷新的时候闪一下，这里可以先把原先Cell的内容截图覆盖在Cell上，
     延迟0.25s后待刷新完成后，再将这个截图从Cell上移除 */
    //    UIImage* screenshot = [GallopUtils screenshotFromView:cell];
    //    UIImageView* imgView = [[UIImageView alloc] initWithFrame:[self.tableView convertRect:cell.frame toView:self.tableView]];
    //    imgView.image = screenshot;
    //    [self.tableView addSubview:imgView];
    
    SunTextCellLayout* layout = [self.dataSource objectAtIndexCheck:indexPath.row];
    //    if (isGift) {
    
//    NSMutableArray* newGiftList = [[NSMutableArray alloc] initWithArray:layout.statusModel.giftList];
//    
//    NSDictionary *dic = @{  @"lid": @(123),
//                            @"custId": @"1234",
//                            @"custNname": [YRUserInfoManager manager].currentUser.custNname,
//                            @"custImg": @""
//                            };
//    [newGiftList insertObject:dic atIndex:0];
//    
    StatusModel* statusModel = layout.statusModel;
//    statusModel.giftList = newGiftList;
//    statusModel.isGift = YES;

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
                    
                    [YRHttpRequest sendReward:giftModel.giftid touserid:statusModel.custId type:1 infoId:statusModel.sid giftNum:1 password:@"" infoType:0 infoTitle:@"" pid:@"" success:^(id data) {
                    
                        [MBProgressHUD showSuccess:@"打赏成功"];
                        
                    } failure:^(NSString *data) {
                        [MBProgressHUD showError:data];
                    }];
                    return ;
                }
                
                [self sendReward:allMoneyStr giftid:giftModel.giftid touserid:statusModel.custId pid:statusModel.sid];
                
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

/***  点击评论 ***/
- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedCommentWithCellLayout:(SunTextCellLayout *)layout atIndexPath:(NSIndexPath *)indexPath {
    self.commentView.placeholder = @"评论";
    [self.commentView.textView becomeFirstResponder];
    self.postComment.from = [YRUserInfoManager manager].currentUser.custNname;
    self.postComment.to = @"";
    self.postComment.index = indexPath.row;
    self.commentIndex = indexPath.row;
    self.commentId = @"评论";
}

/***  发表评论 ***/
- (void)postCommentWithCommentModel:(CommentModel *)model {
    
    /* 由于是异步绘制，而且为了减少View的层级，整个显示内容都是在同一个UIView上面，所以会在刷新的时候闪一下，这里可以先把原先Cell的内容截图覆盖在Cell上，
     延迟0.25s后待刷新完成后，再将这个截图从Cell上移除 */
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:model.index inSection:0]];
    UIImage* screenshot = [GallopUtils screenshotFromView:cell];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:[self.tableView convertRect:cell.frame toView:self.tableView]];
    imgView.image = screenshot;
    [self.tableView addSubview:imgView];
    
    SunTextCellLayout* layout = [self.dataSource objectAtIndexCheck:model.index];
    NSMutableArray* newCommentLists = [[NSMutableArray alloc] initWithArray:layout.statusModel.comments];
    if (newCommentLists.count >=5) {
        NSDictionary* newComment = @{ @"custId": [YRUserInfoManager manager].currentUser.custId,
                                      @"custName":model.from,
                                      @"authorName":model.to,
                                      @"content":model.content};
        
        [newCommentLists insertObject:newComment atIndex:0];
        [newCommentLists removeLastObject];
    }else{
        NSDictionary* newComment = @{ @"custId": [YRUserInfoManager manager].currentUser.custId,
                                      @"custName":model.from,
                                      @"authorName":model.to,
                                      @"content":model.content};
        
        [newCommentLists insertObject:newComment atIndex:0];
    }

    StatusModel* statusModel = layout.statusModel;
    int sid = [statusModel.sid intValue];
    
    NSString *custId;
    if (self.commentId == nil || [self.commentId isEqualToString:@""]) {
        custId = statusModel.custId;
    }else{
        if ([self.commentId isEqualToString:@"评论"]) {
            custId = nil;
        }else{
            custId = self.commentId;
        }
    }

    statusModel.comments = newCommentLists;
    layout = [self layoutWithStatusModel:statusModel index:model.index];
    [self.dataSource replaceObjectAtIndex:model.index withObject:layout];
    
    
    [YRHttpRequest sendFriendsCircleCommentByCustSid:sid AuthorUid:custId  Content:model.content success:^(NSDictionary *data) {
        
    } failure:^(NSString *errorInfo) {
        
    }];
    
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [imgView removeFromSuperview];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:model.index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    });
}

/***  点击图片 ***/
- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedImageWithCellLayout:(SunTextCellLayout *)layout atIndex:(NSInteger)index {
    [self.commentView endEditing:YES];

    NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:layout.imagePostionArray.count];
    for (NSInteger i = 0; i < layout.imagePostionArray.count; i ++) {
        LWImageBrowserModel* imageModel = [[LWImageBrowserModel alloc] initWithplaceholder:nil
                                                                              thumbnailURL:[NSURL URLWithString:[layout.statusModel.pics objectAtIndexCheck:i][@"url"]]
                                                                                     HDURL:[NSURL URLWithString:[layout.statusModel.pics objectAtIndexCheck:i][@"url"]]
                                                                        imageViewSuperView:cell.contentView
                                                                       positionAtSuperView:CGRectFromString(layout.imagePostionArray[i])
                                                                                     index:index];
        [tmp addObject:imageModel];
    }
    
    LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self
                                                                            imageModels:tmp
                                                                           currentIndex:index];
    imageBrowser.delegate = self;
    imageBrowser.view.backgroundColor = [UIColor grayColor];
    
    [imageBrowser show];
}

- (void)imageBrowserDidFnishDownloadImageToRefreshThumbnialImageIfNeed{
    
    [self.tableView reloadData];
}

/***  点击头像 ***/
- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedHeaderImgWithIndexPath:(NSIndexPath *)indexPath{
    SunTextCellLayout* layout = [self.dataSource objectAtIndexCheck:indexPath.row];

    YRAdListUserInfoController *friendInfoViewController = [[YRAdListUserInfoController alloc]init];
    StatusModel* statusModel = layout.statusModel;

    friendInfoViewController.isFriend = YES;
    friendInfoViewController.custId = statusModel.custId;
    [self.navigationController pushViewController:friendInfoViewController animated:YES];
}

/***  点击链接 ***/
- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedLinkWithData:(id)data atIndexPath:(NSIndexPath *)indexPath{

    self.commentIndex = indexPath.row;
    
    if ([data isKindOfClass:[CommentModel class]]) {
        
        CommentModel* commentModel = (CommentModel *)data;
        
        if ([commentModel.custId isEqualToString: [YRUserInfoManager manager].currentUser.custId]) {
            return;
        }

        self.commentView.placeholder = [NSString stringWithFormat:@"回复%@:",commentModel.to];
        [self.commentView.textView becomeFirstResponder];
        self.postComment.from = [YRUserInfoManager manager].currentUser.custNname;
        self.postComment.to = commentModel.to;
        self.postComment.index = commentModel.index;
        self.commentId = commentModel.custId;
        
    } else {
        if ([data isKindOfClass:[NSString class]]) {
            
        }
    }
}

/** 视频播放**/
- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedPlayVideoButtonWithIndexPath:(NSIndexPath *)indexPath{
    [self.commentView endEditing:YES];

    SunTextCellLayout* layout = [self.dataSource objectAtIndexCheck:indexPath.row];
    StatusModel* statusModel = layout.statusModel;
    
    YRShowVideoView *videoView = [[YRShowVideoView alloc] initWithFrame:self.view.frame IsRequest:YES WithPathOrUrl:statusModel.videoUrl];
    [videoView show];
}

/** 删除动态**/
- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedDeleteButtonWithIndexPath:(NSIndexPath *)indexPath{
    [self.commentView endEditing:YES];

    @weakify(self);
    YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"确定删除当前动态" cancelButtonText:@"取消" confirmButtonText:@"确定"];
    alertView.addCancelAction = ^{
        
    };
    alertView.addConfirmAction = ^{
        @strongify(self);
        
        SunTextCellLayout* layout = [self.dataSource objectAtIndexCheck:indexPath.row];
        StatusModel* statusModel = layout.statusModel;
        int sid = [statusModel.sid intValue];
        
        [YRHttpRequest deleteFriendsCircleDetailByCustSid:sid success:^(NSDictionary *data) {
            
            @strongify(self);
            [self.dataSource removeObjectAtIndex:indexPath.row];
            if (self.dataSource.count == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    @strongify(self);
                    [self.view addSubview: self.sunTextFirstView];
                });
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                [self.tableView reloadData];
            });
            
        } failure:^(NSString *errorInfo) {
        }];
    };
    
    [alertView show];
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

/**
 *  @author ZX, 16-08-13 11:08:35
 *
 *  查看更多
 *
 */
- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedLookMoreCommentButtonWithIndexPath:(NSIndexPath *)indexPath{
    
    SunTextCellLayout* layout = [self.dataSource objectAtIndexCheck:indexPath.row];
    StatusModel* statusModel = layout.statusModel;
    YRSunTextDetailViewController *detailVc = [[YRSunTextDetailViewController alloc] init];
    detailVc.delegate = self;
    detailVc.sid = [statusModel.sid intValue];
    detailVc.seleteIndex = indexPath;

    [self.navigationController pushViewController:detailVc animated:YES];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text;

    
    if ([YRUserInfoManager manager].currentUser.custId) {
        text = @"正在刷新，请稍后！";

    }else{
        text = @"您尚未登录，赶紧去登录吧！";

    }
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"cellIdentifier";
    SunTextTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SunTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    SunTextCellLayout* cellLayout = [self.dataSource objectAtIndexCheck:indexPath.row];
    cell.cellLayout = cellLayout;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SunTextCellLayout* layout = [self.dataSource objectAtIndexCheck:indexPath.row];
    return layout.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.commentView.textView endEditing:YES];
    
    SunTextCellLayout* layout = [self.dataSource objectAtIndexCheck:indexPath.row];
    StatusModel* statusModel = layout.statusModel;
    
    YRSunTextDetailViewController *detailVc = [[YRSunTextDetailViewController alloc] init];
    detailVc.delegate = self;
    detailVc.sid = [statusModel.sid intValue];
    detailVc.seleteIndex = indexPath;
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)deleteSunTextWithIndexPath:(NSIndexPath *)index{
    @weakify(self);
    [self.dataSource removeObjectAtIndex:index.row];
    if (self.dataSource.count == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            
//            YRSunTextFirstView *sunTextFirstView = [[[NSBundle mainBundle] loadNibNamed:@"YRSunTextFirstView" owner:nil options:nil]lastObject];
//            sunTextFirstView.frame = self.view.frame;
            //            [weakSelf.view addSubview:sunTextFirstView];
//            self.view = sunTextFirstView;
            
            [self.view addSubview:self.sunTextFirstView];
        });
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self.tableView reloadData];
    });


}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.commentView endEditing:YES];
}

/**
 *  在这里生成LWAsyncDisplayView的模型。
 */

- (SunTextCellLayout *)layoutWithStatusModel:(StatusModel *)statusModel index:(NSInteger)index {
    //生成Layout
    
    
    SunTextCellLayout* layout = [[SunTextCellLayout alloc] initWithStatusModel:statusModel index:index dateFormatter:self.dateFormatter];
    
    
    return layout;
}

- (UIImage *)_screenshotFromView:(UIView *)aView {
    
    UIGraphicsBeginImageContextWithOptions(aView.bounds.size,NO,[UIScreen mainScreen].scale);
    
    [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage* screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return screenshotImage;
}

#pragma mark - Getter
- (ZXLayoutTextView *)commentView {
    if (_commentView) {
        return _commentView;
    }
    __weak typeof(self) wself = self;
    _commentView = [[ZXLayoutTextView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 60.0f)];
    [_commentView setSendBlock:^(YRReportTextView *textView) {
        
        __strong  typeof(wself) swself = wself;
        swself.postComment.content = textView.text;
        [swself postCommentWithCommentModel:swself.postComment];
        swself.commentView.textView.text = @"";
        
    }];
    return _commentView;
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日 hh:mm"];
    });
    return dateFormatter;
}
- (CommentModel *)postComment {
    if (_postComment) {
        return _postComment;
    }
    _postComment = [[CommentModel alloc] init];
    return _postComment;
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
    
    if (SYSTEMVERSION>=8.4) {
        [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
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

- (void)addFriendBtnClick{
    RRZAddressAddFriendController  *addVc = [[RRZAddressAddFriendController alloc] init];
    [self.navigationController pushViewController:addVc animated:YES];
}

/**发布文字*/
- (void)sendText{
    

    YRPublishTextViewController *publishVc = [[YRPublishTextViewController alloc] init];
    BaseNavigationController *navigation = [[BaseNavigationController alloc] initWithRootViewController:publishVc];
    publishVc.isText = YES;
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
    [self presentViewController:navigation animated:YES completion:^{
        [self canRecord];
        [self isRearCameraAvailable];
    }];
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
        [self presentViewController:picker animated:YES completion:^{
            [self isRearCameraAvailable];

        }];//进入照相界面
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

// 后面的摄像头是否可用
- (BOOL) isRearCameraAvailable{
    
    __block BOOL bCanRecord = NO;
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        bCanRecord = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:@"无法拍摄"
                                        message:@"悠然一指需要访问您的相机。\n请启用相机-设置/隐私/相机"
                                       delegate:nil
                              cancelButtonTitle:@"关闭"
                              otherButtonTitles:nil] show];
        });
        
    }else{
        bCanRecord = YES;
    }
    return bCanRecord;
}
-(BOOL)canRecord
{
    __block BOOL bCanRecord = NO;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                bCanRecord = YES;
            }
            else {
                
                bCanRecord = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:@"无法录音"
                                                message:@"悠然一指需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"
                                               delegate:nil
                                      cancelButtonTitle:@"关闭"
                                      otherButtonTitles:nil] show];
                });
            }
        }];
    }
    return bCanRecord;
}

//- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
//    
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}

#pragma mark - 发布晒一晒回调方法
//发布视频
- (void)getPublishVideoShowSunTextWithDic:(NSDictionary *)dic{
    DLog(@"晒一晒数据：%@",dic);

    if (self.dataSource.count == 0) {
        [_tableView.header beginRefreshing];
    }else{
        StatusModel* statusModel = [StatusModel modelWithJSON:dic];
        LWLayout* layout = [self layoutWithStatusModel:statusModel index:0];
        [self.dataSource insertObject:layout atIndex:0];
    }
    [self.tableView reloadData];
}

//发布图文
- (void)getYRPublishTextShowSunTextWithDic:(NSDictionary *)dic{
    
    
    DLog(@"晒一晒数据：%@",dic);
    if (self.dataSource.count == 0) {
        [self.sunTextFirstView removeFromSuperview];
        [self.tableView reloadData];

        [self headRefresh];
    }else{
        StatusModel* statusModel = [StatusModel modelWithJSON:dic];
        LWLayout* layout = [self layoutWithStatusModel:statusModel index:0];
        [self.dataSource insertObject:layout atIndex:0];
        
    }
    [self.tableView reloadData];
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

@end
