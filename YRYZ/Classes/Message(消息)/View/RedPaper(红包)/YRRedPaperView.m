//
//  YRRedPaperView.m
//  YRYZ
//
//  Created by Rongzhong on 16/7/5.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedPaperView.h"

static YRRedPaperView *redPaperView = nil;

@interface YRRedPaperView()

@property (strong, nonatomic) UIImageView  *topBgView;
@property (strong, nonatomic) UIImageView  *bottomBgView;
@property (strong, nonatomic) UIView *shadeView;

@end

@implementation YRRedPaperView
{
    UIImageView  *_redPaperBgView;
    UILabel      *_nameLabel;
    
    BOOL isFollow;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0,  SCREEN_WIDTH , SCREEN_HEIGHT);
    self.frame = frame;
    if (self = [super initWithFrame:frame]) {
        isFollow = NO;
        [self setupView];
    }
    return self;
}

+ (YRRedPaperView *)sharedredPaperView
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        redPaperView = [[YRRedPaperView alloc]initWithFrame:CGRectMake(0, 0,  SCREEN_WIDTH , SCREEN_HEIGHT)];
        UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
        [window addSubview:redPaperView];
    });
    return redPaperView;
}

+(void)showRedPaperViewWithName:(NSString*)name OpenBlock:(void(^)())openblock
{
    [YRRedPaperView sharedredPaperView].openBlock = openblock;
    [[YRRedPaperView sharedredPaperView] showRedPaperView];
}

-(void)setupView
{
    _shadeView = [[UIView alloc]init];
    _shadeView.frame = self.bounds;
    _shadeView.backgroundColor = [UIColor colorWithR:0 g:0 b:0 a:0.6];
    [self addSubview:_shadeView];
    

    _redPaperBgView = [[UIImageView alloc]init];
    _redPaperBgView.userInteractionEnabled = YES;
    _redPaperBgView.center = CGPointMake(SCREEN_WIDTH/2.0f, SCREEN_HEIGHT/2.0f);
    _redPaperBgView.bounds = YRRectMake(0 , 0 ,288, 353.5);
    UIImage *image = [self createRedPaperImage];
    _redPaperBgView.image = image;
    [self addSubview:_redPaperBgView];

    UIButton *cancelButton =[UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = YRRectMake(249, 0, 39, 39);
    [cancelButton addTarget:self action:@selector(hideRedPaperView) forControlEvents:UIControlEventTouchUpInside];
    [_redPaperBgView addSubview:cancelButton];
    
    UIButton *openButton =[UIButton buttonWithType:UIButtonTypeCustom];
    openButton.frame = YRRectMake(95, 68, 98, 96.5);
    [openButton addTarget:self action:@selector(openAction) forControlEvents:UIControlEventTouchUpInside];
    [_redPaperBgView addSubview:openButton];
    

    UIButton *followButton =[UIButton buttonWithType:UIButtonTypeCustom];
    followButton.frame = YRRectMake(81.5, 273, 44, 44);
    [followButton addTarget:self action:@selector(followAction) forControlEvents:UIControlEventTouchUpInside];
    [_redPaperBgView addSubview:followButton];
    
    _topBgView = [[UIImageView alloc]init];
    _topBgView.center = CGPointMake(SCREEN_WIDTH/2.0f, SCREEN_HEIGHT/2.0f - 140 * SCREEN_WIDTH / 320.0f);
    _topBgView.bounds = CGRectMake(0 , 0 , 277 * SCREEN_WIDTH /320.0f, 194);
    _topBgView.image = [UIImage imageNamed:@"redPaperHeadImage"];
    _topBgView.hidden = YES;
    [self addSubview:_topBgView];
    
    _bottomBgView = [[UIImageView alloc]init];
    _bottomBgView.center = CGPointMake(SCREEN_WIDTH/2.0f, SCREEN_HEIGHT/2.0f + 0 * SCREEN_WIDTH / 320.0f);
    _bottomBgView.bounds = YRRectMake(0 , 0 ,277, 286);
    _bottomBgView.image = [UIImage imageNamed:@"redPaperBodyImage"];
    _bottomBgView.hidden = YES;
    [self addSubview:_bottomBgView];
}

-(UIImage *)createRedPaperImage
{
    CGSize size= CGSizeMake (_redPaperBgView.size.width ,_redPaperBgView.size.height); // 画布大小
    UIGraphicsBeginImageContextWithOptions (size, NO , 0.0 );
    
    UIImage *redPaperBgImage = [UIImage imageNamed:@"redPaperBgImage"];
    [redPaperBgImage drawInRect:YRRectMake(0, 0, 288, 353.5)];
    
    UIImage *cancelButtonImage = [UIImage imageNamed:@"cancelButtonImage" ];
    [cancelButtonImage drawInRect:YRRectMake(259, 15, 14, 14)];
    
    
    UIImage *animationImage = [UIImage imageNamed:@"redPaperMoneyImage" ];
    [animationImage drawInRect:YRRectMake(95, 68, 98, 96.5)];
    
    
    CGContextRef context= UIGraphicsGetCurrentContext ();
    CGContextDrawPath (context, kCGPathStroke );
    
    //段落格式
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;//水平居中
    //字体
    UIFont  *font = [UIFont boldSystemFontOfSize:24.0];
    //构建属性集合
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:textStyle, NSForegroundColorAttributeName:[UIColor colorWithR:255 g:224 b:158 a:1]};

    NSString* nameText = @"魏世波";
    CGRect nameTextRect = YRRectMake(0, 192, 288, 28);;
    [nameText drawInRect:nameTextRect withAttributes:attributes];
    
    
    NSDictionary *attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:20], NSParagraphStyleAttributeName:textStyle, NSForegroundColorAttributeName:RGB_COLOR(149, 10, 0)};
    NSString* titleText = @"给你发了一个红包";
    CGRect titleTextRect = YRRectMake(0, 229.5, 288, 24);
    [titleText drawInRect:titleTextRect withAttributes:attributes2];

    //构建属性集合
    NSDictionary *attributes3 = @{NSFontAttributeName:[UIFont systemFontOfSize:18], NSParagraphStyleAttributeName:textStyle, NSForegroundColorAttributeName:RGB_COLOR(149, 10, 0)};
    NSString* messageText = @"关注转发者";
    CGRect messageTextRect = YRRectMake(112, 286, 91, 18);
    [messageText drawInRect:messageTextRect withAttributes:attributes3];
    
    UIImage *selectBoxImage;
    if (isFollow) {
        selectBoxImage = [UIImage imageNamed:@"selectedImage"];
    }
    else
    {
        selectBoxImage = [UIImage imageNamed:@"unSelectedImage"];
    }
    [selectBoxImage drawInRect:YRRectMake(95, 286.5, 17, 17)];

    
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext ();
    
    return newImage;
}

