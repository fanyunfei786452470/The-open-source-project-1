//
//  YRSunTextDetailViewController.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/20.
//  Copyright © 2016年 yryz. All rights reserved.

#import "YRSunTextDetailViewController.h"
#import "YRSunTextDetailHeaderView.h"
#import "YRSunTextDetailHeaderModel.h"
#import "YRSunTextDetailLikeCell.h"
#import "YRSunTextDetailGiftCell.h"
#import "YRSunTextDetailCell.h"
#import "YRSunTextDetailCommentCell.h"
#import "YRCommentListModel.h"
#import "RewardGiftView.h"
#import "YRInputView.h"
#import "SunTextCommentView.h"
#import "LWImageBrowserModel.h"
#import "LWImageBrowser.h"
#import "YRShowVideoView.h"
#import "YRMyShareView.h"
#import "YRLikeListModel.h"
#import "YRLikeListHeightModel.h"
#import "YRGiftListHeightModel.h"
#import "YRComementModel.h"


static NSString *yrSunTextDetailcommentCellIdentifier = @"yrSunTextDetailcommentCellIdentifier";
static NSString *yrSunTextDetaillikeCellIdentifier = @"yrSunTextDetaillikeCellIdentifier";
static NSString *yrSunTextDetailgiftCellIdentifier = @"yrSunTextDetailgiftCellIdentifier";

@interface YRSunTextDetailViewController ()<UITableViewDelegate,UITableViewDataSource,YRSunTextDetailHeaderViewDelegate,YRInputViewDelegate,UIActionSheetDelegate,YRSunTextDetailCommentCellDelegate>
@property (nonatomic,strong) UITableView    *tb_View;

@property (nonatomic,strong) YRInputView    *InputView;

@property (nonatomic,strong) RewardGiftView *rewardGiftView;

@property (nonatomic,strong) UIActionSheet  *actionSheet;

@property (nonatomic,strong) YRMyShareView  *shareView;

@property (nonatomic,strong) NSMutableArray *commentListArr;

@property (nonatomic,strong) NSMutableArray *likesListArr;

@property (nonatomic,strong) YRLikeListHeightModel *likeListHModel;

@property (nonatomic,strong) YRGiftListHeightModel *giftListModel;

@property (nonatomic,strong) YRSunTextDetailHeaderModel *headerViewModel;

@property (nonatomic,strong) YRComementModel *commentModel;

@end

@implementation YRSunTextDetailViewController


- (void)viewWillAppear:(BOOL)animated{
  
    [super viewWillAppear:animated];
    
    int sid = [self.dic[@"sid"] intValue];
    @weakify(self);

    [YRHttpRequest getFriendsCircleLikeListByCustSid:sid Lid:0 Limit:10 success:^(id data) {
        @strongify(self);

        DLog(@"点赞列表：%@",data);
        
        NSDictionary *dic = @{@"likeListArr" : data};
        
        self.likeListHModel = [YRLikeListHeightModel mj_objectWithKeyValues:dic];
        self.giftListModel = [YRGiftListHeightModel mj_objectWithKeyValues:dic];

        self.likesListArr = [YRLikeListModel mj_keyValuesArrayWithObjectArray:(NSArray *)data];

        [self.tb_View reloadData];
        
    } failure:^(NSString *errorInfo) {
        
    }];
}

- (YRComementModel *)commentModel{
    if (!_commentModel) {
        _commentModel = [[YRComementModel alloc] init];
    }
    return _commentModel;
}

- (NSMutableArray *)commentListArr{
    if (!_commentListArr) {
        
        _commentListArr = [NSMutableArray array];
    }
    return _commentListArr;
}

- (NSMutableArray *)likesListArr{
    if (!_likesListArr) {
        
        _likesListArr = [NSMutableArray array];
    }
    return _likesListArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看正文";

    [self initShareView];
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
    
    self.headerViewModel = [YRSunTextDetailHeaderModel mj_objectWithKeyValues:self.dic];
    
    YRSunTextDetailHeaderView *headerView = [[YRSunTextDetailHeaderView alloc] init];
    headerView.delegate = self;
    headerView.model = self.headerViewModel;
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.headerViewModel.headerViewH);
    table.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    footerView.backgroundColor = [UIColor whiteColor];
    table.tableFooterView = footerView;
    
    
    [table registerClass:[YRSunTextDetailCommentCell class] forCellReuseIdentifier:yrSunTextDetailcommentCellIdentifier];
    [table registerClass:[YRSunTextDetailLikeCell class] forCellReuseIdentifier:yrSunTextDetaillikeCellIdentifier];
    [table registerClass:[YRSunTextDetailGiftCell class] forCellReuseIdentifier:yrSunTextDetailgiftCellIdentifier];
    
    YRInputView *inputView = [[YRInputView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50-64, SCREEN_WIDTH, 50)];
    inputView.backgroundColor = [UIColor whiteColor];
    inputView.delegate = self;
    [self.view addSubview:inputView];
    self.InputView = inputView;

}

