//
//  YRRedPaperClearView.m
//  YRYZ
//
//  Created by Rongzhong on 16/7/14.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedPaperClearView.h"

static YRRedPaperClearView *redPaperClearView = nil;

@interface YRRedPaperClearView()

@property(strong,nonatomic)UIImageView  *redPaperBgView;


@end

@implementation YRRedPaperClearView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0,  SCREEN_WIDTH , SCREEN_HEIGHT);
    self.frame = frame;
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

+ (YRRedPaperClearView*)sharedredPaperClearView
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        redPaperClearView = [[YRRedPaperClearView alloc]initWithFrame:CGRectMake(0, 0,  SCREEN_WIDTH , SCREEN_HEIGHT)];
        UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
        [window addSubview:redPaperClearView];
    });
    return redPaperClearView;
}

+(void)refreshData:(NSString*)name{
    UIImage *image = [redPaperClearView createRedPaperImage:name];
    redPaperClearView.redPaperBgView.image = image;
}

+(void)showRedPaperClearViewWithName:(NSString*)name
{
    [YRRedPaperClearView sharedredPaperClearView];
    [redPaperClearView showRedPaperView];
    [self refreshData:name];
}

-(void)setupView
{
    UIView* shadeView = [[UIView alloc]init];
    shadeView.frame = self.bounds;
    shadeView.backgroundColor = [UIColor colorWithR:0 g:0 b:0 a:0.6];
    [self addSubview:shadeView];
    
    _redPaperBgView = [[UIImageView alloc]init];
    _redPaperBgView.userInteractionEnabled = YES;
    _redPaperBgView.center = CGPointMake(SCREEN_WIDTH/2.0f, SCREEN_HEIGHT/2.0f);
    _redPaperBgView.bounds = YRRectMake(0 , 0 ,216, 334);
    [self addSubview:_redPaperBgView];
    
    UIButton *cancelButton =[UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = YRRectMake(177, 0, 39, 39);
    [cancelButton addTarget:self action:@selector(hideRedPaperView) forControlEvents:UIControlEventTouchUpInside];
    [_redPaperBgView addSubview:cancelButton];
    
}

-(UIImage *)createRedPaperImage:(NSString*)name
{
    CGSize size= CGSizeMake (_redPaperBgView.size.width ,_redPaperBgView.size.height); // 画布大小
    UIGraphicsBeginImageContextWithOptions (size, NO , 0.0 );
    
    UIImage *redPaperBgImage = [UIImage imageNamed:name];
    [redPaperBgImage drawInRect:YRRectMake(0, 0, 216 ,334)];
    
    UIImage *cancelButtonImage = [UIImage imageNamed:@"cancelButtonImage" ];
    [cancelButtonImage drawInRect:YRRectMake(190, 10, 13, 13)];
    
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext ();
    
    return newImage;
}

-(void)hideRedPaperView
{
    [UIView animateWithDuration:0.5 animations:^{
        _redPaperBgView.bounds = CGRectMake(0 , 0 , 0, 0);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

-(void)showRedPaperView
{
    self.hidden = NO;
    [UIView animateWithDuration:0.4 animations:^{
        _redPaperBgView.bounds = YRRectMake(0 , 0 ,216, 334);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            _redPaperBgView.bounds = YRRectMake(0 , 0 ,216 * 0.98, 334 * 0.98);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                _redPaperBgView.bounds = YRRectMake(0 , 0 ,216, 334);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}

@end
