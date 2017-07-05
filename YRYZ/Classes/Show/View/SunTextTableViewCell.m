
/********************* 有任何问题欢迎反馈给我 liuweiself@126.com ****************************************/
/***************  https://github.com/waynezxcv/Gallop 持续更新 ***************************/
/******************** 正在不断完善中，谢谢~  Enjoy ******************************************************/


#import "SunTextTableViewCell.h"
#import "GallopUtils.h"
#import "LWImageStorage.h"
#import "SunTextLikeButton.h"
#import "YRAVPlayerView.h"
static NSInteger headerImgTag = 101;

@interface SunTextTableViewCell ()<LWAsyncDisplayViewDelegate>

@property (nonatomic,strong) LWAsyncDisplayView* asyncDisplayView;
@property (nonatomic,strong) UIView*videoView;
@property (nonatomic,strong) UIView* menuView;
//@property (nonatomic,strong) UIView* moreComentView;
@property (nonatomic,strong) UIButton *moreCommentBtn;
@property (nonatomic,strong) UIButton *zanBtn;
@property (nonatomic,strong) UIButton *commentBtn;
@property (nonatomic,strong) UIButton *giftBtn;
@property (nonatomic,strong) UIButton *videoPlayBtn;
@property (nonatomic,strong) UIButton *deleteBtn;

@property (nonatomic,strong) CALayer *layerOne;
@property (nonatomic,strong) CALayer *layerTwo;
@property (nonatomic,strong) UIView* line;
@property (nonatomic,strong) UIView* likeLine;
@property (nonatomic,strong) UIView* giftLine;


@end

@implementation SunTextTableViewCell

#pragma mark - Init

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        [self.contentView addSubview:self.asyncDisplayView];
        [self.contentView addSubview:self.menuView];
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.likeLine];
//        [self.contentView addSubview:self.giftLine];
        [self.contentView addSubview:self.videoPlayBtn];
        [self.contentView addSubview:self.deleteBtn];
        [self.contentView addSubview:self.moreCommentBtn];
        
    }
    return self;
}

#pragma mark - Actions


/***  点击图片  ***/
- (void)lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView
   didCilickedImageStorage:(LWImageStorage *)imageStorage
                     touch:(UITouch *)touch{
//    NSLog(@"tag:%ld",imageStorage.tag);//这里可以通过判断Tag来执行相应的回调。
    CGPoint point = [touch locationInView:self];
    /**点击图片*/
    for (NSInteger i = 0; i < self.cellLayout.imagePostionArray.count; i ++) {
        CGRect imagePosition = CGRectFromString(self.cellLayout.imagePostionArray[i]);
        if (CGRectContainsPoint(imagePosition, point)) {
            if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedImageWithCellLayout:atIndex:)] &&
                [self.delegate conformsToProtocol:@protocol(TableViewCellDelegate)]) {
                [self.delegate tableViewCell:self didClickedImageWithCellLayout:self.cellLayout atIndex:i];
            }
        }
    }
    
    if (imageStorage.tag == headerImgTag) {
        if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedHeaderImgWithIndexPath:)]) {
            [self.delegate tableViewCell:self didClickedHeaderImgWithIndexPath:self.indexPath];
        }
    }
}

/***  点击文本链接 ***/
- (void)lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView didCilickedTextStorage:(LWTextStorage *)textStorage linkdata:(id)data {
//    NSLog(@"tag:%ld",textStorage.tag);//这里可以通过判断Tag来执行相应的回调。
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedLinkWithData: atIndexPath:)] &&
        [self.delegate conformsToProtocol:@protocol(TableViewCellDelegate)]) {
        
        [self.delegate tableViewCell:self didClickedLinkWithData:data atIndexPath:self.indexPath];
    }
}


/***  点击评论 ***/
- (void)didClickedCommentButton {
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedCommentWithCellLayout:atIndexPath:)]) {
        [self.delegate tableViewCell:self didClickedCommentWithCellLayout:self.cellLayout atIndexPath:self.indexPath];
    }
}

//** 点赞 **//
- (void)didclickedLikeButton:(SunTextLikeButton *)likeButton {
        
    __weak typeof(self) weakSelf = self;
    [likeButton likeButtonAnimationCompletion:^(BOOL isSelectd) {
        if ([weakSelf.delegate respondsToSelector:@selector(tableViewCell:didClickedLikeButtonWithIsLike:atIndexPath:)]) {
            [weakSelf.delegate tableViewCell:weakSelf didClickedLikeButtonWithIsLike:weakSelf.cellLayout.statusModel.isLike atIndexPath:weakSelf.indexPath];
        }
    }];
    
}
//** 礼物 **//
- (void)didClickedGiftButton:(SunTextLikeButton *)likeButton {
    __weak typeof(self) weakSelf = self;
    [likeButton likeButtonAnimationCompletion:^(BOOL isSelectd) {
        if ([weakSelf.delegate respondsToSelector:@selector(tableViewCell:didClickedGiftButtonWithIsGift:atIndexPath:)]) {
            [weakSelf.delegate tableViewCell:weakSelf didClickedGiftButtonWithIsGift:!weakSelf.cellLayout.statusModel.isGift atIndexPath:weakSelf.indexPath];
        }
    }];
}

