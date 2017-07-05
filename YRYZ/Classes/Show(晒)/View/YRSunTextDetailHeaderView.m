//
//  YRSunTextDetailHeaderView.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/20.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSunTextDetailHeaderView.h"
#import "YRSunTextDetailHeaderModel.h"
#import "UIImageView+WebCache.h"
#import "SunTextLikeButton.h"
#import "YRTapImageView.h"

@interface YRSunTextDetailHeaderView()<YRTapImageViewDelegate>

@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *dataLab;
@property (nonatomic,strong) UITextView *contextView;
@property (nonatomic,strong) UIImageView *photoImg;
@property (nonatomic,strong) UILabel *deleteLab;

@property (nonatomic,strong) UIView* menuView;
@property (nonatomic,strong) UIButton *zanBtn;
@property (nonatomic,strong) UIButton *commentBtn;
@property (nonatomic,strong) UIButton *giftBtn;
@property (nonatomic,strong) CALayer *layerOne;
@property (nonatomic,strong) CALayer *layerTwo;
@property (nonatomic,strong) NSMutableArray *imageRectArr;

@end

@implementation YRSunTextDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    self.backgroundColor = [UIColor whiteColor];
        [self setUp];
    }
    return self;
}

/**
 *  @author ZX, 16-07-20 17:07:19
 *
 *  布局
 */
