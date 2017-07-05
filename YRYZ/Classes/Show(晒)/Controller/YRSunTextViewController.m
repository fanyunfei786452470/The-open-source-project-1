
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
#import "LWLoadingView.h"
#import "LWImageBrowserModel.h"
#import "LWImageBrowser.h"
#import "YRPublishTextViewController.h"
#import "RewardGiftView.h"
#import "YRShowVideoView.h"
#import "YRPublishVideoViewController.h"
#import "YRSunTextFirstView.h"
#import <ALBBSDK/ALBBSDK.h>
#import <ALBBQuPai/ALBBQuPaiService.h>
#import <ALBBQuPai/QPEffectMusic.h>
#import "NSArray+YRInfo.h"
#import "YRHttpRequest.h"

@interface YRSunTextViewController () <UITableViewDataSource,UITableViewDelegate,TableViewCellDelegate,UIActionSheetDelegate>
{
    BOOL _down;
}

@property (nonatomic,strong) SunTextCommentView  *commentView;
@property (nonatomic,strong) UITableView         *tableView;
@property (nonatomic,strong) NSMutableArray      *dataSource;
@property (nonatomic,assign,getter = isNeedRefresh) BOOL needRefresh;
@property (nonatomic,strong) CommentModel       *postComment;
@property (nonatomic,strong) NSArray            *imgArr;
@property (nonatomic,strong) RewardGiftView     *rewardGiftView;

@property (nonatomic,strong) UIActionSheet *actionSheet;

@property (nonatomic,assign) NSInteger commentIndex;

@end

@implementation YRSunTextViewController

#pragma mark - ViewControllerLifeCycle

- (UIActionSheet *)actionSheet
{
    if(_actionSheet == nil)
    {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取",@"拍照", nil];
    }
    
    return _actionSheet;
}
- (void)loadView {
    [super loadView];

    [self setup];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentIndex = 99999;
    self.navigationItem.title = @"晒一晒";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"yr_show_edit"] style:UIBarButtonItemStylePlain target:self action:@selector(compileAction)];
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(tapView:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];


}
/**
 *  @author ZX, 16-07-28 11:07:00
 *
 *  编辑
 */
- (void)compileAction{
    
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSArray *titles = @[@"文字",@"小视频",@"拍照",@"从手机相册选取"];
        [self addActionTarget:alert titles:titles];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidAppearNotifications:)
                                                 name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHidenNotifications:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [LWLoadingView hideInViwe:self.view];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if (self.isNeedRefresh) {
//        [LWLoadingView showInView:self.view backgroundColor:RGB(245, 245, 245, 1)];
        [self refreshBegin];
//    }
}

- (void)setup {
    self.needRefresh = YES;
}

#pragma mark - Actions
/***  点赞 ***/
- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedLikeButtonWithIsLike:(BOOL)isLike atIndexPath:(NSIndexPath *)indexPath {

    /* 由于是异步绘制，而且为了减少View的层级，整个显示内容都是在同一个UIView上面，所以会在刷新的时候闪一下，这里可以先把原先Cell的内容截图覆盖在Cell上，
     延迟0.25s后待刷新完成后，再将这个截图从Cell上移除 */
    UIImage* screenshot = [GallopUtils screenshotFromView:cell];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:[self.tableView convertRect:cell.frame toView:self.tableView]];
    imgView.image = screenshot;
    [self.tableView addSubview:imgView];

    SunTextCellLayout* layout = [self.dataSource objectAtIndexCheck:indexPath.row];
    if (isLike) {
        NSMutableArray* newLikeList = [[NSMutableArray alloc] initWithArray:layout.statusModel.likes];
        
        NSDictionary *dic = @{  @"lid": @(123),
                                @"custId": @"1234",
                                @"custNname": @"zZ",
                                @"custImg": @""
                              };
        [newLikeList insertObject:dic atIndex:0];
        StatusModel* statusModel = layout.statusModel;
        statusModel.likes = newLikeList;
        statusModel.isLike = YES;
        layout = [self layoutWithStatusModel:statusModel index:indexPath.row];
        [self.dataSource replaceObjectAtIndex:indexPath.row withObject:layout];
        
        int sid = [statusModel.sid intValue];

        [YRHttpRequest getFriendsCircleLikeByCustSid:sid Action:1 success:^(NSDictionary *data) {
            DLog(@"点赞：%@",data);
        } failure:^(NSString *errorInfo) {
            
        }];

    } else {
        NSMutableArray* newLikeList = [[NSMutableArray alloc] initWithArray:layout.statusModel.likes];
        [newLikeList removeObjectAtIndex:0];
        StatusModel* statusModel = layout.statusModel;
        statusModel.likes = newLikeList;
        statusModel.isLike = NO;
        layout = [self layoutWithStatusModel:statusModel index:indexPath.row];
        [self.dataSource replaceObjectAtIndex:indexPath.row withObject:layout];
        int sid = [statusModel.sid intValue];
        
        [YRHttpRequest getFriendsCircleLikeByCustSid:sid Action:0 success:^(NSDictionary *data) {
            DLog(@"点赞：%@",data);
        } failure:^(NSString *errorInfo) {
            
        }];
    }
    
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [imgView removeFromSuperview];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]withRowAnimation:UITableViewRowAnimationAutomatic];
    });

}