- (void)textViewChangeHeightWithText:(NSString *)text Return:(BOOL)isReturn{
    
    CGFloat height = [self widthForString:text fontSize:16];
    
    if (isReturn) {
        
        NSDate* data = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval time=[data timeIntervalSince1970]*1000;
        NSString *timeString = [NSString stringWithFormat:@"%f", time];


        int sid = [self.dic[@"sid"] intValue];
        @weakify(self);
        
        [YRHttpRequest sendFriendsCircleCommentByCustSid:sid AuthorUid:self.dic[@"custId"]  Content:text success:^(NSDictionary *data) {
            @strongify(self);
            YRCommentListModel *model = [[YRCommentListModel alloc]init];
            model.userName = @"🐲";
            model.content = text;
            model.authorName = self.commentModel.toName;
            model.timeStamp = timeString;
            
            [self.commentListArr insertObject:model atIndex:0];
            
            [self.tb_View reloadData];
            
            self.commentModel.toName = nil;
            self.commentModel.toId = nil;
            DLog(@"晒一晒评论：%@",data);
        } failure:^(NSString *errorInfo) {
            
            [MBProgressHUD showError:@"评论失败！"];
        }];

      self.InputView.frame = CGRectMake(0, SCREEN_HEIGHT-50-64, SCREEN_WIDTH, 50);
 
    }else{
        
      self.InputView.frame = CGRectMake(0, SCREEN_HEIGHT-64-31-height, SCREEN_WIDTH, 31+height);
    }
}

/**
 *  @author ZX, 16-07-28 11:07:06
 *
 *  更多按钮
 */
- (void)rightNavAction:(UIButton*)button{
    
    [self.shareView  show];
}