- (void)setUp{
  
    UIImageView *iconImg = [UIImageView new];
    iconImg.frame = CGRectMake(10, 20, 40, 40);
    iconImg.backgroundColor = RGB_COLOR(245, 245, 245);
    iconImg.layer.cornerRadius = 5.f;
    iconImg.clipsToBounds = YES;
    [self addSubview:iconImg];
    
    UILabel *nameLab = [UILabel new];
    nameLab.font = [UIFont systemFontOfSize:17.f];
    nameLab.textColor = [UIColor themeColor];
    nameLab.frame = CGRectMake(60.0f, 20.0f, SCREEN_WIDTH - 80.0f, 20);
    [self addSubview:nameLab];
    
    UILabel *dataLab = [UILabel new];
    dataLab.font = [UIFont systemFontOfSize:13.f];
    dataLab.textColor = [UIColor grayColor];
    dataLab.frame = CGRectMake(60, CGRectGetMaxY(nameLab.frame) + 2.0f, SCREEN_WIDTH - 80.0f, 15);
    [self addSubview:dataLab];
    
    
    UITextView *contextView = [UITextView new];
    contextView.font = [UIFont systemFontOfSize:17.f];
    contextView.textColor = RGB_COLOR(40, 40, 40);
//    contextView.backgroundColor = [UIColor redColor];
    contextView.editable = NO;
    contextView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
    contextView.scrollEnabled = NO;//禁止滚动，让文字完全显现出来
    contextView.frame = CGRectMake(10, CGRectGetMaxY(iconImg.frame)+15, SCREEN_WIDTH-20, 0);
    [self addSubview:contextView];
    
    UILabel *deleteLab = [UILabel new];
    deleteLab.text = @"删除";
    deleteLab.textColor = [UIColor grayColor];
    deleteLab.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:deleteLab];
    deleteLab.userInteractionEnabled = YES;
    [deleteLab addTapGesturesTarget:self selector:@selector(deleteAction)];
    
    
    self.deleteLab = deleteLab;
    self.iconImg = iconImg;
    self.nameLab = nameLab;
    self.dataLab = dataLab;
    self.contextView = contextView;
    
    
    
    _menuView = [[UIView alloc] init];
    _menuView.layer.cornerRadius = 5.f;
    _menuView.backgroundColor = RGBA_COLOR(245, 245, 245, 1);
    _menuView.layer.borderColor = RGBA_COLOR(232, 232, 232, 1).CGColor;
    _menuView.layer.borderWidth = 0.5f;
    
    SunTextLikeButton *zanBtn = [SunTextLikeButton buttonWithType:UIButtonTypeCustom];
    [zanBtn setImage:[UIImage imageNamed:@"yr_show_bluelike"] forState:UIControlStateNormal];
    [_menuView addSubview:zanBtn];
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setImage:[UIImage imageNamed:@"yr_show_bluecomment"] forState:UIControlStateNormal];
    [_menuView addSubview:commentBtn];
    SunTextLikeButton *giftBtn = [SunTextLikeButton buttonWithType:UIButtonTypeCustom];
    [giftBtn setImage:[UIImage imageNamed:@"yr_show_bluegift"] forState:UIControlStateNormal];
    [_menuView addSubview:giftBtn];
    
    
    [zanBtn addTarget:self action:@selector(didclickedLikeAction:) forControlEvents:UIControlEventTouchUpInside];
    [commentBtn addTarget:self action:@selector(didClickedCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [giftBtn addTarget:self action:@selector(didClickedGiftAction:) forControlEvents:UIControlEventTouchUpInside];
    
    zanBtn.frame = CGRectMake(5, -5, 55, 30);
    giftBtn.frame = CGRectMake(70, -5, 55, 30);
    commentBtn.frame = CGRectMake(135, -5, 55, 30);
    
    CALayer *layerOne = [CALayer layer];
    layerOne.backgroundColor = RGBA_COLOR(232, 232, 232, 1).CGColor;
    [_menuView.layer addSublayer:layerOne];
    
    CALayer *layerTwo = [CALayer layer];
    layerTwo.backgroundColor = RGBA_COLOR(232, 232, 232, 1).CGColor;
    [_menuView.layer addSublayer:layerTwo];

    layerOne.frame = CGRectMake(65, 0, 0.5, 20);
    layerTwo.frame = CGRectMake(130, 0, 0.5, 20);
    
    [self addSubview:_menuView];

}

- (void)setModel:(YRSunTextDetailHeaderModel *)model{
    _model = model;
    
    [self.iconImg setImageURL:model.custImg];
    self.nameLab.text = model.custName?model.custName:@"昵称";
    NSInteger sendTime = [model.sendTime integerValue];
    self.dataLab.text = [NSString compareCurrentTime:sendTime];
    
    CGFloat contextH;
    
    if ([model.content isEqualToString:@""]) {
        contextH = 0;
    }else{
        contextH = [self heightForString:model.content fontSize:15.f];
    }
    
    self.contextView.frame = CGRectMake(10, CGRectGetMaxY(_iconImg.frame)+10, SCREEN_WIDTH-20, contextH);
    self.contextView.text = model.content;
    
    CGFloat imageWidth = (SCREEN_WIDTH - 50.0f)/3.0f;
    NSInteger imageCount = [model.pics count];
    NSMutableArray* imageStorageArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
    NSMutableArray* imagePositionArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
    NSInteger row = 0;
    NSInteger column = 0;
    
    if ([model.type isEqualToString:@"image"]) {
        if (imageCount == 1) {
            
            NSString* URLString = [model.pics objectAtIndex:0][@"url"];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:URLString]]];
            
            CGRect imageRect;
            
            if (image.size.width>image.size.height) {
                imageRect = CGRectMake(self.iconImg.mj_x,
                                       CGRectGetMaxY(_contextView.frame) + 5.0f + (row * (imageWidth + 5.0f)),
                                       (imageWidth*1.7*image.size.width/image.size.height)>(SCREEN_WIDTH-20)?(SCREEN_WIDTH-20):(imageWidth*1.7*image.size.width/image.size.height),
                                       imageWidth*1.7);
            }else if (image.size.height>image.size.width){
                imageRect = CGRectMake(self.iconImg.mj_x,
                                       CGRectGetMaxY(_contextView.frame) + 5.0f + (row * (imageWidth + 5.0f)),
                                       imageWidth*1.7,
                                       (imageWidth*1.7*image.size.height/image.size.width)>(SCREEN_WIDTH-20)?(SCREEN_WIDTH-20):(imageWidth*1.7*image.size.height/image.size.width));
                
            }else{
                imageRect = CGRectMake(self.iconImg.mj_x,
                                       CGRectGetMaxY(_contextView.frame) + 5.0f + (row * (imageWidth + 5.0f)),
                                       imageWidth*1.7,
                                       imageWidth*1.7);
            }
            

            
            NSString* imagePositionString = NSStringFromCGRect(imageRect);
            [imagePositionArray addObject:imagePositionString];
            YRTapImageView* imageStorage = [[YRTapImageView alloc] init];
            imageStorage.delegate = self;
            imageStorage.tag = 0;
            imageStorage.contentMode = UIViewContentModeScaleAspectFill;
            imageStorage.clipsToBounds = YES;
            imageStorage.frame = imageRect;
            imageStorage.backgroundColor = RGB_COLOR(240, 240, 240);
//            NSString* URLString = [model.imgs objectAtIndex:0];
            [self addSubview:imageStorage];
            [imageStorage setImageURL:[NSURL URLWithString:URLString]];
            [imageStorageArray addObject:imageStorage];
            
            [_picViews addObject:imageStorage];
        } else {
            for (NSInteger i = 0; i < imageCount; i ++) {
                CGRect imageRect = CGRectMake(self.iconImg.mj_x + (column * (imageWidth + 5.0f)),
                                              CGRectGetMaxY(_contextView.frame) + 5.0f + (row * (imageWidth + 5.0f)),
                                              imageWidth,
                                              imageWidth);
                
                NSString* imagePositionString = NSStringFromCGRect(imageRect);
                [imagePositionArray addObject:imagePositionString];
                YRTapImageView* imageStorage = [[YRTapImageView alloc] init];
                imageStorage.delegate = self;
                imageStorage.contentMode = UIViewContentModeScaleAspectFill;
                imageStorage.clipsToBounds = YES;
                imageStorage.tag = i;
                imageStorage.frame = imageRect;
                imageStorage.backgroundColor = RGB_COLOR(240, 240, 240);
                NSString* URLString = [model.pics objectAtIndex:i][@"url"];
                [imageStorage setImageURL:[NSURL URLWithString:URLString]];
                [imageStorageArray addObject:imageStorage];
                [self addSubview:imageStorage];
                [_picViews addObject:imageStorage];
                
                column = column + 1;
                if (column > 2) {
                    column = 0;
                    row = row + 1;
                }
            }
        }
    }else if ([model.type isEqualToString:@"video"]){
        
        UIView *videoView = [[UIView alloc] init];
        videoView.backgroundColor = RGB_COLOR(245, 245, 245);
        videoView.frame = CGRectMake(10, CGRectGetMaxY(_contextView.frame) + 5.0f, SCREEN_WIDTH-20, 200);
        [self addSubview:videoView];
        UIButton *videoPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [videoPlayBtn setImage:[UIImage imageNamed:@"yr_show_video"] forState:UIControlStateNormal];
        videoPlayBtn.frame = CGRectMake((videoView.mj_w - 100)/2, (videoView.mj_h - 70)/2, 100, 70);
        [videoPlayBtn addTarget:self action:@selector(didclickedPlayVideoButton:) forControlEvents:UIControlEventTouchUpInside];
        [videoView addSubview:videoPlayBtn];
    }

    self.imageRectArr = imagePositionArray;
    CGFloat imageViewH = 0.0;
    if ([model.type isEqualToString:@"image"]) {
        
    if (model.pics.count == 0) {
        imageViewH = 0;
    }else if (model.pics.count == 1){
        imageViewH = imageWidth*1.7;
    }else if (model.pics.count <4){
        imageViewH = imageWidth;
    }else if (model.pics.count <7){
        imageViewH = imageWidth*2+5;
    }else{
        imageViewH = imageWidth*3+10;
    }
           
    }else if([model.type isEqualToString:@"video"]){
        imageViewH = 200;

    }
    

    if (contextH<1) {
        _menuView.frame = CGRectMake(SCREEN_WIDTH - 215.0f,CGRectGetMaxY(_iconImg.frame) + 10 + imageViewH+20,195,20);
    }else if(imageViewH == 0){
        _menuView.frame = CGRectMake(SCREEN_WIDTH - 215.0f,contextH+CGRectGetMaxY(_iconImg.frame) + 20 + imageViewH,195,20);
    }else{
        _menuView.frame = CGRectMake(SCREEN_WIDTH - 215.0f,contextH+CGRectGetMaxY(_iconImg.frame) + 20 + imageViewH+10,195,20);
    }
    
    self.deleteLab.frame = CGRectMake(10, _menuView.mj_y, 30, 20);

}