/***  送礼物 ***/
- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedGiftButtonWithIsGift:(BOOL)isGift atIndexPath:(NSIndexPath *)indexPath {
    
    /* 由于是异步绘制，而且为了减少View的层级，整个显示内容都是在同一个UIView上面，所以会在刷新的时候闪一下，这里可以先把原先Cell的内容截图覆盖在Cell上，
     延迟0.25s后待刷新完成后，再将这个截图从Cell上移除 */
//    UIImage* screenshot = [GallopUtils screenshotFromView:cell];
//    UIImageView* imgView = [[UIImageView alloc] initWithFrame:[self.tableView convertRect:cell.frame toView:self.tableView]];
//    imgView.image = screenshot;
//    [self.tableView addSubview:imgView];
//    
//
//    
//    
//    SunTextCellLayout* layout = [self.dataSource objectAtIndexCheck:indexPath.row];
//    if (isGift) {
//        NSMutableArray* newLikeList = [[NSMutableArray alloc] initWithArray:layout.statusModel.giftList];
//        [newLikeList insertObject:@"waynezxcv的粉丝" atIndex:0];
//        //        [newLikeList addObject:@"waynezxcv的粉丝"];
//        StatusModel* statusModel = layout.statusModel;
//        statusModel.giftList = newLikeList;
//        statusModel.isGift = YES;
//        layout = [self layoutWithStatusModel:statusModel index:indexPath.row];
//        [self.dataSource replaceObjectAtIndex:indexPath.row withObject:layout];
//    [self.rewardGiftView showGiftView];
        
        RewardGiftView *rewardGiftView = [[RewardGiftView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT, self.rewardGiftView.frame.size.width, self.rewardGiftView.frame.size.height)];
        [rewardGiftView showGiftView];
//        
//    } else {
//        NSMutableArray* newLikeList = [[NSMutableArray alloc] initWithArray:layout.statusModel.giftList];
//        [newLikeList removeObject:@"waynezxcv的粉丝"];
//        StatusModel* statusModel = layout.statusModel;
//        statusModel.giftList = newLikeList;
//        statusModel.isGift = NO;
//        layout = [self layoutWithStatusModel:statusModel index:indexPath.row];
//        [self.dataSource replaceObjectAtIndex:indexPath.row withObject:layout];
//     
//    }
//
//    @weakify(self);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        @strongify(self);
//        [imgView removeFromSuperview];
//        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]withRowAnimation:UITableViewRowAnimationAutomatic];
//    });

}


/***  点击评论 ***/
- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedCommentWithCellLayout:(SunTextCellLayout *)layout
          atIndexPath:(NSIndexPath *)indexPath {
    self.commentView.placeHolder = @"评论";
    [self.commentView.textView becomeFirstResponder];
    self.postComment.from = @"🐲";
    self.postComment.to = @"";
    self.postComment.index = indexPath.row;
    self.commentIndex = indexPath.row;
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
    NSDictionary* newComment = @{@"userName":model.from,
                                 @"authorName":model.to,
                                 @"content":model.content};
    [newCommentLists addObject:newComment];
    StatusModel* statusModel = layout.statusModel;
    statusModel.comments = newCommentLists;
    layout = [self layoutWithStatusModel:statusModel index:model.index];
    [self.dataSource replaceObjectAtIndex:model.index withObject:layout];
    
    int sid = [statusModel.sid intValue];
    
    [YRHttpRequest sendFriendsCircleCommentByCustSid:sid AuthorUid:statusModel.custId  Content:model.content success:^(NSDictionary *data) {
    
        DLog(@"晒一晒评论：%@",data);
    } failure:^(NSString *errorInfo) {
    
    }];
    
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [imgView removeFromSuperview];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:model.index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    });

}

/***  点击图片 ***/
- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedImageWithCellLayout:(SunTextCellLayout *)layout atIndex:(NSInteger)index {
    
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
    imageBrowser.view.backgroundColor = [UIColor grayColor];
    [imageBrowser show];

}