- (void)initShareView{
    
    self.shareView  = [[YRMyShareView alloc]init];
    self.shareView.delegate = self;
    self.shareView .chooseShareCell = ^(NSInteger tag,NSString *name){
        NSLog(@"你点击了第%ld个cell  点击的是%@",tag,name);
    };
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
        
        return likeCell;
        
    }else if (indexPath.row == 1){
        
        YRSunTextDetailGiftCell *giftCell = [tableView dequeueReusableCellWithIdentifier:yrSunTextDetailgiftCellIdentifier forIndexPath:indexPath];
        giftCell.selectionStyle = UITableViewCellSelectionStyleNone;
        giftCell.giftListArr = self.giftListModel.giftListArr;
        giftCell.model = self.giftListModel;
        
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

        self.commentModel.toName = model.userName;
        self.commentModel.toId = model.userId;
        
        [self.InputView.textView becomeFirstResponder];
    }
}
- (void)didClickLongPressGestureRecognizerCellWithIndexPath:(NSIndexPath *)indexPath{
    
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSArray *titles = @[@"删除评论"];
        [self addActionTarget:alert titles:titles indexPath:indexPath];
        [self addCancelActionTarget:alert title:@"取消"];
        
        // 会更改UIAlertController中所有字体的内容（此方法有个缺点，会修改所以字体的样式）
        UILabel *appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
        UIFont *font = [UIFont systemFontOfSize:15];
        appearanceLabel.font = font;
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        
        [self.actionSheet showInView:self.view];
    }
}
#pragma mark - YRSunTextDetailHeaderViewDelegate
//查看图片
- (void)headerView:(YRSunTextDetailHeaderView *)view didClickedImageWithCellModel:(YRSunTextDetailHeaderModel *)model atIndex:(NSInteger)index WithArr:(NSMutableArray *)positionArr{
    
    NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:model.pics.count];
    for (NSInteger i = 0; i < model.pics.count; i ++) {
        LWImageBrowserModel* imageModel = [[LWImageBrowserModel alloc] initWithplaceholder:nil
                thumbnailURL:[NSURL URLWithString:[model.pics objectAtIndex:i][@"url"]] HDURL:[NSURL URLWithString:[model.pics objectAtIndex:i][@"url"]] imageViewSuperView:view positionAtSuperView:CGRectFromString(positionArr[i]) index:index];
        [tmp addObject:imageModel];
    }
    LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self
                                                                            imageModels:tmp
                                                                           currentIndex:index];
    imageBrowser.view.backgroundColor = [UIColor grayColor];
    [imageBrowser show];

}
- (void)headerView:(YRSunTextDetailHeaderView *)view didClickedVideoWithCellModel:(YRSunTextDetailHeaderModel *)model{
    
    YRShowVideoView *videoView = [[YRShowVideoView alloc] initWithFrame:self.view.frame IsRequest:YES WithPathOrUrl:nil];
    [videoView show];
}
//点赞
- (void)headerView:(YRSunTextDetailHeaderView *)view didClickedLikeButtonWithIsLike:(BOOL)isLike{

    NSMutableArray *likeArr = [NSMutableArray array];
    [likeArr addObjectsFromArray:self.likeListHModel.likeListArr];
    
    if (isLike) {
        
        [likeArr removeObjectAtIndex:0];

        self.likeListHModel.likeListArr = likeArr;
        
        self.headerViewModel.isLike = NO;
        
        int sid = [self.dic[@"sid"] intValue];

        [YRHttpRequest getFriendsCircleLikeByCustSid:sid Action:1 success:^(NSDictionary *data) {
            DLog(@"点赞：%@",data);
        } failure:^(NSString *errorInfo) {
            
        }];
        
    }else{
        
        NSDictionary *dic = @{
                              @"lid": @(123),
                              @"custId": @"1234",
                              @"custName": @"test",
                              @"custImg": @""
                              };
        

        [likeArr insertObject:dic atIndex:0];
        
        self.likeListHModel.likeListArr = likeArr;
        
        self.headerViewModel.isLike = YES;
        
        int sid = [self.dic[@"sid"] intValue];

        [YRHttpRequest getFriendsCircleLikeByCustSid:sid Action:0 success:^(NSDictionary *data) {
            DLog(@"点赞：%@",data);
        } failure:^(NSString *errorInfo) {
            
        }];
    }

    [self.tb_View reloadData];
}
//礼物
- (void)headerView:(YRSunTextDetailHeaderView *)view didClickedGiftButtonWithIsGift:(BOOL)isGift{
    
//    [self.rewardGiftView showGiftView];
    
    NSMutableArray *likeArr = [NSMutableArray array];
    [likeArr addObjectsFromArray:self.giftListModel.giftListArr];

    NSDictionary *dic = @{
                              @"lid": @(123),
                              @"custId": @"1234",
                              @"custName": @"test",
                              @"custImg": @""
                              };
        
        
    [likeArr insertObject:dic atIndex:0];
        
    self.giftListModel.giftListArr = likeArr;

    [self.tb_View reloadData];
}
//评论
- (void)headerView:(YRSunTextDetailHeaderView *)view didClickedCommentWithCellModel:(YRSunTextDetailHeaderModel *)model{
    self.commentModel.toName = @"";
    self.commentModel.toId = @"";
    [self.InputView.textView becomeFirstResponder];
}
//删除
- (void)didClickDeleteSunText{
    
    
    @weakify(self);
    YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"确定删除当前动态" cancelButtonText:@"取消" confirmButtonText:@"确定"];
    
    alertView.addCancelAction = ^{
        
    };
    alertView.addConfirmAction = ^{
        int sid = [self.dic[@"sid"] intValue];

        [YRHttpRequest deleteFriendsCircleDetailByCustSid:sid success:^(NSDictionary *data) {
            
            @strongify(self);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } failure:^(NSString *errorInfo) {
        }];
    };
    [alertView show];
   
}

-(float)widthForString:(NSString *)value fontSize:(float)fontSize{
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-18, 100) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.height;
}
// 添加删除评论按钮
- (void)addActionTarget:(UIAlertController *)alertController titles:(NSArray *)titles indexPath:(NSIndexPath *)indexPath{
    for (NSString *title in titles) {

        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            YRCommentListModel *model = self.commentListArr[indexPath.row-2];
            int sid = [model.sid intValue];
            int cid = [model.cid intValue];
            
            [YRHttpRequest deleteFriendsCircleCommentByCustSid:sid Cid:cid success:^(NSDictionary *data) {

                DLog(@"删除评论：%@",data);
                [self.commentListArr removeObjectAtIndex:indexPath.row-2];
                [self.tb_View reloadData];
                
            } failure:^(NSString *eCorrorInfo) {
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
    
    int sid = [self.dic[@"sid"] intValue];
    @weakify(self);
    [YRHttpRequest getFriendsCircleCommentListByCustSid:sid Limit:10 Cid:0 success:^(id data) {
        DLog(@"晒一晒评论列表：%@",data);
        @strongify(self);
        
        self.commentListArr = [YRCommentListModel mj_objectArrayWithKeyValuesArray:data];
        
        [self.tb_View reloadData];
        
    } failure:^(NSString *eCorrorInfo) {
        
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