-(void)openAction
{
    _redPaperBgView.hidden = YES;
    _topBgView.hidden = NO;
    _bottomBgView.hidden = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = RGB_COLOR(255, 255, 255);
        _shadeView.alpha = 1;
        _topBgView.center = CGPointMake(SCREEN_WIDTH/2.0f,_topBgView.bounds.size.height / 2.0f);
        _bottomBgView.center = CGPointMake(SCREEN_WIDTH/2.0f,SCREEN_HEIGHT - _bottomBgView.bounds.size.height / 2.0f);
        _bottomBgView.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            _shadeView.alpha = 0;
            _topBgView.bounds = CGRectMake(0 , 0 ,SCREEN_WIDTH, 194);
        } completion:^(BOOL finished) {
            _topBgView.bounds = CGRectMake(0 , 0 , 277 * SCREEN_WIDTH /320.0f, 194);
            _topBgView.center = CGPointMake(SCREEN_WIDTH/2.0f, SCREEN_HEIGHT/2.0f - 140 * SCREEN_WIDTH / 320.0f);
            _bottomBgView.center = CGPointMake(SCREEN_WIDTH/2.0f, SCREEN_HEIGHT/2.0f + 0 * SCREEN_WIDTH / 320.0f);
            self.backgroundColor = [UIColor clearColor];
            self.alpha = 1;
            _redPaperBgView.hidden = NO;
            _topBgView.hidden = YES;
            _bottomBgView.alpha = 1;
            _bottomBgView.hidden = YES;
            _shadeView.alpha = 0.6;
            
            self.hidden = YES;
        }];
    }];
    if (_openBlock) {
        _openBlock();
    }
}

-(void)followAction
{
    if (isFollow) {
        isFollow = NO;
    }
    else
    {
        isFollow = YES;
    }
    _redPaperBgView.image = [self createRedPaperImage];
}

-(void)hideRedPaperView
{
    [UIView animateWithDuration:0.5 animations:^{
        _redPaperBgView.bounds = CGRectMake(0 , 0 ,280 * 0, 388 * 0);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

-(void)showRedPaperView
{
    self.hidden = NO;
    [UIView animateWithDuration:0.4 animations:^{
        _redPaperBgView.bounds = YRRectMake(0 , 0 ,288, 353.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            _redPaperBgView.bounds = YRRectMake(0 , 0 ,288 * 0.98, 353.5 * 0.98);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                _redPaperBgView.bounds = YRRectMake(0 , 0 ,288, 353.5);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}


@end