/***  点击链接 ***/
- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedLinkWithData:(id)data atIndexPath:(NSIndexPath *)indexPath{
    
    self.commentIndex = indexPath.row;
    
    if ([data isKindOfClass:[CommentModel class]]) {
        
        CommentModel* commentModel = (CommentModel *)data;
        self.commentView.placeHolder = [NSString stringWithFormat:@"回复%@:",commentModel.to];
        [self.commentView.textView becomeFirstResponder];
        self.postComment.from = @"🐲";
        self.postComment.to = commentModel.to;
        self.postComment.index = commentModel.index;
        
    } else {
        if ([data isKindOfClass:[NSString class]]) {
            
        }
    }
}

/** 视频播放**/
- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedPlayVideoButtonWithIndexPath:(NSIndexPath *)indexPath{

    YRShowVideoView *videoView = [[YRShowVideoView alloc] initWithFrame:self.view.frame IsRequest:YES WithPathOrUrl:nil];
    [videoView show];
}

/**
 *  @author ZX, 16-08-13 11:08:15
 *
 *  删除动态
 *
 */
- (void)tableViewCell:(SunTextTableViewCell *)cell didClickedDeleteButtonWithIndexPath:(NSIndexPath *)indexPath{
    
    @weakify(self);
    YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"确定删除当前动态" cancelButtonText:@"取消" confirmButtonText:@"确定"];
    alertView.addCancelAction = ^{
        
    };
    alertView.addConfirmAction = ^{
        
    SunTextCellLayout* layout = [self.dataSource objectAtIndexCheck:indexPath.row];
    StatusModel* statusModel = layout.statusModel;
    int sid = [statusModel.sid intValue];
        
    [YRHttpRequest deleteFriendsCircleDetailByCustSid:sid success:^(NSDictionary *data) {
        
        @strongify(self);
        [self.dataSource removeObjectAtIndex:indexPath.row];
        if (self.dataSource.count == 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                
                YRSunTextFirstView *sunTextFirstView = [[[NSBundle mainBundle] loadNibNamed:@"YRSunTextFirstView" owner:nil options:nil]lastObject];
                sunTextFirstView.frame = self.view.frame;
                //            [weakSelf.view addSubview:sunTextFirstView];
                self.view = sunTextFirstView;
            });
    
        }
      
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.tableView reloadData];
        });

    } failure:^(NSString *errorInfo) {
    }];

    };
    
    [alertView show];
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
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setValue:statusModel.type forKey:@"type"];
        [dic setValue:statusModel.custId forKey:@"custId"];
        [dic setValue:statusModel.sid forKey:@"sid"];
        [dic setValue:statusModel.custImg forKey:@"custImg"];
        [dic setValue:statusModel.content forKey:@"content"];
        [dic setValue:statusModel.timeStamp forKey:@"sendTime"];
        [dic setValue:statusModel.custName forKey:@"custName"];
        [dic setValue:statusModel.pics forKey:@"pics"];
        [dic setValue:statusModel.comments forKey:@"comments"];
        [dic setValue:statusModel.likes forKey:@"likes"];
        [dic setValue:statusModel.giftList forKey:@"giftList"];
        
        detailVc.dic = dic;
    
        [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - KeyboardNotifications

- (void)tapView:(id)sender {
    
    [self.commentView endEditing:YES];
}

- (void)keyboardDidAppearNotifications:(NSNotification *)notifications {
    NSDictionary *userInfo = [notifications userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat keyboardHeight = keyboardSize.height;
    
    DLog(@"keyboardHeight: %f",keyboardHeight);
    self.commentView.frame = CGRectMake(0.0f, SCREEN_HEIGHT - 54.0f - keyboardHeight, SCREEN_WIDTH, 54.0f);
}

- (void)keyboardDidHidenNotifications:(NSNotification *)notifications {
    self.commentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 54.0f);
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
        SunTextCellLayout* layout = [self.dataSource objectAtIndexCheck:indexPath.row];
        StatusModel* statusModel = layout.statusModel;
        
        YRSunTextDetailViewController *detailVc = [[YRSunTextDetailViewController alloc] init];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setValue:statusModel.type forKey:@"type"];
        [dic setValue:statusModel.custId forKey:@"custId"];
        [dic setValue:statusModel.sid forKey:@"sid"];
        [dic setValue:statusModel.custImg forKey:@"custImg"];
        [dic setValue:statusModel.content forKey:@"content"];
        [dic setValue:statusModel.timeStamp forKey:@"sendTime"];
        [dic setValue:statusModel.custName forKey:@"custName"];
        [dic setValue:statusModel.pics forKey:@"pics"];
        [dic setValue:statusModel.comments forKey:@"comments"];
        [dic setValue:statusModel.likes forKey:@"likes"];
        [dic setValue:statusModel.giftList forKey:@"giftList"];
        
        detailVc.dic = dic;
        
        [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.commentView endEditing:YES];
}