/**
 *  @author ZX, 16-08-10 16:08:49
 *
 *  视频播放
 */
- (void)didclickedPlayyVideoButton:(UIButton *)videoButton{
    
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedPlayVideoButtonWithIndexPath:)]) {
        [self.delegate tableViewCell:self didClickedPlayVideoButtonWithIndexPath:self.indexPath];
    }
}
/**
 *  @author ZX, 16-08-12 17:08:14
 *
 *  删除
 *
 *  @param deleteButton <#deleteButton description#>
 */
- (void)didclickeDeleteButton:(UIButton *)deleteButton{

    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedDeleteButtonWithIndexPath:)]) {
        [self.delegate tableViewCell:self didClickedDeleteButtonWithIndexPath:self.indexPath];
    }
}

/**
 *  @author ZX, 16-08-13 11:08:16
 *
 *  查看更多
 *
 */
- (void)moreCommentAction:(UIButton *)moreCommentAction{
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedLookMoreCommentButtonWithIndexPath:)]) {
        [self.delegate tableViewCell:self didClickedLookMoreCommentButtonWithIndexPath:self.indexPath];
    }
}
#pragma mark - Draw and setup

- (void)setCellLayout:(SunTextCellLayout *)cellLayout {
    if (_cellLayout == cellLayout) {
        return;
    }
    _cellLayout = cellLayout;
    self.asyncDisplayView.layout = self.cellLayout;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.asyncDisplayView.frame = CGRectMake(0,0,SCREEN_WIDTH,self.cellLayout.cellHeight);
    self.menuView.frame = self.cellLayout.menuPosition;
    
//    self.videoView.frame = self.cellLayout.videoRect;
    self.videoPlayBtn.frame = self.cellLayout.videoBtnRect;
    self.deleteBtn.frame = self.cellLayout.deleteBtnRect;

    self.giftBtn.frame = CGRectMake(5, 0, self.menuView.frame.size.width/3-10, 35);
//    self.zanBtn.frame = CGRectMake(5, -5, self.menuView.frame.size.width/2-10, 30);
    self.zanBtn.frame = CGRectMake(self.menuView.frame.size.width/3+5, 0, self.menuView.frame.size.width/3-10, 35);
    self.commentBtn.frame = CGRectMake(self.menuView.frame.size.width/3*2+5, 0, self.menuView.frame.size.width/3-10, 35);
    self.giftBtn.imageEdgeInsets = UIEdgeInsetsMake(5,5,5,5);//设置
    
    self.moreCommentBtn.frame = self.cellLayout.moreCommentRect;
    
    self.layerOne.frame = CGRectMake(self.menuView.frame.size.width/3, 0, 0.5, 35);
    self.layerTwo.frame = CGRectMake(self.menuView.frame.size.width/3*2, 0, 0.5, 35);
    
    self.line.frame = self.cellLayout.lineRect;
    self.likeLine.frame = self.cellLayout.lineLikeRect;
    self.giftLine.frame = self.cellLayout.lineGiftRect;
 
    if (_cellLayout.statusModel.isLike == 0) {
        self.zanBtn.selected = NO;
    }else if (_cellLayout.statusModel.isLike == 1){
        self.zanBtn.selected = YES;
    }
 
    if ([_cellLayout.statusModel.custId isEqualToString: [YRUserInfoManager manager].currentUser.custId]) {
        self.deleteBtn.hidden = NO;
    }else{
        self.deleteBtn.hidden = YES;
    }
    
}

- (void)extraAsyncDisplayIncontext:(CGContextRef)context size:(CGSize)size isCancelled:(LWAsyncDisplayIsCanclledBlock)isCancelled {
    if (!isCancelled()) {
        //绘制分割线
        CGContextMoveToPoint(context, 0.0f, self.bounds.size.height);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
        CGContextSetLineWidth(context, 0.2f);
        CGContextSetStrokeColorWithColor(context,RGB(220.0f, 220.0f, 220.0f, 1).CGColor);
        CGContextStrokePath(context);

        if ([self.cellLayout.statusModel.type isEqualToString:@"website"]) {
            CGContextAddRect(context, self.cellLayout.websiteRect);
            CGContextSetFillColorWithColor(context, RGB(240, 240, 240, 1).CGColor);
            CGContextFillPath(context);
        }
    }
}

#pragma mark - Getter