-(float)heightForString:(NSString *)value fontSize:(float)fontSize{
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.height;
}

/**
 *  @author ZX, 16-08-16 11:08:42
 *
 *  点击图片
 *
 *  @param tag <#tag description#>
 */
- (void)didSeleteImageViewWithTag:(NSInteger)tag{
    
    if ([self.delegate respondsToSelector:@selector(headerView:didClickedImageWithCellModel:atIndex: WithArr:)]) {
        [self.delegate headerView:self didClickedImageWithCellModel:self.model atIndex:tag WithArr:self.imageRectArr];
    }
}

/**
 *  @author ZX, 16-08-16 11:08:08
 *
 *  点击视频
 */
- (void)didclickedPlayVideoButton:(UIButton *)sender{

    if ([self.delegate respondsToSelector:@selector(headerView:didClickedVideoWithCellModel:)]) {
        [self.delegate headerView:self didClickedVideoWithCellModel:self.model];
    }
}
/**
 *  @author ZX, 16-07-22 15:07:53
 *
 *  点赞
 *
 */
- (void)didclickedLikeAction:(SunTextLikeButton *)sender{
    __weak typeof(self) weakSelf = self;
        [sender likeButtonAnimationCompletion:^(BOOL isSelectd) {
    if ([weakSelf.delegate respondsToSelector:@selector(headerView:didClickedLikeButtonWithIsLike:)]) {
        [weakSelf.delegate headerView:weakSelf didClickedLikeButtonWithIsLike:self.model.isLike];
       }
    }];
    
}

/**
 *  @author ZX, 16-07-22 15:07:00
 *
 *  评论
 */
- (void)didClickedCommentAction{
    
    if ([self.delegate respondsToSelector:@selector(headerView:didClickedCommentWithCellModel:)]) {
        [self.delegate headerView:self didClickedCommentWithCellModel:self.model];
    }
    
}

/**
 *  @author ZX, 16-07-22 15:07:04
 *
 *  礼物
 *
 */
- (void)didClickedGiftAction:(SunTextLikeButton *)sender{
    __weak typeof(self) weakSelf = self;
    [sender likeButtonAnimationCompletion:^(BOOL isSelectd) {
    if ([weakSelf.delegate respondsToSelector:@selector(headerView:didClickedGiftButtonWithIsGift:)]) {
            [weakSelf.delegate headerView:weakSelf didClickedGiftButtonWithIsGift:self.model.isGift];
        }
    }];
}
/**
 *  @author ZX, 16-08-02 16:08:24
 *
 *  删除
 */
- (void)deleteAction{
    
    if ([self.delegate respondsToSelector:@selector(didClickDeleteSunText)]) {
        [self.delegate didClickDeleteSunText];
    }

}
@end