- (void)refreshBegin {
    __weak typeof(self) weakSelf = self;
    
    [self.dataSource removeAllObjects];
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    
    @weakify(self);
    [YRHttpRequest getFriendsCircleListFeedsByCustLimit:10 Page:1 success:^(NSDictionary *data) {
        @strongify(self);
        NSLog(@"晒一晒列表：%@",data);
        [dataArr addObjectsFromArray:(NSArray*)data];
        
        for (NSInteger i = 0; i < dataArr.count; i ++) {
            StatusModel* statusModel = [StatusModel modelWithJSON:dataArr[i]];
            LWLayout* layout = [weakSelf layoutWithStatusModel:statusModel index:i];
            [weakSelf.dataSource addObject:layout];
        }
        
        [_tableView reloadData];
        [LWLoadingView hideInViwe:weakSelf.view];
        
        
        if (weakSelf.dataSource.count == 0) {
            YRSunTextFirstView *sunTextFirstView = [[[NSBundle mainBundle] loadNibNamed:@"YRSunTextFirstView" owner:nil options:nil]lastObject];
            sunTextFirstView.frame = weakSelf.view.frame;
            weakSelf.view = sunTextFirstView;
        }else{
            [weakSelf.view addSubview:weakSelf.tableView];
            
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
            
            [weakSelf.view addSubview:weakSelf.commentView];
            
        }
        
    } failure:^(NSString *errorInfo) {
        [LWLoadingView hideInViwe:weakSelf.view];
        
    }];
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
- (SunTextCommentView *)commentView {
    if (_commentView) {
        return _commentView;
    }
    __weak typeof(self) wself = self;
    _commentView = [[SunTextCommentView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 54.0f)
                                            sendBlock:^(NSString *content) {
                                                __strong  typeof(wself) swself = wself;
                                                swself.postComment.content = content;
                                                [swself postCommentWithCommentModel:swself.postComment];
                                            }];
    
//    _commentView = [[YRInputView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50.f)];
//    self.postComment.content = content;
//    [self postCommentWithCommentModel:self.postComment];
    
    return _commentView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.decelerationRate = 1.0f;
    }
    return _tableView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray array] mutableCopy];
    }
    return _dataSource;
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
    for (NSString *title in titles) {
        
        if ([title isEqualToString:@"文字"]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            YRPublishTextViewController *publishVc = [[YRPublishTextViewController alloc] init];
            BaseNavigationController *navigation = [[BaseNavigationController alloc] initWithRootViewController:publishVc];
            [self presentViewController:navigation animated:YES completion:nil];
                
            }];
            [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
            [alertController addAction:action];
        }
        
        if ([title isEqualToString:@"小视频"]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                if (SYSTEMVERSION>9.0) {
                    
                    [self movieAction];
                    
                }else{
                    [MBProgressHUD showError:@"当前系统版本不支持视频拍摄"];
                }
            }];
            [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
            [alertController addAction:action];
            

        }
        
        if ([title isEqualToString:@"拍照"]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                
            }];
            [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
            [alertController addAction:action];
            

        }
        if ([title isEqualToString:@"从手机相册选取"]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                
            }];
            [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
            [alertController addAction:action];
            

        }
     
        
    }
}
// 取消按钮
- (void)addCancelActionTarget:(UIAlertController *)alertController title:(NSString *)title{
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        
    }];
    
    [action setValue:[UIColor wordColor] forKey:@"_titleTextColor"];
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
    UIViewController *recordController = [sdk createRecordViewControllerWithMinDuration:5 maxDuration:60 bitRate:500000];
    BaseNavigationController *navigation = [[BaseNavigationController alloc] initWithRootViewController:recordController];
    [self presentViewController:navigation animated:YES completion:nil];
    
}
- (void)qupaiSDK:(id<ALBBQuPaiService>)sdk compeleteVideoPath:(NSString *)videoPath thumbnailPath:(NSString *)thumbnailPath{
    
    [self dismissViewControllerAnimated:YES completion:nil];

    if (videoPath) {
        UISaveVideoAtPathToSavedPhotosAlbum(videoPath, nil, nil, nil);
        YRPublishVideoViewController *publishVc = [[YRPublishVideoViewController alloc] init];
        publishVc.videoPath = videoPath;
        publishVc.thumbnailPath = thumbnailPath;
        BaseNavigationController *navigation = [[BaseNavigationController alloc] initWithRootViewController:publishVc];
        [self presentViewController:navigation animated:YES completion:nil];
    }
    if (thumbnailPath) {
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithContentsOfFile:thumbnailPath], nil, nil, nil);
    }
}


@end