- (LWAsyncDisplayView *)asyncDisplayView {
    if (!_asyncDisplayView) {
        _asyncDisplayView = [[LWAsyncDisplayView alloc] initWithFrame:CGRectZero];
        _asyncDisplayView.delegate = self;
    }
    return _asyncDisplayView;
}

//- (UIView *)videoView{
//    if (_videoView) {
//        return _videoView;
//    }
//    
//    _videoView = [[UIView alloc] init];
//    _videoView.backgroundColor = RGB_COLOR(245, 245, 245);
//    _videoView.userInteractionEnabled = NO;
//    return _videoView;
//}

- (UIButton *)videoPlayBtn{
    if (_videoPlayBtn) {
        return _videoPlayBtn;
    }
    _videoPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_videoPlayBtn setImage:[UIImage imageNamed:@"yr_show_video"] forState:UIControlStateNormal];
    [_videoPlayBtn addTarget:self action:@selector(didclickedPlayyVideoButton:) forControlEvents:UIControlEventTouchUpInside];

    return _videoPlayBtn;
}

- (UIButton *)deleteBtn{
    if (_deleteBtn) {
        return _deleteBtn;
    }
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    _deleteBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_deleteBtn setTitleColor:RGB_COLOR(102, 102, 102) forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_deleteBtn addTarget:self action:@selector(didclickeDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return _deleteBtn;
}
- (UIButton *)moreCommentBtn{
    if (_moreCommentBtn) {
        return _moreCommentBtn;
    }
    _moreCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreCommentBtn.backgroundColor = RGB_COLOR(237, 237, 237);
    _moreCommentBtn.layer.cornerRadius = 2.0f;
    [_moreCommentBtn setTitle:@"查看更多评论" forState:UIControlStateNormal];
    [_moreCommentBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    _moreCommentBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_moreCommentBtn addTarget:self action:@selector(moreCommentAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return _moreCommentBtn;
}

- (UIView *)menuView {
    if (_menuView) {
        return _menuView;
    }
    _menuView = [[UIView alloc] init];
    _menuView.layer.cornerRadius = 5.f;
    _menuView.backgroundColor = RGB(245, 245, 245, 1);
    _menuView.layer.borderColor = RGB(232, 232, 232, 1).CGColor;
    _menuView.layer.borderWidth = 0.5f;

    
    SunTextLikeButton *zanBtn = [SunTextLikeButton buttonWithType:UIButtonTypeCustom];
    [zanBtn setImage:[UIImage imageNamed:@"yr_show_bluelike"] forState:UIControlStateNormal];
    [zanBtn setImage:[UIImage imageNamed:@"yr_sunText_like"] forState:UIControlStateSelected];
   
    [_menuView addSubview:zanBtn];
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setImage:[UIImage imageNamed:@"yr_show_bluecomment"] forState:UIControlStateNormal];
    [_menuView addSubview:commentBtn];
    SunTextLikeButton *giftBtn = [SunTextLikeButton buttonWithType:UIButtonTypeCustom];
    [giftBtn setImage:[UIImage imageNamed:@"yr_show_bluegift"] forState:UIControlStateNormal];
    [_menuView addSubview:giftBtn];
    
    [zanBtn addTarget:self action:@selector(didclickedLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    [commentBtn addTarget:self action:@selector(didClickedCommentButton) forControlEvents:UIControlEventTouchUpInside];
    [giftBtn addTarget:self action:@selector(didClickedGiftButton:) forControlEvents:UIControlEventTouchUpInside];
    self.zanBtn = zanBtn;
    self.commentBtn = commentBtn;
    self.giftBtn = giftBtn;
    
    CALayer *layerOne = [CALayer layer];
    layerOne.backgroundColor = RGB(232, 232, 232, 1).CGColor;
    [_menuView.layer addSublayer:layerOne];
    
    CALayer *layerTwo = [CALayer layer];
    layerTwo.backgroundColor = RGB(232, 232, 232, 1).CGColor;
    [_menuView.layer addSublayer:layerTwo];
    
    self.layerOne = layerOne;
    self.layerTwo = layerTwo;
    
    return _menuView;
}

- (UIView *)line {
    if (_line) {
        return _line;
    }
    _line = [[UIView alloc] initWithFrame:CGRectZero];
    _line.backgroundColor = RGB(220.0f, 220.0f, 220.0f, 1);
    return _line;
}
- (UIView *)likeLine {
    if (_likeLine) {
        return _likeLine;
    }
    _likeLine = [[UIView alloc] initWithFrame:CGRectZero];
    _likeLine.backgroundColor = RGB(232.0f, 232.0f, 232.0f, 1);
    return _likeLine;
}
- (UIView *)giftLine {
    if (_giftLine) {
        return _giftLine;
    }
    _giftLine = [[UIView alloc] initWithFrame:CGRectZero];
    _giftLine.backgroundColor = RGB(232.0f, 232.0f, 232.0f, 1);
    return _giftLine;
}


@end
